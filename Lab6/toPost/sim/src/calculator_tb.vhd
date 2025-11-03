-------------------------------------------------------------------------------
-- Testbench for 8-bit Calculator
-- Tests: Multiply 4x8, Save to Memory, Subtract 8, Divide by 2, 
--        Load from Memory, Divide by 2
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator_tb is
end calculator_tb;

architecture tb of calculator_tb is

    -- Constants
    constant CLK_PERIOD : time := 20 ns; -- 50 MHz clock

    -- Signals
    signal clk         : std_logic := '0';
    signal reset_n     : std_logic := '1';
    signal execute     : std_logic := '0';
    signal ms          : std_logic := '0';
    signal mr          : std_logic := '0';
    signal switch      : std_logic_vector(7 downto 0) := (others => '0');
    signal op          : std_logic_vector(1 downto 0) := (others => '0');
    signal led         : std_logic_vector(3 downto 0);
    signal bcd_0       : std_logic_vector(6 downto 0);
    signal bcd_1       : std_logic_vector(6 downto 0);
    signal bcd_2       : std_logic_vector(6 downto 0);

    -- Component declaration
    component top is
        port (
            clk         : in  std_logic;
            reset_n     : in  std_logic;
            execute     : in  std_logic;
            ms          : in  std_logic;
            mr          : in  std_logic;
            switch      : in  std_logic_vector(7 downto 0);
            op          : in  std_logic_vector(1 downto 0);
            led         : out std_logic_vector(3 downto 0);
            bcd_0       : out std_logic_vector(6 downto 0);
            bcd_1       : out std_logic_vector(6 downto 0);
            bcd_2       : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Function to convert 7-segment to integer
    function seg_to_int(seg : std_logic_vector(6 downto 0)) return integer is
    begin
        case seg is
            when "1000000" => return 0; -- 0
            when "1111001" => return 1; -- 1
            when "0100100" => return 2; -- 2
            when "0110000" => return 3; -- 3
            when "0011001" => return 4; -- 4
            when "0010010" => return 5; -- 5
            when "0000010" => return 6; -- 6
            when "1111000" => return 7; -- 7
            when "0000000" => return 8; -- 8
            when "0011000" => return 9; -- 9
            when others    => return -1; -- invalid
        end case;
    end function;

    -- Function to get displayed value from 7-segments
    function get_display_value(hundreds_seg, tens_seg, ones_seg : std_logic_vector(6 downto 0)) return integer is
        variable hundreds, tens, ones : integer;
    begin
        hundreds := seg_to_int(hundreds_seg);
        tens := seg_to_int(tens_seg);
        ones := seg_to_int(ones_seg);
        
        if hundreds = -1 or tens = -1 or ones = -1 then
            return -1;
        else
            return (hundreds * 100) + (tens * 10) + ones;
        end if;
    end function;

begin

    -- Clock generation
    clk <= not clk after CLK_PERIOD/2;

    -- Device Under Test instantiation
    dut: top
        port map (
            clk         => clk,
            reset_n     => reset_n,
            execute     => execute,
            ms          => ms,
            mr          => mr,
            switch      => switch,
            op          => op,
            led         => led,
            bcd_0       => bcd_0,
            bcd_1       => bcd_1,
            bcd_2       => bcd_2
        );

    -- Test process
    test_sequence: process
        variable display_value : integer;
    begin
        -- Initialize
        report "Starting Calculator Testbench";
        reset_n <= '0';
        wait for CLK_PERIOD * 2;
        reset_n <= '1';
        wait for CLK_PERIOD * 2;

        -- Test 1: Multiply 4 by 8
        report "Test 1: Multiply 4 by 8";
        -- Set switches to 4 (first operand should be 0 initially)
        switch <= std_logic_vector(to_unsigned(4, 8));
        -- Set operation to multiply
        op <= "10";
        wait for CLK_PERIOD;
        
        -- Press execute to perform multiplication (0 * 4 = 0)
        execute <= '1';
        wait for CLK_PERIOD;
        execute <= '0';
        wait for CLK_PERIOD * 5;
        
        -- Now set switches to 8 and multiply again
        switch <= std_logic_vector(to_unsigned(8, 8));
        wait for CLK_PERIOD;
        
        execute <= '1';
        wait for CLK_PERIOD;
        execute <= '0';
        wait for CLK_PERIOD * 5;
        
        display_value := get_display_value(bcd_2, bcd_1, bcd_0);
        report "4 * 8 = " & integer'image(display_value);
        assert display_value = 32 report "Multiplication failed! Expected 32" severity error;

        -- Test 2: Save result to memory
        report "Test 2: Save result (32) to memory";
        ms <= '1';
        wait for CLK_PERIOD;
        ms <= '0';
        wait for CLK_PERIOD * 5;

        -- Test 3: Subtract 8
        report "Test 3: Subtract 8 from current value";
        switch <= std_logic_vector(to_unsigned(8, 8));
        op <= "01"; -- Subtraction
        wait for CLK_PERIOD;
        
        execute <= '1';
        wait for CLK_PERIOD;
        execute <= '0';
        wait for CLK_PERIOD * 5;
        
        display_value := get_display_value(bcd_2, bcd_1, bcd_0);
        report "32 - 8 = " & integer'image(display_value);
        assert display_value = 24 report "Subtraction failed! Expected 24" severity error;

        -- Test 4: Divide by 2
        report "Test 4: Divide 24 by 2";
        switch <= std_logic_vector(to_unsigned(2, 8));
        op <= "11"; -- Division
        wait for CLK_PERIOD;
        
        execute <= '1';
        wait for CLK_PERIOD;
        execute <= '0';
        wait for CLK_PERIOD * 5;
        
        display_value := get_display_value(bcd_2, bcd_1, bcd_0);
        report "24 / 2 = " & integer'image(display_value);
        assert display_value = 12 report "Division failed! Expected 12" severity error;

        -- Test 5: Load saved value from memory (32)
        report "Test 5: Load saved value (32) from memory";
        mr <= '1';
        wait for CLK_PERIOD;
        mr <= '0';
        wait for CLK_PERIOD * 5;
        
        display_value := get_display_value(bcd_2, bcd_1, bcd_0);
        report "Loaded from memory: " & integer'image(display_value);
        assert display_value = 32 report "Memory recall failed! Expected 32" severity error;

        -- Test 6: Divide loaded value by 2
        report "Test 6: Divide loaded value (32) by 2";
        switch <= std_logic_vector(to_unsigned(2, 8));
        op <= "11"; -- Division
        wait for CLK_PERIOD;
        
        execute <= '1';
        wait for CLK_PERIOD;
        execute <= '0';
        wait for CLK_PERIOD * 5;
        
        display_value := get_display_value(bcd_2, bcd_1, bcd_0);
        report "32 / 2 = " & integer'image(display_value);
        assert display_value = 16 report "Final division failed! Expected 16" severity error;

        -- Final summary
        report "All tests completed!";
        if display_value = 16 then
            report "TEST PASSED: All operations working correctly!" severity note;
        else
            report "TEST FAILED: Final result incorrect!" severity error;
        end if;

        wait for CLK_PERIOD * 10;
        report "Simulation finished" severity failure;
        
    end process test_sequence;

    -- Monitor process to display state changes
    monitor: process
    begin
        wait for CLK_PERIOD;
        case led is
            when "0001" => report "State: IDLE" severity note;
            when "0010" => report "State: EXECUTE_OP" severity note;
            when "0100" => report "State: MEMORY_SAVE" severity note;
            when "1000" => report "State: MEMORY_RECALL" severity note;
            when others => null;
        end case;
    end process monitor;

end tb;