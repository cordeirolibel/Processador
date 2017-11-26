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
		0  => "0000111000000000", --  addi 1,$r0,$r1
	 	1  => "0000000000000001", -- cte 1
	 	2  => "0001011000000000", -- addi 33,$r0,$r2
	 	3  => "0000000000100001", -- cte 33 
		-- SALVARAM
	 	4  => "0000110010000001", -- SST.H $r1,($r1) 
		5  => "0000111000000001", -- addi 1,$r1,$r1
		6  => "0000000000000001", -- cte 1
		7  => "0001100000000001", -- mov $r1,$r3
		8  => "0001100110100010", -- sub $r2,$r3
		9  => "1111110110111011", -- BGT SALVARAM (-5)
								  --58950ns
		-- TODO
		10 => "0000111000000000", -- addi 2,$r0,$r1  
		11 => "0000000000000010", -- cte 2
		-- LOOP1
		12 => "0010010000000001", -- SLD.H $r4,($r1) 
		13 => "0000000110100100", -- sub $r4,$r0
		14 => "0000110110100010", -- BZ	 N_PRIMO (10)(00001010)
		15 => "0010100000000100", -- mov $r4, $r5
		-- LOOP2
		16 => "0010100111000100", -- add $r4, $r5
		17 => "0001100000000010", -- mov $r2,$r3
		18 => "0001100110100101", -- sub $r5,$r3
		19 => "0000010111011011", -- BGT MAIS32 (5) (00000101)
		20 => "0000010010000101", -- SST.H $r0,($r5)
		21 => "0001111000000000", -- addi 16,$r0,$r3  
		22 => "0000000000010000", -- cte 16
		23 => "0000000001100011", -- JMP $r3 (LOOP2 =16)
		-- MAIS32
		-- N_PRIMO
		24 => "0000111000000001", -- addi $r1,$r1,1
		25 => "0000000000000001", -- cte 1
		26 => "0001100000000001", -- mov  $r1,$r3
		27 => "0001100110100010", -- sub  $r2,$r3
		28 => "1111010110001011", -- BGT LOOP1 (-16)(11110000)
		

		29 => "0000111000000000", -- addi 1,$r0,$r1
		30 => "0000000000000001", -- cte 1
		-- LERAM
		31 => "0010010000000001", -- SLD.H $r4,($r1)
		32 => "0000111000000001", -- addi 1,$r1,$r1
		33 => "0000000000000001", -- cte 1
		34 => "0001100000000001", -- mov $r1,$r3
		35 => "0001100110100010", -- sub $r2,$r3
		36 => "1111110110111011", -- BGT LERAM (-5)

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
