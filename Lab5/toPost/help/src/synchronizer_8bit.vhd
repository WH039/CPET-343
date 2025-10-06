------------------------------
--Weicheng Huang            --
--syncrhonizer_3bit.vhd     --
------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity synchronizer_8bit is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        async_in : in std_logic_vector(7 downto 0);
        sync_out : out std_logic_vector(7 downto 0)
    );
end entity synchronizer_8bit;

architecture behavioral of synchronizer_8bit is
    signal sync_reg : std_logic_vector(7 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            sync_reg <= (others => '0');
        elsif rising_edge(clk) then
            sync_reg <= async_in;
        end if;
    end process;
    
    sync_out <= sync_reg;
end behavioral;