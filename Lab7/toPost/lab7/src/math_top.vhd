-------------------------------------------------------------------------------
-- Jacob Kraft
-- Top level of basic Math Display
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.components_pkg.all;

entity math_top is
    generic (
        bits : integer := 8
    );
    port (
        CLK              : in std_logic;                           --! Clock
        RESET            : in std_logic;                           --! Reset 
        OPERATOR         : in std_logic_vector(1 downto 0);        --! Operator
        B_INPUT          : in std_logic_vector(bits-1 downto 0);   --! B input
        MS               : in std_logic;                           --! MS button
        MR               : in std_logic;                           --! MR button
        EXEC             : in std_logic;                           --! Execute Button
        RESULT_HEX_ONE   : out std_logic_vector(6 downto 0);       --! Result seven segment display 1
        RESULT_HEX_TWO   : out std_logic_vector(6 downto 0);       --! Result seven segment display 2
        RESULT_HEX_THREE : out std_logic_vector(6 downto 0);       --! Result seven segment display 3
        STATE_LED        : out std_logic_vector(4 downto 0)        --! State LEDS
    );
end entity math_top;

architecture top of math_top is

    signal s_b_sync    : std_logic_vector(bits-1 downto 0); --! Sync of B Input
    signal s_state     : std_logic_vector(4 downto 0);      --! State Instantiation
    signal s_data_out  : std_logic_vector(bits-1 downto 0); --! Data out from ALU to Memory
    signal s_a_data    : std_logic_vector(bits-1 downto 0); --! Data out from work register in memory to alu
    signal s_we        : std_logic;                         --! Write Enable
    signal s_addr      : std_logic_vector(1 downto 0);      --! Address control signal from state machine to memory
    signal s_ms_sync   : std_logic;                         --! Sync for ms button
    signal s_mr_sync   : std_logic;                         --! Sync for mr button
    signal s_exec_sync : std_logic;                         --! Sync for exec button

begin

    STATE_LED <= s_state;

    bit_synchronizer : entity work.sync_bits
        generic map(
            bits => bits
        )
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => B_INPUT,
            SYNC  => s_b_sync
        );

    ms_sync : entity work.rising_edge_synchronizer
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => MS,
            EDGE  => s_ms_sync
        );

    mr_sync : entity work.rising_edge_synchronizer
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => MR,
            EDGE  => s_mr_sync
        );

    exec_sync : entity work.rising_edge_synchronizer
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => EXEC,
            EDGE  => s_exec_sync
        );
    
    math_alu : entity work.alu
        port map(
            clk    => clk,
            reset  => reset,
            execute => s_exec_sync,
            a      => s_a_data,
            b      => s_b_sync,
            op     => OPERATOR,
            result => s_data_out
        );

    ram_mem  : entity work.memory
        generic map(
            addr_width => 2,
            data_width => 8
        )
        port map(
            clk   => clk,
            rst   => reset,
            we    => s_we,
            addr  => s_addr,
            state => s_state,
            din   => s_data_out,
            dout  => s_a_data
        );

    ctrl_mem : entity work.addr_ctrl
        port map(
            CLK   => CLK,
            RST   => RESET,
            MS    => s_ms_sync,
            MR    => s_mr_sync,
            EXEC  => s_exec_sync,
            WE    => s_we,
            ADDR  => s_addr,
            STATE => s_state
        );
    
    display : entity work.seven_segment_full
        generic map(
            bits => bits
        )
        port map(
            RESET     => RESET,
            STATE     => s_state,
            A_BCD     => s_a_data,
            BCD       => s_data_out,
            HEX_ONE   => RESULT_HEX_ONE,
            HEX_TWO   => RESULT_HEX_TWO,
            HEX_THREE => RESULT_HEX_THREE
        );

end top;
