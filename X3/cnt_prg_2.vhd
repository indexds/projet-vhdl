library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity cnt_prg_2 is
 port (
		clk,rst 	: in std_logic;
		sel 		: in std_logic_vector(1 downto 0);
		clk_out		: out std_logic
 );
end cnt_prg_2; 

architecture structural of cnt_prg_2 is


component cnt_4b is
 port (
		clk,rst 	: in std_logic;
		cnt			: out std_logic_vector(3 downto 0)
 );
end component;

component mux_4_1 is
 port (
		e00,e01,e10,e11 	: in std_logic;
		sel 				: in std_logic_vector(1 downto 0);
		s_mux				: out std_logic
 );
end component;

signal int : std_logic_vector(3 downto 0);

begin

I0 : cnt_4b port map (clk => clk, rst => rst, cnt => int);
I1 : mux_4_1 port map (e00 => int(0), e01 => int(1), e10 => int(2), e11 => int(3), sel => sel, s_mux => clk_out); 


end structural;