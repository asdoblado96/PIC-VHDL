
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

USE work.PIC_pkg.ALL;

ENTITY PICtop IS
  PORT (
    Reset : IN STD_LOGIC; -- Asynchronous, active low
    Clk : IN STD_LOGIC; -- System clock, 100 MHz, rising_edge
    RS232_RX : IN STD_LOGIC; -- RS232 RX line
    RS232_TX : OUT STD_LOGIC; -- RS232 TX line
    switches : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Switch status bargraph
    Temp : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Display value for T_STAT
    Disp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)); -- Display activation for T_STAT
END PICtop;

ARCHITECTURE behavior OF PICtop IS

  SIGNAL clk20 : STD_LOGIC;

  COMPONENT Clk_Gen
    PORT (
      RESETN : IN STD_LOGIC;
      CLK_IN1 : IN STD_LOGIC;
      CLK_OUT1 : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT RS232top
    PORT (
      Reset : IN STD_LOGIC;
      Clk : IN STD_LOGIC;
      Data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Valid_D : IN STD_LOGIC;
      Ack_in : OUT STD_LOGIC;
      TX_RDY : OUT STD_LOGIC;
      TD : OUT STD_LOGIC;
      RD : IN STD_LOGIC;
      Data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      Data_read : IN STD_LOGIC;
      Full : OUT STD_LOGIC;
      Empty : OUT STD_LOGIC);
  END COMPONENT;

  COMPONENT ALU
    PORT (
      Reset : IN STD_LOGIC;
      Clk : IN STD_LOGIC;
      u_instruction : IN alu_op;
      FlagZ : OUT STD_LOGIC;
      FlagC : OUT STD_LOGIC;
      FlagN : OUT STD_LOGIC;
      FlagE : OUT STD_LOGIC;
      Index_Reg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      Databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT CPU
    PORT (
      Reset : IN STD_LOGIC;
      Clk : IN STD_LOGIC;
      ROM_Data : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      ROM_Addr : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
      RAM_Addr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      RAM_Write : OUT STD_LOGIC;
      RAM_OE : OUT STD_LOGIC;
      Databus : INOUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      DMA_RQ : IN STD_LOGIC;
      DMA_ACK : OUT STD_LOGIC;
      SEND_comm : OUT STD_LOGIC;
      DMA_READY : IN STD_LOGIC;
      Alu_op : OUT alu_op;
      Index_Reg : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      FlagZ : IN STD_LOGIC;
      FlagC : IN STD_LOGIC;
      FlagN : IN STD_LOGIC;
      FlagE : IN STD_LOGIC
    );
  END COMPONENT;

  COMPONENT DMA
    PORT (
      Reset, Clk : IN STD_LOGIC;
      RX_Full, RX_Empty : IN STD_LOGIC;
      RCVD_Data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      Data_Read : OUT STD_LOGIC;
      ACK_out, TX_RDY : IN STD_LOGIC;
      Valid_D : OUT STD_LOGIC;
      TX_Data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      Databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      Write_en, OE, CS : OUT STD_LOGIC;
      Address : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      DMA_ACK, Send_comm : IN STD_LOGIC;
      DMA_RQ, READY : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT ROM
    PORT (
      Instruction : OUT STD_LOGIC_VECTOR(11 DOWNTO 0); -- Instruction bus
      Program_counter : IN STD_LOGIC_VECTOR(11 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT RAMtop
    PORT (
      Clk : IN STD_LOGIC;
      Reset : IN STD_LOGIC;
      write_en : IN STD_LOGIC;
      oe : IN STD_LOGIC; --activo nivel bajo
      CS : IN STD_LOGIC;
      address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);

      out_SW : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      out_TempH, out_TempL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
  END COMPONENT;

  CONSTANT Reset_val : STD_LOGIC := '0';


  SIGNAL RX_Full : STD_LOGIC;
  SIGNAL RX_Empty : STD_LOGIC;
  SIGNAL Valid_D : STD_LOGIC;
  SIGNAL ACK_out : STD_LOGIC;
  SIGNAL TX_Rdy : STD_LOGIC;
  SIGNAL Data_Read : STD_LOGIC;

  SIGNAL TX_Data : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL RCVD_Data : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL databus : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL RAM_address : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL RAM_write_en : STD_LOGIC;
  SIGNAL RAM_oe : STD_LOGIC;
  SIGNAL DMA_ACK : STD_LOGIC;
  SIGNAL Send_comm : STD_LOGIC;
  SIGNAL DMA_RQ : STD_LOGIC;
  SIGNAL DMA_READY : STD_LOGIC;
  SIGNAL CS : STD_LOGIC := '1';

  SIGNAL u_instruction : alu_op;
  SIGNAL FlagZ, FlagC, FlagE, FlagN : STD_LOGIC;
  SIGNAL Index_Reg : STD_LOGIC_VECTOR(7 DOWNTO 0);

  signal ROM_ins, ROM_PC: std_logic_vector(11 downto 0);

  signal TempL,TempH:std_logic_vector(6 downto 0);
  signal display: std_logic_vector(1 downto 0):="01";

  signal counterD: integer;
BEGIN -- behavior

  Clk_global : Clk_Gen
  PORT MAP(
    resetn => reset,
    CLK_IN1 => clk,
    clk_out1 => clk20
  );

  RS232_PHY : RS232top
  PORT MAP(
    Reset => Reset,
    Clk => Clk20,

    Data_in => TX_Data,
    Valid_D => Valid_D,
    Ack_in => Ack_out,
    TX_RDY => TX_RDY,
    TD => RS232_TX,

    RD => RS232_RX,
    Data_out => RCVD_Data,
    Data_read => Data_read,
    Full => RX_Full,
    Empty => RX_Empty
  );

  DMA_PHY : DMA
  PORT MAP(
    Reset => reset,
    clk => clk20,
    RX_Full => RX_Full,
    RX_Empty => RX_Empty,
    RCVD_Data => RCVD_Data,
    Data_Read => Data_Read,
    ACK_out => Ack_out,
    TX_RDY => TX_RDY,
    Valid_D => Valid_D,
    TX_Data => TX_Data,
    Databus => Databus,
    Write_en => RAM_write_en,
    OE => RAM_OE,
    CS => open,
    Address => RAM_Address,
    DMA_ACK => DMA_ACK,
    SEND_comm => SEND_comm,
    DMA_RQ => DMA_RQ,
    READY => DMA_READY
  );

  ALU_PHY : ALU
  PORT MAP(
    reset => reset,
    clk => clk20,
    u_instruction => u_instruction,
    FlagC => FlagC,
    FlagE => FlagE,
    FlagN => FlagN,
    FlagZ => FlagZ,
    Index_Reg => Index_Reg,
    Databus => databus
  );

  CPU_PHY: CPU
  PORT MAP(
    reset => reset,
    clk => clk20,
    ROM_Data=> ROM_ins,
    ROM_Addr=> ROM_PC ,
    RAM_Addr=> RAM_Address,
    RAM_Write=> RAM_write_en,
    RAM_OE=> RAM_oe ,
    Databus=> databus,
    DMA_RQ=> DMA_RQ,
    DMA_ACK=>DMA_ACK ,
    SEND_comm=>Send_comm ,
    DMA_READY=> DMA_READY,
    Alu_op=>u_instruction ,
    Index_Reg=>Index_Reg ,
    FlagZ=> FlagZ,
    FlagC=>FlagC ,
    FlagN=>FlagN ,
    FlagE=>FlagE
  );

  ROM_PHY: ROM
  PORT MAP(
    Instruction => ROM_ins,
    Program_counter => ROM_PC

  );

  RAM_PHY: RAMtop
  PORT MAP(
    CLK => CLK20,
    reset => reset,
    write_en => RAM_write_en,
    oe => ram_oe,
    cs => cs,
    address => RAM_address,
    databus => databus,
    out_SW =>switches ,
    out_TempH => TempH,
    out_TempL => TempL

  );

displayp: process(clk20, reset)
begin
  if reset = reset_val then
    CounterD <=0; 
    Display<="01";
    Temp <= (others => '0');
  elsif rising_edge(clk20) then
    counterD <= CounterD + 1;
    
    if counterD=20000 then
        Display <= not(Display);
        counterD<=0;
    end if;

    if Display="01" then
      Temp <= TempL&'0';
    elsif Display="10" then
      Temp <= TempH&'0';
    else
      Temp <= (others => '0');
    end if;

  end if;



end process displayp;

Disp<=Display;

END behavior;