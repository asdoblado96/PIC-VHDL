LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.PIC_pkg.ALL;

ENTITY ALU IS
    PORT (
        Reset : IN STD_LOGIC;
        Clk : IN STD_LOGIC;
        u_instruction : IN alu_op;
        FlagZ : OUT STD_LOGIC;
        FlagC : OUT STD_LOGIC;
        FlagN : OUT STD_LOGIC;
        FlagE : OUT STD_LOGIC;
        Index_Reg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END ALU;

ARCHITECTURE RTL OF ALU IS

    CONSTANT Reset_val : STD_LOGIC := '0';

    SIGNAL Areg : signed(7 DOWNTO 0);
    SIGNAL Breg : signed(7 DOWNTO 0);
    SIGNAL Accreg : signed(7 DOWNTO 0);
    SIGNAL Idreg : signed(7 DOWNTO 0);

    SIGNAL tempR : signed(7 DOWNTO 0);

    SIGNAL E : STD_LOGIC;
    SIGNAL Z : STD_LOGIC;
    SIGNAL N : STD_LOGIC;
    SIGNAL C : STD_LOGIC;

    SIGNAL tE : STD_LOGIC;
    SIGNAL tZ : STD_LOGIC;
    SIGNAL tN : STD_LOGIC;
    SIGNAL tC : STD_LOGIC;
BEGIN

    regproc : PROCESS (clk, Reset)
    BEGIN
        IF Reset = Reset_val THEN

            Areg <= "00000000";
            Breg <= "00000000";
            Accreg <= "00000000";
            Idreg <= "00000000";
            Z <= '0';
            N <= '0';
            C <= '0';
            E <= '0';

        ELSIF rising_edge(clk) THEN

            CASE u_instruction IS

                WHEN nop =>

                WHEN op_lda =>

                    Areg <= signed(Databus);

                WHEN op_ldb =>

                    Breg <= signed(Databus);

                WHEN op_ldacc =>

                    Accreg <= signed(Databus);

                WHEN op_ldid =>

                    Idreg <= signed(Databus);

                WHEN op_mvacc2a =>

                    Areg <= accreg;

                WHEN op_mvacc2b =>

                    Breg <= accreg;

                WHEN op_mvacc2id =>

                    Idreg <= accreg;

                WHEN op_oeacc =>

                WHEN op_shiftl =>

                    FOR i IN 1 TO 7 LOOP
                        Accreg(i) <= Accreg(i - 1);
                    END LOOP;
                    Accreg(0) <= '0';

                WHEN op_shiftr =>

                    FOR i IN 0 TO 6 LOOP
                        Accreg(i) <= Accreg(i + 1);
                    END LOOP;
                    Accreg(7) <= '0';

                WHEN op_add =>
                    Z <= tz;
                    N <= tN;
                    C <= tC;
                    Accreg <= tempR;
                WHEN op_sub =>
                    Z <= tz;
                    N <= tN;
                    C <= tC;
                    Accreg <= tempR;
                WHEN op_and =>
                    Z <= tz;
                    Accreg <= tempR;
                WHEN op_xor =>
                    Z <= tz;
                    Accreg <= tempR;
                WHEN op_or =>
                    Z <= tz;
                    Accreg <= tempR;
                WHEN op_cmpe =>
                    Z <= tz;
                WHEN op_cmpg =>
                    Z <= tz;
                WHEN op_cmpl =>
                    Z <= tz;
                WHEN op_ascii2bin =>
                    e <= te;
                    Accreg <= tempR;
                WHEN op_bin2ascii =>
                    e <= te;
                    Accreg <= tempR;
                WHEN OTHERS =>
                    Accreg <= tempR;

            END CASE;
        END IF;
    END PROCESS regproc;

    outproc : PROCESS (u_instruction, tempR, tc, te, Areg, Breg,Accreg)
    BEGIN
        tempR <= (OTHERS => '0');
        Databus <= (OTHERS => 'Z');
        tE <= '0';
        tZ <= '0';
        tC <= '0';
        tN <= '0';

        CASE u_instruction IS
            WHEN op_add =>
                tempR <= Areg + Breg;

                IF ((Areg(7) = '0') AND (Breg(7) = '0')) THEN
                    tC <= tempR(7);
                ELSIF ((Areg(7) = '1') AND (Breg(7) = '1')) THEN
                    tC <= NOT(tempR(7));
                ELSE
                    tc <= '0';
                END IF;
                IF (Areg(3) = '0' AND Breg(3) = '0') THEN
                    tN <= tempR(3);
                ELSIF (Areg(3) = '1' AND Breg(3) = '1') THEN
                    tN <= NOT(tempR(3));
                ELSE
                    tN <= '0';
                END IF;

                tZ <= (NOT(TC)) AND (NOT(tempr(7) OR tempR(6)OR tempR(5)OR tempR(4)OR tempR(3)OR tempR(2)OR tempR(1)OR tempR(0)));

            WHEN op_sub =>
                tempR <= Areg - Breg;
                IF (Areg(7) = '0' AND Breg(7) = '1') THEN
                    tC <= tempR(7);
                ELSIF (Areg(7) = '1' AND Breg(7) = '0') THEN
                    tC <= NOT(tempR(7));
                ELSE
                    tc <= '0';
                END IF;
                IF (Areg(3) = '0' AND Breg(3) = '1') THEN
                    tC <= tempR(3);
                ELSIF (Areg(3) = '1' AND Breg(3) = '0') THEN
                    tC <= NOT(tempR(3));
                ELSE
                    tc <= '0';
                END IF;
                tZ <= (NOT(TC)) AND (NOT(tempr(7) OR tempR(6)OR tempR(5)OR tempR(4)OR tempR(3)OR tempR(2)OR tempR(1)OR tempR(0)));

            WHEN op_and =>

                tempR <= Areg AND Breg;
                tZ <= (NOT(tempr(7) OR tempR(6)OR tempR(5)OR tempR(4)OR tempR(3)OR tempR(2)OR tempR(1)OR tempR(0)));
            WHEN op_or =>

                tempR <= Areg OR Breg;
                tZ <= (NOT(tempr(7) OR tempR(6)OR tempR(5)OR tempR(4)OR tempR(3)OR tempR(2)OR tempR(1)OR tempR(0)));
            WHEN op_xor =>
                tempR <= Areg XOR Breg;
                tZ <= (NOT(tempr(7) OR tempR(6)OR tempR(5)OR tempR(4)OR tempR(3)OR tempR(2)OR tempR(1)OR tempR(0)));
            WHEN op_cmpe =>

                IF Areg = Breg THEN
                    tz <= '1';
                ELSE
                    tz <= '0';
                END IF;

            WHEN op_cmpg =>
                IF Areg > Breg THEN
                    tz <= '1';
                ELSE
                    tz <= '0';
                END IF;

            WHEN op_cmpl =>
                IF Areg < Breg THEN
                    tz <= '1';
                ELSE
                    tz <= '0';
                END IF;

            WHEN op_ascii2bin =>

                tempR(0) <= Areg(0);
                tempR(1) <= Areg(1);
                tempR(2) <= Areg(2);
                tempR(3) <= Areg(3);

                tempR(4) <= '0';
                tempR(5) <= '0';
                tempR(6) <= '0';
                tempR(7) <= '0';

                tE <= Areg(7) OR Areg(6) OR (NOT(Areg(5))) OR (NOT(Areg(4))) OR (Areg(3) AND Areg(2)) OR (Areg(3) AND Areg(1));
                IF tE = '1' THEN
                    tempR <= (OTHERS => '1');
                END IF;
            WHEN op_bin2ascii =>

                tempR(0) <= Areg(0);
                tempR(1) <= Areg(1);
                tempR(2) <= Areg(2);
                tempR(3) <= Areg(3);

                tempR(4) <= '1';
                tempR(5) <= '1';
                tempR(6) <= '0';
                tempR(7) <= '0';

                tE <= Areg(7) OR Areg(6) OR Areg(5) OR Areg(4) OR (Areg(3) AND Areg(2)) OR (Areg(3) AND Areg(1));
                IF tE = '1' THEN
                    tempR <= (OTHERS => '1');
                END IF;
            WHEN op_oeacc =>

                Databus <= STD_LOGIC_VECTOR(Accreg);

            WHEN OTHERS =>
        END CASE;

    END PROCESS outproc;

    flage <= E;
    FLAGZ <= Z;
    FLAGC <= C;
    FLAGN <= N;
    Index_Reg <= STD_LOGIC_VECTOR(Idreg);

END RTL;