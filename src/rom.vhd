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
		2  => "0001010010000101", -- SST.H (endereco 5, salva 30)
		3  => "0001111000000000", -- ADDI 10,$r0,$r3
		4  => "0000000000001010", -- cte 10
		5  => "0001110011100100", -- SST.H (endereco 100, salva 10)
		6  => "0010010000000101", -- SLD.H (recebe o endereco 5 no reg 4)
		7  => "0010110001100100", -- SLD.H (recebe o endereco 100 no reg5)
		8  => "0000000000000000",	
		9  => "0000000000000000", 
		10 => "0000000000000000",
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
