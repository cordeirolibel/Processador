library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ula is
	port( 	entrA : in unsigned(15 downto 0);
			entrB : in unsigned(15 downto 0);
			sel : in unsigned(2 downto 0); -- bits de seleção num só bus
			saida : out unsigned(15 downto 0);
			zero: out std_logic;
			carry: out std_logic
	);
end entity;

architecture a_ula of ula is
	
	signal entrA17: unsigned(16 downto 0);
	signal entrB17: unsigned(16 downto 0);
	signal saida17: unsigned(16 downto 0);

	begin
		entrA17 <= '0' & entrA;
		entrB17 <= '0' & entrB;

		saida17 <=	entrA17+entrB17		when sel="000" else -- Soma
					entrA17-entrB17		when sel="001" else -- Subtracao
					entrA17				when sel="010" else --  
					entrA17 and entrB17 when sel="011" else -- and
					entrA17 or entrB17 	when sel="100" else -- or 
					not entrA17 		when sel="101" else -- not A
					entrA17 xor entrB17 when sel="110" else -- A xor B
					entrA17 			when sel="111" else -- 
					"00000000000000000";

		carry <= saida17(16) when sel = "000" else
				 '0';

		-- por equando nada de carry
		saida <= saida17(15 downto 0);

		
		zero <= '1' when entrA17-entrB17 = "00000000000000000" 
						 and sel="001" else
				'0';

end architecture;

