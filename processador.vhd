library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
	port( 	clk : in std_logic;
			rst : in std_logic
			--==================
			-- Coisas para teste
			--reg_write : in std_logic;
			--constante : in unsigned(15 downto 0); --"Constante"
			--sel_ula_in2 : in std_logic;-- 0:bank->ula   1:cte->ula
			--out_ula : out unsigned(15 downto 0); --saida da ula
			--read_reg1 : in unsigned(2 downto 0); --le registrador
			--read_reg2 : in unsigned(2 downto 0); --le registrador
			--write_reg : in unsigned(2 downto 0) --Seleciona em qual registrador escreve

	);
end entity;

architecture a_processador of processador is
	--==================================================
	--==== Componentes
	--==================================================

	--==== ULA

	component ula is
		port( 	entrA : in unsigned(15 downto 0);
				entrB : in unsigned(15 downto 0);
				sel : in unsigned(2 downto 0); -- bits de seleção num só bus
				saida : out unsigned(15 downto 0);
				zero: out std_logic;
				maior: out std_logic;
				carry: out std_logic
		);
	end component;

	--==== Banco de Registradores

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
	
	
	--==== UC
	component unidadeControle is
		port( 	clk : in std_logic;
				rst : in std_logic;
				-- Instruction register
				dado_rom : in unsigned(15 downto 0);
				read_reg1: out unsigned (2 downto 0);
				read_reg2: out unsigned (2 downto 0);
				write_reg: out unsigned (2 downto 0);
				cte : out unsigned(15 downto 0);

				-- Control
				reg_write : out std_logic;
				ALUSrcA : out std_logic;
				ALUSrcB : out unsigned(1 downto 0);
				ALUOp: out unsigned(2 downto 0);
				wr_en_pc: out std_logic
		);
	end component;
	
	
	--==== PC

	component pc is
		port( 	wr_en : in std_logic;
				rst : in std_logic; ----TEM QUE TER RESET?????
				clk : in std_logic;
				data_in : in unsigned(6 downto 0);
				data_out : out unsigned(6 downto 0)
		);
	end component;

	--==== ROM

	component rom is
		port( 	clk : in std_logic;
				endereco : in unsigned(6 downto 0);
				dado : out unsigned(15 downto 0)
		);
	end component;

	--==================================================
	--==== Ligacoes
	--==================================================

	--==== Sinais

	signal bank_out1, bank_out2: unsigned(15 downto 0);
	--signal bank_read_reg1, bank_read_reg2: unsigned(2 downto 0);
	signal bank_write_reg : unsigned(2 downto 0);
	signal reg_write : std_logic;
	
	signal data_pc : unsigned(6 downto 0);
	signal data_in_pc : unsigned(6 downto 0);
	signal data_out_pc: unsigned(6 downto 0);

	signal ula_in1, ula_in2: unsigned(15 downto 0);
	signal read_reg1,read_reg2: unsigned (2 downto 0);
	signal cte: unsigned(15 downto 0);
	signal write_reg : unsigned(2 downto 0);
	signal ula_out: unsigned(15 downto 0);
	signal sel_ula : unsigned(2 downto 0);
	signal zero_ula_out : std_logic;
	signal maior_ula_out : std_logic;
	signal carry_ula_out : std_logic;
	--signal wr_en : std_logic;

	signal wr_en_pc : std_logic;
	signal data_rom: unsigned(15 downto 0);
	
	signal ALUSrcA : std_logic;
	signal ALUSrcB : unsigned(1 downto 0);

	begin
		--==== Port Maps
		bank8reg_p: bank8reg port map(	read_reg1 =>read_reg1,
										read_reg2 =>read_reg2,
										write_reg => write_reg,
										write_data=>ula_out,
										reg_write=>reg_write,--flag
										clk => clk,
										rst => rst,
										reg1_out =>bank_out1,
										reg2_out =>bank_out2
							);

		ula_p: ula port map(	entrA=>ula_in1,
								entrB=>ula_in2,
								sel=>sel_ula,
								saida => ula_out,
								zero=>zero_ula_out,
								maior=>maior_ula_out,
								carry=>carry_ula_out
								);

		pc_p: pc port map(	clk => clk,
						  	rst => rst,
						  	wr_en => wr_en_pc,
						  	data_in => data_in_pc,
						  	data_out => data_out_pc
						);

		rom_p: rom port map(clk => clk,
							endereco=>data_out_pc,
							dado=>data_rom
							);

		unidadeControle_p: unidadeControle port map( clk => clk,
											rst => rst,
											dado_rom =>data_rom,
											read_reg1=>read_reg1,
											read_reg2=>read_reg2,
											cte => cte,
											write_reg=>write_reg,
											reg_write=>reg_write,
											ALUSrcA=>ALUSrcA,
											ALUSrcB=>ALUSrcB,
											ALUOp=>sel_ula,
											wr_en_pc=>wr_en_pc
										   );

		--==== Ligacoes
		
		ula_in1 <= 	bank_out1 when ALUSrcA = '1' else
					"000000000"&data_out_pc;

		ula_in2 <= bank_out2	 when ALUSrcB = "00" else
				"0000000000000001" when ALUSrcB = "01" else--proxima instrucao
				cte when ALUSrcB = "10" else--cte
				"0000000000000000"; -- mov
				   

		--Mux
		--ula_in2 <= bank_out2 when ALUSrc = '0' else
		--		   constante;


		--out_ula <= ula_out;

		--wr_en_pc <= '0';
		data_in_pc <= ula_out(6 downto 0);

end architecture;