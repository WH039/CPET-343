-------------------------------------------------------------------------------
-- Weicheng Huang
-- single bit full adder test bench
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;      -- gives you the std_logic type

entity full_adder_single_bit_beh_tb is 
end full_adder_single_bit_beh_tb;

architecture arch of full_adder_single_bit_beh_tb is

signal x    : std_logic := '0'; 
signal y    : std_logic := '0'; 
signal cin  : std_logic := '0';
signal sum  : std_logic;
signal cout : std_logic;

begin 
  uut: entity work.full_adder_single_bit_beh 
    port map(
      a     => x,
      b     => y,
      cin   => cin,
      sum   => sum,
      cout  => cout
    );
    
  x <= not x after 10 ns;
  y <= not y after 20 ns;
  cin <= not cin after 40 ns;
end arch;