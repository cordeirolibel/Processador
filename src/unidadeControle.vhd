library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
	port( 	clk : in std_logic;
			rst : in std_logic;
			zero : in std_logic;
			carry: in std_logic;
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
			wr_en_pc: out std_logic;
			wr_en_ram: out std_logic;
			write_bank_sel : out std_logic --0:ram  1:ula
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

	component reg16bits is
		port( 	clk : in std_logic;
				rst : in std_logic;
				wr_en : in std_logic;
				data_in : in unsigned(15 downto 0);
				data_out : out unsigned(15 downto 0)
		);
	end component;

	component reg1bit is
		port( 	clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in std_logic;
			data_out : out std_logic
		);
	end component;

	component reg3bits is
		port( 	clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in unsigned(2 downto 0);
			data_out : out unsigned(2 downto 0)
		);
	end component;

	--==================================================
	--==== Ligacoes
	--==================================================

	--==== Sinais
	signal dado_rom_ant: unsigned(15 downto 0);

	signal estado : unsigned(1 downto 0);

	signal opcode : unsigned(5 downto 0);
	signal reg1 : unsigned(4 downto 0);
	signal reg2 : unsigned(4 downto 0);

	signal second_int : std_logic;
	signal second_int_ant : std_logic;
	signal pre_second_int : std_logic;
	signal pre_second_int_ant : std_logic;
	
	signal ALUOp_ant : unsigned(2 downto 0);
	signal ALUOp_s : unsigned(2 downto 0);

	signal reg_write_s: std_logic;
	signal reg_write_zero_s: std_logic;
	signal reg_write_carry_s: std_logic;


	signal cccc_Bcond: unsigned(3 downto 0);

	signal zero_ant : std_logic;
	signal carry_ant : std_logic;
	signal Bcond : std_logic;


	begin
		--==== Port Maps


		maquinaEstados_p: maquinaEstados port map(	clk => clk,
													rst => rst,
													estado => estado
												);

		dado_rom_ant_p: reg16bits port map(	clk=>clk,
											rst=>rst,
											wr_en=>reg_write_s,
											data_in=>dado_rom,
											data_out=>dado_rom_ant
										);

		second_int_ant_p: reg1bit port map(	clk=>clk,
											rst=>rst,
											wr_en=>'1',
											data_in=>second_int,
											data_out=>second_int_ant
										);

		pre_second_int_ant_p: reg1bit port map(	clk=>clk,
												rst=>rst,
												wr_en=>'1',
												data_in=>pre_second_int,
												data_out=>pre_second_int_ant
											);

		zero_ant_p: reg1bit port map(	clk=>clk,
										rst=>rst,
										wr_en=>reg_write_zero_s,
										data_in=>zero,
										data_out=>zero_ant
									);

		carry_ant_p: reg1bit port map(	clk=>clk,
										rst=>rst,
										wr_en=>reg_write_carry_s,
										data_in=>carry,
										data_out=>carry_ant
									);

		ALUOp_ant_p: reg3bits port map(	clk=>clk,
										rst=>rst,
										wr_en=>reg_write_s,
										data_in=>ALUOp_s,
										data_out=>ALUOp_ant
									);

		--==== Ligacoes

		opcode <= dado_rom(10 downto 5) when second_int = '0' else
				  dado_rom_ant(10 downto 5);

		reg1 <= "00000" when opcode="000011" and second_int = '0' else--for jmp
				dado_rom(4 downto 0) when second_int = '0' else
				dado_rom_ant(4 downto 0);

		reg2 <= dado_rom(4 downto 0) when opcode="000011" and second_int = '0' else --for jmp
				dado_rom(15 downto 11)when second_int = '0' else
				dado_rom_ant(15 downto 11);

		cte <= 	"00000000"&dado_rom(15 downto 11)&dado_rom(6 downto 4) when Bcond = '1' and dado_rom(15) = '0' else
				"11111111"&dado_rom(15 downto 11)&dado_rom(6 downto 4) when Bcond = '1' and dado_rom(15) = '1' else
				dado_rom;
		

		cccc_Bcond <= dado_rom(3 downto 0);

		-- Flags:

		-- salva o proximo valor de second_int 
		pre_second_int <= '1' when estado = "10" and second_int = '0' and
							(opcode = "110000" or--addi
							 opcode = "110110" or--andi
							 opcode = "110100" or--ori
							 opcode = "110101" )else--xori
					  	  '0' when estado = "10" else
					  	  '0' when rst='1'else
					  	  pre_second_int_ant;

		-- muda somente no estado 00
		second_int <= pre_second_int when estado = "00" else
					  '0' when rst='1'else
					  second_int_ant;

		Bcond <= '1' when opcode(5 downto 2) = "1011" and second_int = '0' and estado = "01" and(
						  (cccc_Bcond = "0010" and zero_ant = '1') or  -- pula se zero = 1
						  (cccc_Bcond = "1011" and (zero_ant = '0' and carry_ant = '0'))) else -- pula se maior = 1
				 '1' when estado = "10" and Bcond = '1' else -- mantem no estado de atualizacao do pc
				 '0';

		-- RAM: OK
		wr_en_ram <= '1' when opcode(5 downto 2) = "1001" and second_int = '0' and estado = "01" else -- SST.H
					 '0';

		write_bank_sel <= '0' when opcode(5 downto 2) = "1000" and second_int = '0' and estado = "01" else --ram  -- SLD.H
					      '1';          																   --ula

		-- ULA: OK

		ALUOp_s <=	"000" when (opcode = "001110" or opcode = "110000")and(estado = "01" and second_int = '0') else -- add e addi
					"001" when (opcode = "001101")						and(estado = "01" and second_int = '0') else -- sub
					--maior 010
					"011" when (opcode = "001010" or opcode = "110110")and(estado = "01" and second_int = '0') else -- and e andi
					"100" when (opcode = "001000" or opcode = "110100")and(estado = "01" and second_int = '0') else -- or e ori
					"101" when (opcode = "000001")						and(estado = "01" and second_int = '0') else -- not
					"110" when (opcode = "001001" or opcode = "001001")and(estado = "01" and second_int = '0') else -- xor e xori
					ALUOp_ant;--pega a anterior
		ALUOp <= ALUOp_s;

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
												 opcode(5 downto 2) = "1000" or -- SLD.H
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
				   "10" when estado = "10" and Bcond ='1' else -- branch
				   "01"; -- soma 1 pc

		-- Regs: OK

		reg_write_s <= '1' when estado = "10" else
					 '0';

		reg_write_zero_s <= '1' when estado = "01" and 
									(opcode = "001110" or --add
									 opcode = "110000" or --addi
									 opcode = "001010" or --and
									 opcode = "110110" or --andi
									 opcode = "000001" or --not
									 opcode = "001000" or --or
									 opcode = "110100" or --ori
									 opcode = "001101" or --sub
									 opcode = "001001" or --xor
									 opcode = "110101"    --xori
									 )	else
					 		'0';

		reg_write_carry_s  <= '1' when estado = "01" and 
									  (opcode = "001110" or --add
									   opcode = "110000" or --addi
									   opcode = "001101"    --sub
									 )	else
					 		  '0';
					 
end architecture;