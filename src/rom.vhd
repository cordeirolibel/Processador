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
		-- TODO
		10 => "0000000000000000", -- 
		11 => "0000000000000000", -- 
		12 => "0000000000000000", -- 
		13 => "0000000000000000", -- 
		14 => "0000000000000000", -- 
		15 => "0000000000000000", -- 
		16 => "0000000000000000", --
		17 => "0000000000000000", --
		18 => "0000000000000000", --
		19 => "0000000000000000", --
		20 => "0000000000000000", --
		21 => "0000000000000000", --
		22 => "0000000000000000", --
		23 => "0000000000000000", --
		24 => "0000000000000000", --
		
		25 => "0000111000000000", -- addi 1,$r0,$r1
		26 => "0000000000000001", -- cte 1
		-- LERAM
		27 => "0010010000000001", -- SLD.H $r4,($r1)
		28 => "0000111000000001", -- addi 1,$r1,$r1
		29 => "0000000000000001", -- cte 1
		30 => "0001100000000001", -- mov $r1,$r3
		31 => "0001100110100010", -- sub $r2,$r3
		32 => "1111110110111011", -- BGT LERAM (-5)
		33 => "0000000000000000", --

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
