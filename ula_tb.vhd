library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
	component ula
		port( 	entrA : in unsigned(15 downto 0);
				entrB : in unsigned(15 downto 0);
				sel : in unsigned(2 downto 0); -- bits de seleção num só bus
				saida : out unsigned(15 downto 0);
				zero: out std_logic;
				maior: out std_logic;
				carry: out std_logic
		);
	end component;
	signal entrA, entrB, saida : unsigned(15 downto 0);
	signal sel : unsigned(2 downto 0);
	signal zero, maior, carry:  std_logic;
	
	begin 
		uut: ula port map (	entrA => entrA,
							entrB => entrB,
							sel => sel,
							zero => zero,
							maior => maior,
							saida => saida,
							carry => carry);
								
		process
		begin
			-- Teste 1
			sel <= "000";
			entrA <= "0000000000000000";
			entrB <= "0000000000000000";
			for I in 0 to 5 loop
				wait for 50 ns;
				sel <= "001";
				wait for 50 ns;
				sel <= "010";
				wait for 50 ns;
				sel <= "011";
				wait for 50 ns;
				sel <= "100";
				wait for 50 ns;
				sel <= "101";
				wait for 50 ns;
				sel <= "110";
				wait for 50 ns;
				entrA <= entrA + "0000000000000010";
				entrB <= entrB + "0000000000000001";
				sel <= "000";
			end loop;

			-- Teste 2
			sel <= "000";
			entrA <= "0111111111111110";
			entrB <= "0111111111111100";
			for I in 0 to 5 loop
				wait for 50 ns;
				sel <= "001";
				wait for 50 ns;
				sel <= "010";
				wait for 50 ns;
				sel <= "011";
				wait for 50 ns;
				sel <= "100";
				wait for 50 ns;
				sel <= "101";
				wait for 50 ns;
				sel <= "110";
				wait for 50 ns;
				entrA <= entrA + "0000000000000010";
				entrB <= entrB + "0000000000000001";
				sel <= "000";
			end loop;

			-- Teste 3
			sel <= "000";
			entrA <= "1111111111111110";
			entrB <= "1111111111111100";
			for I in 0 to 5 loop
				wait for 50 ns;
				sel <= "001";
				wait for 50 ns;
				sel <= "010";
				wait for 50 ns;
				sel <= "011";
				wait for 50 ns;
				sel <= "100";
				wait for 50 ns;
				sel <= "101";
				wait for 50 ns;
				sel <= "110";
				wait for 50 ns;
				entrA <= entrA + "0000000000000010";
				entrB <= entrB + "0000000000000001";
				sel <= "000";
			end loop;

			wait;
		end process;
end architecture;	
		