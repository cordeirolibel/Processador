library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle_tb is
end;

architecture a_unidadeControle_tb of unidadeControle_tb is
 	component unidadeControle is
 		port( 	clk : in std_logic;
				rst : in std_logic;
				dadoRom : out unsigned(15 downto 0)
		);
	end component;

 
	signal clk, rst : std_logic;
	signal dadoRom : unsigned(15 downto 0);

	begin
		uut: unidadeControle port map(	clk => clk,
										rst => rst,
										dadoRom => dadoRom
									);
	process -- sinal de clock
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;

	process -- sinal de reset
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;

end architecture;
