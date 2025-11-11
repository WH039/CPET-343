-------------------------------------------------------------------------------
-- Components Package
-- Auto-generated from project files
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package components_pkg is

    -- Address Controller for memory
    component addr_ctrl is
        port (
            CLK   : in std_logic;
            RST   : in std_logic;
            MS    : in std_logic;
            MR    : in std_logic;
            EXEC  : in std_logic;
            WE    : out std_logic;
            ADDR  : out std_logic_vector(1 downto 0);
            STATE : out std_logic_vector(4 downto 0)
        );
    end component addr_ctrl;

    -- Arithmetic Logic Unit
    component alu is
        port (
            clk     : in std_logic;
            reset   : in std_logic;
            execute : in std_logic;
            a       : in std_logic_vector(7 downto 0);
            b       : in std_logic_vector(7 downto 0);
            op      : in std_logic_vector(1 downto 0);
            result  : out std_logic_vector(7 downto 0)
        );
    end component alu;

    -- Memory module
    component memory is
        generic (
            addr_width : integer := 2;
            data_width : integer := 4
        );
        port (
            CLK   : in std_logic;
            RST   : in std_logic;
            WE    : in std_logic;
            STATE : in std_logic_vector(4 downto 0);
            ADDR  : in std_logic_vector(addr_width - 1 downto 0);
            DIN   : in std_logic_vector(data_width - 1 downto 0);
            DOUT  : out std_logic_vector(data_width - 1 downto 0)
        );
    end component memory;

    -- Rising Edge Synchronizer
    component rising_edge_synchronizer is
        port (
            CLK   : in std_logic;
            RESET : in std_logic;
            INPUT : in std_logic;
            EDGE  : out std_logic
        );
    end component rising_edge_synchronizer;

    -- Seven Segment Display Controller
    component seven_segment_full is
        generic(
            bits : integer
        );
        port(
            RESET       : in std_logic;
            STATE       : in std_logic_vector(4 downto 0);
            A_BCD       : in std_logic_vector(bits-1 downto 0);
            BCD         : in std_logic_vector(bits-1 downto 0);
            HEX_ONE     : out std_logic_vector(6 downto 0);
            HEX_TWO     : out std_logic_vector(6 downto 0);
            HEX_THREE   : out std_logic_vector(6 downto 0)
        );
    end component seven_segment_full;

    -- Bit Synchronizer
    component sync_bits is
        generic (
            bits : integer
        );
        port (
            CLK   : in std_logic;
            RESET : in std_logic;
            INPUT : in std_logic_vector(bits-1 downto 0);
            SYNC  : out std_logic_vector(bits-1 downto 0)
        );
    end component sync_bits;

end package components_pkg;