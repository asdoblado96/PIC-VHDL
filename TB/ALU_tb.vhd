LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.PIC_pkg.ALL;

entity tb_ALU is
end tb_ALU;

architecture tb of tb_ALU is

    component ALU
        port (Reset         : in std_logic;
              Clk           : in std_logic;
              u_instruction : in alu_op;
              FlagZ         : out std_logic;
              FlagC         : out std_logic;
              FlagN         : out std_logic;
              FlagE         : out std_logic;
              Index_Reg     : out std_logic_vector (7 downto 0);
              Databus       : inout std_logic_vector (7 downto 0));
    end component;

    signal Reset         : std_logic;
    signal Clk           : std_logic;
    signal u_instruction : alu_op;
    signal FlagZ         : std_logic;
    signal FlagC         : std_logic;
    signal FlagN         : std_logic;
    signal FlagE         : std_logic;
    signal Index_Reg     : std_logic_vector (7 downto 0);
    signal Databus       : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 50 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : ALU
    port map (Reset         => Reset,
              Clk           => Clk,
              u_instruction => u_instruction,
              FlagZ         => FlagZ,
              FlagC         => FlagC,
              FlagN         => FlagN,
              FlagE         => FlagE,
              Index_Reg     => Index_Reg,
              Databus       => Databus);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that Clk is really your main clock signal
    Clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        u_instruction <= nop;
        Databus <= (OTHERS => 'Z');


        -- Reset generation
        -- EDIT: Check that Reset is really your reset signal
        Reset <= '0';
        wait for 100 ns;
        Reset <= '1';
        wait for 125 ns;

        -- EDIT Add stimuli here
        wait for TbPeriod/2;

        u_instruction <= op_lda;
        Databus <= "10010001";

        wait for TbPeriod;
        u_instruction <= op_ldb;
        Databus <= "10010000";
        wait for TbPeriod;
        Databus <= "10000000";
        u_instruction <=  op_add;
        wait for TbPeriod;
        u_instruction <=  op_sub;
        wait for TbPeriod;
        u_instruction <=  op_and;
        wait for TbPeriod;
        u_instruction <=  op_or;
        wait for TbPeriod;
        u_instruction <=  op_xor;
        wait for TbPeriod;
        u_instruction <=  op_shiftl;
        wait for TbPeriod;
        u_instruction <=  op_shiftR;
        wait for TbPeriod;
        u_instruction <=  op_cmpe;
        wait for TbPeriod;
        u_instruction <=  op_cmpg;
        wait for TbPeriod;
        u_instruction <=  op_cmpl;
        wait for TbPeriod;
        u_instruction <=  op_mvacc2id;
        wait for TbPeriod;
        u_instruction <=  op_mvacc2a;
        wait for TbPeriod;
        u_instruction <=  op_mvacc2b;
        wait for TbPeriod;
        u_instruction <=  op_lda;
        Databus <= "00111000";
        wait for TbPeriod;
        u_instruction <=  op_ascii2bin;
        wait for TbPeriod;
        u_instruction <=  op_lda;
        Databus <= "10001000";
        wait for TbPeriod;
        u_instruction <=  op_bin2ascii;
        wait for TbPeriod;

        databus <= (others => 'Z');
        u_instruction <=  op_oeacc;

        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_ALU of tb_ALU is
    for tb
    end for;
end cfg_tb_ALU;