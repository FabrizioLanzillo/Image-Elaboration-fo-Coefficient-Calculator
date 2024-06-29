library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
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
        -- The # of bits of the output is evaluated from the given formula
        -- where we have the multiplication of the 3 bits of alpha 
        -- by the pixel value over 8 bits resulting in 11 bits
        -- next we have the sum of the same quantity so the total bits become 12
        fo : out std_logic_vector(NbitFo-1 downto 0)  
    );
end entity ControlUnit;

architecture behavioral of ControlUnit is
    signal i_s : std_logic_vector(NbitRow-1 downto 0);
    signal j_s : std_logic_vector(NBitCol-1 downto 0);
    signal fo_s : std_logic_vector(NbitFo-1 downto 0);

begin
    CU_PROC: process(i_current_value, j_current_value, alpha, pixel, previous_pixel)
        begin

            -- check on the number of the row of the matrix, in order
            -- to update the value when we reach the end of the column
            if(to_integer(unsigned(i_current_value)) <= (NRow-1)) then
                -- check if we are reading the pixel on the first value
                -- in this case we return as fo the zero value
                if(to_integer(unsigned(i_current_value)) = 0) then
                    -- we assign fo the default value of zero
                    fo_s <= (others => '0');
                    i_s <= std_logic_vector(resize(unsigned(i_current_value) +1, NbitRow));
                    j_s <= j_current_value;
                else
                    -- we compute fo using the given formula
                    fo_s <= std_logic_vector(resize(unsigned(alpha) * unsigned(previous_pixel) + (8 - unsigned(alpha)) * unsigned(pixel), NbitFo));
                    if(to_integer(unsigned(i_current_value)) = (NRow-1)) then
                        i_s <= (others => '0');

                        if(to_integer(unsigned(j_current_value)) < (NCol-1)) then
                            j_s <= std_logic_vector(resize(unsigned(j_current_value) +1, NBitCol));                          
                        else
                            j_s <= (others => '0');
                        end if;
                    else
                        i_s <= std_logic_vector(resize(unsigned(i_current_value) +1, NbitRow));
                        j_s <= j_current_value;
                    end if;
                end if;

            else
                fo_s <= (others => '0');
                i_s <= (others => '0');
                j_s <= (others => '0');
            end if;

        end process;

        i_next_value <= i_s;
        j_next_value <= j_s;
        fo <= fo_s;
end architecture behavioral;