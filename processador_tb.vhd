
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
 	component processador is
 		port( 	clk : in std_logic;
			rst : in std_logic;

			--=============
			-- Coisas para teste
			top_level : in unsigned(15 downto 0);
			sel_ula_in2 : in std_logic;-- 0:banck->ula   1:cte->ula
			out_ula : out unsigned(15 downto 0)

		);
	end component;

 
	signal clk, rst : std_logic;
	signal top_level,out_ula : unsigned(15 downto 0);
	signal sel_ula_in2 : std_logic;

	begin
		uut: processador port map(	clk => clk,
									rst => rst,
									top_level => top_level,
									out_ula => out_ula,
									sel_ula_in2 => sel_ula_in2);
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

	process -- 
	begin
		wait for 100 ns;
		sel_ula_in2 <= '1';-- 1:cte->ula
		top_level <= "0000000000000001";
		wait for 100 ns;
		sel_ula_in2 <= '0';--0:banck->ula
		wait for 100 ns;
		sel_ula_in2 <= '1';-- 1:cte->ula
		top_level <= "0000000000000100";
		wait;
	end process;
end architecture;
