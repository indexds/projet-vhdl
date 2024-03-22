library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity DFF_R_b is
	port (
		D,CLK,RST	: in std_logic;
		Q			: out std_logic
	);
end DFF_R_b; 

architecture rtl of DFF_R_b is

begin

process(CLK,RST)
	begin
		if(RST = '0')then 
			Q <= '0';
		elsif (CLK'event and CLK = '0')then
			Q <= D;
		end if;
end process;

end rtl;

