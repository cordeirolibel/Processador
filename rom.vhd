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
 	0  => "0001111000000000", -- ADDI 5,$r0, $r3
	1  => "0000000000000101", -- cte 5
	2  => "0010011000000000", -- ADDI 8,$r0, $r4
	3  => "0000000000001000", -- cte 8
	4  => "0010000111000011", -- ADD $r3, $r4
	5  => "0010000000000101", -- MOV $r4, $r5
	6  => "0010111000000001", -- ADDI -1, $r5,$r5
	7  => "1111111111111111", -- cte -1
	8  => "0011011000000000", -- ADDI 20,$r0, $r6
	9  => "0000000000010100", -- cte 20
	10 => "0000000001100110", -- JMP r6
	11 => "0000000000000000", -- nop
	12 => "0000000000000000", -- nop
	13 => "0000000000000000", -- nop
	14 => "0000000000000000", -- nop
	15 => "0000000000000000", -- nop
	16 => "0000000000000000", -- nop
	17 => "0000000000000000", -- nop
	18 => "0000000000000000", -- nop
	19 => "0000000000000000", -- nop
	20 => "0010100000000011", -- MOV $r5, $r3
	21 => "0011011000000000", -- ADDI 4,$r0, $r6
	22 => "0000000000000100", -- cte 4
	23 => "0000000001100110", -- JMP r6
	24 => "0000000000000000", -- nop
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
