library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity ROM is
    generic (
        Npixel : natural := 4;
        NBitPixelValue: natural := 8;
        NBitRow : natural := 2;   -- Default value is 4, can be configured
        NBitCol : natural := 2   -- Default value is 4, can be configured
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
end entity ROM;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture dataflow of ROM is
    signal pixel_addr_int : integer range 0 to Npixel*Npixel-1;
    -- Type definition for the ROM array
    type rom_array_t is array (0 to Npixel*Npixel-1) of unsigned(NBitPixelValue-1 downto 0);
    -- Constant ROM array with predefined values
    constant rom : rom_array_t := (
        x"FF", x"AA", x"55", x"33",  -- first 4 values
        x"11", x"22", x"33", x"44",  -- next 4 values
        x"66", x"77", x"88", x"99",  -- next 4 values
        x"BB", x"CC", x"DD", x"EE"   -- last 4 values
    );
begin

    -- Calculate the pixel address
    --pixel_addr_int <= to_integer(unsigned(i)*Npixel + unsigned(j));
    pixel_addr_int <= to_integer(unsigned(j)*to_unsigned(Npixel,3) + unsigned(i));
    -- Assign the pixel value from the ROM array
    pixel <= std_logic_vector(rom(pixel_addr_int));

end architecture;
