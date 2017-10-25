
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
 	component processador is
 		port( 	clk : in std_logic;
				rst : in std_logic
				--reg_write : in std_logic;
				--==================
				-- Coisas para teste
				--constante : in unsigned(15 downto 0);
				--sel_ula_in2 : in std_logic;-- 0:bank->ula   1:cte->ula
				--out_ula : out unsigned(15 downto 0);
				--read_reg1 : in unsigned(2 downto 0);
				--read_reg2 : in unsigned(2 downto 0);
				--write_reg : in unsigned(2 downto 0)

		);
	end component;

 
	signal clk, rst : std_logic;
	--signal constante,out_ula : unsigned(15 downto 0);
	--signal sel_ula_in2 : std_logic;
	--signal read_reg1, read_reg2, write_reg : unsigned(2 downto 0);

	begin
		uut: processador port map(	clk => clk,
									rst => rst
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
