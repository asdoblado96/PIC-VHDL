----------------------------------------------------------------
--   Nombre      :  ROM.vhd
--   Descripcion :  Memoria de programa del PIC
----------------------------------------------------------------
--   Version   :  1.0
----------------------------------------------------------------
 
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

USE work.PIC_pkg.all;
 
 
entity ROM is
  port (
    Instruction     : out std_logic_vector(11 downto 0);  -- Instruction bus
    Program_counter : in  std_logic_vector(11 downto 0));
end ROM;
 
architecture AUTOMATIC of ROM is

constant W0  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W1  : std_logic_vector(11 downto 0) := X"003";
constant W2  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W3  : std_logic_vector(11 downto 0) := X"0FF";
constant W4  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPL;
constant W5  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W6  : std_logic_vector(11 downto 0) :=X"000";
constant W7  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W8  : std_logic_vector(11 downto 0) := X"000";
constant W9  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W10  : std_logic_vector(11 downto 0) := X"003";
constant W11  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W12  : std_logic_vector(11 downto 0) := X"000";
constant W13  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W14  : std_logic_vector(11 downto 0) := X"041";
constant W15  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W16  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W17  : std_logic_vector(11 downto 0) :=X"045";
constant W18  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W19  : std_logic_vector(11 downto 0) := X"049";
constant W20  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W21  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W22  : std_logic_vector(11 downto 0) :=X"02E";
constant W23  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W24  : std_logic_vector(11 downto 0) := X"054";
constant W25  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W26  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W27  : std_logic_vector(11 downto 0) :=X"05C";
constant W28  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W29  : std_logic_vector(11 downto 0) := X"053";
constant W30  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W31  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W32  : std_logic_vector(11 downto 0) :=X"07E";
constant W33  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W34  : std_logic_vector(11 downto 0) :=X"0D6";
constant W35  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W36  : std_logic_vector(11 downto 0) := X"04F";
constant W37  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W38  : std_logic_vector(11 downto 0) := X"004";
constant W39  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W40  : std_logic_vector(11 downto 0) := X"04B";
constant W41  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W42  : std_logic_vector(11 downto 0) := X"005";
constant W43  : std_logic_vector(11 downto 0) :=X"0" & TYPE_4 & "000000";
constant W44  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W45  : std_logic_vector(11 downto 0) :=X"000";
constant W46  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W47  : std_logic_vector(11 downto 0) := X"001";
constant W48  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W49  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_INDX;
constant W50  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W51  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W52  : std_logic_vector(11 downto 0) := X"007";
constant W53  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPG;
constant W54  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W55  : std_logic_vector(11 downto 0) :=X"0D6";
constant W56  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W57  : std_logic_vector(11 downto 0) := X"002";
constant W58  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W59  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W60  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W61  : std_logic_vector(11 downto 0) := X"001";
constant W62  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPG;
constant W63  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W64  : std_logic_vector(11 downto 0) :=X"0D6";
constant W65  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_INDXD_MEM;
constant W66  : std_logic_vector(11 downto 0) := X"010";
constant W67  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W68  : std_logic_vector(11 downto 0) :=X"023";
constant W69  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W70  : std_logic_vector(11 downto 0) := X"001";
constant W71  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W72  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W73  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_INDX;
constant W74  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W75  : std_logic_vector(11 downto 0) := X"0FF";
constant W76  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W77  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W78  : std_logic_vector(11 downto 0) :=X"0D6";
constant W79  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W80  : std_logic_vector(11 downto 0) := X"002";
constant W81  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W82  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W83  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W84  : std_logic_vector(11 downto 0) := X"009";
constant W85  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPG;
constant W86  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W87  : std_logic_vector(11 downto 0) :=X"0D6";
constant W88  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_INDXD_MEM;
constant W89  : std_logic_vector(11 downto 0) := X"020";
constant W90  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W91  : std_logic_vector(11 downto 0) :=X"023";
constant W92  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W93  : std_logic_vector(11 downto 0) := X"001";
constant W94  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W95  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W96  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W97  : std_logic_vector(11 downto 0) := X"002";
constant W98  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPG;
constant W99  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W100  : std_logic_vector(11 downto 0) :=X"0D6";
constant W101  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W102  : std_logic_vector(11 downto 0) := X"000";
constant W103  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ADD;
constant W104  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTL;
constant W105  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTL;
constant W106  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTL;
constant W107  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTL;
constant W108  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W109  : std_logic_vector(11 downto 0) := X"041";
constant W110  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W111  : std_logic_vector(11 downto 0) := X"002";
constant W112  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W113  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W114  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W115  : std_logic_vector(11 downto 0) := X"0FF";
constant W116  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W117  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W118  : std_logic_vector(11 downto 0) :=X"0D6";
constant W119  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_B;
constant W120  : std_logic_vector(11 downto 0) := X"041";
constant W121  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ADD;
constant W122  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W123  : std_logic_vector(11 downto 0) := X"031";
constant W124  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W125  : std_logic_vector(11 downto 0) :=X"023";
constant W126  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W127  : std_logic_vector(11 downto 0) := X"001";
constant W128  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W129  : std_logic_vector(11 downto 0) := X"041";
constant W130  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W131  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W132  : std_logic_vector(11 downto 0) :=X"091";
constant W133  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W134  : std_logic_vector(11 downto 0) := X"049";
constant W135  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W136  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W137  : std_logic_vector(11 downto 0) :=X"0A7";
constant W138  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W139  : std_logic_vector(11 downto 0) := X"054";
constant W140  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPE;
constant W141  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W142  : std_logic_vector(11 downto 0) :=X"0BD";
constant W143  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W144  : std_logic_vector(11 downto 0) :=X"0D6";
constant W145  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W146  : std_logic_vector(11 downto 0) := X"002";
constant W147  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W148  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W149  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_INDX;
constant W150  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W151  : std_logic_vector(11 downto 0) := X"009";
constant W152  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPG;
constant W153  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W154  : std_logic_vector(11 downto 0) :=X"0D6";
constant W155  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_INDXD_MEM & DST_A;
constant W156  : std_logic_vector(11 downto 0) := X"020";
constant W157  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_BIN2ASCII;
constant W158  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W159  : std_logic_vector(11 downto 0) := X"005";
constant W160  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W161  : std_logic_vector(11 downto 0) := X"041";
constant W162  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W163  : std_logic_vector(11 downto 0) := X"004";
constant W164  : std_logic_vector(11 downto 0) :=X"0" & TYPE_4 & "000000";
constant W165  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W166  : std_logic_vector(11 downto 0) :=X"000";
constant W167  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W168  : std_logic_vector(11 downto 0) := X"002";
constant W169  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_ASCII2BIN;
constant W170  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W171  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_INDX;
constant W172  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W173  : std_logic_vector(11 downto 0) := X"007";
constant W174  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_CMPG;
constant W175  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_COND;
constant W176  : std_logic_vector(11 downto 0) :=X"0D6";
constant W177  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_INDXD_MEM & DST_A;
constant W178  : std_logic_vector(11 downto 0) := X"010";
constant W179  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_BIN2ASCII;
constant W180  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W181  : std_logic_vector(11 downto 0) := X"005";
constant W182  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W183  : std_logic_vector(11 downto 0) := X"053";
constant W184  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W185  : std_logic_vector(11 downto 0) := X"004";
constant W186  : std_logic_vector(11 downto 0) :=X"0" & TYPE_4 & "000000";
constant W187  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W188  : std_logic_vector(11 downto 0) :=X"000";
constant W189  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W190  : std_logic_vector(11 downto 0) := X"031";
constant W191  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W192  : std_logic_vector(11 downto 0) :="000011110000";
constant W193  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_AND;
constant W194  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTR;
constant W195  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTR;
constant W196  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTR;
constant W197  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_SHIFTR;
constant W198  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W199  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_BIN2ASCII;
constant W200  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W201  : std_logic_vector(11 downto 0) := X"004";
constant W202  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_MEM & DST_A;
constant W203  : std_logic_vector(11 downto 0) := X"031";
constant W204  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_B;
constant W205  : std_logic_vector(11 downto 0) :="000000001111";
constant W206  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_AND;
constant W207  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_ACC & DST_A;
constant W208  : std_logic_vector(11 downto 0) :=X"0" & TYPE_1 & ALU_BIN2ASCII;
constant W209  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W210  : std_logic_vector(11 downto 0) := X"005";
constant W211  : std_logic_vector(11 downto 0) :=X"0" & TYPE_4 & "000000";
constant W212  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W213  : std_logic_vector(11 downto 0) :=X"000";
constant W214  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W215  : std_logic_vector(11 downto 0) := X"045";
constant W216  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W217  : std_logic_vector(11 downto 0) := X"004";
constant W218  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & LD & SRC_CONSTANT & DST_ACC;
constant W219  : std_logic_vector(11 downto 0) := X"052";
constant W220  : std_logic_vector(11 downto 0) :=X"0" & TYPE_3 & WR & SRC_ACC & DST_MEM;
constant W221  : std_logic_vector(11 downto 0) := X"005";
constant W222  : std_logic_vector(11 downto 0) :=X"0" & TYPE_4 & "000000";
constant W223  : std_logic_vector(11 downto 0) :=X"0" & TYPE_2 & JMP_UNCOND;
constant W224  : std_logic_vector(11 downto 0) :=X"000";
 
 
begin  -- AUTOMATIC
 
with Program_counter select
    Instruction <=
 W0 when X"000",
 W1 when X"001",
 W2 when X"002",
 W3 when X"003",
 W4 when X"004",
 W5 when X"005",
 W6 when X"006",
 W7 when X"007",
 W8 when X"008",
 W9 when X"009",
 W10 when X"00A",
 W11 when X"00B",
 W12 when X"00C",
 W13 when X"00D",
 W14 when X"00E",
 W15 when X"00F",
 W16 when X"010",
 W17 when X"011",
 W18 when X"012",
 W19 when X"013",
 W20 when X"014",
 W21 when X"015",
 W22 when X"016",
 W23 when X"017",
 W24 when X"018",
 W25 when X"019",
 W26 when X"01A",
 W27 when X"01B",
 W28 when X"01C",
 W29 when X"01D",
 W30 when X"01E",
 W31 when X"01F",
 W32 when X"020",
 W33 when X"021",
 W34 when X"022",
 W35 when X"023",
 W36 when X"024",
 W37 when X"025",
 W38 when X"026",
 W39 when X"027",
 W40 when X"028",
 W41 when X"029",
 W42 when X"02A",
 W43 when X"02B",
 W44 when X"02C",
 W45 when X"02D",
 W46 when X"02E",
 W47 when X"02F",
 W48 when X"030",
 W49 when X"031",
 W50 when X"032",
 W51 when X"033",
 W52 when X"034",
 W53 when X"035",
 W54 when X"036",
 W55 when X"037",
 W56 when X"038",
 W57 when X"039",
 W58 when X"03A",
 W59 when X"03B",
 W60 when X"03C",
 W61 when X"03D",
 W62 when X"03E",
 W63 when X"03F",
 W64 when X"040",
 W65 when X"041",
 W66 when X"042",
 W67 when X"043",
 W68 when X"044",
 W69 when X"045",
 W70 when X"046",
 W71 when X"047",
 W72 when X"048",
 W73 when X"049",
 W74 when X"04A",
 W75 when X"04B",
 W76 when X"04C",
 W77 when X"04D",
 W78 when X"04E",
 W79 when X"04F",
 W80 when X"050",
 W81 when X"051",
 W82 when X"052",
 W83 when X"053",
 W84 when X"054",
 W85 when X"055",
 W86 when X"056",
 W87 when X"057",
 W88 when X"058",
 W89 when X"059",
 W90 when X"05A",
 W91 when X"05B",
 W92 when X"05C",
 W93 when X"05D",
 W94 when X"05E",
 W95 when X"05F",
 W96 when X"060",
 W97 when X"061",
 W98 when X"062",
 W99 when X"063",
 W100 when X"064",
 W101 when X"065",
 W102 when X"066",
 W103 when X"067",
 W104 when X"068",
 W105 when X"069",
 W106 when X"06A",
 W107 when X"06B",
 W108 when X"06C",
 W109 when X"06D",
 W110 when X"06E",
 W111 when X"06F",
 W112 when X"070",
 W113 when X"071",
 W114 when X"072",
 W115 when X"073",
 W116 when X"074",
 W117 when X"075",
 W118 when X"076",
 W119 when X"077",
 W120 when X"078",
 W121 when X"079",
 W122 when X"07A",
 W123 when X"07B",
 W124 when X"07C",
 W125 when X"07D",
 W126 when X"07E",
 W127 when X"07F",
 W128 when X"080",
 W129 when X"081",
 W130 when X"082",
 W131 when X"083",
 W132 when X"084",
 W133 when X"085",
 W134 when X"086",
 W135 when X"087",
 W136 when X"088",
 W137 when X"089",
 W138 when X"08A",
 W139 when X"08B",
 W140 when X"08C",
 W141 when X"08D",
 W142 when X"08E",
 W143 when X"08F",
 W144 when X"090",
 W145 when X"091",
 W146 when X"092",
 W147 when X"093",
 W148 when X"094",
 W149 when X"095",
 W150 when X"096",
 W151 when X"097",
 W152 when X"098",
 W153 when X"099",
 W154 when X"09A",
 W155 when X"09B",
 W156 when X"09C",
 W157 when X"09D",
 W158 when X"09E",
 W159 when X"09F",
 W160 when X"0A0",
 W161 when X"0A1",
 W162 when X"0A2",
 W163 when X"0A3",
 W164 when X"0A4",
 W165 when X"0A5",
 W166 when X"0A6",
 W167 when X"0A7",
 W168 when X"0A8",
 W169 when X"0A9",
 W170 when X"0AA",
 W171 when X"0AB",
 W172 when X"0AC",
 W173 when X"0AD",
 W174 when X"0AE",
 W175 when X"0AF",
 W176 when X"0B0",
 W177 when X"0B1",
 W178 when X"0B2",
 W179 when X"0B3",
 W180 when X"0B4",
 W181 when X"0B5",
 W182 when X"0B6",
 W183 when X"0B7",
 W184 when X"0B8",
 W185 when X"0B9",
 W186 when X"0BA",
 W187 when X"0BB",
 W188 when X"0BC",
 W189 when X"0BD",
 W190 when X"0BE",
 W191 when X"0BF",
 W192 when X"0C0",
 W193 when X"0C1",
 W194 when X"0C2",
 W195 when X"0C3",
 W196 when X"0C4",
 W197 when X"0C5",
 W198 when X"0C6",
 W199 when X"0C7",
 W200 when X"0C8",
 W201 when X"0C9",
 W202 when X"0CA",
 W203 when X"0CB",
 W204 when X"0CC",
 W205 when X"0CD",
 W206 when X"0CE",
 W207 when X"0CF",
 W208 when X"0D0",
 W209 when X"0D1",
 W210 when X"0D2",
 W211 when X"0D3",
 W212 when X"0D4",
 W213 when X"0D5",
 W214 when X"0D6",
 W215 when X"0D7",
 W216 when X"0D8",
 W217 when X"0D9",
 W218 when X"0DA",
 W219 when X"0DB",
 W220 when X"0DC",
 W221 when X"0DD",
 W222 when X"0DE",
 W223 when X"0DF",
 W224 when X"0E0",
    X"0" & TYPE_1 & ALU_ADD when others;
 
end AUTOMATIC;

