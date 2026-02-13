-------------------------------------------------------------------------------
-- Jacob Kraft
-- Scrap flexible address change CPU top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  generic (
    bits             : integer := 8
  );
  port (
    CLK              : in  std_logic; 
    RESET            : in  std_logic;
    EXEC             : in  std_logic;
    RESULT_HEX_ONE   : out std_logic_vector(6 downto 0);
    RESULT_HEX_TWO   : out std_logic_vector(6 downto 0);
    RESULT_HEX_THREE : out std_logic_vector(6 downto 0);
    STATE_LED        : out std_logic_vector(4 downto 0)
  );
end top;

architecture arch of top is

  signal s_state        : std_logic_vector(4 downto 0);      --! State Instantiation
  signal s_q_sig        : std_logic_vector(11 downto 0);
  signal s_exec_sync    : std_logic;
  signal s_data_out     : std_logic_vector(bits-1 downto 0);
  signal s_b_data       : std_logic_vector(7 downto 0);
  signal s_we           : std_logic;
  signal s_addr         : std_logic_vector(1 downto 0);
  signal s_pg_cnt       : std_logic_vector(4 downto 0) := "00001";

  ALIAS  A_INSTR        : std_logic_vector(7 downto 0) is s_q_sig(11 downto 4);
	ALIAS  OP_INSTR       : std_logic_vector(1 downto 0) is s_q_sig(3 downto 2);
	ALIAS  MR_INSTR       : std_logic is s_q_sig(1);
	ALIAS  MS_INSTR       : std_logic is s_q_sig(0);

  /*
  | STATE      | DETAILS
  | :----:     | :------:
  | IDLE       | IDLE state, wait 
  | READ       | READ state, uses after execute
  | ZERO       | RESET state? 
  */
  type ROM_CTRL_STM is (IDLE,READ_ST,ZERO_ST);

  signal cur_st : ROM_CTRL_STM;
  signal nxt_st : ROM_CTRL_STM;

begin

  STATE_LED <= s_state;

  /* Transition from current state to whatever next state is */
  state_transition : process(CLK, RESET)
  begin
      if RESET = '0' then
          cur_st <= IDLE;
      elsif rising_edge(CLK) then
          cur_st <= nxt_st;
      end if;
  end process state_transition;

  nxt_st_proc : process(all)
  begin
    if RESET = '0' then
      nxt_st <= IDLE;
    end if;
    case cur_st is
    when READ_ST =>
      nxt_st <= ZERO_ST;
    when ZERO_ST =>
      nxt_st <= IDLE;
    when others => --IDLE State 
      if s_exec_sync = '1' then
        nxt_st <= READ_ST;
      end if;
    end case;
  end process nxt_st_proc;

  pc_cnt : process(CLK, RESET)
  begin
    if RESET = '0' then
      s_pg_cnt <= (others => '0');
    elsif rising_edge(CLK) then
      if nxt_st = READ_ST then
        s_pg_cnt <= std_logic_vector(unsigned(s_pg_cnt) + 1);
      end if;
    end if;
  end process pc_cnt;

  exec_sync : entity work.rising_edge_synchronizer
    port map(
      CLK   => CLK,
      RESET => RESET,
      INPUT => EXEC,
      EDGE  => s_exec_sync
    );
  
  math_alu : entity work.alu
    port map(
      CLK     => clk,
      RESET   => reset,
      EXECUTE => s_exec_sync,
      A       => s_b_data,
      B       => A_INSTR,
      OP      => OP_INSTR,
      RESULT  => s_data_out
    );
  
  ram_mem  : entity work.memory
    generic map(
      addr_width => 2,
      data_width => 8
    )
    port map(
      CLK   => clk,
      RST   => reset,
      WE    => s_we,
      ADDR  => s_addr,
      STATE => s_state,
      DIN   => s_data_out,
      DOUT  => s_b_data
    );
  
  ctrl_mem : entity work.addr_ctrl
    port map(
      CLK   => CLK,
      RST   => RESET,
      MS    => MS_INSTR,
      MR    => MR_INSTR,
      EXEC  => s_exec_sync,
      WE    => s_we,
      ADDR  => s_addr,
      STATE => s_state
    );
  
  display : entity work.seven_segment_full
    generic map(
      bits => bits
    )
    port map(
      RESET     => RESET,
      BCD       => s_data_out,
      HEX_ONE   => RESULT_HEX_ONE,
      HEX_TWO   => RESULT_HEX_TWO,
      HEX_THREE => RESULT_HEX_THREE
    );
  
  rom_inst : entity work.blink_rom 
    port map (
      ADDRESS     => s_pg_cnt,
      CLOCK       => clk,
      Q           => s_q_sig
    );
  
end arch;