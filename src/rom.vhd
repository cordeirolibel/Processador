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
	type mem is array (0 to 127) of unsigned(15 downto 0);
 	constant conteudo_rom : mem := (
	 	-- caso endereco => conteudo
	 	0  => "0001011000000000", -- ADDI 30,$r0,$r2
	 	1  => "0000000000011110", -- cte 30
		2  => "0001100111000000", -- ADD $r0, $r3
		3  => "0010000111000000", -- ADD $r0, $r4
		4  => "0010000111000011", -- ADD $r3, $r4
		5  => "0001111000000011", -- ADDI 1, $r3,$r3
		6  => "0000000000000001", -- cte 1
		7  => "0000100000000011", -- MOV $r3,$r1
		8  => "0000100110100010", -- SUB $r2,$r1	
		9  => "1111110110101011", -- BGT -6	#-6 = 11111010
		10 => "0010100000000100", -- MOV $r4,$r5
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
