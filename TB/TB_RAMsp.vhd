library ieee;
use ieee.std_logic_1164.all;

entity tb_RAMtop is
end tb_RAMtop;

architecture tb of tb_RAMtop is

    component RAMtop
        port (Clk       : in std_logic;
              Reset     : in std_logic;
              write_en  : in std_logic;
              oe        : in std_logic;
              CS        : in std_logic;
              address   : in std_logic_vector (7 downto 0);
              databus   : inout std_logic_vector (7 downto 0);
              out_SW    : out std_logic_vector (7 downto 0);
              out_TempH : out std_logic_vector (6 downto 0);
              out_TempL : out std_logic_vector (6 downto 0));
    end component;

    signal Clk       : std_logic;
    signal Reset     : std_logic;
    signal write_en  : std_logic;
    signal oe        : std_logic;
    signal CS        : std_logic;
    signal address   : std_logic_vector (7 downto 0);
    signal databus   : std_logic_vector (7 downto 0);
    signal out_SW    : std_logic_vector (7 downto 0);
    signal out_TempH : std_logic_vector (6 downto 0);
    signal out_TempL : std_logic_vector (6 downto 0);

    constant TbPeriod : time := 100 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : RAMtop
    port map (Clk       => Clk,
              Reset     => Reset,
              write_en  => write_en,
              oe        => oe,
              CS        => CS,
              address   => address,
              databus   => databus,
              out_SW    => out_SW,
              out_TempH => out_TempH,
              out_TempL => out_TempL);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        write_en <= '0';
        oe <= '1';
        CS <= '1';
        address <= (others => 'Z');

        -- Reset generation
        -- EDIT: Check that Reset is really your reset signal
        Reset <= '0';
        wait for 100 ns;
        Reset <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        databus <= "00000001"; --1
        address <= "00010001"; --switch 2
        write_en <= '1';
        wait for TbPeriod;
        databus <= "00100001"; --21
        address <= "00110001"; --temp
        write_en <= '1';
        wait for TbPeriod;
        write_en <= '0';
        databus <= (others => 'Z');
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_RAMtop of tb_RAMtop is
    for tb
    end for;
end cfg_tb_RAMtop;