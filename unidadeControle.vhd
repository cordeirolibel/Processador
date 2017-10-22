library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
	port( 	clk : in std_logic;
			rst : in std_logic;
			dado_rom : in unsigned(15 downto 0);
			read_reg1: out unsigned (2 downto 0);
			read_reg2: out unsigned (2 downto 0);
			write_reg: out unsigned (2 downto 0);
			ALUSrc : in std_logic
			

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
	signal cte : unsigned(15 downto 0);

	signal duas_int : std_logic;

	begin
		--==== Port Maps


		maquinaEstados_p: maquinaEstados port map(	clk => clk,
													rst => rst,
													estado => estado
												);

		--==== Ligacoes

		opcode <= dado_rom(10 downto 5);
		reg1 <= dado_rom(4 downto 0);
		reg2 <= dado_rom(15 downto 11);
		cte <= dado_rom;

		duas_int <= '1' when estado = "00" and duas_int = '0' and
							(opcode = "110000" or
							opcode = "110110" or
							opcode = "011110" or
							opcode = "110100" or
							opcode = "110101" ) else
					'0';

		

		endereco_rom <= data_out_pc when estado_maquinaEstados = '0' else
						endereco_rom;

		--banco
		read_reg1 <= reg1(2 downto 0)
		read_reg2 <= reg2(2 downto 0)
		
		-- pc
		wr_en_pc <= '1' when estado = "10" else 
					'0';

		ALUSrc <= '0' when estado = "10" and opcode = "000011" else -- VER Bcond
				  '1';


end architecture;