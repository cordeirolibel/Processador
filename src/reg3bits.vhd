library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg3bits is
	port( 	clk : in std_logic;
			rst : in std_logic;
			wr_en : in std_logic;
			data_in : in unsigned(2 downto 0);
			data_out : out unsigned(2 downto 0)
	);
end entity;

architecture a_reg3bits of reg3bits is
	signal registro: unsigned(2 downto 0);
	
	begin
		process(clk,rst,wr_en) -- acionado se houver mudança em clk, rst ou wr_en
		begin
			if rst='1' then
				registro <= "000";
			elsif wr_en='1' then
				if rising_edge(clk) then
					registro <= data_in;
				end if;
			end if;
		end process;
		data_out <= registro;
end architecture;