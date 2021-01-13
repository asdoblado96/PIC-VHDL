library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegister is
    generic(N:integer:=8);
    port (D,Enable, Clk, Reset: in std_logic;
        Q: out std_logic_vector(N-1 downto 0)
    );
end ShiftRegister;

architecture Behavioral of ShiftRegister is
    
CONSTANT reset_val : std_logic := '0';

signal z: std_logic_vector(N-1 downto 0);

begin
    process(clk,Reset)
    begin
        if(Reset=reset_val) then
            z<=(others=>'0');
        elsif rising_edge(clk) then
            if(Enable='1') then
                z(N-1)<=D;
                z(N-2 downto 0)<=z(N-1 downto 1);
            end if;
        end if;
    Q<=z;
    end process;
end Behavioral;
