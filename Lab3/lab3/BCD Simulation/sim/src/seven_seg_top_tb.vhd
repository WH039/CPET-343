-------------------------------------------------------------------------------
-- Jacob Kraft
-- seven segment top test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_top_tb is
end seven_seg_top_tb;

architecture arch of seven_seg_top_tb is

signal output       : std_logic;
constant period     : time := 10ns;                                              
signal clk          : std_logic := '0';
signal reset        : std_logic := '1';
signal bcd          : std_logic_vector(3 downto 0) := "0000";

begin

    uut : entity work.seven_seg_top
    	generic map(
    		bits => 4,
    		max_count => 3
    	)
    	port map (
    		CLK => CLK,
    		RESET => RESET,
    		ADD => "0001",
    		seven_seg_out => open
        );


    -- bcd iteration
    sequential_tb : process 
        begin
          report "****************** sequential testbench start ****************";
          wait for 20 ns;   -- let all the initial conditions trickle through
          for i in 0 to 9 loop
            bcd <= std_logic_vector(unsigned(bcd) + 1 );
            wait for 20 ns;
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

end arch;
