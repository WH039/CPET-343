-------------------------------------------------------------------------------
-- Jacob Kraft
-- rising edge synchronizer
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      

entity rising_edge_synchronizer is 
  port (
    CLK               : in std_logic; --! Clock
    RESET             : in std_logic; --! Reset 
    INPUT             : in std_logic; --! Input 
    EDGE              : out std_logic --! Edge
  );
end rising_edge_synchronizer;

architecture beh of rising_edge_synchronizer is
-- signal declarations
signal input_z     : std_logic;
signal input_zz    : std_logic;
signal input_zzz   : std_logic;

begin 
synchronizer: process(RESET,CLK)
  begin
    if RESET = '0' then
      input_z     <= '1';
      input_zz    <= '1';
    elsif rising_edge(CLK) then
      input_z   <= INPUT;
      input_zz  <= input_z;
    end if;
end process;  

rising_edge_detector: process(RESET,CLK)
  begin
    if RESET = '0' then
      EDGE        <= '0';
      input_zzz   <= '1';
    elsif rising_edge(CLK) then
      input_zzz   <= input_zz;
      EDGE <= (input_zz xor input_zzz) and input_zz;
    end if;
end process;  
end beh; 