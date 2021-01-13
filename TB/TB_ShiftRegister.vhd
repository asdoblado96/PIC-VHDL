library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity tb_ShiftRegister is
end tb_ShiftRegister;

architecture Behavioral of tb_ShiftRegister is
    component ShiftRegister
        port (D,Enable, Clk, Reset: in std_logic;
            Q: out std_logic_vector(7 downto 0)
        );
    end component;

signal D,Enable, Clk, Reset: std_logic;
signal Q: std_logic_vector(7 downto 0);

begin

    uut: ShiftRegister
        port map(D=>D, Enable=>Enable, Clk=>Clk, Reset=>Reset, Q=>Q);

--reloj
    p_clk : PROCESS
    BEGIN
        clk <= '1', '0' after 50 ns;
        wait for 100 ns;
    END PROCESS;

--reset
    p_reset : PROCESS
    begin
        reset <= '0', '1' after 45 ns, '0' after 200 ns;
        wait;
    end process;

--datos

    p_datos: PROCESS
    begin
        enable<= '1' after 280ns;

        D <= '1' after 210 ns,
        '0' after 310 ns,
        '0' after 410 ns,
        '1' after 510 ns,
        '1' after 610 ns,
        '0' after 710 ns,
        '1' after 810 ns,
        '1' after 910 ns;
        
        wait;
    end process;

    
end Behavioral;
