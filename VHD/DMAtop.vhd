LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DMAtop IS
    PORT (
        Clk100 : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        Write_en : IN STD_LOGIC;
        oe : IN STD_LOGIC;
        CS : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        databus_aux : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_SW : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_TempH, out_TempL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

        Send_comm : IN STD_LOGIC;
        DMA_ACK : IN STD_LOGIC;
        DMA_RQ : OUT STD_LOGIC;
        ready : OUT STD_LOGIC;

        rd : IN STD_LOGIC;
        td : OUT STD_LOGIC
    );
END DMAtop;

ARCHITECTURE Behavioral OF DMAtop IS

    COMPONENT RAMtop
        PORT (
            Clk : IN STD_LOGIC;
            Reset : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            oe : IN STD_LOGIC; --activo nivel bajo
            cs : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            out_SW : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            out_TempH, out_TempL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

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

    COMPONENT RS232top
        PORT (
            Reset : IN STD_LOGIC; -- Low_level-active asynchronous reset
            Clk100MHz : IN STD_LOGIC; -- System clock (20MHz), rising edge used
            Data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Data to be sent
            Valid_D : IN STD_LOGIC; -- Handshake signal
            -- from guest system, low when data is valid
            Ack_in : OUT STD_LOGIC; -- ACK for data received, low once data
            -- has been stored
            TX_RDY : OUT STD_LOGIC; -- System ready to transmit
            TD : OUT STD_LOGIC; -- RS232 Transmission line
            RD : IN STD_LOGIC; -- RS232 Reception line
            Data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Received data
            Data_read : IN STD_LOGIC; -- Data read for guest system
            Full : OUT STD_LOGIC; -- Full internal memory
            Empty : OUT STD_LOGIC -- Empty internal memory
        );
    END COMPONENT;

    COMPONENT Clk_Gen
        PORT (
            resetn : IN STD_LOGIC;
            clk_in1 : IN STD_LOGIC;
            clk_out1 : OUT STD_LOGIC;
            locked : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL CLK20 : STD_LOGIC;

    SIGNAL tfull, tempty : STD_LOGIC;

    SIGNAL tValid_D : STD_LOGIC;
    SIGNAL tTX_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL tRCVD_Data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL tData_Read : STD_LOGIC;
    SIGNAL tTX_RDY, tACK_out : STD_LOGIC;

    SIGNAL wendma : STD_LOGIC;
    SIGNAL oedma : STD_LOGIC;
    SIGNAL csdma : STD_LOGIC;
    SIGNAL addressdma : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL databus : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL wenram : STD_LOGIC;
    SIGNAL oeram : STD_LOGIC;
    SIGNAL csram : STD_LOGIC;
    SIGNAL addressram : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

    wenram <= wendma;
    wenram <= write_en;

    oeram <= oedma;
    oeram <= oe;

    csram <= csdma;
    csram <= cs;

    addressram <= addressdma;
    addressram <= address;

    databus <= databus_aux;
    proc_address : PROCESS (cs, csdma)
    BEGIN
        IF (cs = '1') THEN
            addressram <= address;
        ELSIF (csdma = '1') THEN
            addressram <= addressdma;
        ELSE
            addressram <= "00000000";
        END IF;

    END PROCESS proc_address;

    Clock_generator : Clk_Gen
    PORT MAP(
        resetn => reset,
        clk_in1 => Clk100,
        clk_out1 => Clk20,
        locked => OPEN);

    RAM : RAMtop
    PORT MAP(
        clk => clk20,
        reset => reset,
        write_en => wenram,
        oe => oeram,
        cs => csram,
        address => addressram,
        databus => databus,
        out_SW => out_SW,
        out_TempH => out_TempH,
        out_TempL => out_TempL
    );

    RS232 : RS232top
    PORT MAP(
        reset => reset,
        Clk100MHz => Clk100,

        td => td,
        rd => rd,

        Data_in => tTX_Data,
        Valid_D => tValid_D,
        Ack_in => tACK_out,
        TX_RDY => tTX_RDY,
        Data_out => tRCVD_Data,
        Data_Read => tData_Read,
        full => tfull,
        Empty => tempty
    );

    DMAt : DMA
    PORT MAP(
        clk => clk20,
        reset => reset,

        RX_Full => tfull,
        RX_Empty => tempty,
        RCVD_Data => tRCVD_Data,
        Data_Read => tData_Read,

        ACK_out => tACK_out,
        TX_RDY => tTX_RDY,
        Valid_D => tValid_D,
        TX_Data => tTX_Data,

        databus => databus,
        write_en => wendma,
        oe => oedma,
        cs => csdma,
        address => addressdma,

        DMA_ACK => DMA_ACK,
        Send_comm => Send_comm,
        DMA_RQ => DMA_RQ,
        ready => ready
    );

END Behavioral;