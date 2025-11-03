--------------------------------
-- Kohl Carpenter            --
-- memory.vhd               --
-- 4x8 memory for calculator --
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic (addr_width : integer := 2;
             data_width : integer := 4);
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        wr_en   : in std_logic;
        state   : in std_logic_vector(data_width downto 0);
        addr    : in std_logic_vector(addr_width - 1 downto 0);
        data_in : in std_logic_vector(data_width - 1 downto 0);
        data_out : out std_logic_vector(data_width -1 downto 0)
    );
end entity memory;

architecture behavioral of memory is
    constant C_WORK_ADDR : std_logic_vector(addr_width-1 downto 0) := (others => '0');
    constant C_SAVE_ADDR : std_logic_vector(addr_width-1 downto 0) := std_logic_vector(to_unsigned(1, addr_width));


    type mem_array is array ((2 ** addr_width - 1) downto 0) of std_logic_vector(data_width downto 0);
    signal memory_reg : mem_array := (others => (others => '0'));

begin
    process(clk, reset)
    begin
        if reset = '0' then
            -- Initialize all memory locations to zero
            memory_reg(to_integer(unsigned(addr))) <= (others => '0');
        elsif (clk'event and clk = '1') then
            if wr_en = '1' then
                -- Write to specified address
                memory_reg(to_integer(unsigned(addr))) <= data_in;
            end if;
            if state = b"10000" then
                memory_reg(to_integer(unsigned(C_WORK_ADDR))) <= memory_reg(to_integer(unsigned(C_SAVE_ADDR)));
            end if;
            if state = b"10000" then
                memory_reg(to_integer(unsigned(C_WORK_ADDR))) <= memory_reg(to_integer(unsigned(C_SAVE_ADDR)));
            end if;
        end if;
    end process;
    
    -- Read from memory (asynchronous read)
    data_out <= memory_reg(to_integer(unsigned(addr)));
end architecture behavioral;