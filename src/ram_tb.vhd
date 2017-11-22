library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ram_tb is
end;

architecture a_ram_tb of ram_tb is
	component ram
		port( 	clk : in std_logic;
				endereco : in unsigned(6 downto 0);
				wr_en : in std_logic;
				dado_in : in unsigned(15 downto 0);
				dado_out : out unsigned(15 downto 0)
		);

	end component;
	signal clk:  std_logic;
	signal endereco : unsigned(6 downto 0);
	signal dado_in : unsigned(15 downto 0);
	signal dado_out : unsigned(15 downto 0);
	signal wr_en : std_logic;
	
	
	begin 
		uut: ram port map (	clk => clk,
							endereco => endereco,
							dado_in => dado_in,
							dado_out => dado_out,
							wr_en => wr_en
							);
								

	process -- sinal de clock
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;

	process
	begin
		for I in 0 to 127 loop
			wr_en <= '1';
			endereco <= "0000000"+I;
			dado_in <= "0000000000000101"+I;
			wait for 100 ns;
		end loop;
		wr_en <= '0';
		for I in 0 to 127 loop
			endereco <= "0000000"+I;
			wait for 100 ns;
		end loop;
		wait;
	end process;
end architecture;
