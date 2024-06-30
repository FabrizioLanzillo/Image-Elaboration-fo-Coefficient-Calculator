library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

---------------------------------------------------------
-- Entity
---------------------------------------------------------
entity ROM_tb is
    end ROM_tb;

---------------------------------------------------------
-- Architecture
---------------------------------------------------------
architecture rtl of ROM_tb is

    constant clk_period :   time := 100 ns;
    constant Npixel :       natural := 4;
    constant NBitPixelValue: natural := 8;
    constant NBitRow :      natural := 2;  
    constant NBitCol :      natural := 2;   

    ---------------------------------------------------------
    -- ROM Component
    ---------------------------------------------------------
    component ROM
        generic (
            Npixel : natural := 4;
            NBitPixelValue: natural := 8;
            NBitRow : natural := 2;   
            NBitCol : natural := 2   
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
    ---------------- input ----------------------   
    signal clk : std_logic := '0';
    signal i_in_ext : std_logic_vector(NBitRow-1 downto 0);
    signal j_in_ext : std_logic_vector(NBitCol-1 downto 0);
    
    ---------------- output ---------------------
    signal pixel_out_ext : std_logic_vector(NBitPixelValue-1 downto 0);
    signal testing : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: ROM
        generic map (
            Npixel => Npixel,
            NBitPixelValue => NBitPixelValue,
            NBitRow => NBitRow,
            NBitCol => NBitCol
        )
        port map(
            i => i_in_ext,
            j => j_in_ext,

            pixel => pixel_out_ext
        );

        stimulus : process 
			begin            
            i_in_ext <= "00";
            j_in_ext <= "00";
			wait until rising_edge(clk);
            i_in_ext <= "01";
            j_in_ext <= "00";
			wait until rising_edge(clk);
            i_in_ext <= "10";
            j_in_ext <= "00";
			wait until rising_edge(clk);
            i_in_ext <= "11";
            j_in_ext <= "00";
            wait until rising_edge(clk);
            i_in_ext <= "00";
            j_in_ext <= "01";
			wait until rising_edge(clk);
            i_in_ext <= "01";
            j_in_ext <= "01";
            wait until rising_edge(clk);
            i_in_ext <= "10";
            j_in_ext <= "01";
            wait until rising_edge(clk);
            i_in_ext <= "11";
            j_in_ext <= "01";
            wait until rising_edge(clk);
            i_in_ext <= "11";
            j_in_ext <= "11";
			wait until rising_edge(clk);
			testing  <= false;
		end process;
end rtl;