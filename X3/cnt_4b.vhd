library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity cnt_4b is
 port (
		clk,rst 	: in std_logic;
		cnt			: out std_logic_vector(3 downto 0)
 );
end cnt_4b; 

architecture rtl of cnt_4b is

signal state : std_logic_vector(3 downto 0);

begin

process (clk,rst)
begin
	if (rst = '0') then
		state <= (others => '0');
	elsif (clk'event and clk = '1') then
		state <= state + '1';
	end if;
end process;

cnt <= state;

end rtl;