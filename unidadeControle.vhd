library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
	port( 	clk : in std_logic;
			rst : in std_logic;
			dadoRom : out unsigned(15 downto 0)
	);
end entity;

architecture a_unidadeControle of unidadeControle is
	--==================================================
	--==== Componentes
	--==================================================

	--==== PC

	component pc is
		port( 	wr_en : in std_logic;
				rst : in std_logic; ----TEM QUE TER RESET?????
				clk : in std_logic;
				data_in : in unsigned(6 downto 0);
				data_out : out unsigned(6 downto 0)
		);
	end component;

	--==== ROM

	component rom is
		port( 	clk : in std_logic;
				endereco : in unsigned(6 downto 0);
 				dado : out unsigned(15 downto 0)
		);
	end component;

	--==== maquinaEstados

	component maquinaEstados is
		port( 	clk : in std_logic;
				rst : in std_logic;
				estado : out std_logic
		);
	end component;

	--==================================================
	--==== Ligacoes
	--==================================================

	--==== Sinais


	signal wr_en_pc : std_logic;
	signal data_in_pc: unsigned(6 downto 0);
	signal data_out_pc: unsigned(6 downto 0);

	signal endereco_rom : unsigned(6 downto 0);
	signal dado_rom : unsigned(15 downto 0);

	signal estado_maquinaEstados : std_logic;

	signal opcode : unsigned(3 downto 0);
	signal jump_en : std_logic;

	begin
		--==== Port Maps

		pc_p: pc port map(	clk => clk,
						  	rst => rst,
						  	wr_en => wr_en_pc,
						  	data_in => data_in_pc,
						  	data_out => data_out_pc
						);


		rom_p: rom port map(	clk => clk,
								endereco => endereco_rom,
								dado => dado_rom
							); 

		maquinaEstados_p: maquinaEstados port map(	clk => clk,
													rst => rst,
													estado => estado_maquinaEstados
												);

		--==== Ligacoes


		dadoRom <= dado_rom;

		wr_en_pc <= '1' when estado_maquinaEstados = '1' else 
					'0' when estado_maquinaEstados = '0' else
					'0';

		endereco_rom <= data_out_pc when estado_maquinaEstados = '0' else
						endereco_rom;

		opcode <= dado_rom(15 downto 12);
		--JUMP: OPCODE = 1111
		jump_en <= 	'1' when opcode="1111" else
 					'0';

		data_in_pc <=	data_out_pc + "0000001" when estado_maquinaEstados = '1' and jump_en = '0' else
						dado_rom(6 downto 0) when estado_maquinaEstados = '1' and jump_en = '1' else
						data_out_pc;


end architecture;