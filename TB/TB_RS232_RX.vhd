
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_RS232_RX is
end TB_RS232_RX;

architecture Behavioral of TB_RS232_RX is

    component RS232_RX
    PORT (
        reset, clk, lineRD_in : IN std_logic;
        valid_out, code_out, store_out : OUT std_logic
    );
    end component;

signal  reset, clk, lineRD_in, valid_out, code_out, store_out: std_logic;

begin

    uut: RS232_RX
    port map(reset=>reset, clk=>clk, lineRD_in=>lineRD_in, valid_out=>valid_out, code_out=>code_out, store_out=>store_out
             );

--reloj
    p_clk : PROCESS
    BEGIN
        Clk <= '1', '0' after 50 ns;
        wait for 100 ns;
    END PROCESS;

    --reset
    p_reset : PROCESS
    begin
        Reset <= '1', '0' after 45 ns, '1' after 200 ns;
        wait;
    end process;

    p_datos : process
    begin
        -- bit de inicio y recibir dato "11111111" :D
        lineRD_in<='0' after 250 ns, '1' after 165 us;

        wait;
        
    end process ; -- p_datos

end Behavioral;
