LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RS232_RX IS
    PORT (
        Reset, Clk, LineRD_in : IN STD_LOGIC;
        Valid_out, Code_out, Store_out : OUT STD_LOGIC
    );
END ENTITY RS232_RX;

ARCHITECTURE RTL OF RS232_RX IS

    CONSTANT reset_val : STD_LOGIC := '0';

    TYPE estados IS (Idle, StartBit, RcvData, StopBit);
    SIGNAL SMCurrentState, SMNextState : estados;

    CONSTANT PulseEndOfCount : INTEGER := 174;

    SIGNAL enable_hcounter : STD_LOGIC := '0';
    SIGNAL enable_fcounter : STD_LOGIC := '0';

    SIGNAL halfcounter : INTEGER := 0;
    SIGNAL halfbit : STD_LOGIC := '0';

    SIGNAL fullcounter : INTEGER := 0;
    SIGNAL fullbit : STD_LOGIC := '0';

    SIGNAL datacounter : INTEGER := 0;

BEGIN

    fsm : PROCESS (Clk, Reset)
    BEGIN
        IF Reset = reset_val THEN

            SMCurrentState <= Idle;

            halfcounter <= 0;
            fullcounter <= 0;

            halfbit <= '0';
            fullbit <= '0';

        ELSIF rising_edge(Clk) THEN

            SMCurrentState <= SMNextState;

            IF enable_hcounter = '1' THEN
                halfcounter <= halfcounter + 1;
                IF halfcounter < ((PulseEndOfCount/2) - 2) THEN
                    halfbit <= '0';
                ELSIF halfcounter = ((PulseEndOfCount/2) - 2) THEN
                    halfbit <= '1';
                ELSE
                    halfbit <= '0';
                    halfcounter <= 0;
                    enable_fcounter <= '1';
                END IF;
            ELSE
                enable_fcounter <= '0';
                fullbit <= '0';

                halfcounter <= 0;
                fullcounter <= 0;
                datacounter <= 0;
            END IF;

            IF enable_fcounter = '1' THEN
                fullcounter <= fullcounter + 1;

                IF fullcounter < PulseEndOfCount - 2 THEN
                    fullbit <= '0';
                ELSIF fullcounter = (PulseEndOfCount - 2) THEN
                    fullbit <= '1';
                ELSE
                    fullbit <= '0';
                    fullcounter <= 0;

                END IF;
            ELSE
                fullcounter <= 0;
            END IF;

            IF fullbit = '1' THEN
                datacounter <= datacounter + 1;
                IF datacounter > 8 THEN
                    datacounter <= 0;
                END IF;
            END IF;

        END IF;
    END PROCESS fsm;
    input : PROCESS (SMCurrentState, LineRD_in, fullbit, datacounter, halfbit)
    BEGIN
        CASE SMCurrentState IS

            WHEN Idle =>
                IF LineRD_in = '0' THEN
                    SMNextState <= StartBit;
                ELSE
                    SMNextState <= Idle;
                END IF;

            WHEN StartBit =>
                IF fullbit = '1' THEN
                    SMNextState <= RcvData;
                ELSE
                    SMNextState <= StartBit;
                END IF;

            WHEN RcvData =>
                IF fullbit = '1' AND LineRD_in = '1' AND datacounter = 8 THEN
                    SMNextState <= StopBit;
                ELSE
                    SMNextState <= RcvData;
                END IF;
            WHEN StopBit =>
                IF halfbit = '1' AND datacounter = 9 THEN
                    SMNextState <= Idle;
                ELSE
                    SMNextState <= StopBit;
                END IF;

        END CASE;
    END PROCESS input;
    output : PROCESS (SMCurrentState, LineRD_in, fullcounter)
    BEGIN
        CASE SMCurrentState IS

            WHEN Idle =>
                enable_hcounter <= '0';

                Store_out <= '0';
                Code_out <= '0';
                Valid_out <= '0';

            WHEN StartBit =>
                enable_hcounter <= '1';

                Store_out <= '0';
                Code_out <= '0';
                Valid_out <= '0';

            WHEN RcvData =>
                enable_hcounter <= '1';

                Store_out <= '0';
                Code_out <= LineRD_in;

                IF fullcounter = 0 THEN
                    Valid_out <= '1';
                ELSE
                    Valid_out <= '0';
                END IF;

            WHEN StopBit =>
                enable_hcounter <= '1';

                Code_out <= '1';
                Valid_out <= '0';
                
                
                IF fullcounter = 0 THEN
                    Store_out <= '1';
                ELSE
                    Store_out <= '0';
                END IF;

        END CASE;
    END PROCESS output;
END ARCHITECTURE RTL;