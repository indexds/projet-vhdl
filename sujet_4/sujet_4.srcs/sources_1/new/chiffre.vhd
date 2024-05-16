library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chiffre is
    port (
        RST: in std_logic;
        seg : out std_logic_vector (6 downto 0);
        an : out std_logic_vector (3 downto 0)
    );
end chiffre;

architecture rtl of chiffre is
begin
    process(RST)
    begin
        if RST = '1' then
            an <= "1111";
            seg <= "1111111";
        else
            an <= "1000";
            seg <= "0000010";
        end if;
    end process;

end rtl;