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
	 	2  => "0000111000000000", -- ADDI 5,$r0,$r1
	 	3  => "0000000000000101", -- cte 5
	 	4  => "0001010010000001", -- SST.H $r2,($r1) #endereco 5, salva 30

		5  => "0001111000000000", -- ADDI 10,$r0,$r3
		6  => "0000000000001010", -- cte 10
		7  => "0011011000000000", -- ADDI 100,$r0,$r6
		8  => "0000000001100100", -- cte 100
		9  => "0001110010000110", -- SST.H $r3,($r6) #endereco 100, salva 10

		10 => "0000111000000000", -- ADDI 5,$r0,$r1
		11 => "0000000000000101", -- cte 5
		12 => "0010010000000001", -- SLD.H $r4,($r1) #recebe o endereco 5 no reg 4

		13 => "0001011000000000", -- ADDI 100,$r0,$r2
		14 => "0000000001100100", -- cte 100
		15 => "0010110000000010", -- SLD.H $r5,($r2)(recebe o endereco 100 no reg5)

		16 => "0010000111000101", -- ADD $r5,$r4

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
