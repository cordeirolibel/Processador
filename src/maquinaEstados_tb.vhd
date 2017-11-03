library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquinaEstados_tb is
end;

architecture a_maquinaEstados_tb of maquinaEstados_tb is
 	component maquinaEstados is
 		port( 	clk : in std_logic;
				estado: out unsigned(1 downto 0);
				rst : in std_logic
		);
	end component;

	signal clk,estado,rst : std_logic;
	signal estado: unsigned(1 downto 0);

	begin
		uut: maquinaEstados port map(	clk => clk,
										estado => estado,
										rst => rst
									 );
		process -- sinal de clock
		begin
			clk <= '0';
			wait for 50 ns;
			clk <= '1';
			wait for 50 ns;
		end process;

		process -- 
		begin
			rst <= '1';
			wait for 100 ns;
			rst <= '0';
			wait for 1000 ns;
			rst <= '1';
			wait for 100 ns;
			rst <= '0';
			wait for 1000 ns;
			wait;
		end process;
end architecture;
