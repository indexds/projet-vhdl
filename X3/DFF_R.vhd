library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity DFF_R is
	port (
		D		: in std_logic;
		CLK		: in std_logic;
		RST 	: in std_logic;
		Q		: out std_logic
	);
end DFF_R;

architecture rtl of DFF_R is

begin

process(CLK,RST)
	begin
		if(RST = '1')then 
			Q <= '0';
		elsif (CLK'event and CLK = '1')then
			Q <= D;
		end if;
end process;

end rtl;
 
 