library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add1 is
	port( 	clk : in std_logic;
			a_data_in : unsigned(15 downto 0);
			a_data_out : out unsigned(15 downto 0)
	);
end entity;

architecture a_add1 of add1 is
	--signal registro: unsigned(15 downto 0);
	
	begin
		--process(clk) -- acionado se houver mudança em clk, rst ou wr_en
		--begin
		--	if rising_edge(clk) then
		--		registro <= a_data_in;
		--	end if;
		--end process;
		--a_data_out <= registro+1;

		a_data_out <= a_data_in+1;
end architecture;