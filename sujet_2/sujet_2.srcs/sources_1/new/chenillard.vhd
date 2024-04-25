library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity chenillard is
port (
        CLK,RST : in std_logic;
        LED : out std_logic_vector(15 downto 0)
        );
end chenillard;

architecture rtl of chenillard is
    signal counter : integer range 0 to 12500000 := 0;
    signal led_sel : integer range 0 to 16 := 0;
    signal all_leds_on : std_logic := '0';
begin

process (CLK, RST)
begin
    if (RST = '1') then
        LED <= (others => '0');
        counter <= 0;
        led_sel <= 0;
        all_leds_on <= '0';
    elsif (rising_edge(CLK)) then
        counter <= counter + 1;
        
        if (counter = 12500000) then
            counter <= 0;
            
            if (all_leds_on = '1') then
                LED(led_sel) <= '0';
                led_sel <= led_sel - 1;
                if (led_sel < 0) then
                    all_leds_on <= '0';
                end if;
            else
                LED(led_sel) <= '1';
                led_sel <= led_sel + 1;
                if (led_sel = 16) then
                    all_leds_on <= '1';
                end if;
            end if;
        end if;
    end if;
end process;


end rtl;