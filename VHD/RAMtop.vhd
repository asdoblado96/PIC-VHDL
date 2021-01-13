LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.PIC_pkg.ALL;

ENTITY RAMtop IS
    PORT (
        Clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        write_en : IN STD_LOGIC;
        oe : IN STD_LOGIC; --activo nivel bajo
        CS : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);

        out_SW : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        out_TempH, out_TempL : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );

END RAMtop;

ARCHITECTURE Behavioral OF RAMtop IS

    COMPONENT RAM_GP
        GENERIC (addr_width : INTEGER);
        PORT (
            Clk : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            oe : IN STD_LOGIC; --activo nivel bajo
            cs : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

    COMPONENT RAM_SP
        GENERIC (addr_width : INTEGER);
        PORT (
            Clk : IN STD_LOGIC;
            Reset : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            oe : IN STD_LOGIC; --activo nivel bajo
            cs : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            out_SW : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            out_TempL, out_TempH : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL write_en_SP : STD_LOGIC;
    SIGNAL write_en_GP : STD_LOGIC;

    SIGNAL oe_SP : STD_LOGIC;
    SIGNAL oe_GP : STD_LOGIC;

    SIGNAL addressModified : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    SP_RAM : RAM_SP
    GENERIC MAP(64)
    PORT MAP(
        Clk => Clk, CS => CS, Reset => Reset, write_en => write_en_SP, oe => oe_SP,
        address => addressModified, databus => databus,
        out_SW => out_SW, out_TempH => out_TempH, out_TempL => out_TempL);

    GP_RAM : RAM_GP
    GENERIC MAP(192)
    PORT MAP(
        Clk => Clk, CS => CS, write_en => write_en_GP, oe => oe_GP, address => addressModified,
        databus => databus);

    login : PROCESS (address, oe, write_en)

        CONSTANT addressMAX : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00111111";

    BEGIN

        write_en_GP <= '0';
        write_en_SP <= '0';
        oe_GP <= '1';
        oe_SP <= '1';

        IF (address > addressMAX) THEN
            addressModified <= STD_LOGIC_VECTOR(unsigned(address) - unsigned(addressMAX));

            IF oe = '0' THEN
                oe_GP <= '0';
            ELSIF write_en = '1' THEN
                write_en_GP <= '1';
            END IF;
        ELSE
            addressModified <= address;
            IF oe = '0' THEN
                oe_SP <= '0';
            ELSIF write_en = '1' THEN
                write_en_SP <= '1';
            END IF;

        END IF;

    END PROCESS login;
    END behavioral;