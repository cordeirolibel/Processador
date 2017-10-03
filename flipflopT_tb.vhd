library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflopT_tb is
end;

architecture a_flipflopT_tb of flipflopT_tb is
 	component flipflopT is
 		port( 	clk : in std_logic;
				estado : out std_logic;
				rst : in std_logic
		);
	end component;

	signal clk,estado,rst : std_logic;
	
	begin
		uut: flipflopT port map(	clk => clk,
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
