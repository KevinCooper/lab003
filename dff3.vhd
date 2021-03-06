--Author: Kevin Cooper
--Date: 3 Mar 2014
--Purpose: This module provides a 4 bit D-Flip-Flop

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity dff3 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           d : in  STD_LOGIC_VECTOR(3 downto 0);
           q : out  STD_LOGIC_VECTOR(3 downto 0));
end dff3;

architecture cooper of dff3 is
signal data: std_logic_vector(3 downto 0);
begin

process (clk, reset) is
begin
	data <= data;
	if(reset='1') then
		data <= "0000";
	elsif(rising_edge(clk)) then
		data <= d;
	end if;
end process;

q<= data;

end cooper;