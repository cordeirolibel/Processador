
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end;

architecture a_processador_tb of processador_tb is
 	component processador is
 		port( 	clk : in std_logic;
				rst : in std_logic;
				reg_write : in std_logic;
				--==================
				-- Coisas para teste
				constante : in unsigned(15 downto 0);
				sel_ula_in2 : in std_logic;-- 0:bank->ula   1:cte->ula
				out_ula : out unsigned(15 downto 0);
				read_reg1 : in unsigned(2 downto 0);
				read_reg2 : in unsigned(2 downto 0);
				write_reg : in unsigned(2 downto 0)

		);
	end component;

 
	signal clk, rst, reg_write : std_logic;
	signal constante,out_ula : unsigned(15 downto 0);
	signal sel_ula_in2 : std_logic;
	signal read_reg1, read_reg2, write_reg : unsigned(2 downto 0);

	begin
		uut: processador port map(	clk => clk,
									rst => rst,
									reg_write => reg_write,
									constante => constante,
									out_ula => out_ula,
									sel_ula_in2 => sel_ula_in2,
									read_reg1 => read_reg1,
									read_reg2 => read_reg2,
									write_reg => write_reg
									);
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
		--wait reset
		wait for 150 ns;
		--========================================
		--======Gravando em todos os Registradores
		--========================================

		reg_write <= '1'; --Escreve
		sel_ula_in2 <= '1';-- 1:cte->ula
		read_reg1 <= "000";
		read_reg2 <= "000";

		--reg 1 recebe 3
		write_reg <= "001"; --No reg 1 (recebe a saida da ula = 3)
		constante <= "0000000000000011"; --cte = 3
		wait for 100 ns;

		--reg 2 recebe 6
		write_reg <= "010"; --No reg 2 (recebe a saida da ula = 6)
		constante <= "0000000000000110"; --cte = 6
		wait for 100 ns;

		--reg 3 recebe C
		write_reg <= "011"; --No reg 3 (recebe a saida da ula = C)
		constante <= "0000000000001100"; --cte = C
		wait for 100 ns;

		--reg 4 recebe 1
		write_reg <= "100"; --No reg 4 (recebe a saida da ula = 1)
		constante <= "0000000000000001"; --cte = 1
		wait for 100 ns;

		--reg 5 recebe 5
		write_reg <= "101"; --No reg 5 (recebe a saida da ula = 5)
		constante <= "0000000000000101"; --cte = 5
		wait for 100 ns;

		--reg 6 recebe 7
		write_reg <= "110"; --No reg 6 (recebe a saida da ula = 7)
		constante <= "0000000000000111"; --cte = 7
		wait for 100 ns;

		--reg 7 recebe 2
		write_reg <= "111"; --No reg 7 (recebe a saida da ula = 2)
		constante <= "0000000000000010"; --cte = 2
		wait for 100 ns;

		--========================================
		--======Somando Registradores com costante
		--========================================

		sel_ula_in2 <= '1';-- 1:cte->ula
		reg_write <= '0'; --Nao escreve
		constante <= "0000000000000011";

		--reg0 + cte = 3
		read_reg1 <= "000";
		wait for 100 ns;

		--reg1 + cte = 6
		read_reg1 <= "001";
		wait for 100 ns;

		--reg2 + cte = 9
		read_reg1 <= "010";
		wait for 100 ns;

		--reg3 + cte = F
		read_reg1 <= "011";
		wait for 100 ns;

		--reg4 + cte = 4
		read_reg1 <= "100";
		wait for 100 ns;

		--reg5 + cte = 8
		read_reg1 <= "101";
		wait for 100 ns;

		--reg6 + cte = A
		read_reg1 <= "110";
		wait for 100 ns;

		--reg7 + cte = 5
		read_reg1 <= "111";
		wait for 100 ns;

		--=============================================
		--======Somando Registradores com Registradores
		--=============================================

		sel_ula_in2 <= '0'; --0:bank->ula
		reg_write <= '0'; --Nao escreve

		--reg0 + reg7 = 2
		read_reg1 <= "000";
		read_reg2 <= "111";
		wait for 100 ns;

		--reg1 + reg6 = A
		read_reg1 <= "001";
		read_reg2 <= "110";
		wait for 100 ns;

		--reg2 + reg5 = B
		read_reg1 <= "010";
		read_reg2 <= "101";
		wait for 100 ns;

		--reg3 + reg4 = D
		read_reg1 <= "011";
		read_reg2 <= "100";
		wait for 100 ns;

		wait;
	end process;
end architecture;
