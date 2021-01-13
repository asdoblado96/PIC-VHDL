
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PIC_pkg.ALL;

entity CPU is
    port ( Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           ROM_Data : in  STD_LOGIC_VECTOR (11 downto 0);
           ROM_Addr : out  STD_LOGIC_VECTOR (11 downto 0);
           RAM_Addr : out  STD_LOGIC_VECTOR (7 downto 0);
           RAM_Write : out  STD_LOGIC;
           RAM_OE : out  STD_LOGIC;
           Databus : inout  STD_LOGIC_VECTOR (7 downto 0);
           DMA_RQ : in  STD_LOGIC;
           DMA_ACK : out  STD_LOGIC;
           SEND_comm : out  STD_LOGIC;
           DMA_READY : in  STD_LOGIC;
           Alu_op : out  alu_op;
           Index_Reg : in  STD_LOGIC_VECTOR (7 downto 0);
           FlagZ : in  STD_LOGIC;
           FlagC : in  STD_LOGIC;
           FlagN : in  STD_LOGIC;
           FlagE : in  STD_LOGIC);
end CPU;

architecture Behavioral of CPU is

		type State is (Idle, Fetch, Op_Fetch, Decode, Execute, Receive, Transmit);

		signal current_state, next_state: State;
		signal PC_reg, INS_reg, TMP_reg: std_logic_vector(7 downto 0);
		signal PC_reg_tmp, INS_reg_tmp, TMP_reg_tmp: std_logic_vector(7 downto 0);
		
begin

ROM_Addr <= "0000" & PC_reg;

process(current_state, FlagZ, Index_Reg, DMA_RQ, DMA_READY, ROM_Data, PC_reg, INS_reg, TMP_reg)
begin
		-- Valores por defecto
		Databus <= "ZZZZZZZZ";
		RAM_Addr <= "ZZZZZZZZ";
		RAM_Write <= 'Z';
		RAM_OE <= 'Z';
		DMA_Ack <= '0';
		Send_comm <= '0';
		ALU_op <= nop;
		next_state <= current_state;
		INS_reg_tmp <= INS_reg;
		PC_reg_tmp <= PC_reg;
		TMP_reg_tmp <= TMP_reg;

		case current_state is

			when Idle =>
				if DMA_RQ='1' then
					next_state <= Receive;
				else
					next_state <= Fetch;
				end if;

			when Receive =>
				DMA_ACK<='1';
				if DMA_RQ='0' then
					next_state <= Fetch;
				end if;

			when Fetch =>
				INS_reg_tmp <= ROM_Data(7 downto 0);
				PC_reg_tmp <= PC_reg+1;
				next_state <= Decode;

			when Decode =>
				case INS_reg(7 downto 6) is
					when TYPE_1 =>
						next_state <= Execute;
					when TYPE_2 =>
						next_state <= Op_Fetch;
					when TYPE_3 =>
						if INS_reg(5 downto 3)=(LD & SRC_ACC) then
							next_state <= Execute;
						else
							next_state <= Op_Fetch;
						end if;
					when TYPE_4 =>
						next_state <= Transmit;
					when others =>
				end case;

			when Op_Fetch =>
					TMP_reg_tmp <= ROM_Data(7 downto 0);
					PC_reg_tmp <= PC_reg+1;
					next_state <= Execute;

			when Execute =>
				case INS_reg(7 downto 6) is

					when TYPE_1 =>
						case INS_reg(5 downto 0) is
							when ALU_ADD =>
								Alu_op <= op_add;
							when ALU_SUB =>
								Alu_op <= op_sub;
							when ALU_SHIFTL =>
								Alu_op <= op_shiftl;
							when ALU_SHIFTR =>
								Alu_op <= op_shiftr;
							when ALU_AND =>
								Alu_op <= op_and;
							when ALU_OR =>
								Alu_op <= op_or;
							when ALU_XOR =>
								Alu_op <= op_xor;
							when ALU_CMPE =>
								Alu_op <= op_cmpe;
							when ALU_CMPL =>
								Alu_op <= op_cmpl;
							when ALU_CMPG =>
								Alu_op <= op_cmpg;
							when ALU_ASCII2BIN =>
								Alu_op <= op_ascii2bin;
							when ALU_BIN2ASCII =>
								Alu_op <= op_bin2ascii;					
							when others =>
						end case;
						next_state <= Idle;

					when TYPE_2 =>
						case INS_reg(5 downto 0) is
							when JMP_UNCOND =>
								PC_reg_tmp <= TMP_reg;
							when JMP_COND =>
								if FlagZ='1' then
									PC_reg_tmp <= TMP_reg;
								end if;
							when others =>
						end case;
						next_state <= Idle;

					when TYPE_3 =>
						if INS_reg(5)='0' then  -- Registros o lectura de memoria

							case INS_reg(4 downto 0) is

								-- Transferencias entre registros
								when SRC_ACC & DST_A =>
									Alu_op <= op_mvacc2a;
									next_state <= Idle;
								when SRC_ACC & DST_B =>
									Alu_op <= op_mvacc2b;
									next_state <= Idle;
								when SRC_ACC & DST_INDX =>
									Alu_op <= op_mvacc2id;
									next_state <= Idle;

								-- Carga de registros con constantes
								when SRC_CONSTANT	& DST_A =>
									Alu_op <= op_lda;
									Databus <= TMP_reg(7 downto 0);
									next_state <= Idle;
								when SRC_CONSTANT	& DST_B =>
									Alu_op <= op_ldb;
									Databus <= TMP_reg(7 downto 0);
									next_state <= Idle;
								when SRC_CONSTANT	& DST_INDX =>
									Alu_op <= op_ldid;
									Databus <= TMP_reg(7 downto 0);
									next_state <= Idle;
								when SRC_CONSTANT	& DST_ACC =>
									Alu_op <= op_ldacc;
									Databus <= TMP_reg(7 downto 0);
									next_state <= Idle;

								-- Carga de registros desde memoria
								when SRC_MEM & DST_A =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0);
									Alu_op <= op_lda;
									next_state <= Idle;
								when SRC_MEM & DST_B =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0);
									Alu_op <= op_ldb;
									next_state <= Idle;
								when SRC_MEM & DST_ACC =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0);
									Alu_op <= op_ldacc;
									next_state <= Idle;
								when SRC_MEM & DST_INDX =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0);
									Alu_op <= op_ldid;
									next_state <= Idle;

								-- Carga de registros desde memoria indexada
								when SRC_INDXD_MEM &	DST_A =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0)+Index_Reg;
									Alu_op <= op_lda;
									next_state <= Idle;
								when SRC_INDXD_MEM &	DST_B =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0)+Index_Reg;
									Alu_op <= op_ldb;
									next_state <= Idle;
								when SRC_INDXD_MEM &	DST_ACC =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0)+Index_Reg;
									Alu_op <= op_ldacc;
									next_state <= Idle;
								when SRC_INDXD_MEM &	DST_INDX =>
									RAM_OE <= '0';
									RAM_Write <= '0';
									RAM_Addr <= TMP_reg(7 downto 0)+Index_Reg;
									Alu_op <= op_ldid;
									next_state <= Idle;

								when others =>
							end case;

						else  -- Escritura en memoria
							Alu_op <= op_oeacc;
							case INS_reg(4 downto 0) is

								when SRC_ACC & DST_MEM =>
									RAM_Write <= '1';
									RAM_OE <= '1';
									RAM_Addr <= TMP_reg(7 downto 0);
									next_state <= Idle;
								when SRC_ACC & DST_INDXD_MEM =>
									RAM_Write <= '1';
									RAM_OE <= '1';
									RAM_Addr <= TMP_reg(7 downto 0)+Index_Reg;
									next_state <= Idle;

								when others =>
							end case;		
						end if;

					when TYPE_4 =>
					when others =>
				end case;

			when Transmit =>
				SEND_comm <= '1';
				if DMA_READY='1' then
					next_state <= Idle;
				end if;				

		end case;
end process;

PROCESS (reset, clk)
BEGIN
	if reset='0' then
		current_state <= Idle;
		PC_reg <= (others=>'0');
	elsif clk'event and clk='1' then
      current_state <= next_state;
		PC_reg <= PC_reg_tmp;
		INS_reg <= INS_reg_tmp;
		TMP_reg <= TMP_reg_tmp;
	end if;
END PROCESS;

end Behavioral;
