library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flipflopT is
	port( 	clk : in std_logic;
			estado : out std_logic;
			rst : in std_logic
		);
end entity;

architecture a_flipflopT of flipflopT is
	signal estado_tmp : std_logic;

	begin
	process(clk,rst)
		begin
		if rst='1' then
			estado_tmp <= '0';
		elsif(rising_edge(clk)) then
			estado_tmp <= not estado_tmp;
		end if;
	end process;

	estado <= estado_tmp;
end architecture;
