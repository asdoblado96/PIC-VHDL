library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;

entity DMA_tb_RX is
end DMA_tb_RX;

architecture Behavioral of DMA_tb_RX is

    COMPONENT DMA 
    PORT (
        --global
        Reset, Clk : IN STD_LOGIC;

        --receptor RS232
        RX_Full, RX_Empty : IN STD_LOGIC;
        RCVD_Data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);

        Data_Read : OUT STD_LOGIC;

        --transmisor RS232
        ACK_out, TX_RDY : IN STD_LOGIC;

        Valid_D : OUT STD_LOGIC;
        TX_Data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

        --RAM
        Databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);

        Write_en, OE, CS : OUT STD_LOGIC;
        Address : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

        --Procesador
        DMA_ACK, Send_comm : IN STD_LOGIC;

        DMA_RQ, READY : OUT STD_LOGIC
    );
END COMPONENT;

signal reset, clk, RX_Full, RX_Empty,Data_Read,ACK_out,
    TX_RDY, Valid_D, Write_en,oe, CS, DMA_ACK, Send_comm, DMA_RQ
    ,READY : STD_LOGIC;

signal RCVD_Data,TX_Data,Databus, Address: STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

    uut: DMA
        PORT MAP(reset => Reset, clk => clk, RX_Full => RX_Full,
        RX_Empty => RX_Empty, Data_Read => Data_Read, ACK_out => ACK_out,
        TX_RDY => TX_RDY, Valid_D => Valid_D, Write_en => Write_en,
        oe => oe, cs => cs, DMA_ACK => DMA_ACK, Send_comm => Send_comm,
        DMA_RQ => DMA_RQ, READY => READY, RCVD_Data=> RCVD_Data,
        TX_Data=>TX_Data, Databus=>Databus, Address=>Address
    );

    -- Clock generator
    p_clk : PROCESS
        BEGIN
            clk <= '1', '0' AFTER 5 ns;
            WAIT FOR 10 ns;
        END PROCESS;

        PROCESS
    BEGIN

    reset <= '1', '0' after 75 ns, '1' after 600 ns;
    send_comm <= '0';

    RX_Empty <= '1', '0' after 1000 ns, '1' after 1005 ns,'0' after 1200 ns, '1' after 1205 ns,'0' after 1300 ns, '1' after 1305 ns;
    RCVD_Data <= "00000000", "00000001" after 950 ns, "00000010" after 1100 ns, "00000100" after 1200 ns;
    
    DMA_ACK <= '0', '1' after 1100 ns, '0' after 1400 ns;
    wait;
    END PROCESS;

end Behavioral;
