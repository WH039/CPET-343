-------------------------------------------------------------------------------
-- Jacob Kraft
-- Testbench of basic Math Display with Memory
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use work.components_pkg.all;

entity math_top_tb is
end entity math_top_tb;

architecture tb of math_top_tb is

    constant period  : time := 10 ns;
    constant bits    : integer := 8;
    signal s_clk     : std_logic := '0'; -- Clock
    signal s_rst     : std_logic := '0'; -- Reset 
    signal s_op      : std_logic_vector(1 downto 0) := (others => '0'); -- Mathematical Operator
    signal s_input   : std_logic_vector(bits-1 downto 0); -- Manual Input 
    signal s_ms      : std_logic := '0'; -- Save Number to Save Register 
    signal s_mr      : std_logic := '0'; -- Use Number in Save Register
    signal s_ex      : std_logic := '0'; -- Execute Button
    
begin

    uut : entity work.math_top
    	generic map(
    		bits => bits
    	)
    	port map(
    		CLK              => s_clk,
    		RESET            => s_rst,
    		OPERATOR         => s_op,
    		B_INPUT          => s_input,
    		MS               => s_ms,
    		MR               => s_mr,
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
    s_input <= x"04";
    s_op    <= "00"; -- no operator
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
    s_op    <= "10"; -- Multiply
    s_input <= x"08";
    wait for 2*period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 2 complete (4 * 8 executed, result stored)" severity note;

    --------------------------------------------------------------------------
    -- Step 3: Save to memory (MS)
    --------------------------------------------------------------------------
    s_ms <= '1';
    wait for period;
    s_ms <= '0';
    wait for 5*period;
    report "Step 3 complete (Saved working register to save register)" severity note;

    --------------------------------------------------------------------------
    -- Step 4: Subtract 8 → EXEC
    --------------------------------------------------------------------------
    s_op    <= "01"; -- Subtract
    s_input <= x"08";
    wait for 2*period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 4 complete (Subtract 8)" severity note;

    --------------------------------------------------------------------------
    -- Step 5: Divide by 2 → EXEC
    --------------------------------------------------------------------------
    s_op    <= "11"; -- Divide
    s_input <= x"02";
    wait for 2*period;
    s_ex <= '1';
    wait for period;
    s_ex <= '0';
    wait for 5*period;
    report "Step 5 complete (Divide by 2)" severity note;

    --------------------------------------------------------------------------
    -- Step 6: Recall saved register (MR)
    --------------------------------------------------------------------------
    s_mr <= '1';
    wait for period;
    s_mr <= '0';
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

