library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
	port( 	clk : in std_logic;
			rst : in std_logic;
			-- Instruction register
			dado_rom : in unsigned(15 downto 0);
			cte : out unsigned(15 downto 0);
			read_reg1: out unsigned (2 downto 0);
			read_reg2: out unsigned (2 downto 0);
			write_reg: out unsigned (2 downto 0);
			-- Control
			reg_write : out std_logic;
			ALUSrcA : out std_logic;
			ALUSrcB : out unsigned(1 downto 0);
			ALUOp: out unsigned(2 downto 0);
			wr_en_pc: out std_logic

	);
end entity;

architecture a_unidadeControle of unidadeControle is
	--==================================================
	--==== Componentes
	--==================================================

	--==== maquinaEstados

	component maquinaEstados is
		port( 	clk : in std_logic;
				rst : in std_logic;
				estado: out unsigned(1 downto 0)
		);
	end component;

	--==================================================
	--==== Ligacoes
	--==================================================

	--==== Sinais

	signal estado : unsigned(1 downto 0);

	signal opcode : unsigned(5 downto 0);
	signal reg1 : unsigned(4 downto 0);
	signal reg2 : unsigned(4 downto 0);

	signal second_int : std_logic;
	signal pre_second_int : std_logic;
	
	signal aluopbuffer : unsigned(2 downto 0);

	begin
		--==== Port Maps


		maquinaEstados_p: maquinaEstados port map(	clk => clk,
													rst => rst,
													estado => estado
												);

		--==== Ligacoes

		opcode <= dado_rom(10 downto 5) when second_int = '0' else
				  opcode;
		reg1 <= "00000" when opcode="000011" and second_int = '0' else--for jmp
				dado_rom(4 downto 0) when second_int = '0' else
				reg1;
		reg2 <= dado_rom(4 downto 0) when opcode="000011" and second_int = '0' else --for jmp
				dado_rom(15 downto 11)when second_int = '0' else
				reg2;
		cte <= dado_rom when second_int = '1' else
			   "0000000000000000";

		-- Flags:
		-- salva o proximo valor de second_int 
		pre_second_int <= '1' when estado = "10" and second_int = '0' and
							(opcode = "110000" or--addi
							 opcode = "110110" or--andi
							 opcode = "110100" or--ori
							 opcode = "110101" )else--xori
					  	  '0' when estado = "10" else
					  	  '0' when rst='1'else
					  	  pre_second_int;

		-- muda somente no estado 00
		second_int <= pre_second_int when estado = "00" else
					  '0' when rst='1'else
					  second_int;


		-- ULA: OK


		aluopbuffer <= "000" when (opcode = "001110" or opcode = "110000")and(estado = "00" and second_int = '0') else -- add e addi
				 	"001" when (opcode = "001101")						and(estado = "00" and second_int = '0') else -- sub
				 	--maior 010
				 	"011" when (opcode = "001010" or opcode = "110110")and(estado = "00" and second_int = '0') else -- and e andi
				 	"100" when (opcode = "001000" or opcode = "110100")and(estado = "00" and second_int = '0') else -- or e ori
				 	"101" when (opcode = "000001")						and(estado = "00" and second_int = '0') else -- not
				 	"110" when (opcode = "001001" or opcode = "001001")and(estado = "00" and second_int = '0') else -- xor e xori
				 	"000";

		ALUOp <= "000" when (opcode = "001110" or opcode = "110000")and(estado = "01" and second_int = '0') else -- add e addi
				 "001" when (opcode = "001101")						and(estado = "01" and second_int = '0') else -- sub
				 --maior 010
				 "011" when (opcode = "001010" or opcode = "110110")and(estado = "01" and second_int = '0') else -- and e andi
				 "100" when (opcode = "001000" or opcode = "110100")and(estado = "01" and second_int = '0') else -- or e ori
				 "101" when (opcode = "000001")						and(estado = "01" and second_int = '0') else -- not
				 "110" when (opcode = "001001" or opcode = "001001")and(estado = "01" and second_int = '0') else -- xor e xori
				 aluopbuffer;--pega a anterior


		-- Banco: OK
		
		read_reg1 <= reg1(2 downto 0);
		read_reg2 <= reg2(2 downto 0);
		write_reg <= reg2(2 downto 0);
		reg_write <= '1' when estado = "01" and (opcode = "001110" or--add
												 opcode = "001010" or--and
												 opcode = "000000" or--mov
												 opcode = "000001" or--not
												 opcode = "001000" or--or
												 opcode = "001101" or--sub
												 opcode = "001001" or--xor
												 second_int = '1')else--addi,andi,xori,ori
					'0';

		-- PC: OK
		wr_en_pc <= '1' when estado = "10" else 
					'0';

		ALUSrcA <= '1' when estado = "10" and opcode = "000011" else
				   '0' when estado = "10" else
				   '1';

		ALUSrcB <= "00" when estado = "10" and opcode = "000011" and second_int = '0' else -- jmp
				   "11" when estado = "01" and opcode = "000000" and second_int = '0' else -- mov
				   "10" when estado = "01" and second_int = '1' else --cte
				   "00" when estado = "01" and second_int = '0' else --reg

				   "01"; -- soma 1 pc


end architecture;