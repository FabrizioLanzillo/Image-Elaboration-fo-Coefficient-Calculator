library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
    generic (
        NBitAlpha : natural := 3;  -- Default value is 3, can be configured
        NBitPixel : natural := 8;   -- Default value is 8, can be configured
        NRowMatrixImage : natural := 4;   -- Default value is 4, can be configured
        NbitRow : natural := 2;   -- Default value is 4, can be configured
        NColMatrixImage : natural := 4;   -- Default value is 4, can be configured
        NBitCol : natural := 2   -- Default value is 4, can be configured
    );
    port (
        ---------------- input ----------------------
        alpha : in std_logic_vector(NBitAlpha-1 downto 0);
        pixel : in std_logic_vector(NBitPixel-1 downto 0);
        previous_pixel : in std_logic_vector(NBitPixel-1 downto 0);
        i_current_value : in std_logic_vector(NbitRow-1 downto 0);
        j_current_value : in std_logic_vector(NBitCol-1 downto 0);
        
        ---------------- output ---------------------
        i_next_value : out std_logic_vector(NbitRow-1 downto 0);
        j_next_value : out std_logic_vector(NBitCol-1 downto 0);
        -- The # of bits of the output is evaluated from the given formula
        -- where we have the multiplication of the 3 bits of alpha 
        -- by the pixel value over 8 bits resulting in 11 bits
        -- next we have the sum of the same quantity so the total bits become 12
        fo : out std_logic_vector(11 downto 0)  
    );
end entity ControlUnit;

architecture behavioral of ControlUnit is
    signal i_s : std_logic_vector(NbitRow-1 downto 0);
    signal j_s : std_logic_vector(NBitCol-1 downto 0);
    signal fo_s : std_logic_vector(11 downto 0);

begin
    CU_PROC: process(i_current_value, j_current_value)
        begin
            -- check on the number of the row of the matrix, in order
            -- to update the value when we reach the end of the column
            if i_current_value < NRowMatrixImage then
                -- check if we are reading the pixel on the first value
                -- in this case we return as fo the zero value
                if i_current_value = 0  then
                    -- we assign fo the default value of zero
                    fo_s <= 0;
                else
                    -- we compute fo using the given formula
                    fo_s <= alpha * previous_pixel + (8 - alpha) * pixel;
                end if;
                -- increment of the row value to select the next pixel of the column
                i_s <= i_current_value + 1;
                -- the column remein constant
                j_s <= j_current_value;
            else
                -- we check that there are still column to which extract the pixels
                -- we arrive here if we have taken all the pixels of the previuous column
                if j_current_value < NColMatrixImage  then
                    -- we increment the one of the column
                    j_s <= j_current_value + 1;
                else
                    -- if we reached the end of the image we reset also j
                    j_s <= 0;
                end if;
                -- we restore the row value 
                i_s <= 0;
                -- we assign fo the default value of zero
                fo_s <= 0;
            end if;

        i_next_value = i_s;
        j_next_value = j_s;
        fo = fo_s;
        end process;
end architecture behavioral;