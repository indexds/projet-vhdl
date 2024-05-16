library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity compteur_led is
    port (
        CLK, RST, btnL, btnR: in std_logic;
        LED: out std_logic_vector(15 downto 0)
    );
end compteur_led;

architecture rtl of compteur_led is
    signal counter: integer range 0 to 12500000 := 0;
    signal led_sel: integer range 0 to 16 := 0;
    signal all_leds_on: std_logic := '0';
    
begin

    process(CLK, RST, btnL, btnR)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                LED <= (others => '0');
                led_sel <= 0;
                counter <= 0;
                all_leds_on <= '0';
            else
                if (btnL = '1') then
                if (counter = 10000000) then
                    if (led_sel < 16) then
                        LED(led_sel) <= '1';
                        led_sel <= led_sel + 1;
                    end if;
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            elsif (btnR = '1') then
               if (counter = 10000000) then
                    if (led_sel >= 0) then
                        LED(led_sel) <= '0';
                        if (led_sel <= 0) then
                            led_sel <= 0;
                        else 
                            led_sel <= led_sel - 1;
                        end if;
                    end if;
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            else
                counter <= 0;
            end if;
            end if;
        end if;
    end process;
end rtl;