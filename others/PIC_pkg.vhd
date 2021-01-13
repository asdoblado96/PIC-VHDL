
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

PACKAGE PIC_pkg IS

-------------------------------------------------------------------------------
-- Types for the RAM memory
-------------------------------------------------------------------------------
  
  SUBTYPE item_array8_ram IS std_logic_vector (7 downto 0);
  TYPE array8_ram IS array (integer range <>) of item_array8_ram;

-------------------------------------------------------------------------------
-- Useful constants for addressing purposes
-------------------------------------------------------------------------------

  constant DMA_RX_BUFFER_MSB : std_logic_vector(7 downto 0) := X"00";
  constant DMA_RX_BUFFER_MID : std_logic_vector(7 downto 0) := X"01";
  constant DMA_RX_BUFFER_LSB : std_logic_vector(7 downto 0) := X"02";
  constant NEW_INST          : std_logic_vector(7 downto 0) := X"03";
  constant DMA_TX_BUFFER_MSB : std_logic_vector(7 downto 0) := X"04";
  constant DMA_TX_BUFFER_LSB : std_logic_vector(7 downto 0) := X"05";
  constant SWITCH_BASE       : std_logic_vector(7 downto 0) := X"10";
  constant LEVER_BASE        : std_logic_vector(7 downto 0) := X"20";
  constant CAL_OP            : std_logic_vector(7 downto 0) := X"30";
  constant T_STAT            : std_logic_vector(7 downto 0) := X"31";
  constant GP_RAM_BASE       : std_logic_vector(7 downto 0) := X"40";

-------------------------------------------------------------------------------
-- Constants to define Type 1 instructions (ALU)
-------------------------------------------------------------------------------

  constant TYPE_1        : std_logic_vector(1 downto 0) := "00";
  constant ALU_ADD       : std_logic_vector(5 downto 0) := "000000";
  constant ALU_SUB       : std_logic_vector(5 downto 0) := "000001";
  constant ALU_SHIFTL    : std_logic_vector(5 downto 0) := "000010";
  constant ALU_SHIFTR    : std_logic_vector(5 downto 0) := "000011";
  constant ALU_AND       : std_logic_vector(5 downto 0) := "000100";
  constant ALU_OR        : std_logic_vector(5 downto 0) := "000101";
  constant ALU_XOR       : std_logic_vector(5 downto 0) := "000110";
  constant ALU_CMPE      : std_logic_vector(5 downto 0) := "000111";
  constant ALU_CMPG      : std_logic_vector(5 downto 0) := "001000";
  constant ALU_CMPL      : std_logic_vector(5 downto 0) := "001001";
  constant ALU_ASCII2BIN : std_logic_vector(5 downto 0) := "001010";
  constant ALU_BIN2ASCII : std_logic_vector(5 downto 0) := "001011";

-------------------------------------------------------------------------------
-- Constants to define Type 2 instructions (JUMP)
-------------------------------------------------------------------------------

  constant TYPE_2     : std_logic_vector(1 downto 0) := "01";
  constant JMP_UNCOND : std_logic_vector(5 downto 0) := "00" & X"0";
  constant JMP_COND   : std_logic_vector(5 downto 0) := "00" & X"1";

-------------------------------------------------------------------------------
-- Constants to define Type 3 instructions (LOAD & STORE)
-------------------------------------------------------------------------------

  constant TYPE_3        : std_logic_vector(1 downto 0) := "10";
  -- instruction
  constant LD            : std_logic                    := '0';
  constant WR            : std_logic                    := '1';
  -- source
  constant SRC_ACC       : std_logic_vector(1 downto 0) := "00";
  constant SRC_CONSTANT  : std_logic_vector(1 downto 0) := "01";
  constant SRC_MEM       : std_logic_vector(1 downto 0) := "10";
  constant SRC_INDXD_MEM : std_logic_vector(1 downto 0) := "11";
  -- destination
  constant DST_ACC       : std_logic_vector(2 downto 0) := "000";
  constant DST_A         : std_logic_vector(2 downto 0) := "001";
  constant DST_B         : std_logic_vector(2 downto 0) := "010";
  constant DST_INDX      : std_logic_vector(2 downto 0) := "011";
  constant DST_MEM       : std_logic_vector(2 downto 0) := "100";
  constant DST_INDXD_MEM : std_logic_vector(2 downto 0) := "101";

-------------------------------------------------------------------------------
-- Constants to define Type 4 instructions (SEND)
-------------------------------------------------------------------------------

  constant TYPE_4        : std_logic_vector(1 downto 0) := "11";

-------------------------------------------------------------------------------
-- Type containing the ALU instruction set
-------------------------------------------------------------------------------

    TYPE alu_op IS (
      nop,                                  -- no operation
      op_lda, op_ldb, op_ldacc, op_ldid,    -- external value load
      op_mvacc2id, op_mvacc2a, op_mvacc2b,  -- internal load
      op_add, op_sub, op_shiftl, op_shiftr, -- arithmetic operations
      op_and, op_or, op_xor,                -- logic operations
      op_cmpe, op_cmpl, op_cmpg,            -- compare operations
      op_ascii2bin, op_bin2ascii,           -- conversion operations
      op_oeacc);                            -- output enable

END PIC_pkg;

PACKAGE BODY PIC_pkg IS
END PIC_pkg;

