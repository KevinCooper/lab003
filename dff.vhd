
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity dff is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           d : in  STD_LOGIC;
           q : out  STD_LOGIC);
end dff;

architecture Behavioral of dff is

signal data: std_logic;

begin

process (clk, reset) is
begin
	data <= data;
	if(reset='1') then
		data <= '0';
	elsif(rising_edge(clk)) then
		data <= d;
	end if;
end process;

q<= data;

end Behavioral;

