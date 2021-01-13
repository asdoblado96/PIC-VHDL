
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE work.PIC_pkg.all;
USE work.RS232_test.all;

entity PICtop_tb is
end PICtop_tb;

architecture TestBench of PICtop_tb is

  component PICtop
    port (
      Reset    : in  std_logic;
      Clk      : in  std_logic;
      RS232_RX : in  std_logic;
      RS232_TX : out std_logic;
      switches : out std_logic_vector(7 downto 0);
      Temp     : out std_logic_vector(7 downto 0);
      Disp     : out std_logic_vector(1 downto 0));
    --TempL: OUT STD_LOGIC_VECTOR(6 DOWNTO O);
    --TempH: OUT STD_LOGIC_VECTOR(6 DOWNTO O);
  end component;

-----------------------------------------------------------------------------
-- Internal signals
-----------------------------------------------------------------------------

  signal Reset    : std_logic;
  signal Clk      : std_logic;
  signal RS232_RX : std_logic;
  signal RS232_TX : std_logic;
  signal switches : std_logic_vector(7 downto 0);
  signal Temp     : std_logic_vector(7 downto 0);
  signal Disp     : std_logic_vector(1 downto 0);
--signal TempL: OUT STD_LOGIC_VECTOR(6 DOWNTO O);
--signal TempH: OUT STD_LOGIC_VECTOR(6 DOWNTO O);

begin  -- TestBench

  UUT: PICtop
    port map (
        Reset    => Reset,
        Clk      => Clk,
        RS232_RX => RS232_RX,
        RS232_TX => RS232_TX,
        switches => switches,
        Temp     => Temp,
        Disp     => Disp);

-----------------------------------------------------------------------------
-- Reset & clock generator
-----------------------------------------------------------------------------

  Reset <= '0', '1' after 75 ns;

  p_clk : PROCESS
  BEGIN
     clk <= '1', '0' after 5 ns;
     wait for 10 ns;
  END PROCESS;

-------------------------------------------------------------------------------
-- Sending some stuff through RS232 port
-------------------------------------------------------------------------------

  SEND_STUFF : process
  begin
     RS232_RX <= '1';
     wait for 40 us;
     Transmit(RS232_RX, X"49");
     wait for 40 us;
     Transmit(RS232_RX, X"34");
     wait for 40 us;
     Transmit(RS232_RX, X"31");
     wait for 40 us;
     RS232_RX <= '1';
     wait for 340 us;
     Transmit(RS232_RX, X"54");
     wait for 40 us;
     Transmit(RS232_RX, X"32");
     wait for 40 us;
     Transmit(RS232_RX, X"31");
     wait;
  end process SEND_STUFF;
   
end TestBench;

