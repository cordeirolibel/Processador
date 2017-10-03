library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end;

architecture a_rom_tb of rom_tb is
 	component rom is
 		port( 	clk : in std_logic;
				endereco : in unsigned(6 downto 0);
				dado : out unsigned(15 downto 0)
			);
	end component;

 
	signal dado : unsigned(15 downto 0);
	signal endereco : unsigned(6 downto 0);
	signal clk : std_logic;
	
	begin
		uut: rom port map(	dado => dado,
							endereco => endereco,
							clk => clk
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
			for I in 0 to 20 loop
				endereco <= "0000000"+I;
				wait for 100 ns;
			end loop;
			wait;
		end process;
end architecture;
