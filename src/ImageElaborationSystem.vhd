library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------
entity ImageElaborationSystem is
    generic (
        NBitAlpha :     natural := 3;  
        NBitFo :        natural := 12;  
        NBitPixelValue: natural := 8;   
        NRow :          natural := 4;
        NBitRow :       natural := 2;  
        NBitCol :       natural := 2;   
        NCol :          natural := 4;
        Npixel :        natural := 4
    );
    port (
        ---------------- input ----------------------
        clk         : in  std_logic;
        a_rst_n     : in  std_logic;
        alpha       : in std_logic_vector(NBitAlpha-1 downto 0);

        ---------------- output ---------------------
        fo : out std_logic_vector(NBitFo-1 downto 0)  
    );
end ImageElaborationSystem;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture rtl of ImageElaborationSystem is
    
    ---------------------------------------------------------
    -- FoCalculator Component
    ---------------------------------------------------------
    component FoCalculator
        generic (
            NBitAlpha :     natural := 3;  
            NBitPixelValue: natural := 8;   
            NRow :          natural := 4;
            NBitRow :       natural := 2;  
            NBitCol :       natural := 2;   
            NCol :          natural := 4;
            NBitFo :        natural := 12  
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
    -- ROM Component
    ---------------------------------------------------------
    component ROM
        generic (
            Npixel :        natural := 4;
            NBitPixelValue: natural := 8;
            NBitRow :       natural := 2; 
            NBitCol :       natural := 2   
        );
        port (
            ---------------- input ----------------------
            -- i is the counter of the row of the matrix
            i : in std_logic_vector(NBitRow-1 downto 0);
            -- j is the counter of the row of the matrix
            j : in std_logic_vector(NBitCol-1 downto 0);

            ---------------- output ---------------------
            pixel : out std_logic_vector(NBitPixelValue-1 downto 0)
        );
    end component;

    ---------------------------------------------------------
    -- Signals
    ---------------------------------------------------------
    signal pixel_ext : std_logic_vector(7 downto 0);
    signal i_next_value_ext : std_logic_vector(NBitRow-1 downto 0);
    signal j_next_value_ext : std_logic_vector(NBitCol-1 downto 0);

    begin

        -- Fo Calculator component
        FO_CALCULATOR: FoCalculator
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
            a_rst_n => a_rst_n,
            pixel => pixel_ext,
            alpha => alpha,

            i_next_value => i_next_value_ext,
            j_next_value => j_next_value_ext,
            fo => fo
        );
        
        -- ROM component
        C_ROM: ROM
        generic map (
            Npixel => Npixel,
            NBitPixelValue => NBitPixelValue,
            NBitRow => NBitRow,
            NBitCol => NBitCol
        )
        port map(
            i => i_next_value_ext,
            j => j_next_value_ext,

            pixel => pixel_ext
        );

end rtl;