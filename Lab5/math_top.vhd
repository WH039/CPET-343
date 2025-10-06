-------------------------------------------------------------------------------
-- Jacob Kraft
-- Top level of basic Math Display
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity math_top is
    generic (
        bits : integer := 8
    );
    port (
        CLK              : in std_logic;                           --! Clock
        RESET            : in std_logic;                           --! Reset 
        BTN              : in std_logic;                           --! Add Button
        SWITCH           : in std_logic_vector(bits-1 downto 0);   --! A input
        RESULT_HEX_ONE   : out std_logic_vector(6 downto 0);       --! Result seven segment display 1
        RESULT_HEX_TWO   : out std_logic_vector(6 downto 0);       --! Result seven segment display 2
        RESULT_HEX_THREE : out std_logic_vector(6 downto 0);        --! Result seven segment display 3
        STATE_LED        : out std_logic_vector(3 downto 0)
    );
end entity math_top;

architecture top of math_top is

    signal s_edge : std_logic;
    signal s_a_sync   : std_logic_vector(bits-1 downto 0);
    signal s_b_sync   : std_logic_vector(bits-1 downto 0);
    signal s_result   : std_logic_vector(bits downto 0);
    signal s_a_input  : std_logic_vector(bits-1 downto 0);
    signal s_b_input  : std_logic_vector(bits-1 downto 0);
    signal s_state    : std_logic_vector(3 downto 0);

begin

    /* Give the leds the binary of what state it is in */
    STATE_LED <= s_state;

    s_a_input <= std_logic_vector(resize(unsigned(SWITCH),s_a_input'length)) when s_state(0) = '1';
    s_b_input <= std_logic_Vector(resize(unsigned(SWITCH),s_b_input'length)) when s_state(1) = '1';

    /* Button synchronize so it does not have metastability */
    a_btn_sync : entity work.rising_edge_synchronizer
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => BTN,
            EDGE  => s_edge
        );

    /* Synchronize bits A */
    a_in_sync : entity work.sync_bits
        generic map(
            bits => bits
        )
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => s_a_input,
            SYNC  => s_a_sync
        );

    /* Synchronize bits B */
    b_in_sync : entity work.sync_bits
        generic map(
            bits => bits
        )
        port map(
            CLK   => CLK,
            RESET => RESET,
            INPUT => s_b_input,
            SYNC  => s_b_sync
        );

    /* Control component with state machine */
    ctrl_comp : entity work.ctrl_stm
        port map(
            CLK    => CLK,
            RST    => RESET,
            BUTTON => s_edge,
            STATE  => s_state
        );
    
    /* Component that does the subtraction and addition */
    math_comp : entity work.generic_add_sub
        generic map(
            bits => bits
        )
        port map(
            CLK      => CLK,
            RESET    => RESET,
            A_SYNC   => s_a_sync,
            B_SYNC   => s_b_sync,
            STATE    => s_state,
            RESULT   => s_result
        );

    /* Full seven segment display from hundreds digits to singles */
    result_display : entity work.seven_segment_full
        generic map(
        	bits => bits
        )
        port map(
            RESET     => RESET,
            STATE     => s_state,
            A_BCD     => s_a_sync,
            B_BCD     => s_b_sync,
            BCD       => s_result,
            HEX_ONE   => RESULT_HEX_ONE,
            HEX_TWO   => RESULT_HEX_TWO,
            HEX_THREE => RESULT_HEX_THREE
        );

end top;

    
    
        
