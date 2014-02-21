
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity input_to_pulse is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           input : in  STD_LOGIC;
           pulse : out  STD_LOGIC);
end input_to_pulse;

architecture Behavioral of input_to_pulse is
constant two_milli: integer := 200000; -- 2ms @ 20MHZ
type states is (idle, high);
signal state_reg, state_next : states;
signal counter, counter_next: unsigned(19 downto 0);

begin

counter_next <= counter+1;
process (clk, reset) is
begin
	if(reset='1') then
		counter <= "00000000000000000000";
	elsif(rising_edge(clk)) then
		counter <= counter;
		if(counter = two_milli+1) then
			counter <= "00000000000000000000";
		else
			if(state_reg=high) then
				counter <= counter_next;
			end if;
		end if;
	end if;
end process;

process (clk, reset) is
begin
	if(reset='1') then
		state_reg <= idle;
	elsif(rising_edge(clk)) then
		state_reg <= state_next;
	end if;
end process;

process(counter, clk, reset) is
begin
	if(reset='1') then
		state_next <= idle;
	elsif(rising_edge(clk)) then
		if(state_reg=idle and input='1') then
			state_next<=high;
		elsif(state_reg=high and counter=two_milli) then
			if(input = '0') then
				state_next<= idle;
			else
				state_next<= high;
			end if;
		end if;
	end if;

end process;


pulse <= '0' when reset ='1' else
			'1' when state_reg=idle and state_next=high else
			'0';

end Behavioral;

