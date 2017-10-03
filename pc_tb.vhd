
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
	component add1
		port( 	clk : in std_logic;
				a_data_in : unsigned(15 downto 0);
				a_data_out : out unsigned(15 downto 0)
		);
	end component;
	component pc
		port( 	wr_en : in std_logic;
				rst : in std_logic; ----TEM QUE TER RESET?????
				clk : in std_logic;
				data_in : unsigned(15 downto 0);
				data_out : out unsigned(15 downto 0)
		);
	end component;

	signal pc_data_in, pc_data_out : unsigned(15 downto 0);
	signal wr_en, rst, clk:  std_logic;
	
	begin 
		uut: pc port map (	data_out => pc_data_out,
							data_in => pc_data_in,
							wr_en => wr_en,
							rst => rst,
							clk => clk);
								
		uut2: add1 port map (	a_data_out => pc_data_in,
								a_data_in => pc_data_out,
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
		wr_en <= '1';
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;


end architecture;