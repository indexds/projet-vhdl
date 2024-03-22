library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity RAM_1KB is
	port (
		ADD			: in std_logic_vector(9 downto 0);
		CS,WE,RE	: in std_logic;
		IO			: inout std_logic_vector(7 downto 0)
	);
end RAM_1KB; 


