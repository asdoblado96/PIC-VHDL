
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

USE work.PIC_pkg.ALL;

ENTITY RAM_GP IS
    GENERIC (
        addr_width : INTEGER := 192);
    PORT (
        Clk : IN STD_LOGIC;
        write_en : IN STD_LOGIC;
        oe : IN STD_LOGIC; --activo nivel bajo
        cs : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END RAM_GP;

ARCHITECTURE behavior OF RAM_GP IS

    SIGNAL contents_ram : array8_ram((addr_width - 1) DOWNTO 0);

BEGIN

    p_ram : PROCESS (clk) -- no reset
    BEGIN

        IF rising_edge(clk) THEN
            IF cs = '1' AND write_en = '1' THEN
                contents_ram(to_integer(unsigned((address)))) <= databus;
            END IF;
        END IF;

    END PROCESS;

    databus <= contents_ram(to_integer(unsigned((address)))) WHEN oe = '0' ELSE
        (OTHERS => 'Z');

END behavior;