
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity reg16bits_tb is
end;

architecture a_reg16bits_tb of reg16bits_tb is
	component reg16bits
		port( 	clk : in std_logic;
				rst : in std_logic;
				wr_en : in std_logic;
				data_in : in unsigned(15 downto 0);
				data_out : out unsigned(15 downto 0)
	);
	end component;

	signal data_in, data_out : unsigned(15 downto 0);
	signal wr_en, rst, clk:  std_logic;
	
	begin 
		uut: reg16bits port map (	data_out => data_out,
							data_in => data_in,
							wr_en => wr_en,
							rst => rst,
							clk => clk);
								

-- arquitetura do testbench
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
		wait for 1000 ns;
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;

	process -- sinais dos casos de teste
	begin
		wait for 100 ns;
		wr_en <= '0';
		data_in <= "1111111111111111";
		wait for 100 ns;
		data_in <= "0000000010001101";
		wait for 100 ns;
		wr_en <= '1';
		data_in <= "1111111111111111";
		wait for 100 ns;
		data_in <= "0000000010001101";
		wait for 100 ns;
	end process;
end architecture;