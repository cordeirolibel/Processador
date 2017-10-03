library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank8reg_tb is
end;

architecture a_bank8reg_tb of bank8reg_tb is
 	component bank8reg is
 		port( 	read_reg1 : in unsigned(2 downto 0);
				read_reg2 : in unsigned(2 downto 0);
				write_reg : in unsigned(2 downto 0);
				write_data : in unsigned(15 downto 0);
				reg_write : in std_logic;
				clk : in std_logic;
				rst : in std_logic;
				reg1_out : out unsigned(15 downto 0);
				reg2_out : out unsigned(15 downto 0)
		);
	end component;

 
	signal read_reg1, read_reg2, write_reg : unsigned(2 downto 0);
	signal write_data, reg1_out, reg2_out : unsigned(15 downto 0);
	signal reg_write, clk, rst : std_logic;
	
	begin
		uut: bank8reg port map(	read_reg1 => read_reg1,
								read_reg2 => read_reg2,
								write_reg => write_reg,
								write_data => write_data,
								reg_write => reg_write,
								clk => clk,
								rst => rst,
								reg1_out => reg1_out,
								reg2_out => reg2_out);
	process -- sinal de clock
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;

	process -- sinal de reset
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;

	process -- 
	begin
		
		reg_write <= '0';
		wait for 100 ns;
		-- lendo R0 e R1
		read_reg1 <= "000";
		read_reg2 <= "000";
		wait for 100 ns;
		-- grava 3 em R0 (nao grava)
		reg_write <= '1';
		write_reg <= "000";
		write_data <= "0000000000000011";
		wait for 100 ns;
		-- grava 5 em R1
		write_reg <= "001";
		write_data <= "0000000000000101";
		wait for 100 ns;
		-- grava 6 em R2
		write_reg <= "010";
		write_data <= "0000000000000110";
		wait for 100 ns;
		-- grava 7 em R3
		write_reg <= "011";
		write_data <= "0000000000000111";
		wait for 100 ns;
		-- grava -5 em R4
		write_reg <= "100";
		write_data <= "1111111111111011";
		wait for 100 ns;
		-- grava -6 em R5
		write_reg <= "101";
		write_data <= "1111111111111010";
		wait for 100 ns;
		-- grava -7 em R6
		write_reg <= "110";
		write_data <= "1111111111111001";
		wait for 100 ns;
		-- grava 16 em R7
		write_reg <= "111";
		write_data <= "0000000000010000";
		wait for 100 ns;
		
		-- lendo R0 e R1
		reg_write <= '0';
		read_reg1 <= "000";
		read_reg2 <= "001";
		wait for 100 ns;
		-- lendo R2 e R3
		read_reg1 <= "010";
		read_reg2 <= "011";
		wait for 100 ns;
		-- lendo R4 e R5
		read_reg1 <= "100";
		read_reg2 <= "101";
		wait for 100 ns;
		-- lendo R6 e R7
		read_reg1 <= "110";
		read_reg2 <= "111";
		wait for 100 ns;
		
		-- grava 8 em R5
		reg_write <= '1';
		write_reg <= "101";
		write_data <= "0000000000001000";
		wait for 100 ns;
		-- grava 1 em R3
		write_reg <= "011";
		write_data <= "0000000000000001";
		wait for 100 ns;
		
		-- lendo R5 e R3
		reg_write <= '0';
		read_reg1 <= "101";
		read_reg2 <= "011";
		
		wait;
	end process;
end architecture;
