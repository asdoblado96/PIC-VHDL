LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
USE work.PIC_pkg.ALL;

ENTITY DMA IS
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
END DMA;

ARCHITECTURE RTL OF DMA IS

    TYPE estado IS (Idle, waitTransmit,prepTransmit, Transmit,
        BUS_RQ,prepReceive,Receive,Receive_1, finishReceive);

    SIGNAL SMCurrentState, SMNextState : estado;

    CONSTANT rst_val : STD_LOGIC := '0';

    SIGNAL CT, CR : unsigned(1 DOWNTO 0) ;
    Signal enable_CT, enable_CR : std_logic;
    signal resetCT,resetCR: std_logic;
BEGIN

    logreg : PROCESS (clk, reset)
    BEGIN
        IF reset = rst_val THEN

            SMCurrentState <= Idle;
            CR <= "00";
            CT <= "00";

        ELSIF rising_edge(clk) THEN

            SMCurrentState <= SMNextState;

            IF (enable_CR='1') THEN
                CR <= CR+1;
            ELSIF resetCR='1' then
                CR <= (others => '0');
            end IF;
            
            IF (enable_CT='1') THEN
                CT <= CT+1;
            ELSIF resetCT='1' then
                CT <=(others => '0');
            end IF;

        END IF;
    END PROCESS logreg;

    login: PROCESS (SMCurrentState,Send_comm, RX_Empty, TX_RDY, CT, CR, ACK_out, DMA_ACK)

    BEGIN
    
        CASE SMCurrentState IS
            WHEN Idle =>

                IF RX_Empty = '0' THEN
                SMNextState <= BUS_RQ;
                ELSIF Send_comm = '1' THEN
                SMNextState <= waitTransmit;
                ELSE
                SMNextState <= Idle;
                END IF;

            WHEN waitTransmit =>

                IF TX_RDY = '1' THEN
                    SMNextState <= PrepTransmit;
                ELSE
                    SMNextState <= waitTransmit;
                END IF;  
                
            WHEN PrepTransmit =>
            
                 SMNextState <= Transmit;

            WHEN Transmit => 

                IF ACK_out = '0' then
                    IF CT<2 THEN
                    SMNextState <= waitTransmit;
                    ELSE
                    SMNextState <= IDLE;
                    end if;
                ELSE
                    SMNextState <= Transmit;
                END IF;

            WHEN BUS_RQ =>

                IF DMA_ACK = '1' THEN
                    SMNextState <= prepReceive;
                ELSE
                    SMNextState <= BUS_RQ;
                END IF;

            when prepReceive => 
            
            if CR = 0 then
        
            SMNextState <= Receive_1;
            else
            SMNextState <= Receive;
            
            end if;
            
            WHEN Receive_1 =>
            
                SMNextState <= Receive;

            WHEN Receive =>

            IF CR > 2 THEN
                SMNextState <= finishReceive;

            ELSE
                SMNextState <= Idle;
            END IF;

            when finishReceive => 
            SMNextState <= Idle;

        END CASE;

    END PROCESS login;

    logout : PROCESS (SMCurrentState,CT,CR,Databus, RCVD_Data)
    BEGIN

        enable_CR <= '0';
        enable_CT <= '0';
        resetCT<='0';
        resetCR<='0';

        
        READY <= '0';
        DMA_RQ <= '0';

        Write_en <= 'Z';
        oe <= 'Z'; --activo nivel bajo
        CS <= 'Z';

        Data_Read <= '0'; 
        Databus <=  (others => 'Z');
        Address <= (others => 'Z');

        Valid_D <= '1';
        TX_Data<="00000000";


        CASE SMCurrentState IS

            WHEN Idle =>

                resetCT <='1';
                READY <= '1';

            WHEN waitTransmit =>
            
            WHEN PrepTransmit =>
                 enable_CT <= '1';

            WHEN Transmit =>

                Valid_D <= '0';
                
                Write_en <= '0';
                oe <= '0'; 
                CS <= '1';

                Address <= std_logic_vector(resize(CT,8)+3);
                TX_Data <=  Databus;

            WHEN BUS_RQ =>
                DMA_RQ <= '1';

            WHEN prepReceive => 

                enable_CR <= '1';
                Data_Read <= '1';

            when Receive_1 =>
                
                Write_en <= '1';
                oe <= '1'; 
                CS <= '1';
                Databus <=  "00000000";
                Address <= "00000011";

            WHEN Receive =>

                Write_en <= '1';
                oe <= '1'; 
                CS <= '1';
                Databus <=  RCVD_Data;
                Address <= std_logic_vector(resize(CR,8)-1);

            WHEN finishReceive => 

                resetCR <= '1';
                
                Write_en <= '1';
                oe <= '1'; --activo nivel bajo
                CS <= '1';
                Databus <=  "11111111";
                Address <= "00000011";

        END CASE;


    END PROCESS logout;

END RTL;