library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity mux8to1 is
    Port ( data : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC_VECTOR (2 downto 0);
           q : out  STD_LOGIC);
end mux8to1;

architecture cooper of mux8to1 is

begin

q<= data(7) when sel = "000" else
	 data(6) when sel = "001" else
	 data(5) when sel = "010" else
	 data(4) when sel = "011" else
	 data(3) when sel = "100" else
	 data(2) when sel = "101" else
	 data(1) when sel = "110" else
	 data(0);


end cooper;

