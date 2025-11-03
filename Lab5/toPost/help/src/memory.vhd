--------------------------------
-- Kohl Carpenter            --
-- memory.vhd               --
-- 4x8 memory for calculator --
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        addr    : in std_logic_vector(1 downto 0);
        data_in : in std_logic_vector(7 downto 0);
        wr_en   : in std_logic;
        data_out : out std_logic_vector(7 downto 0)
    );
end entity memory;

architecture behavioral of memory is
    type mem_array is array (0 to 3) of std_logic_vector(7 downto 0);
    signal memory_reg : mem_array;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- Initialize all memory locations to zero
            memory_reg <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if wr_en = '1' then
                -- Write to specified address
                memory_reg(to_integer(unsigned(addr))) <= data_in;
            end if;
        end if;
    end process;
    
    -- Read from memory (asynchronous read)
    data_out <= memory_reg(to_integer(unsigned(addr)));
end architecture behavioral;