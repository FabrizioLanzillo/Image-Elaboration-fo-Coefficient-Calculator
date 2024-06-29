library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity ImageElaborationSystem_tb is
    end ImageElaborationSystem_tb;

architecture rtl of ImageElaborationSystem_tb is

    constant clk_period     : time := 100 ns;
    constant NBitAlpha : natural := 3;  -- Default value is 3, can be configured
    constant NBitFo : natural := 12;  -- Default value is 4, can be configured
    constant NBitPixelValue : natural := 8;   -- Default value is 8, can be configured
    constant NRow : natural := 4;
    constant NBitRow : natural := 2;  
    constant NBitCol : natural := 2;   
    constant NCol : natural := 4;
    constant Npixel : natural := 4;

    component ImageElaborationSystem
        generic (
            NBitAlpha : natural := 3;  -- Default value is 3, can be configured
            NBitFo : natural := 12;  -- Default value is 4, can be configured
            NBitPixelValue : natural := 8;   -- Default value is 8, can be configured
            NRow : natural := 4;
            NBitRow : natural := 2;  
            NBitCol : natural := 2;   
            NCol : natural := 4;
            Npixel : natural := 4
        );
        port (
            clk         : in  std_logic;
            a_rst_n     : in  std_logic;
            alpha       : in std_logic_vector(NBitAlpha-1 downto 0);

            fo : out std_logic_vector(NBitFo-1 downto 0)  
        );
    end component;

    signal clk : std_logic := '0';
    signal a_rst_n_ext : std_logic := '0';
    signal alpha_in_ext : std_logic_vector(NBitAlpha-1 downto 0) := "010";
    
    ---------------- output ---------------------
    signal fo_out_ext : std_logic_vector(NBitFo-1 downto 0);

    signal testing : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: ImageElaborationSystem
        generic map (
            NBitAlpha => NBitAlpha,
            NBitFo => NBitFo,
            NBitPixelValue => NBitPixelValue,
            NRow => NRow,
            NBitRow => NBitRow,
            NBitCol => NBitCol,
            NCol => NCol,
            Npixel => Npixel
        )
        port map(
            clk => clk,
            a_rst_n => a_rst_n_ext,
            alpha => alpha_in_ext,

            fo => fo_out_ext
        );

        stimulus : process 
			begin    
			a_rst_n_ext <= '1';     
			wait for 800 ns;
			wait until rising_edge(clk);
			testing  <= false;
		end process;
end rtl;