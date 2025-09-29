------------------------------
-- Weicheng Huang           --
-- rising edge synchronizer --
------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_synchronizer is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        input   : in std_logic;
        output  : out std_logic
    );
end entity rising_edge_synchronizer;

architecture behavioral of rising_edge_synchronizer is
    signal input_sync : std_logic;
    signal input_prev : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            input_sync <= '0';
            input_prev <= '0';
        elsif rising_edge(clk) then
            input_sync <= input;
            input_prev <= input_sync;
        end if;
    end process;
    
    output <= input_sync and not input_prev;
end architecture behavioral;
