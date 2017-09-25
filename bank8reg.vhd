library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank8reg is
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
end entity;

architecture a_bank8reg of bank8reg is
 	component reg16bits is
 		port( 	clk : in std_logic;
				rst : in std_logic;
				wr_en : in std_logic;
				data_in : in unsigned(15 downto 0);
				data_out : out unsigned(15 downto 0)
		);
	end component;
 
	signal reg_write0,reg_write1,reg_write2,reg_write3,reg_write4,reg_write5,reg_write6,reg_write7: std_logic;
	signal write_data0,write_data1,write_data2,write_data3,write_data4,write_data5,write_data6,write_data7: unsigned(15 downto 0);
	signal reg_out0,reg_out1,reg_out2,reg_out3,reg_out4,reg_out5,reg_out6,reg_out7: unsigned(15 downto 0);

	begin
		reg0: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write0,data_in=>write_data0,data_out=>reg_out0);
 		reg1: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write1,data_in=>write_data1,data_out=>reg_out1);
 		reg2: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write2,data_in=>write_data2,data_out=>reg_out2);
 		reg3: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write3,data_in=>write_data3,data_out=>reg_out3);
 		reg4: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write4,data_in=>write_data4,data_out=>reg_out4);
 		reg5: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write5,data_in=>write_data5,data_out=>reg_out5);
 		reg6: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write6,data_in=>write_data6,data_out=>reg_out6);
 		reg7: reg16bits port map(clk=>clk,rst=>rst,wr_en=>reg_write7,data_in=>write_data7,data_out=>reg_out7);


 		--Leitura
		reg1_out <= "0000000000000000" when read_reg1 = "000" else
					reg_out1 when read_reg1 = "001" else
					reg_out2 when read_reg1 = "010" else
					reg_out3 when read_reg1 = "011" else
					reg_out4 when read_reg1 = "100" else
					reg_out5 when read_reg1 = "101" else
					reg_out6 when read_reg1 = "110" else
					reg_out7 when read_reg1 = "111" else
					"0000000000000000";

		reg2_out <= "0000000000000000" when read_reg2 = "000" else
					reg_out1 when read_reg2 = "001" else
					reg_out2 when read_reg2 = "010" else
					reg_out3 when read_reg2 = "011" else
					reg_out4 when read_reg2 = "100" else
					reg_out5 when read_reg2 = "101" else
					reg_out6 when read_reg2 = "110" else
					reg_out7 when read_reg2 = "111" else
					"0000000000000000";


		--Escrita reg
		reg_write0 <= '0'; --Não pode escrever no registrador 0
		reg_write1 <= '1' when reg_write = '1' and write_reg = "001" else '0';
		reg_write2 <= '1' when reg_write = '1' and write_reg = "010" else '0';
		reg_write3 <= '1' when reg_write = '1' and write_reg = "011" else '0';
		reg_write4 <= '1' when reg_write = '1' and write_reg = "100" else '0';
		reg_write5 <= '1' when reg_write = '1' and write_reg = "101" else '0';
		reg_write6 <= '1' when reg_write = '1' and write_reg = "110" else '0';
		reg_write7 <= '1' when reg_write = '1' and write_reg = "111" else '0';

		write_data0 <= "0000000000000000";
		write_data1 <= write_data when reg_write1 = '1' and  write_reg = "001" else "0000000000000000";
		write_data2 <= write_data when reg_write2 = '1' and  write_reg = "010" else "0000000000000000";
		write_data3 <= write_data when reg_write3 = '1' and  write_reg = "011" else "0000000000000000";
		write_data4 <= write_data when reg_write4 = '1' and  write_reg = "100" else "0000000000000000";
		write_data5 <= write_data when reg_write5 = '1' and  write_reg = "101" else "0000000000000000";
		write_data6 <= write_data when reg_write6 = '1' and  write_reg = "110" else "0000000000000000";
		write_data7 <= write_data when reg_write7 = '1' and  write_reg = "111" else "0000000000000000";

end architecture;