library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------
entity FoCalculator_tb is
    end FoCalculator_tb;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------
architecture rtl of FoCalculator_tb is

    constant clk_period :       time := 100 ns;
    constant NBitAlpha :        natural := 3; 
    constant NBitPixelValue :   natural := 8;   
    constant NRow :             natural := 4;
    constant NBitRow :          natural := 2;  
    constant NBitCol :          natural := 2;   
    constant NCol :             natural := 4;
    constant NBitFo :           natural := 12;

    ---------------------------------------------------------
    -- ControlUnit Component
    ---------------------------------------------------------
    component FoCalculator
        generic (
            NBitAlpha :         natural := 3; 
            NBitPixelValue :    natural := 8; 
            NRow :              natural := 4;
            NBitRow :           natural := 2;  
            NBitCol :           natural := 2;   
            NCol :              natural := 4;
            NBitFo :            natural := 12  
        );
        port (
            ---------------- input ----------------------
            clk         : in  std_logic;
            a_rst_n     : in  std_logic;
            pixel       : in std_logic_vector(7 downto 0);
            alpha       : in std_logic_vector(NBitAlpha-1 downto 0);

            ---------------- output ---------------------
            i_next_value : out std_logic_vector(NBitRow-1 downto 0);
            j_next_value : out std_logic_vector(NBitCol-1 downto 0);
            fo : out std_logic_vector(NBitFo-1 downto 0)  
        );
    end component;

    ---------------------------------------------------------
    -- Signals
    ---------------------------------------------------------
    ---------------- input ----------------------
    signal clk : std_logic := '0';
    signal a_rst_n_ext : std_logic := '0';
    signal pixel_in_ext : std_logic_vector(7 downto 0);
    signal alpha_in_ext : std_logic_vector(NBitAlpha-1 downto 0) := "010";
    
    ---------------- output ---------------------
    signal i_next_value_out_ext : std_logic_vector(NBitRow-1 downto 0);
    signal j_next_value_out_ext : std_logic_vector(NBitCol-1 downto 0);
    signal fo_out_ext : std_logic_vector(NBitFo-1 downto 0);

    signal testing : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: FoCalculator
        generic map (
            NBitAlpha => NBitAlpha,
            NBitPixelValue => NBitPixelValue,
            NRow => NRow,
            NBitRow => NBitRow,
            NBitCol => NBitCol,
            NCol => NCol,
            NBitFo => NBitFo
        )
        port map(
            clk => clk,
            a_rst_n => a_rst_n_ext,
            pixel => pixel_in_ext,
            alpha => alpha_in_ext,

            i_next_value => i_next_value_out_ext,
            j_next_value => j_next_value_out_ext,
            fo => fo_out_ext
        );

        stimulus : process 
			begin    
			a_rst_n_ext <= '1';        
            pixel_in_ext <= x"FF";
			wait until rising_edge(clk);
            pixel_in_ext <= x"AA";
			wait until rising_edge(clk);
            pixel_in_ext <= x"55";
			wait until rising_edge(clk);
            pixel_in_ext <= x"33";
            wait until rising_edge(clk);
            pixel_in_ext <= x"11";
			wait until rising_edge(clk);
            pixel_in_ext <= x"22";
            wait until rising_edge(clk);
            pixel_in_ext <= x"33";
            wait until rising_edge(clk);
            pixel_in_ext <= x"44";
			wait until rising_edge(clk);
            pixel_in_ext <= x"EE";
			wait until rising_edge(clk);
			testing  <= false;
		end process;
end rtl;