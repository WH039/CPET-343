--------------------------------------------
-- Weicheng Huang            
-- add, sub, multiply, divide calculator
--------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
  port (
    clk         : in std_logic;
    reset       : in std_logic;
    execute     : in std_logic;
    ms          : in std_logic;
    mr          : in std_logic;
    switch      : in std_logic_vector(7 downto 0);
    op          : in std_logic_vector(1 downto 0);
    result      : out std_logic_vector(7 downto 0);
    state_led   : out std_logic_vector(3 downto 0)
  );
end calculator;

architecture beh of calculator is
  type state_type is (IDLE, EXECUTE_OP, MS_SAVE, MR_LOAD);
  signal current_state : state_type;
  
  signal mem_write_en  : std_logic;
  signal mem_address   : std_logic_vector(1 downto 0);
  signal mem_data_in   : std_logic_vector(7 downto 0);
  signal mem_data_out  : std_logic_vector(7 downto 0);
  signal alu_result    : std_logic_vector(7 downto 0);
  
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

begin
  -- Memory instance (00=working reg, 01=save reg)
  mem_inst: memory
    port map (
      clk => clk,
      reset => reset,
      address => mem_address,
      data_in => mem_data_in,
      write_en => mem_write_en,
      data_out => mem_data_out
    );
  
  -- ALU instance
  alu_inst: alu
    port map (
      clk => clk,
      reset => reset,
      a => mem_data_out,  -- from working register
      b => switch,        -- from switches
      op => op,
      result => alu_result
    );
  
  -- State machine process
  process(clk, reset)
  begin
    if reset = '1' then
      current_state <= IDLE;
      mem_write_en <= '0';
      mem_address <= "00";  -- working register
      state_led <= "0001";
    elsif rising_edge(clk) then
      mem_write_en <= '0';  -- default
      
      case current_state is
        when IDLE =>
          state_led <= "0001";
          if execute = '1' then
            current_state <= EXECUTE_OP;
          elsif ms = '1' then
            current_state <= MS_SAVE;
          elsif mr = '1' then
            current_state <= MR_LOAD;
          end if;
          
        when EXECUTE_OP =>
          state_led <= "0010";
          mem_address <= "00";  -- working register
          mem_data_in <= alu_result;
          mem_write_en <= '1';
          current_state <= IDLE;
          
        when MS_SAVE =>
          state_led <= "0100";
          mem_address <= "01";  -- save register
          mem_data_in <= mem_data_out;  -- current working reg value
          mem_write_en <= '1';
          current_state <= IDLE;
          
        when MR_LOAD =>
          state_led <= "1000";
          mem_address <= "00";  -- working register
          mem_data_in <= mem_data_out;  -- from save register (address 01)
          mem_write_en <= '1';
          current_state <= IDLE;
          
      end case;
    end if;
  end process;
  
  -- Output the working register value
  result <= mem_data_out when mem_address = "00" else (others => '0');
  
  -- Memory address control
  process(current_state)
  begin
    case current_state is
      when MR_LOAD =>
        mem_address <= "01";  -- read from save register
      when others =>
        mem_address <= "00";  -- read from working register
    end case;
  end process;
end beh;