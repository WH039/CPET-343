------------------------------
-- Weicheng Huang            
-- memory storage
------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  port (
    clk       : in std_logic;
    reset     : in std_logic;
    address   : in std_logic_vector(1 downto 0);
    data_in   : in std_logic_vector(7 downto 0);
    write_en  : in std_logic;
    data_out  : out std_logic_vector(7 downto 0)
  );
end memory;

architecture beh of memory is
  type mem_array is array (0 to 3) of std_logic_vector(7 downto 0);
  signal memory : mem_array;
begin
  process(clk, reset)
  begin
    if reset = '1' then
      memory <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if write_en = '1' then
        memory(to_integer(unsigned(address))) <= data_in;
      end if;
    end if;
  end process;
  
  data_out <= memory(to_integer(unsigned(address)));
end beh;