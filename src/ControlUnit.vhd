library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity ControlUnit is
    generic (
        NBitAlpha :         natural := 3;  
        NBitPixelValue :    natural := 8;  
        NRow :              natural := 4;
        NBitRow :           natural := 2;   
        NBitCol :           natural := 2;   
        NCol :              natural := 4;
        -- The # of bits of the output is evaluated from the given formula
        -- where we have the multiplication of the 3 bits of alpha 
        -- by the pixel value over 8 bits resulting in 11 bits
        -- next we have the sum of the same quantity so the total bits become 12
        NbitFo :            natural := 12
    );
    port (
        ------------------------ input ---------------------------
        alpha : in std_logic_vector(NBitAlpha-1 downto 0);
        pixel : in std_logic_vector(NBitPixelValue-1 downto 0);
        previous_pixel : in std_logic_vector(NBitPixelValue-1 downto 0);
        i_current_value : in std_logic_vector(NBitRow-1 downto 0);
        j_current_value : in std_logic_vector(NBitCol-1 downto 0);
        
        ------------------------- output -------------------------
        i_next_value : out std_logic_vector(NBitRow-1 downto 0);
        j_next_value : out std_logic_vector(NBitCol-1 downto 0);
        fo : out std_logic_vector(NbitFo-1 downto 0)  
    );
end entity ControlUnit;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture behavioral of ControlUnit is
    signal i_s : std_logic_vector(NBitRow-1 downto 0);
    signal j_s : std_logic_vector(NBitCol-1 downto 0);
    signal fo_s : std_logic_vector(NbitFo-1 downto 0);

begin
    CU_PROC: process(i_current_value, j_current_value, alpha, pixel, previous_pixel)
        begin

            -- check if the index of the row is not greater than the number of rows
            if(to_integer(unsigned(i_current_value)) <= (NRow-1)) then
                -- check if we are reading the pixel of the first row
                -- in this case we return as fo the zero value
                -- because there is not a previous pixel
                if(to_integer(unsigned(i_current_value)) = 0) then
                    -- we assign fo the default value of zero
                    fo_s <= (others => '0');
                    -- increment of the row value
                    i_s <= std_logic_vector(resize(unsigned(i_current_value) +1, NBitRow));
                    j_s <= j_current_value;
                else
                    -- if we are in a row greater than zero we have the previous pixel 
                    -- we can compute fo
                    fo_s <= std_logic_vector(resize(unsigned(alpha) * unsigned(previous_pixel) + (8 - unsigned(alpha)) * unsigned(pixel), NbitFo));
                    -- if we reached the final row
                    if(to_integer(unsigned(i_current_value)) = (NRow-1)) then
                        -- we reset the row index value
                        i_s <= (others => '0');
                        -- we check that the index of the column is not greater than the number of columns
                        if(to_integer(unsigned(j_current_value)) < (NCol-1)) then
                            -- we pass to the next column, by incrementing the column index value
                            j_s <= std_logic_vector(resize(unsigned(j_current_value) +1, NBitCol));                          
                        else
                            -- we reset the column index value
                            j_s <= (others => '0');
                        end if;
                    else
                        -- if we have not reached the final row we just increment the
                        -- row index value without change the column one
                        i_s <= std_logic_vector(resize(unsigned(i_current_value) +1, NBitRow));
                        j_s <= j_current_value;
                    end if;
                end if;

            else
                fo_s <= (others => '0');
                i_s <= (others => '0');
                j_s <= (others => '0');
            end if;

        end process;
        
        -- assignment to the outport value the signals
        i_next_value <= i_s;
        j_next_value <= j_s;
        fo <= fo_s;
end architecture behavioral;