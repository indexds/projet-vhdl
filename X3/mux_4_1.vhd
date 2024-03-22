library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mux_4_1 is
 port (
		e00,e01,e10,e11 	: in std_logic;
		sel 				: in std_logic_vector(1 downto 0);
		s_mux				: out std_logic
 );
end mux_4_1; 

architecture rtl of mux_4_1 is

begin

with sel select
		s_mux <=
			e00 when "00",
			e01 when "01",
			e10 when "10",
			e11 when "11",
			'0' when others;

end rtl;