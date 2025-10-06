-------------------------------------------------------------------------------
-- Jacob Kraft
-- Top level of basic Math Display
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

/* Testbench for Math top level that has a control state machine in it */
entity add_sub_tb is
end entity add_sub_tb;

architecture tb of add_sub_tb is

    constant period  : time := 10 ns;
    signal s_clk     : std_logic := '0';
    signal s_rst     : std_logic := '1';
    signal s_btn     : std_logic := '0';
    signal s_switch  : std_logic_vector(7 downto 0) := (others => '0');

begin

    uut : entity work.add_sub
        port map(
            clk              => s_clk,
            reset            => s_rst,
            btn              => s_btn,
            a_b_input        => s_switch,
            state     => open,
            hex_one   => open,
            hex_two   => open,
            hex_three => open
        );

    /* Combinational logic of switch */
    comb_switch_tb : process
    begin
      wait until s_rst = '0';
      s_switch <= 8x"5";
      wait for 50 ns;
      s_switch <= 8x"2";
      wait for 128 ns;
      s_switch <= 8x"2";
      wait for 50 ns;
      s_switch <= 8x"5";
      wait for 120 ns;
      s_switch <= 8x"C8";
      wait for 47 ns;
      s_switch <= 8x"64";
      wait for 120 ns;
      s_switch <= 8x"64";
      wait for 35 ns;
      s_switch <= 8x"C8";
      wait for 128 ns;
    end process comb_switch_tb;
    
    -- clock process
    clock: process
      begin
        s_clk <= not s_clk;
        wait for period/2;
    end process; 
     
    -- reset process
    async_reset: process
      begin
        wait for 2 * period;
        s_rst <= '0';
        wait;
    end process; 

    -- button process
    button_proc : process
    begin
        s_btn <= not(s_btn);
        wait for 4 ns;
    end process button_proc;

end tb;

