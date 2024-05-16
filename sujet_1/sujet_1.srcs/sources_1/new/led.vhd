library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity led is
port (CLK,RST : in std_logic;
        LED: out std_logic);
end led;

architecture rtl of led is

    signal cnt : std_logic_vector(23 downto 0);
    begin
        process (CLK,RST)
        begin
            if (RST = '1') then
                cnt <= (others => '0');
            elsif rising_edge(CLK) then
                cnt <= cnt +1;
            end if;
        end process;

LED <= cnt(23);

end rtl;