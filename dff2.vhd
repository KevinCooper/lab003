library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity dff2 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           d : in  STD_LOGIC_VECTOR(2 downto 0);
           q : out  STD_LOGIC_VECTOR(2 downto 0));
end dff2;

architecture cooper of dff2 is
signal data: std_logic_vector(2 downto 0);
begin

process (clk, reset) is
begin
	data <= data;
	if(reset='1') then
		data <= "000";
	elsif(rising_edge(clk)) then
		data <= d;
	end if;
end process;

q<= data;

end cooper;