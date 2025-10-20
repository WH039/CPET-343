------------------------------
-- Weicheng Huang            
-- components of the lab
------------------------------
library ieee;
use ieee.std_logic_1164.all;

package components is
  component rising_edge_synchronizer
    port (
      clk     : in std_logic;
      reset   : in std_logic;
      input   : in std_logic;
      edge    : out std_logic
    );
  end component;
  
  component synchronizer_8bit
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      async_in  : in std_logic_vector(7 downto 0);
      sync_out  : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component alu
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      a         : in std_logic_vector(7 downto 0);
      b         : in std_logic_vector(7 downto 0);
      op        : in std_logic_vector(1 downto 0);
      result    : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component memory
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      address   : in std_logic_vector(1 downto 0);
      data_in   : in std_logic_vector(7 downto 0);
      write_en  : in std_logic;
      data_out  : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component double_dabble
    port (
      result_padded : in std_logic_vector(11 downto 0);
      ones          : out std_logic_vector(3 downto 0);
      tens          : out std_logic_vector(3 downto 0);
      hundreds      : out std_logic_vector(3 downto 0)
    );
  end component;
  
  component seven_segment
    port (
      bcd : in std_logic_vector(3 downto 0);
      seg : out std_logic_vector(6 downto 0)
    );
  end component;
  
  component calculator
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      execute   : in std_logic;
      ms        : in std_logic;
      mr        : in std_logic;
      switch    : in std_logic_vector(7 downto 0);
      op        : in std_logic_vector(1 downto 0);
      result    : out std_logic_vector(7 downto 0);
      state_led : out std_logic_vector(3 downto 0)
    );
  end component;
end package;