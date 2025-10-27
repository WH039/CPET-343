-------------------------------------------------------------------------------
-- Weicheng Huang
-- Component declarations for calculator
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package components is
  
  -- ALU Component
  component alu is
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      a             : in  std_logic_vector(7 downto 0);
      b             : in  std_logic_vector(7 downto 0);
      op            : in  std_logic_vector(1 downto 0);
      result        : out std_logic_vector(7 downto 0)
    );
  end component;
  
  -- Memory Component
  component memory is 
    generic (
      addr_width : integer := 2;
      data_width : integer := 8
    );
    port (
      clk               : in std_logic;
      we                : in std_logic;
      addr              : in std_logic_vector(addr_width - 1 downto 0);
      din               : in std_logic_vector(data_width - 1 downto 0);
      dout              : out std_logic_vector(data_width - 1 downto 0)
    );
  end component;
  
  -- Rising Edge Synchronizer Component
  component rising_edge_synchronizer is 
    port (
      clk               : in std_logic;
      reset             : in std_logic;
      input             : in std_logic;
      edge              : out std_logic
    );
  end component;
  
  -- 8-bit Synchronizer Component
  component synchronizer_8bit is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      async_in  : in std_logic_vector(7 downto 0);
      sync_out  : out std_logic_vector(7 downto 0)
    );
  end component;
  
  -- Seven Segment Display Component
  component seven_segment is
    port (
      bcd     : in std_logic_vector(3 downto 0);
      seg     : out std_logic_vector(6 downto 0)
    );
  end component;
  
  -- Double Dabble BCD Converter Component
  component double_dabble is
    port (
      result_padded   : in  std_logic_vector(11 downto 0);
      ones            : out std_logic_vector(3 downto 0);
      tens            : out std_logic_vector(3 downto 0);
      hundreds        : out std_logic_vector(3 downto 0)
    );
  end component;

end package components;