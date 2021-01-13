
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

USE IEEE.numeric_std.ALL;
USE work.PIC_pkg.ALL;
USE IEEE.math_real.ALL;

ENTITY RAM_SP IS
  GENERIC (
    addr_width : INTEGER := 64);

  PORT (
    Clk : IN STD_LOGIC;
    Reset : IN STD_LOGIC;
    write_en : IN STD_LOGIC;
    oe : IN STD_LOGIC; --activo nivel bajo
    CS : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    databus : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    out_SW : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    out_TempL, out_TempH : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
END RAM_SP;

ARCHITECTURE behavior OF RAM_SP IS

  SIGNAL contents_ram : array8_ram((addr_width - 1) DOWNTO 0);
  --  SIGNAL cont_switch: STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  logreg : PROCESS (reset, clk)
  BEGIN
    IF reset = '0' THEN
      contents_ram <= (OTHERS => (OTHERS => '0'));

    ELSIF rising_edge(clk) THEN
      IF cs = '1' AND write_en = '1' THEN
        contents_ram(to_integer(unsigned((address)))) <= databus;
      END IF;
    END IF;


END PROCESS logreg;

logout : PROCESS (contents_ram, CS)

BEGIN

  FOR i IN 0 TO 7 LOOP
    out_SW(i) <= contents_ram(16 + i)(0);
  END LOOP;

END PROCESS logout;

databus <= contents_ram(to_integer(unsigned((address)))) WHEN oe = '0' ELSE
  (OTHERS => 'Z');

WITH contents_ram(49)(7 DOWNTO 4) SELECT
out_TempH <=
  "0000110" WHEN "0001", -- 1
  "1011011" WHEN "0010",
  "1001111" WHEN "0011",
  "1100110" WHEN "0100",
  "1101101" WHEN "0101",
  "1111101" WHEN "0110",
  "0000111" WHEN "0111",
  "1111111" WHEN "1000", -- 8
  "1101111" WHEN "1001",
  "1110111" WHEN "1010",
  "1111100" WHEN "1011",
  "0111001" WHEN "1100",
  "1011110" WHEN "1101",
  "1111001" WHEN "1110",
  "1110001" WHEN "1111", --F
  "0111111" WHEN OTHERS;

WITH contents_ram(49)(3 DOWNTO 0) SELECT
out_TempL <=
  "0000110" WHEN "0001", -- 1
  "1011011" WHEN "0010",
  "1001111" WHEN "0011",
  "1100110" WHEN "0100",
  "1101101" WHEN "0101",
  "1111101" WHEN "0110",
  "0000111" WHEN "0111",
  "1111111" WHEN "1000", -- 8
  "1101111" WHEN "1001",
  "1110111" WHEN "1010",
  "1111100" WHEN "1011",
  "0111001" WHEN "1100",
  "1011110" WHEN "1101",
  "1111001" WHEN "1110",
  "1110001" WHEN "1111", -- F
  "0111111" WHEN OTHERS;

END behavior;