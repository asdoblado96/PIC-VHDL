library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.RS232_test.all;

entity DMAtop_tb is
end;

architecture bench of DMAtop_tb is

  component DMAtop
      PORT (
          Clk100 : IN STD_LOGIC;
          reset : IN STD_LOGIC;
          Write_en : IN STD_LOGIC;
          oe : IN STD_LOGIC;
          CS : IN STD_LOGIC;
          address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          databus_aux : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          out_SW: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          out_TempH, out_TempL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          Send_comm : IN STD_LOGIC;
          DMA_ACK : IN STD_LOGIC;
          DMA_RQ : OUT STD_LOGIC;
          ready : OUT STD_LOGIC;
          rd : IN STD_LOGIC;
          td : OUT STD_LOGIC
      );
  end component;

  signal Clk100: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal Write_en: STD_LOGIC;
  signal oe: STD_LOGIC;
  signal CS: STD_LOGIC;
  signal address: STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal databus_aux: STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal out_SW: STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal out_TempH, out_TempL: STD_LOGIC_VECTOR(6 DOWNTO 0);
  signal Send_comm: STD_LOGIC;
  signal DMA_ACK: STD_LOGIC;
  signal DMA_RQ: STD_LOGIC;
  signal ready: STD_LOGIC;
  signal rd: STD_LOGIC;
  signal td: STD_LOGIC ;

  signal Data_transmit: std_logic_vector(7 downto 0);

begin

  uut: DMAtop port map ( Clk100      => Clk100,
                         reset       => reset,
                         Write_en    => Write_en,
                         oe          => oe,
                         CS          => CS,
                         address     => address,
                         databus_aux => databus_aux,
                         out_SW      => out_SW,
                         out_TempH   => out_TempH,
                         out_TempL   => out_TempL,
                         Send_comm   => Send_comm,
                         DMA_ACK     => DMA_ACK,
                         DMA_RQ      => DMA_RQ,
                         ready       => ready,
                         rd          => rd,
                         td          => td );

-- Clock generator
    p_clk : PROCESS
    BEGIN
        Clk100 <= '1', '0' AFTER 5 ns;
        WAIT FOR 10 ns;
    END PROCESS;

  stimulus: process
  begin

Write_en <= 'Z';
oe <= 'Z';
cs <= 'Z';
address <= "ZZZZZZZZ";
databus_aux <= "ZZZZZZZZ";
Send_comm <= '0';
DMA_ACK <= '0';
rd <= '1';

wait for 100 ns;

reset <= '0';
wait for 20 ns;
reset <= '1';

wait for 1000 ns;

Write_en <= '1';
cs <= '1';
address <= "00000100";
databus_aux <= "10101111";
wait for 100 ns;
Write_en <= 'Z';
cs <= 'Z';
databus_aux <= "ZZZZZZZZ";
address <= "ZZZZZZZZ";

wait for 100 ns;
Write_en <= '1';
cs <= '1';
address <= "00000101";
databus_aux <= "11111010";

wait for 100 ns;

cs <= 'Z';
Write_en <= 'Z';
databus_aux <= "ZZZZZZZZ";
address <= "ZZZZZZZZ";


Send_comm <= '1';

wait for 100 ns;
Send_comm <= '0';
Data_transmit <= "01101101"; --6D
wait for 20 ns;
Transmit(RD,Data_transmit);
wait for 200 ns;
Data_transmit <= "11101010"; --EA
wait for 400 ns;
DMA_ACK <= '1';
wait for 100 ns;
DMA_ACK <= '0';
Transmit(RD,Data_transmit);
wait for 200 ns;
Data_transmit <= "01001101"; --4D
wait for 20 ns;
Transmit(RD,Data_transmit);
wait for 800 ns;
DMA_ACK <= '1';
wait for 100 ns;
DMA_ACK <= '0';
wait for 500 ns;
DMA_ACK <= '1';
wait for 100 ns;
DMA_ACK <= '0';
wait;
  end process;


end;