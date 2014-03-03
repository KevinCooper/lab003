

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity atlys_lab_video is
    port ( 
             clk   : in  std_logic; -- 100 MHz
             reset : in  std_logic;
		    	 up: in std_logic;
	    		 down: in std_logic;
				 enter: in std_logic;
				 one: in std_logic;
				 two: in std_logic;
				 three: in std_logic;
				 four: in std_logic;
				 five: in std_logic;
				 six: in std_logic;
				 seven: in std_logic;
				 eight: in std_logic;
             tmds  : out std_logic_vector(3 downto 0);
             tmdsb : out std_logic_vector(3 downto 0)
         );
end atlys_lab_video;

architecture Cooper of atlys_lab_video is
signal blue, green, red : std_logic_vector(7 downto 0);
signal red_s, blue_s, green_s, clock_s: std_logic;
signal row, column: unsigned(10 downto 0);
signal v_sync, h_sync: std_logic;
signal pixel_clk, serialize_clk, serialize_clk_n: std_logic;
signal v_completed, blank: std_logic;
signal ball_x, ball_y, paddle_y: unsigned (10 downto 0);
signal h_out, v_out, v_completed_out : std_logic;
signal h_temp, v_temp, v_completed_temp, h_temp2, v_temp2 : std_logic;
signal blank_temp, blank_temp2, blank_temp3 : std_logic;
signal ascii_to_write: std_logic_vector(7 downto 0);
signal write_en: std_logic;
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

begin

--		inst_pixel: entity work.pixel_gen
--		port map(
--			row =>row,
--			column =>column,
--			blank => blank,
--			r =>red,
--			g =>green,
--			b =>blue
--		);
					
	Inst_character_gen: entity work.character_gen 
		PORT MAP(
		clk => pixel_clk,
		blank => blank_temp,
		reset => reset,
		row => std_logic_vector(row),
		column => std_logic_vector(column),
		ascii_to_write => eight & seven & six & five & four & three & two & one,
		write_en => write_en,
		r => red,
		g => green,
		b => blue
	);
	
	Inst_input_to_pulse: entity work.input_to_pulse
		PORT MAP(
		clk => pixel_clk,
		reset => '0',
		input =>enter,
		pulse =>write_en
	);

    -- Convert VGA signals to HDMI (actually, DVID ... but close enough)
    inst_dvid: entity work.dvid
    port map(
                clk       => serialize_clk,
                clk_n     => serialize_clk_n, 
                clk_pixel => pixel_clk,
                red_p     => red,
                green_p   => green,
                blue_p    => blue,
                blank     => blank_temp2,
                hsync     => h_temp2,
                vsync     => v_temp2,
                -- outputs to TMDS drivers
                red_s     => red_s,
                green_s   => green_s,
                blue_s    => blue_s,
                clock_s   => clock_s
            );

    --VGA component instantiation
	 inst_vga_sync: vga_sync
	 port map(
				clk => pixel_clk,
				reset => reset,
				h_sync=>h_out,
				v_sync=>v_out,
				v_completed=>v_completed,
				blank=>blank,
				row=> row,
				column=> column
				);
	--Pipeline the signals
	
	inst_blank: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => blank,	 q => blank_temp);
	inst_blank2: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => blank_temp,	 q => blank_temp2);
	inst_blank3: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => blank_temp2,	 q => blank_temp3);
		
	inst_h1: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => h_out,	 q => h_temp);
	inst_h2: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => h_temp,	 q => h_temp2);
	inst_h3: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => h_temp2,	 q => h_sync);
--		
	inst_v1: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => v_out,	 q => v_temp);
	inst_v2: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => v_temp,	 q => v_temp2);
	inst_v3: entity work.dff
		port map(	 clk => pixel_clk,	 reset => reset,	 d => v_temp2,	 q => v_sync);
--		
--	inst_v_completed_1: entity work.dff
--		port map(	 clk => pixel_clk,	 reset => reset,	 d => v_completed_out,	 q => v_completed_temp);
--	inst_v_completed_2: entity work.dff
--		port map(	 clk => pixel_clk,	 reset => reset,	 d => v_completed_temp,	 q => v_completed);
		
		
    -- Clock divider - creates pixel clock from 100MHz clock
    inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
    OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
    OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
    OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );

end Cooper;