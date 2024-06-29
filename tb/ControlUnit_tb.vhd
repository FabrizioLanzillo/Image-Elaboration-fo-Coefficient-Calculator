library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ControlUnit_tb is
    end ControlUnit_tb;

architecture rtl of ControlUnit_tb is

    constant clk_period     : time := 100 ns;
    constant NBitAlpha : natural := 3;  -- Default value is 3, can be configured
    constant NBitPixelValue : natural := 8;   -- Default value is 8, can be configured
    -- the matrix is 4 pixel x 4 pixel
    constant NRow : natural := 4;
    constant NbitRow : natural := 2;   -- Default value is 4, can be configured
    constant NBitCol : natural := 2;   -- Default value is 4, can be configured
    constant NCol : natural := 4;
    constant NbitFo : natural := 12;

    component ControlUnit
        generic (
            NBitAlpha : natural := 3;  -- Default value is 3, can be configured
            NBitPixelValue : natural := 8;   -- Default value is 8, can be configured
            -- the matrix is 4 pixel x 4 pixel
            NRow : natural := 4;
            NbitRow : natural := 2;   -- Default value is 4, can be configured
            NBitCol : natural := 2;   -- Default value is 4, can be configured
            NCol : natural := 4;
            NbitFo : natural := 12  
        );
        port (
            ---------------- input ----------------------
            alpha : in std_logic_vector(NBitAlpha-1 downto 0);
            pixel : in std_logic_vector(NBitPixelValue-1 downto 0);
            previous_pixel : in std_logic_vector(NBitPixelValue-1 downto 0);
            i_current_value : in std_logic_vector(NbitRow-1 downto 0);
            j_current_value : in std_logic_vector(NBitCol-1 downto 0);
            
            ---------------- output ---------------------
            i_next_value : out std_logic_vector(NbitRow-1 downto 0);
            j_next_value : out std_logic_vector(NBitCol-1 downto 0);
            fo : out std_logic_vector(NbitFo-1 downto 0)  
        );
    end component;

    signal clk : std_logic := '0';
    signal alpha_in_ext : std_logic_vector(NBitAlpha-1 downto 0) := "010";
    signal pixel_in_ext : std_logic_vector(NBitPixelValue-1 downto 0);
    signal previous_pixel_in_ext : std_logic_vector(NBitPixelValue-1 downto 0);
    signal i_current_value_in_ext : std_logic_vector(NbitRow-1 downto 0);
    signal j_current_value_in_ext : std_logic_vector(NBitCol-1 downto 0);
    
    ---------------- output ---------------------
    signal i_next_value_out_ext : std_logic_vector(NbitRow-1 downto 0);
    signal j_next_value_out_ext : std_logic_vector(NBitCol-1 downto 0);
    signal fo_out_ext : std_logic_vector(NbitFo-1 downto 0);

    signal testing : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: ControlUnit
        generic map (
            NBitAlpha => NBitAlpha,
            NBitPixelValue => NBitPixelValue,
            NRow => NRow,
            NbitRow => NbitRow,  
            NBitCol => NBitCol,   
            NCol => NCol,
            NbitFo => NbitFo
        )
        port map(
            alpha => alpha_in_ext,
            pixel => pixel_in_ext,
            previous_pixel => previous_pixel_in_ext,
            i_current_value => i_current_value_in_ext,
            j_current_value => j_current_value_in_ext,

            i_next_value => i_next_value_out_ext,
            j_next_value => j_next_value_out_ext,
            fo => fo_out_ext
        );

        stimulus : process 
			begin            
			pixel_in_ext <= x"01";
            previous_pixel_in_ext <= x"03";
            i_current_value_in_ext <= "00";
            j_current_value_in_ext <= "00";
			wait until rising_edge(clk);
			pixel_in_ext <= x"04";
            previous_pixel_in_ext <= x"07";
            i_current_value_in_ext <= "01";
            j_current_value_in_ext <= "00";
			wait until rising_edge(clk);
			pixel_in_ext <= x"0B";
            previous_pixel_in_ext <= x"09";
            i_current_value_in_ext <= "10";
            j_current_value_in_ext <= "00";
			wait until rising_edge(clk);
			pixel_in_ext <= x"07";
            previous_pixel_in_ext <= x"0A";
            i_current_value_in_ext <= "11";
            j_current_value_in_ext <= "00";
            wait until rising_edge(clk);
			pixel_in_ext <= x"04";
            previous_pixel_in_ext <= x"0C";
            i_current_value_in_ext <= "00";
            j_current_value_in_ext <= "01";
			wait until rising_edge(clk);
			pixel_in_ext <= x"0E";
            previous_pixel_in_ext <= x"0B";
            i_current_value_in_ext <= "01";
            j_current_value_in_ext <= "01";
            wait until rising_edge(clk);
			pixel_in_ext <= x"02";
            previous_pixel_in_ext <= x"08";
            i_current_value_in_ext <= "11";
            j_current_value_in_ext <= "11";
			wait until rising_edge(clk);
			testing  <= false;
		end process;
end rtl;