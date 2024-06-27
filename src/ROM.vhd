library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------

entity ROM is
    generic (
        Npixel : integer := 4
    );
    port (
        ---------------- input ----------------------
        -- i is the counter of the row of the matrix
        i : in std_logic_vector(ceil(log2(Npixel))-1 downto 0);
        -- j is the counter of the row of the matrix
        j : in std_logic_vector(ceil(log2(Npixel))-1 downto 0);

        ---------------- output ---------------------
        pixel : out std_logic_vector(7 downto 0)
    );
end entity ROM;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------

architecture dataflow of ROM is
    signal pixel_addr_int : integer range 0 to Npixel*Npixel-1;
    -- Type definition for the ROM array
    type rom_array_t is array (0 to Npixel*Npixel-1) of unsigned(7 downto 0);
    -- Constant ROM array with predefined values
    constant rom : rom_array_t := (
        x"FF", x"AA", x"55", x"33",  -- first 4 values
        x"11", x"22", x"33", x"44",  -- next 4 values
        x"66", x"77", x"88", x"99",  -- next 4 values
        x"BB", x"CC", x"DD", x"EE"   -- last 4 values
    );
begin
    -- Calculate the pixel address
    pixel_addr_int <= to_integer(i)*Npixel + to_integer(j);
    -- Assign the pixel value from the ROM array
    pixel <= rom(pixel_addr_int);
end architecture;
