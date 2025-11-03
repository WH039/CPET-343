-------------------------------------------------------------------------------
-- Dr. Kaputa
-- memory 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      
use ieee.numeric_std.all;

entity memory is 
  generic (addr_width : integer := 2;
           data_width : integer := 4);
  port (
    CLK               : in std_logic;
    RST               : in std_logic;
    WE                : in std_logic;
    STATE             : in std_logic_vector(4 downto 0);
    ADDR              : in std_logic_vector(addr_width - 1 downto 0);
    DIN               : in std_logic_vector(data_width - 1 downto 0);
    DOUT              : out std_logic_vector(data_width - 1 downto 0)
  );
end memory;

architecture beh of memory is
    -- constant address declarations
    constant C_WORK_ADDR : std_logic_vector(addr_width-1 downto 0) := (others => '0');
    constant C_SAVE_ADDR : std_logic_vector(addr_width-1 downto 0) := std_logic_vector(to_unsigned(1, addr_width));

    -- signal declarations
    type ram_type is array ((2 ** addr_width -1) downto 0) of std_logic_vector(data_width -1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));

begin 

process(CLK, RST)
begin
  if RST = '0' then
    RAM(to_integer(unsigned(ADDR))) <= (others => '0');
  elsif (CLK'event and CLK = '1') then
    if (WE = '1') then
      RAM(to_integer(unsigned(ADDR))) <= DIN;
    end if;
    if STATE = b"10000" then --Read Save register to Working Register
      RAM(to_integer(unsigned(C_WORK_ADDR))) <= RAM(to_integer(unsigned(C_SAVE_ADDR)));
    end if;
    if STATE = b"01000" then -- Save Working Register to Save Register
      RAM(to_integer(unsigned(C_SAVE_ADDR))) <= RAM(to_integer(unsigned(C_WORK_ADDR)));
    end if;
    DOUT <= RAM(to_integer(unsigned(C_WORK_ADDR)));
  end if;
end process;

end beh; 