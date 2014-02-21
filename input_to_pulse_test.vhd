library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
 
ENTITY input_to_pulse_test IS
END input_to_pulse_test;
 
ARCHITECTURE behavior OF input_to_pulse_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT input_to_pulse
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         input : IN  std_logic;
         pulse : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal input : std_logic := '0';

 	--Outputs
   signal pulse : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: input_to_pulse PORT MAP (
          clk => clk,
          reset => reset,
          input => input,
          pulse => pulse
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
		input <= '0';
      wait for 100 ns;	
		reset <= '0';
      wait for clk_period*10;
		wait for clk_period*(3/4);
      input <= '1';
		wait for clk_period*190000;
		input <= '0';
		wait for clk_period*1000;
		input <= '1';
		wait for clk_period*1000;
		input <= '0';
		wait for clk_period*1000;
		input <= '1';
		wait for clk_period*1000;
		input <= '0';
		wait for clk_period*7000;
		input <='1';
		wait for clk_period*7000;
		input <='0';
      wait;
   end process;

END;
