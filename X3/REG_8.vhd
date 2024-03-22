library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity REG_8 is
	port (
		R_IN	: in std_logic_vector(7 downto 0);
		CLK,RST	: in std_logic;
		R_OUT	: out std_logic_vector(7 downto 0)
	);
end REG_8; 

architecture rtl of REG_8 is

begin

process(CLK,RST)
	begin
		if(RST = '0')then 
			R_OUT <= "00000000";
--			R_OUT <= (others => '0');			
		elsif (CLK'event and CLK = '1')then
			R_OUT <= R_IN;
		end if;
end process;

end rtl;





