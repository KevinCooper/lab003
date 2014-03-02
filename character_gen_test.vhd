--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use ieee.std_logic_arith.all;
 
ENTITY character_gen_test IS
END character_gen_test;
 
ARCHITECTURE behavior OF character_gen_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT character_gen
    PORT(
         clk : IN  std_logic;
         blank : IN  std_logic;
         reset : IN  std_logic;
         row : IN  std_logic_vector(10 downto 0);
         column : IN  std_logic_vector(10 downto 0);
         ascii_to_write : IN  std_logic_vector(7 downto 0);
         write_en : IN  std_logic;
         r : OUT  std_logic_vector(7 downto 0);
         g : OUT  std_logic_vector(7 downto 0);
         b : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	 
	 component vga_sync
    port ( clk         : in  std_logic;
           reset       : in  std_logic;
           h_sync      : out std_logic;
           v_sync      : out std_logic;
           v_completed : out std_logic;
           blank       : out std_logic;
           row         : out unsigned(10 downto 0);
           column      : out unsigned(10 downto 0)
     );
	end component;
    

   --Inputs
   signal clk : std_logic := '0';
   signal blank : std_logic := '0';
   signal reset : std_logic := '0';
   signal row : std_logic_vector(10 downto 0) := (others => '0');
   signal column : std_logic_vector(10 downto 0) := (others => '0');
   signal ascii_to_write : std_logic_vector(7 downto 0) := (others => '0');
   signal write_en : std_logic := '0';

 	--Outputs
   signal r : std_logic_vector(7 downto 0);
   signal g : std_logic_vector(7 downto 0);
   signal b : std_logic_vector(7 downto 0);
	signal h_sync, v_sync, v_completed : std_logic;
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: character_gen PORT MAP (
          clk => clk,
          blank => blank,
          reset => reset,
          row => row,
          column => column,
          ascii_to_write => ascii_to_write,
          write_en => write_en,
          r => r,
          g => g,
          b => b
        );
		  
	inst_vga_sync: vga_sync
	 port map(
				clk => clk,
				reset => reset,
				h_sync=>h_sync,
				v_sync=>v_sync,
				v_completed=>v_completed,
				blank=>blank,
				unsigned(row)=> row,
				unsigned(column)=> column
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
      reset <= '0';
		blank <= '0';
		ascii_to_write <= "01000001";
		write_en<= '0';
      wait for 100 ns;	

      wait for clk_period*10;
		wait for clk_period/4;

      for I in 0 to 480-1 loop
			for J in 0 to 640-1 loop
				row <= conv_std_logic_vector(I, 11);
				column <= conv_std_logic_vector(J, 11);
				wait for clk_period;
			end loop;
			wait for clk_period;
		end loop;

      wait;
   end process;

END;
