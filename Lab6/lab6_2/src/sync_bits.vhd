-------------------------------------------------------------------------------
-- Jacob Kraft
-- Synchronize port signals
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;   
use ieee.numeric_std.all;   

entity sync_bits is
    generic (
        bits : integer
      );
    port (
        CLK       : in std_logic; --! Clock
        RESET     : in std_logic; --! Reset 
        INPUT     : in std_logic_vector(bits-1 downto 0); --! Input 
        SYNC      : out std_logic_vector(bits-1 downto 0) --! Synchronized output
    );
end sync_bits;

architecture beh of sync_bits is
-- signal declarations
signal input_z     : std_logic_vector(bits-1 downto 0);
signal input_zz    : std_logic_vector(bits-1 downto 0);

begin 

synchronizer: process(RESET,CLK)
  begin
    if RESET = '0' then
      input_z  <= (others => '0');
      input_z(0) <= '1';
      input_zz <= (others => '0');
      input_zz(0) <= '1';
    elsif rising_edge(CLK) then
      input_z   <= INPUT;
      input_zz  <= input_z;
    end if;
end process;

SYNC <= input_zz;

end beh;