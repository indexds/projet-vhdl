library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chronometre is
    port (
        CLK, RST, btnR: in std_logic;
        seg : out std_logic_vector (6 downto 0);
        an : out std_logic_vector (3 downto 0)
    );
end chronometre;

architecture rtl of chronometre is
    signal clk_1hz: std_logic := '0';
    signal clk_10khz: std_logic := '0';
    
    signal clk_1hz_counter: integer range 0 to 45000000 := 0;
    signal clk_10khz_counter: integer range 0 to 45000 := 0;
    
    signal digits: integer range 0 to 3 := 0;
    
    signal seconds_counter: integer range 0 to 9 := 0;
    signal tens_seconds_counter: integer range 0 to 5 := 0;
    
    signal minutes_counter: integer range 0 to 9 := 0;
    signal tens_minutes_counter: integer range 0 to 5 := 0;
    
    signal button_right_was_pressed: std_logic := '0';
    
    
begin
    -- Clock 1Hz
    process(CLK)
    begin
        if rising_edge(CLK) then
            clk_1hz_counter <= clk_1hz_counter + 1;
            if clk_1hz_counter = 45000000 then
                clk_1hz_counter <= 0;
                clk_1hz <= not clk_1hz;
            end if;
        end if;
    end process;
    
    --Clock 10kHz
    process(CLK)
    begin
        if rising_edge(CLK) then
            clk_10khz_counter <= clk_10khz_counter + 1;
            if clk_10khz_counter = 45000 then
                clk_10khz_counter <= 0;
                clk_10khz <= not clk_10khz;
            end if;
        end if;
    end process;
    
    process(clk_1hz, RST, btnR)
    begin
        if btnR = '1' then
            button_right_was_pressed <= '1';
            
        elsif RST = '1' then
            seconds_counter <= 0;
            tens_seconds_counter <= 0;
            minutes_counter <= 0;
            tens_minutes_counter <= 0;
            button_right_was_pressed <= '0';
        
        elsif rising_edge(clk_1hz) then
            if button_right_was_pressed = '1' then
                
                if seconds_counter = 9 then
                    seconds_counter <= 0;
                    
                    if tens_seconds_counter < 5 then
                        tens_seconds_counter <= tens_seconds_counter + 1;
                    else
                        tens_seconds_counter <= 0;
                        
                        
                        if minutes_counter < 9 then
                            minutes_counter <= minutes_counter + 1;
                        else
                            minutes_counter <= 0;
                            
                            if tens_minutes_counter < 5 then
                                tens_minutes_counter <= tens_minutes_counter + 1;
                            else
                                seconds_counter <= 0;
                                tens_seconds_counter <= 0;
                                minutes_counter <= 0;
                                tens_minutes_counter <= 0;
                            end if;
						end if;
					end if;
				end if;
				seconds_counter <= seconds_counter + 1;
			end if;
		end if;
     end process;
     
     process(clk_10khz)
     begin
        if rising_edge(clk_10khz) then
            digits <= digits + 1;
            if digits = 4 then
                digits <= 0;
            end if;
            
            case digits is
                when 0 =>
                    case seconds_counter is
                        when 0 =>
                            an <= "1110";
                            seg <= "1000000"; -- 0
                        when 1 =>
                            an <= "1110";
                            seg <= "1111001"; -- 1
                        when 2 =>
                            an <= "1110";
                            seg <= "0100100"; -- 2
                        when 3 =>
                            an <= "1110";
                            seg <= "0110000"; -- 3
                        when 4 =>
                            an <= "1110";
                            seg <= "0011001"; -- 4
                        when 5 =>
                            an <= "1110";
                            seg <= "0010010"; -- 5
                        when 6 =>
                            an <= "1110";
                            seg <= "0000010"; -- 6                       
                        when 7 =>
                            an <= "1110";
                            seg <= "1111000"; -- 7                       
                        when 8 =>
                            an <= "1110";
                            seg <= "0000000"; -- 8                       
                        when 9 =>
                            an <= "1110";
                            seg <= "0010000"; -- 9  
                    end case;
                when 1 =>            
                    case tens_seconds_counter is
                        when 0 =>
                            an <= "1101";
                            seg <= "1000000"; -- 0
                        when 1 =>
                            an <= "1101";
                            seg <= "1111001"; -- 1
                        when 2 =>
                            an <= "1101";
                            seg <= "0100100"; -- 2
                        when 3 =>
                            an <= "1101";
                            seg <= "0110000"; -- 3
                        when 4 =>
                            an <= "1101";
                            seg <= "0011001"; -- 4
                        when 5 =>
                            an <= "1101";
                            seg <= "0010010"; -- 5
                    end case;
                when 2 =>
                    case minutes_counter is
                        when 0 =>
                            an <= "1011";
                            seg <= "1000000"; -- 0
                        when 1 =>
                            an <= "1011";
                            seg <= "1111001"; -- 1
                        when 2 =>
                            an <= "1011";
                            seg <= "0100100"; -- 2
                        when 3 =>
                            an <= "1011";
                            seg <= "0110000"; -- 3
                        when 4 =>
                            an <= "1011";
                            seg <= "0011001"; -- 4
                        when 5 =>
                            an <= "1011";
                            seg <= "0010010"; -- 5
                        when 6 =>
                            an <= "1011";
                            seg <= "0000010"; -- 6                       
                        when 7 =>
                            an <= "1011";
                            seg <= "1111000"; -- 7                       
                        when 8 =>
                            an <= "1011";
                            seg <= "0000000"; -- 8                       
                        when 9 =>
                            an <= "1011";
                            seg <= "0010000"; -- 9  
                    end case;
                when 3 =>
                    case tens_minutes_counter is
                        when 0 =>
                            an <= "0111";
                            seg <= "1000000"; -- 0
                        when 1 =>
                            an <= "0111";
                            seg <= "1111001"; -- 1
                        when 2 =>
                            an <= "0111";
                            seg <= "0100100"; -- 2
                        when 3 =>
                            an <= "0111";
                            seg <= "0110000"; -- 3
                        when 4 =>
                            an <= "0111";
                            seg <= "0011001"; -- 4
                        when 5 =>
                            an <= "0111";
                            seg <= "0010010"; -- 5
                    end case;
                end case;
        end if;
    end process;
end rtl;

