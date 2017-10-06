library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
	port( 	clk : in std_logic;
			rst : in std_logic;
			entrada : in unsigned(15 downto 0);
			read_reg1: out unsigned (2 downto 0);
			read_reg2: out unsigned (2 downto 0);
			write_reg: out unsigned (2 downto 0);
			

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
				estado : out std_logic
		);
	end component;

	--==================================================
	--==== Ligacoes
	--==================================================

	--==== Sinais


	signal estado_maquinaEstados : std_logic;

	signal opcode : unsigned(3 downto 0);
	signal jump_en : std_logic;

	begin
		--==== Port Maps

	

		maquinaEstados_p: maquinaEstados port map(	clk => clk,
													rst => rst,
													estado => estado_maquinaEstados
												);

		--==== Ligacoes

		wr_en_pc <= '1' when estado_maquinaEstados = '1' else 
					'0' when estado_maquinaEstados = '0' else
					'0';

		endereco_rom <= data_out_pc when estado_maquinaEstados = '0' else
						endereco_rom;

		opcode <= dado_rom(10 downto 5);
		
		--JUMP: OPCODE = 1111
		jump_en <= 	'1' when opcode="1111" else
 					'0';

		data_in_pc <=	dado_rom(6 downto 0) when estado_maquinaEstados = "10" and opcode = "000011" else
						data_out_pc + "0000001" ;


end architecture;