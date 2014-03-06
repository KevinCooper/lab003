--Author: Kevin Cooper
--Date: 3 March 2014
--Purpose: The purpose of this code is to use the buttons on the NES controller in order to determine which position we are currently in on the 30x80 screen.  In addition, it keeps track of the ASCII character that is currently being displayed using the up/down buttons.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity controller is
    Port ( clk : in  STD_LOGIC;
			  reset: in STD_LOGIC;
           ascii_to_write : out  STD_LOGIC_VECTOR (7 downto 0);
           write_en : out  STD_LOGIC;
			  pos: out STD_LOGIC_vector(11 downto 0);
			  data: in STD_LOGIC;
			  nes_clk: out std_logic;
			  latch: out STD_LOGIC
			  );
end controller;

architecture Behavioral of controller is

signal pulse : std_logic;
signal input : std_logic;
signal up, down, left, right: std_logic;
signal pos_num, less, more: unsigned(11 downto 0);
signal write_en_temp: std_logic;
signal ascii_num, ascii_less, ascii_more: unsigned(7 downto 0);
signal counter, counter_next : unsigned(12 downto 0);

begin 

input <= up or down or left or right;
Inst_input_to_pulse: entity work.input_to_pulse
	PORT MAP(
		clk => clk,
		reset => '0',
		input => input,
		pulse =>pulse
	);
--counter_next<= counter+1;
--process(clk) is
--begin
--	if(rising_edge(clk)) then
--		if(counter_next>=2000) then
--			counter <= "0000000000000";
--		else
--			counter<= counter_next;
--		end if;
--	end if;
--end process;
	

	inst_nes: entity work.nes_controller
		PORT MAP(
			reset =>reset,
			clk =>clk,
			data =>data,
			nes_clk =>nes_clk,
			latch =>latch,
			a => open,
			b => open,
			sel => open,
			start => open,
			up => up,
			down => down,
			left => left,
			right => right
		);
		
less <= pos_num -1;
more <= pos_num +1;
ascii_less<= ascii_num-1;
ascii_more<= ascii_num+1;

process (clk, up, down, left, right) is
begin
	if(rising_edge(clk)) then
		write_en_temp<= '0';
		if(pulse='1') then
				if(up='1') then
				ascii_num<= ascii_more;
					write_en_temp<= '1';
				end if;
				if(down='1') then
					ascii_num<= ascii_less;
					write_en_temp<= '1';
				end if;
				if(left='1') then
					pos_num <= less;
				end if;
				if(right='1') then
					pos_num <= more;
				end if;
		end if;
	end if;

end process;


ascii_to_write <= std_logic_vector(ascii_num);
pos <= std_logic_vector(pos_num);
write_en<= write_en_temp;

end Behavioral;

