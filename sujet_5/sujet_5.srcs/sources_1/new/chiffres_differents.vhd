library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chiffres_differents is
    port (
        CLK, RST, btnR: in std_logic;
        seg : out std_logic_vector (6 downto 0);
        an : out std_logic_vector (3 downto 0)
    );
end chiffres_differents;

architecture rtl of chiffres_differents is
    signal clk_10khz : std_logic := '0';
    signal counter : integer range 0 to 45000 := 0;
    signal digits : integer range 0 to 3 := 0;
begin
    -- Clock 10kHz
    process(CLK)
    begin
        if rising_edge(CLK) then
            counter <= counter + 1;
            if counter = 45000 then
                counter <= 0;
                clk_10khz <= not clk_10khz;
            end if;
        end if;
    end process;
    
    -- 7 Segment Display
    process(clk_10khz, RST, btnR)
    begin
        if RST = '1' then
            digits <= 0;
            an <= "1111";
            seg <= "1111111";
        elsif rising_edge(clk_10khz) then
            digits <= digits + 1;
            if digits = 4 then
                digits <= 0;
            end if;
            
            if btnR = '0' then
                case digits is
                    when 0 =>
                        an <= "0111";
                        seg <= "0011000"; -- Q
                    when 1 =>
                        an <= "1011";
                        seg <= "1000001"; -- U
                    when 2 =>
                        an <= "1101";
                        seg <= "1000000"; -- O
                    when 3 =>
                        an <= "1110";
                        seg <= "1111001"; -- I
                end case;
            else
                case digits is
                    when 0 =>
                        an <= "0111";
                        seg <= "0001110"; -- F
                    when 1 =>
                        an <= "1011";
                        seg <= "0000110"; -- E
                    when 2 =>
                        an <= "1101";
                        seg <= "1000001"; -- U
                    when 3 =>
                        an <= "1110";
                        seg <= "0001000"; -- R
                end case;
            end if;
        end if;
    end process;
end rtl;

