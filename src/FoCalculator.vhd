library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity FoCalculator is
    generic (
        NBitAlpha : natural := 3;  -- Default value is 3, can be configured
        NBitPixelValue : natural := 8;   -- Default value is 8, can be configured
        NRow : natural := 4;
        NBitRow : natural := 2;  
        NBitCol : natural := 2;   
        NCol : natural := 4;
        NBitFo : natural := 12  -- Default value is 4, can be configured
    );
    port (
        clk         : in  std_logic;
        a_rst_n     : in  std_logic;
    	pixel       : in std_logic_vector(7 downto 0);
        alpha       : in std_logic_vector(NBitAlpha-1 downto 0);

        i_next_value : out std_logic_vector(NBitRow-1 downto 0);
        j_next_value : out std_logic_vector(NBitCol-1 downto 0);
        -- The # of bits of the output is evaluated from the given formula
        -- where we have the multiplication of the 3 bits of alpha 
        -- by the pixel value over 8 bits resulting in 11 bits
        -- next we have the sum of the same quantity so the total bits become 12
        fo : out std_logic_vector(NBitFo-1 downto 0)  
    );
end FoCalculator;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of FoCalculator is
    -- signals 
    -- control unit
    signal alpha_in_ext : std_logic_vector(NBitAlpha-1 downto 0);
    signal pixel_in_ext : std_logic_vector(NBitPixelValue-1 downto 0);
    signal previous_pixel_in_ext : std_logic_vector(NBitPixelValue-1 downto 0);
    signal i_current_value_in_ext : std_logic_vector(NBitRow-1 downto 0);
    signal j_current_value_in_ext : std_logic_vector(NBitCol-1 downto 0);
    
    ---------------- output ---------------------
    signal i_next_value_out_ext : std_logic_vector(NBitRow-1 downto 0);
    signal j_next_value_out_ext : std_logic_vector(NBitCol-1 downto 0);
    signal fo_out_ext : std_logic_vector(11 downto 0);


    -- costants
    constant one    : std_logic := '1';

    component DFF_N
        generic (NBit : positive := 8);
        port (
            clk     : in  std_logic;
            a_rst_n : in  std_logic;
            en      : in  std_logic;
            D       : in  std_logic_vector(NBit - 1 downto 0);
            Q       : out std_logic_vector(NBit - 1 downto 0)
        );
    end component;

    component ControlUnit
        generic (
            NBitAlpha : natural := 3;  
            NBitPixelValue : natural := 8;  
            NRow : natural := 4;
            NBitRow : natural := 2;  
            NBitCol : natural := 2;   
            NCol : natural := 4;
            NbitFo : natural := 12
        );
        port (
            ---------------- input ----------------------
            alpha : in std_logic_vector(NBitAlpha-1 downto 0);
            pixel : in std_logic_vector(NBitPixelValue-1 downto 0);
            previous_pixel : in std_logic_vector(NBitPixelValue-1 downto 0);
            i_current_value : in std_logic_vector(NBitRow-1 downto 0);
            j_current_value : in std_logic_vector(NBitCol-1 downto 0);
            
            ---------------- output ---------------------
            i_next_value : out std_logic_vector(NBitRow-1 downto 0);
            j_next_value : out std_logic_vector(NBitCol-1 downto 0);
            fo : out std_logic_vector(NbitFo-1 downto 0)  
        );
    end component;

begin

    -- new pixel
    REG_NEW_PIXEL: DFF_N
        generic map (NBit => NBitPixelValue)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => one,
            D       => pixel,
            Q       => pixel_in_ext
        );

    -- old pixel
    REG_OLD_PIXEL: DFF_N
        generic map (NBit => NBitPixelValue)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => one,
            D       => pixel_in_ext,
            Q       => previous_pixel_in_ext
        );

    -- row
    REG_ROW: DFF_N
        generic map (NBit => NBitRow)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => one,
            D       => i_next_value_out_ext,
            Q       => i_current_value_in_ext
        );

    -- col
    REG_COL: DFF_N
        generic map (NBit => NbitCol)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => one,
            D       => j_next_value_out_ext,
            Q       => j_current_value_in_ext
        );

    -- alpha
    REG_ALPHA: DFF_N
        generic map (NBit => NBitAlpha)
        port map(
            clk     => clk,   
            a_rst_n => a_rst_n,
            en      => one,
            D       => alpha,
            Q       => alpha_in_ext
        );
    
    -- fo
    REG_FO: DFF_N
    generic map (NBit => NBitFo)
    port map(
        clk     => clk,   
        a_rst_n => a_rst_n,
        en      => one,
        D       => fo_out_ext,
        Q       => fo
    );
    
    CONTROL_UNIT: ControlUnit
        generic map (
            NBitAlpha => NBitAlpha,
            NBitPixelValue => NBitPixelValue,
            NRow => NRow,
            NBitRow => NBitRow,  
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

    i_next_value <= i_current_value_in_ext;
    j_next_value <= j_current_value_in_ext;
end rtl;