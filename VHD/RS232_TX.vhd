LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY RS232_TX IS
    PORT (
        Start, Clk, Reset : IN std_logic;
        Data : IN std_logic_vector(7 DOWNTO 0);
        EOT, TX : OUT std_logic
    );
END RS232_TX;
ARCHITECTURE RTL OF RS232_TX IS

    CONSTANT reset_val : std_logic := '0';

    TYPE estados IS (Idle, StartBit, SendData, StopBit);
    SIGNAL SMCurrentState, SMNextState : estados;

    SIGNAL RData : std_logic_vector(7 DOWNTO 0);

    SIGNAL Pulse_With : std_logic;
    SIGNAL Enable_Cuenta : std_logic ;

    SIGNAL Clk_Count : INTEGER;
    SIGNAL Data_Count : INTEGER;

    CONSTANT PulseEndOfCount : INTEGER := 174;
BEGIN

logreg:    PROCESS (Clk, Reset)
    BEGIN
        IF (Reset = reset_val) THEN

            SMCurrentState <= Idle;

            RData <= (OTHERS => '0');

            Clk_Count <= 0;
            Pulse_With <= '0';
            Data_Count <= 0;

        ELSIF (Clk'event AND Clk = '1') THEN

            SMCurrentState <= SMNextState;

            RData <= Data; --enable?

            IF (Enable_Cuenta = '1') THEN --contador de ciclos de reloj
                Clk_Count <= Clk_Count + 1;
                IF Clk_Count < (PulseEndOfCount-2) THEN
                    Pulse_With <= '0';
                ELSE
                    Pulse_With <= '1';
                END IF;
            ELSE
                Clk_Count <= 0;
                Data_Count <= 0;
            END IF;

            IF Pulse_With = '1' THEN    --contador de datos
                Clk_Count <= 0;
                Pulse_With <= '0';
                IF Data_Count < 8 THEN
                    Data_Count <= Data_Count + 1;
                ELSE
                    Data_Count <= 0;
                END IF;
            END IF;

        END IF;
    END PROCESS; -- FFs

login:PROCESS (SMCurrentState, Start, Pulse_With, Data_Count)
    BEGIN

        CASE(SMCurrentState) IS

            WHEN Idle =>
            IF Start = '1' THEN
                SMNextState <= StartBit;
            ELSE
                SMNextState <= Idle;
            END IF;

            WHEN StartBit =>
            IF Pulse_With = '1' THEN
                SMNextState <= SendData;
            ELSE
                SMNextState <= StartBit;
            END IF;

            WHEN SendData =>
            IF Pulse_With = '1' AND Data_Count = 8 THEN
                SMNextState <= StopBit;
            ELSE
                SMNextState <= SendData;
            END IF;

            WHEN StopBit =>
            IF Pulse_With = '1' THEN
                SMNextState <= Idle;
            ELSE
                SMNextState <= StopBit;
            END IF;

        END CASE;

    END PROCESS;

logout : PROCESS (SMCurrentState, RData, Data_Count)
    BEGIN
        CASE(SMCurrentState) IS

            WHEN Idle =>
            EOT <= '1';
            TX <= '1';

            Enable_Cuenta <= '0';

            WHEN StartBit =>
            EOT <= '0';
            TX <= '0';

            Enable_Cuenta <= '1';

            WHEN SendData =>
            EOT <= '0';
            TX <= RData(Data_Count - 1);

            Enable_Cuenta <= '1';

            WHEN StopBit =>
            EOT <= '0';
            TX <= '1';

            Enable_Cuenta <= '1';

        END CASE;

    END PROCESS; -- Salida

END RTL;
