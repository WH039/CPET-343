-------------------------------------------------------------------------------
-- Weicheng Huang
-- Top level entity for calculator
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  port (
    clk         : in  std_logic;
    reset_n     : in  std_logic;
    execute     : in  std_logic;
    ms          : in  std_logic;
    mr          : in  std_logic;
    switch      : in  std_logic_vector(7 downto 0);
    op          : in  std_logic_vector(1 downto 0);
    led         : out std_logic_vector(3 downto 0);
    bcd_0       : out std_logic_vector(6 downto 0);
    bcd_1       : out std_logic_vector(6 downto 0);
    bcd_2       : out std_logic_vector(6 downto 0)
  );
end top;

architecture structural of top is

  -- Internal signals
  signal reset              : std_logic;
  signal working_reg        : std_logic_vector(7 downto 0);
  signal sync_switches      : std_logic_vector(7 downto 0);
  signal sync_op            : std_logic_vector(1 downto 0);
  signal bcd_ones           : std_logic_vector(3 downto 0);
  signal bcd_tens           : std_logic_vector(3 downto 0);
  signal bcd_hundreds       : std_logic_vector(3 downto 0);
  signal result_padded      : std_logic_vector(11 downto 0);
  
  -- Component declarations
  component calculator is
    port (
      clk               : in  std_logic;
      reset             : in  std_logic;
      execute           : in  std_logic;
      ms                : in  std_logic;
      mr                : in  std_logic;
      switch_input      : in  std_logic_vector(7 downto 0);
      op_code           : in  std_logic_vector(1 downto 0);
      working_reg_out   : out std_logic_vector(7 downto 0);
      state_leds        : out std_logic_vector(3 downto 0)
    );
  end component;
  
  component synchronizer_8bit is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      async_in  : in std_logic_vector(7 downto 0);
      sync_out  : out std_logic_vector(7 downto 0)
    );
  end component;
  
  component double_dabble is
    port (
      result_padded   : in  std_logic_vector(11 downto 0);
      ones            : out std_logic_vector(3 downto 0);
      tens            : out std_logic_vector(3 downto 0);
      hundreds        : out std_logic_vector(3 downto 0)
    );
  end component;
  
  component seven_segment is
    port (
      bcd     : in std_logic_vector(3 downto 0);
      seg     : out std_logic_vector(6 downto 0)
    );
  end component;

begin

  -- Reset inversion (pushbutton is active low)
  reset <= not reset_n;
  
  -- Switch input synchronization
  switch_synchronizer: synchronizer_8bit
    port map (
      clk       => clk,
      reset     => reset,
      async_in  => switch,
      sync_out  => sync_switches
    );
    
  -- Operation code synchronization (using 8-bit synchronizer for 2 bits)
  op_synchronizer: synchronizer_8bit
    port map (
      clk       => clk,
      reset     => reset,
      async_in  => "000000" & op,
      sync_out  => sync_op(1 downto 0)  -- Only use the first 2 bits
    );
  
  -- Calculator core
  calculator_inst: calculator
    port map (
      clk             => clk,
      reset           => reset,
      execute         => execute,
      ms              => ms,
      mr              => mr,
      switch_input    => sync_switches,
      op_code         => sync_op(1 downto 0),
      working_reg_out => working_reg,
      state_leds      => led
    );
  
  -- Convert working register to BCD for display
  result_padded <= "0000" & working_reg;  -- Pad to 12 bits for double dabble
  
  -- BCD conversion
  bcd_converter: double_dabble
    port map (
      result_padded   => result_padded,
      ones            => bcd_ones,
      tens            => bcd_tens,
      hundreds        => bcd_hundreds
    );
  
  -- Seven segment displays
  seg_ones: seven_segment
    port map (
      bcd     => bcd_ones,
      seg     => bcd_0
    );
    
  seg_tens: seven_segment
    port map (
      bcd     => bcd_tens,
      seg     => bcd_1
    );
    
  seg_hundreds: seven_segment
    port map (
      bcd     => bcd_hundreds,
      seg     => bcd_2
    );

end structural;