-------------------------------------------------------------------------------
-- Test Bench for Math Top
-- Sequence: 4 * 8 = 32 -> save to memory -> 32 / 2 = 16 -> 16 - 4 = 12 -> 
-- load memory (32) -> 32 + 2 = 34
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity math_top_tb2 is
end math_top_tb2;

architecture testbench of math_top_tb2 is

    -- Component Declaration
    component math_top is
        generic (
            bits : integer := 8
        );
        port (
            CLK              : in std_logic;
            RESET            : in std_logic;
            OPERATOR         : in std_logic_vector(1 downto 0);
            B_INPUT          : in std_logic_vector(7 downto 0);
            MS               : in std_logic;
            MR               : in std_logic;
            EXEC             : in std_logic;
            RESULT_HEX_ONE   : out std_logic_vector(6 downto 0);
            RESULT_HEX_TWO   : out std_logic_vector(6 downto 0);
            RESULT_HEX_THREE : out std_logic_vector(6 downto 0);
            STATE_LED        : out std_logic_vector(4 downto 0)
        );
    end component;

    -- Constants
    constant CLK_PERIOD : time := 10 ns;
    
    -- Operation codes
    constant OP_ADD  : std_logic_vector(1 downto 0) := "00";
    constant OP_SUB  : std_logic_vector(1 downto 0) := "01";
    constant OP_MULT : std_logic_vector(1 downto 0) := "10";
    constant OP_DIV  : std_logic_vector(1 downto 0) := "11";

    -- Signals
    signal clk              : std_logic := '0';
    signal reset            : std_logic := '0';
    signal operator         : std_logic_vector(1 downto 0) := (others => '0');
    signal b_input          : std_logic_vector(7 downto 0) := (others => '0');
    signal ms               : std_logic := '0';
    signal mr               : std_logic := '0';
    signal exec             : std_logic := '0';
    signal result_hex_one   : std_logic_vector(6 downto 0);
    signal result_hex_two   : std_logic_vector(6 downto 0);
    signal result_hex_three : std_logic_vector(6 downto 0);
    signal state_led        : std_logic_vector(4 downto 0);

    -- Test sequence state machine
    type test_state is (
        INIT,
        LOAD_A,              -- Load initial value 4 into working register
        MULTIPLY_BY_8,       -- 4 * 8 = 32
        SAVE_TO_MEMORY,      -- Save 32 to memory
        DIVIDE_BY_2,         -- 32 / 2 = 16
        SUBTRACT_4,          -- 16 - 4 = 12
        LOAD_FROM_MEMORY,    -- Load saved 32 from memory
        ADD_2,               -- 32 + 2 = 34
        DONE
    );
    
    signal current_test_state : test_state := INIT;
    signal test_step_counter : integer := 0;

begin

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Unit Under Test
    uut: math_top
        generic map (
            bits => 8
        )
        port map (
            CLK              => clk,
            RESET            => reset,
            OPERATOR         => operator,
            B_INPUT          => b_input,
            MS               => ms,
            MR               => mr,
            EXEC             => exec,
            RESULT_HEX_ONE   => result_hex_one,
            RESULT_HEX_TWO   => result_hex_two,
            RESULT_HEX_THREE => result_hex_three,
            STATE_LED        => state_led
        );

    -- Test process
    test_sequence: process
    begin
        -- Initialize
        reset <= '0';
        wait for CLK_PERIOD * 2;
        reset <= '1';
        wait for CLK_PERIOD * 2;
        
        -- Test sequence
        current_test_state <= LOAD_A;
        
        -- Step 1: Load initial value 4 into working register
        report "Step 1: Loading initial value 4 into working register";
        b_input <= std_logic_vector(to_unsigned(4, 8));
        operator <= OP_ADD;  -- Use ADD to load value (A + 0 effectively loads A)
        wait for CLK_PERIOD;
        exec <= '1';
        wait for CLK_PERIOD * 3;  -- Wait for execution
        exec <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= MULTIPLY_BY_8;
        
        -- Step 2: Multiply by 8 (4 * 8 = 32)
        report "Step 2: Multiplying 4 * 8 = 32";
        b_input <= std_logic_vector(to_unsigned(8, 8));
        operator <= OP_MULT;
        wait for CLK_PERIOD;
        exec <= '1';
        wait for CLK_PERIOD * 3;
        exec <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= SAVE_TO_MEMORY;
        
        -- Step 3: Save result (32) to memory using MS button
        report "Step 3: Saving result 32 to memory";
        ms <= '1';
        wait for CLK_PERIOD * 3;
        ms <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= DIVIDE_BY_2;
        
        -- Step 4: Divide by 2 (32 / 2 = 16)
        report "Step 4: Dividing 32 / 2 = 16";
        b_input <= std_logic_vector(to_unsigned(2, 8));
        operator <= OP_DIV;
        wait for CLK_PERIOD;
        exec <= '1';
        wait for CLK_PERIOD * 3;
        exec <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= SUBTRACT_4;
        
        -- Step 5: Subtract 4 (16 - 4 = 12)
        report "Step 5: Subtracting 16 - 4 = 12";
        b_input <= std_logic_vector(to_unsigned(4, 8));
        operator <= OP_SUB;
        wait for CLK_PERIOD;
        exec <= '1';
        wait for CLK_PERIOD * 3;
        exec <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= LOAD_FROM_MEMORY;
        
        -- Step 6: Load saved value (32) from memory using MR button
        report "Step 6: Loading saved value 32 from memory";
        mr <= '1';
        wait for CLK_PERIOD * 3;
        mr <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= ADD_2;
        
        -- Step 7: Add 2 to loaded value (32 + 2 = 34)
        report "Step 7: Adding 32 + 2 = 34";
        b_input <= std_logic_vector(to_unsigned(2, 8));
        operator <= OP_ADD;
        wait for CLK_PERIOD;
        exec <= '1';
        wait for CLK_PERIOD * 3;
        exec <= '0';
        wait for CLK_PERIOD * 2;
        
        current_test_state <= DONE;
        
        -- Final wait and report
        report "Test sequence completed successfully!";
        report "Expected final result: 34";
        wait for CLK_PERIOD * 10;
        
        -- End simulation
        assert false report "Simulation completed" severity note;
        wait;
    end process;

    -- Monitor process to display results
    monitor: process(clk)
        variable result_value : integer;
    begin
        if rising_edge(clk) then
            case current_test_state is
                when MULTIPLY_BY_8 =>
                    if state_led = "00100" then  -- WRITE_W state
                        -- Can't directly read internal signals, but we can monitor state changes
                        report "Multiplication operation completed";
                    end if;
                    
                when SAVE_TO_MEMORY =>
                    if state_led = "01000" then  -- WRITE_S state
                        report "Value saved to memory";
                    end if;
                    
                when LOAD_FROM_MEMORY =>
                    if state_led = "10000" then  -- HOLD/READ_S state
                        report "Value loaded from memory";
                    end if;
                    
                when DONE =>
                    report "Final operation completed - check seven segment displays for result 34";
                    
                when others =>
                    null;
            end case;
        end if;
    end process;

end testbench;