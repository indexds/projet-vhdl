library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity cnt_prg is
 port (
		clk,rst 	: in std_logic;
		sel 		: in std_logic_vector(1 downto 0);
		clk_out		: out std_logic
 );
end cnt_prg; 

architecture rtl of cnt_prg is

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

with sel select
		clk_out <=
			state(0) when "00",
			state(1) when "01",
			state(2) when "10",
			state(3) when "11",
			'0' when others;

end rtl;