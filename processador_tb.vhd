
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
				--=============
				-- Coisas para teste
				top_level : in unsigned(15 downto 0);
				sel_ula_in2 : in std_logic;-- 0:bank->ula   1:cte->ula
				out_ula : out unsigned(15 downto 0);
				read_reg1 : in unsigned(2 downto 0);
				read_reg2 : in unsigned(2 downto 0);
				write_reg : in unsigned(2 downto 0)

		);
	end component;

 
	signal clk, rst, reg_write : std_logic;
	signal top_level,out_ula : unsigned(15 downto 0);
	signal sel_ula_in2 : std_logic;
	signal read_reg1, read_reg2, write_reg : unsigned(2 downto 0);

	begin
		uut: processador port map(	clk => clk,
									rst => rst,
									reg_write => reg_write,
									top_level => top_level,
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
		sel_ula_in2 <= '1';
		top_level <= "0000000000000000"; --cte = 0
		reg_write <= '0'; --Nao escreve
		wait for 100 ns;
		sel_ula_in2 <= '1';-- 1:cte->ula
		top_level <= "0000000000000001"; --cte = 1
		wait for 100 ns;
		reg_write <= '1'; --Escreve
		write_reg <= "100"; --No reg 4 (recebe a saida da ula = 1)
		wait for 100 ns;
		reg_write <= '0'; --Nao escreve
		sel_ula_in2 <= '0';--0:bank->ula
		read_reg1 <= "001"; -- Le o registrador 1: deve ter 0 nele
		read_reg2 <= "100"; -- Le o registrador 4: deve ter 1 nele 
		--(saida da ula = 1)
		wait for 100 ns;
		reg_write <= '1'; --Escreve
		write_reg <= "111"; --No reg 7 (recebe a saida da ula = 4)
		sel_ula_in2 <= '1';-- 1:cte->ula
		top_level <= "0000000000000100"; --cte = 4
		wait for 100 ns;
		top_level <= "0000000000000000"; --cte = 0
		sel_ula_in2 <= '0'; --0:bank->ula
		reg_write <= '0'; --Nao escreve
		read_reg1 <= "100"; --Le o reg 4 (valor 1)
		read_reg2 <= "111"; --Le o reg 7 (valor 4)
		--(saida da ula = 5)
		wait;
	end process;
end architecture;
