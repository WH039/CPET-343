-------------------------------------------------------------------------------
-- Weicheng Huang
-- single bit full adder [behavioral]
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;     
use ieee.numeric_std.all;      

entity full_adder_single_bit_beh is 
  port (
    a       : in std_logic;
    b       : in std_logic;
    cin     : in std_logic;
    sum     : out std_logic;
    cout    : out std_logic
  );
end full_adder_single_bit_beh;

architecture beh of full_adder_single_bit_beh is

signal x   : std_logic;
signal y   : std_logic;

begin
  process_xy : process(a, b)
  begin
    x <= a;
    y <= b;
  end process_xy

  sum <= (x xor b) xor cin;
  cout <= (x and y) or (x and cin) or (y and cin);

end beh; 