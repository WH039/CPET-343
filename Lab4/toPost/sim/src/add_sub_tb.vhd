-----------------------------------------------
-- Weicheng Huang                            --
-- top level adder and subtractor test bench --
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
        
        -- Test addition: 3 + 2 = 5
        a <= "011"; -- 3
        b <= "010"; -- 2
        wait for 40 ns;
        add_btn <= '1';
        wait for 40 ns;
        add_btn <= '0';
        wait for 100 ns;
        
        -- Test subtraction: 3 - 2 = 1
        sub_btn <= '1';
        wait for 40 ns;
        sub_btn <= '0';
        wait for 100 ns;
        
        -- Test wrap-around: 1 - 2 = 15 (0xF)
        a <= "001"; -- 1
        b <= "010"; -- 2
        wait for 40 ns;
        sub_btn <= '1';
        wait for 40 ns;
        sub_btn <= '0';
        wait for 100 ns;
        
        -- Test maximum values: 7 + 7 = 14 (0xE)
        a <= "111"; -- 7
        b <= "111"; -- 7
        wait for 40 ns;
        add_btn <= '1';
        wait for 40 ns;
        add_btn <= '0';
        wait for 100 ns;
        
        wait;
    end process;
end architecture testbench;