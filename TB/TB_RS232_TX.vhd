

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_RS232_TX is
end TB_RS232_TX;

architecture Behavioral of TB_RS232_TX is

    component RS232_TX
        port(
            Start, Clk, Reset: in std_logic;
            Data: in std_logic_vector(7 downto 0);
            EOT,TX: out std_logic
        );
    end component;

signal  Start, Clk, Reset, EOT, TX: std_logic;
signal Data: std_logic_vector(7 downto 0);

begin

    uut: RS232_TX
    port map(Start=>Start, TX=>TX, Clk=>Clk, Reset=>Reset, EOT=>EOT, Data=>Data
             );

--reloj
    p_clk : PROCESS --ponemos el reloj a 1 y despues de 50 ns a 0. Repetimos despues de 100ns
    BEGIN
        Clk <= '1', '0' after 50 ns;
        wait for 100 ns;
    END PROCESS;

    --reset
    p_reset : PROCESS -- ponemos el reset a 1, despues de 45ns a 0 y dp de 200ns a 1 otra vez (el reset es a valor bajo)
    begin
        Reset <= '1', '0' after 45 ns, '1' after 200 ns;
        wait;
    end process;

    p_datos : process
    begin

        Data<="10011010" after 200ns;   --dato que queremos enviar
        Start<='1' after 250ns;         --señal de start después de 250 ns (cuando ya ha terminado el reset etc)
        wait;                           -- esperamos indefinidamente (hemos terminado)

    end process ; -- p_datos

end Behavioral;
