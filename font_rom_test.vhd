LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY font_rom_test IS
END font_rom_test;
 
ARCHITECTURE behavior OF font_rom_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT font_rom
    PORT(
         clk : IN  std_logic;
         addr : IN  std_logic_vector(10 downto 0);
         data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal addr : std_logic_vector(10 downto 0) := (others => '0');
 	--Outputs
   signal data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: font_rom PORT MAP (
          clk => clk,
          addr => addr,
          data => data
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		addr <= "1000001"&"0000";
      wait for clk_period*10;
		addr <= "1000001"&"0001";
      wait for clk_period*10;
		addr <= "1000001"&"0010";
      wait for clk_period*10;
		addr <= "1000001"&"0011";
      wait for clk_period*10;
		addr <= "1000001"&"0100";
      wait for clk_period*10;
		addr <= "1000001"&"0101";		
      wait for clk_period*10;
		addr <= "1000001"&"0110";		
      wait for clk_period*10;
		addr <= "1000001"&"0111";		
      wait for clk_period*10;
		addr <= "1000001"&"1000";				

      wait;
   end process;

END;
