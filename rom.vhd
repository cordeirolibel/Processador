library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( 	clk : in std_logic;
			endereco : in unsigned(6 downto 0);
 			dado : out unsigned(15 downto 0)
		);
end entity;

architecture a_rom of rom is
	type mem is array (0 to 127) of unsigned(6 downto 0);
 	constant conteudo_rom : mem := (
 	-- caso endereco => conteudo
 	0 => "0000000000000000", -- nop
 	1 => "0000000000000000", -- nop
 	2 => "0000000000000000", -- nop
 	3 => "1111000000000111", -- jmp para 7
 	4 => "0000000000000000", -- nop
 	5 => "0000000000000000", -- nop
 	6 => "0000000000000000", -- nop
 	7 => "0000000000000000", -- nop
 	8 => "1111000000000001", -- jmp para 1 (loop)
 	9 => "0000000000000000", -- nop
 	10 => "0000000000000000", -- nop
 	-- abaixo: casos omissos => (zero em todos os bits)
 	others => (others=>'0')
 );

	begin
 		process(clk)
 		begin
 			if(rising_edge(clk)) then
 				dado <= conteudo_rom(to_integer(endereco));
 			end if;
 		end process;
end architecture;
