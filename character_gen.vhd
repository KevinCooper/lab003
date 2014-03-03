library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity character_gen is
    Port ( clk : in  STD_LOGIC;
           blank : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           row : in  STD_LOGIC_VECTOR (10 downto 0);
           column : in  STD_LOGIC_VECTOR (10 downto 0);
           ascii_to_write : in  STD_LOGIC_VECTOR (7 downto 0);
           write_en : in  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0)--;
--			  test: out STD_LOGIC_VECTOR (11 downto 0);
--			  test2: out STD_LOGIC_VECTOR (7 downto 0)
			  );
	
end character_gen;

architecture cooper of character_gen is

signal col_temp: std_logic_vector(2 downto 0);
signal col_out: std_logic_vector(2 downto 0);
signal row_out: std_logic_vector(3 downto 0);
signal data_out: std_logic_vector(7 downto 0);
signal f: unsigned(13 downto 0);
signal mux_out: std_logic;
signal internal_counter, temp: unsigned(11 downto 0);
signal output, output2: std_logic_vector(7 downto 0);

begin
	 f<= unsigned( unsigned(column(10 downto 3)) + 80 * unsigned(row(10 downto 4)));
	 
    inst_col1: entity work.dff2
    port map(	 clk => clk,	 reset => reset,	 d => column(2 downto 0),	 q => col_temp);
	 
    inst_col2: entity work.dff2
    port map( 	 clk => clk, 	 reset => reset,	 d => col_temp,	 q => col_out);
	 
    inst_row: entity work.dff3
    port map(   clk => clk, 	 reset => reset,	 d => row(3 downto 0),	 q => row_out);
	 
	 char_buffer: entity work.char_screen_buffer
	 port map(	 clk => clk, we => write_en, address_a => std_logic_vector(internal_counter), address_b => std_logic_vector(f(11 downto 0)), data_in =>ascii_to_write, data_out_a =>  output, data_out_b => output2);
	 
	 font_rom: entity work.FONT_ROM
    port map(   clk => clk, 	 addr => output2(6 downto 0)&row_out,  data=> data_out);
	 
	 mux: entity work.mux8to1
	 port map(	 data =>data_out, sel=>col_out, q=> mux_out	);


--Internal counter

temp <= internal_counter +1;

process(clk, write_en,reset) is
begin
	internal_counter <= internal_counter;
	
	if(reset='1') then
		internal_counter <= (others => '0');
	elsif(rising_edge(clk)) then
		if(write_en='1') then
			if (temp >=2400) then
				internal_counter <= (others => '0');
			else
				internal_counter <= temp;
			end if;
		end if;
	end if;
end process;

--test<= std_logic_vector(internal_counter);
--test2<=ascii_to_write;


--Output stuff
	r <= "00000000";
	g <= "00000000" ;
	b <= "00000000" when blank='1' else
			mux_out & mux_out & mux_out & mux_out & mux_out & mux_out & mux_out & mux_out;

end cooper;