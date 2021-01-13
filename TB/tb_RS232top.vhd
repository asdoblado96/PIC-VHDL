library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

    use work.RS232_test.all;
    
entity RS232top_TB is
end RS232top_TB;

architecture Testbench of RS232top_TB is

  component RS232top
    port (
      Reset     : in  std_logic;
      Clk100MHz : in  std_logic;
      Data_in   : in  std_logic_vector(7 downto 0);
      Valid_D   : in  std_logic;
      Ack_in    : out std_logic;
      TX_RDY    : out std_logic;
      TD        : out std_logic;
      RD        : in  std_logic;
      Data_out  : out std_logic_vector(7 downto 0);
      Data_read : in  std_logic;
      Full      : out std_logic;
      Empty     : out std_logic);
  end component;
  
  signal Reset, Clk, Valid_D, Ack_in, TX_RDY : std_logic;
  signal TD, RD, Data_read, Full, Empty : std_logic;
  signal Data_out, Data_in,Data_transmit : std_logic_vector(7 downto 0);

begin

  UUT: RS232top
    port map (
      Reset     => Reset,
      Clk100MHz => Clk,
      Data_in   => Data_in,
      Valid_D   => Valid_D,
      Ack_in    => Ack_in,
      TX_RDY    => TX_RDY,
      TD        => TD,
      RD        => RD,
      Data_out  => Data_out,
      Data_read => Data_read,
      Full      => Full,
      Empty     => Empty);

 
  -- Clock generator
  p_clk : PROCESS
  BEGIN
     clk <= '1', '0' after 5 ns;
     wait for 10 ns;
  END PROCESS;

  -- Reset & Start generator
  p_reset : PROCESS
  BEGIN
    --primeros datos
    Data_in <= "11100010"; --E2
    Data_transmit <= "01101101"; --6D
    --reset
    reset <= '0', '1' after 75 ns;
    Valid_D <= '1';     
    RD <= '1';     
    Data_read <= '0';

    wait for 2500 ns; 
    --mandamos
    Valid_D <= '1', '0' after 110 ns,
                '1' after 400 ns;
    --recibimos
    Transmit(RD,Data_transmit);
    --almacenamos
    Data_read <= '0','1'after 10000 ns,
                  '0' after 10500 ns;
    --esperamos un poco
     wait for 12000 ns;
    --nuevos datos
    Data_in <= "11101010"; --EA
    Data_transmit <= "01111001"; -- 79
    --esperamos un pooc
    wait for 10000 ns;
    --mandamos
    Valid_D <= '1', '0' after 110 ns,
                '1' after 400 ns;
    --recibimos
    Transmit(RD,Data_transmit);
    --almacenamos
    Data_read <= '0','1'after 10000 ns,
                  '0' after 10500 ns;
    wait;
    
  END PROCESS;

end Testbench;

