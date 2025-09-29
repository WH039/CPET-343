-------------------------------------------------------------------------------
-- Jacob Kraft
-- Top level of basic Math Display
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity add_sub_tb is
end entity add_sub_tb;

architecture tb of add_sub_tb is

    constant period  : time := 10ns;
    signal clk     : std_logic := '0';
    signal reset     : std_logic := '1';
    signal add_btn : std_logic := '1';
    signal sub_btn : std_logic := '0';
    signal a       : std_logic_vector(2 downto 0) := "000";
    signal b       : std_logic_vector(2 downto 0) := "000";

begin

    uut : entity work.add_sub
    	generic map(
    		bits => 3
    	)
    	port map(
    		CLK => clk,
    		RESET => reset,
    		ADD_BTN => add_btn,
    		SUB_BTN => sub_btn,
    		A => a,
    		B => b,
    		A_BCD => open,
    		B_BCD => open,
    		result_bcd => open
        );

    -- a_bcd iteration
    sequential_a_tb : process 
        begin
          report "****************** sequential testbench start ****************";
          wait for 20 ns;   -- let all the initial conditions trickle through
          for i in 0 to 13 loop
            a <= std_logic_vector(unsigned(a) + 1 );
            wait for 20 ns;
          end loop;
          report "****************** sequential testbench stop ****************";
          wait;
      end process; 

    -- b_bcd iteration
    sequential_b_tb : process 
        begin
          report "****************** sequential testbench start ****************";
          wait for 20 ns;   -- let all the initial conditions trickle through
          for i in 0 to 25 loop
            b <= std_logic_vector(unsigned(b) + 1 );
            wait for 10 ns;
          end loop;
          report "****************** sequential testbench stop ****************";
          wait;
      end process; 
    
    -- clock process
    clock: process
      begin
        clk <= not clk;
        wait for period/2;
    end process; 
     
    -- reset process
    async_reset: process
      begin
        wait for 2 * period;
        reset <= '0';
        wait;
    end process; 

    -- button process
    button_proc : process
    begin
        add_btn <= not(add_btn);
        sub_btn <= not(sub_btn);
        wait for 120 ns;
    end process button_proc;


end tb;

