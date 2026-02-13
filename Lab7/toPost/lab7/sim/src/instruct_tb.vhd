-------------------------------------------------------------------------------
-- Jacob Kraft
-- Testbench of basic Math Display with Memory
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity instruct_tb is
end entity instruct_tb;

architecture tb of instruct_tb is

    constant period      : time := 10 ns;
    constant bits        : integer := 8;
    signal s_clk         : std_logic := '0'; -- Clock
    signal s_rst         : std_logic := '0'; -- Reset 
    signal s_ex          : std_logic := '0'; -- Execute Button
    
begin

    uut : entity work.top
    	generic map(
    		bits        => bits
    	)
    	port map(
    		CLK              => s_clk,
    		RESET            => s_rst,
    		EXEC             => s_ex,
    		RESULT_HEX_ONE   => open,
    		RESULT_HEX_TWO   => open,
    		RESULT_HEX_THREE => open,
    		STATE_LED        => open
        );

    -- clock process
    clock : process
      begin
        s_clk <= not s_clk;
        wait for period/2;
    end process; 
     
    -- reset process
    async_reset : process
      begin
        wait for 2 * period;
        s_rst <= '1';
        wait;
    end process; 

    instr_proc : process
    begin
    --------------------------------------------------------------------------
    -- Wait for reset release
    --------------------------------------------------------------------------
    wait until s_rst = '1';
    wait until rising_edge(s_clk);
    report "Reset released, starting operations..." severity note;

    --------------------------------------------------------------------------
    -- Step 1: Input 4 → EXEC → write to working
    --------------------------------------------------------------------------
    wait for 5*period;
    wait until rising_edge(s_clk);
    s_ex <= '1';
    wait for period; -- hold for one full clock
    s_ex <= '0';
    wait for period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 10*period; -- allow for synchronizer + FSM + memory write
    report "Step 1 complete (Loaded 4 into working register)" severity note;

    --------------------------------------------------------------------------
    -- Step 2: Multiply by 8 → EXEC
    --------------------------------------------------------------------------
    wait for 2*period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 2 complete (4 * 8 executed, result stored)" severity note;

    --------------------------------------------------------------------------
    -- Step 3: Save to memory (MS)
    --------------------------------------------------------------------------
    wait for 5*period;
    report "Step 3 complete (Saved working register to save register)" severity note;

    --------------------------------------------------------------------------
    -- Step 4: Subtract 8 → EXEC
    --------------------------------------------------------------------------
    wait for 2*period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 4 complete (Subtract 8)" severity note;

    --------------------------------------------------------------------------
    -- Step 5: Divide by 2 → EXEC
    --------------------------------------------------------------------------
    wait for 2*period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 5 complete (Divide by 2)" severity note;

    --------------------------------------------------------------------------
    -- Step 6: Recall saved register (MR)
    --------------------------------------------------------------------------
    wait for 5*period;
    report "Step 6 complete (Recalled saved register into working)" severity note;

    --------------------------------------------------------------------------
    -- Step 7: Execute after recall (EXEC)
    --------------------------------------------------------------------------
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 7 complete (Executed after recall)" severity note;

    --------------------------------------------------------------------------
    -- End of simulation
    --------------------------------------------------------------------------
    wait for 10*period;
    assert false report "Simulation complete." severity failure;
end process;

end tb;