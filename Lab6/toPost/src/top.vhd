library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity top is
  port (
    clk       : in std_logic;
    reset_n   : in std_logic;
    execute   : in std_logic;
    ms        : in std_logic;
    mr        : in std_logic;
    switch    : in std_logic_vector(7 downto 0);
    op        : in std_logic_vector(1 downto 0);
    led       : out std_logic_vector(3 downto 0);
    bcd_0     : out std_logic_vector(6 downto 0);
    bcd_1     : out std_logic_vector(6 downto 0);
    bcd_2     : out std_logic_vector(6 downto 0)
  );
end top;

architecture struc of top is
  signal reset          : std_logic;
  signal sync_execute   : std_logic;
  signal sync_ms        : std_logic;
  signal sync_mr        : std_logic;
  signal sync_switch    : std_logic_vector(7 downto 0);
  signal sync_op        : std_logic_vector(1 downto 0);
  signal calc_result    : std_logic_vector(7 downto 0);
  signal state_led      : std_logic_vector(3 downto 0);
  signal ones           : std_logic_vector(3 downto 0);
  signal tens           : std_logic_vector(3 downto 0);
  signal hundreds       : std_logic_vector(3 downto 0);
  signal result_padded  : std_logic_vector(11 downto 0);
  
  -- Component declaration for seven_segment
  component seven_segment
    port (
      bcd : in std_logic_vector(3 downto 0);
      seg : out std_logic_vector(6 downto 0)
    );
  end component;
  
begin
  reset <= not reset_n;  -- Active high reset
  
  -- Button synchronizers
  sync_execute_inst: rising_edge_synchronizer
    port map (
      clk => clk,
      reset => reset,
      input => execute,
      edge => sync_execute
    );
    
  sync_ms_inst: rising_edge_synchronizer
    port map (
      clk => clk,
      reset => reset,
      input => ms,
      edge => sync_ms
    );
    
  sync_mr_inst: rising_edge_synchronizer
    port map (
      clk => clk,
      reset => reset,
      input => mr,
      edge => sync_mr
    );
  
  -- Switch synchronizers
  sync_switch_inst: synchronizer_8bit
    port map (
      clk => clk,
      reset => reset,
      async_in => switch,
      sync_out => sync_switch
    );
  
  -- Operation synchronizer (2-bit)
  sync_op_proc: process(clk, reset)
  begin
    if reset = '1' then
      sync_op <= "00";
    elsif rising_edge(clk) then
      sync_op <= op;
    end if;
  end process;
  
  -- Calculator core
  calc_inst: calculator
    port map (
      clk => clk,
      reset => reset,
      execute => sync_execute,
      ms => sync_ms,
      mr => sync_mr,
      switch => sync_switch,
      op => sync_op,
      result => calc_result,
      state_led => state_led
    );
  
  -- Binary to BCD conversion
  result_padded <= "0000" & calc_result;
  
  bcd_conv: double_dabble
    port map (
      result_padded => result_padded,
      ones => ones,
      tens => tens,
      hundreds => hundreds
    );
  
  -- Individual seven segment displays for each digit
  -- HEX_0: Ones place
  seg_ones: seven_segment
    port map (
      bcd => ones,
      seg => bcd_0
    );
  
  -- HEX_1: Tens place  
  seg_tens: seven_segment
    port map (
      bcd => tens,
      seg => bcd_1
    );
  
  -- HEX_2: Hundreds place
  seg_hundreds: seven_segment
    port map (
      bcd => hundreds,
      seg => bcd_2
    );
  
  -- LED outputs for state indication
  led <= state_led;
  
end struc;