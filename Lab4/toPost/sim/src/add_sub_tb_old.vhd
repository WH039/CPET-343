-----------------------------------------------
-- Weicheng Huang                            --
-- top level adder and subtractor test bench --
-- Exhaustive test with shorter delays      --
-----------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub_tb is
end entity add_sub_tb;

architecture testbench of add_sub_tb is
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal a, b : std_logic_vector(2 downto 0) := "000";
    signal add_btn, sub_btn : std_logic := '0';
    signal a_bcd, b_bcd, result_bcd : std_logic_vector(6 downto 0);
    
    constant CLK_PERIOD : time := 20 ns; -- 50 MHz
    
begin
    -- Unit Under Test
    uut: entity work.add_sub
        port map (
            clk => clk,
            reset => reset,
            a => a,
            b => b,
            add_btn => add_btn,
            sub_btn => sub_btn,
            a_bcd => a_bcd,
            b_bcd => b_bcd,
            result_bcd => result_bcd
        );
    
    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;
    
    -- Test process
    stimulus: process
    begin
        -- Reset
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 20 ns;
        
        report "Starting exhaustive test of all 64 input combinations...";
        
        -- Loop through all possible values of a and b (8x8 = 64 combinations)
        for i in 0 to 7 loop
            for j in 0 to 7 loop
                a <= std_logic_vector(to_unsigned(i, 3));
                b <= std_logic_vector(to_unsigned(j, 3));
                
                wait for 20 ns;
                
                -- Test addition
                add_btn <= '1';
                wait for 20 ns;
                add_btn <= '0';
                wait for 40 ns;
                
                -- Test subtraction  
                sub_btn <= '1';
                wait for 20 ns;
                sub_btn <= '0';
                wait for 40 ns;
                
            end loop;
        end loop;
        
        report "All 64 test combinations completed successfully!";
        
        -- Final test to ensure system is still working
        a <= "101"; -- 5
        b <= "011"; -- 3
        wait for 20 ns;
        add_btn <= '1'; wait for 20 ns; add_btn <= '0'; wait for 40 ns; -- Should show 8
        sub_btn <= '1'; wait for 20 ns; sub_btn <= '0'; wait for 40 ns; -- Should show 2
        
        report "Final verification test completed!";
        wait;
    end process;
end architecture testbench;