-------------------------------------------------------------------------------
-- Weicheng Huang
-- Calculator FSM and control logic
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
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
end calculator;

architecture beh of calculator is

  -- State type definition
  type state_type is (IDLE, EXECUTE_OP, MEMORY_SAVE, MEMORY_RECALL);
  signal current_state, next_state : state_type;
  
  -- Internal signals
  signal working_reg      : std_logic_vector(7 downto 0);
  signal memory_we        : std_logic;
  signal memory_addr      : std_logic_vector(1 downto 0);
  signal memory_din       : std_logic_vector(7 downto 0);
  signal memory_dout      : std_logic_vector(7 downto 0);
  signal alu_result       : std_logic_vector(7 downto 0);
  signal alu_a            : std_logic_vector(7 downto 0);
  signal alu_b            : std_logic_vector(7 downto 0);
  signal execute_edge     : std_logic;
  signal ms_edge          : std_logic;
  signal mr_edge          : std_logic;
  
  -- Component declarations
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
  
  component rising_edge_synchronizer is 
    port (
      clk               : in std_logic;
      reset             : in std_logic;
      input             : in std_logic;
      edge              : out std_logic
    );
  end component;

begin

  -- Edge detectors for push buttons
  execute_edge_detector: rising_edge_synchronizer
    port map (
      clk     => clk,
      reset   => reset,
      input   => execute,
      edge    => execute_edge
    );
    
  ms_edge_detector: rising_edge_synchronizer
    port map (
      clk     => clk,
      reset   => reset,
      input   => ms,
      edge    => ms_edge
    );
    
  mr_edge_detector: rising_edge_synchronizer
    port map (
      clk     => clk,
      reset   => reset,
      input   => mr,
      edge    => mr_edge
    );
    
  -- ALU instance
  alu_inst: alu
    port map (
      clk     => clk,
      reset   => reset,
      a       => alu_a,
      b       => alu_b,
      op      => op_code,
      result  => alu_result
    );
    
  -- Memory instance (2x8 memory)
  memory_inst: memory
    generic map (
      addr_width => 2,
      data_width => 8
    )
    port map (
      clk     => clk,
      we      => memory_we,
      addr    => memory_addr,
      din     => memory_din,
      dout    => memory_dout
    );
    
  -- State register
  state_register: process(clk, reset)
  begin
    if reset = '1' then
      current_state <= IDLE;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;
  
  -- Next state logic
  next_state_logic: process(current_state, execute_edge, ms_edge, mr_edge)
  begin
    next_state <= current_state;
    
    case current_state is
      when IDLE =>
        if execute_edge = '1' then
          next_state <= EXECUTE_OP;
        elsif ms_edge = '1' then
          next_state <= MEMORY_SAVE;
        elsif mr_edge = '1' then
          next_state <= MEMORY_RECALL;
        end if;
        
      when EXECUTE_OP =>
        next_state <= IDLE;
        
      when MEMORY_SAVE =>
        next_state <= IDLE;
        
      when MEMORY_RECALL =>
        next_state <= IDLE;
        
      when others =>
        next_state <= IDLE;
    end case;
  end process;
  
  -- Output logic and datapath control
  datapath_control: process(clk, reset)
  begin
    if reset = '1' then
      working_reg <= (others => '0');
      memory_we <= '0';
      memory_addr <= "00";
      memory_din <= (others => '0');
      alu_a <= (others => '0');
      alu_b <= (others => '0');
    elsif rising_edge(clk) then
      -- Default values
      memory_we <= '0';
      memory_addr <= "00"; -- Default to working register address
      
      case current_state is
        when IDLE =>
          -- Read working register from memory
          memory_addr <= "00";
          
        when EXECUTE_OP =>
          -- Perform ALU operation
          alu_a <= working_reg;           -- First operand from working register
          alu_b <= switch_input;          -- Second operand from switches
          working_reg <= alu_result;      -- Update working register with result
          
        when MEMORY_SAVE =>
          -- Save working register to save register (address 01)
          memory_we <= '1';
          memory_addr <= "01";
          memory_din <= working_reg;
          
        when MEMORY_RECALL =>
          -- Load save register into working register
          memory_addr <= "01";            -- Read from save register
          working_reg <= memory_dout;     -- Update working register
          
        when others =>
          null;
      end case;
      
      -- Always read working register when not writing
      if memory_we = '0' and memory_addr = "00" then
        working_reg <= memory_dout;
      end if;
    end if;
  end process;
  
  -- Output assignments
  working_reg_out <= working_reg;
  
  -- State indication on LEDs
  with current_state select
    state_leds <= 
      "0001" when IDLE,
      "0010" when EXECUTE_OP,
      "0100" when MEMORY_SAVE,
      "1000" when MEMORY_RECALL,
      "0000" when others;

end beh;