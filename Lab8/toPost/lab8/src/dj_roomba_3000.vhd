-- Dr. Kaputa
-- Lab 8: DJ Roomba 3000 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dj_roomba_3000 is 
  port(
    clk                 : in std_logic;
    reset               : in std_logic;
    execute_btn         : in std_logic;
    sync                : in std_logic;
    led                 : out std_logic_vector(7 downto 0);
    audio_out           : out std_logic_vector(15 downto 0)
  );
end dj_roomba_3000;

architecture beh of dj_roomba_3000 is
-- Track states
signal current_state  : std_logic_vector(3 downto 0);
signal next_state     : std_logic_vector(3 downto 0);

--Define states
constant idle         : std_logic_vector(3 downto 0) := "0001";
constant fetch        : std_logic_vector(3 downto 0) := "0010";
constant decode       : std_logic_vector(3 downto 0) := "0100";
constant execute      : std_logic_vector(3 downto 0) := "1000";

signal data_address   : std_logic_vector(13 downto 0);
signal instr_address  : std_logic_vector(4 downto 0);

signal ex_en          : std_logic;
signal firstPlay      : std_logic := '1';

signal instruction    : std_logic_vector(7 downto 0);

  -- instruction memory
  component rom_instructions
    port(
      address    : in std_logic_vector (4 DOWNTO 0);
      clock      : in std_logic  := '1';
      q          : out std_logic_vector (7 DOWNTO 0)
    );
  end component;
  
  -- data memory
  component rom_data
    port(
      address  : in std_logic_vector (13 DOWNTO 0);
      clock    : in std_logic  := '1';
      q        : out std_logic_vector (15 DOWNTO 0)
    );
  end component;
  
    -- Rising edge synchronizer
  component rising_edge_synchronizer is 
    port (
     clk               : in std_logic;
     reset             : in std_logic;
     input             : in std_logic;
     edge              : out std_logic
    );
  end component;

begin

ex_uut : rising_edge_synchronizer
  port map (
    clk      => clk,
	reset    => reset,
	input    => execute_btn,
	edge     => ex_en
	);
	
-- data instantiation
u_rom_data_inst : rom_data
  port map (
    address    => data_address,
    clock      => clk,
    q          => audio_out
  );

-- instruction
instr_uut : rom_instructions
  port map (
    address    => instr_address,
    clock      => clk,
    q          => instruction
  );
  
  
  
  -- synchronize states --
--(sets initial state and sends next state to current state when clocked)
process(reset,clk)
  begin
    if(reset = '1') then
      current_state <= idle;
    elsif(rising_edge(clk)) then
      current_state <= next_state;
    end if;
end process;

-- Update State based on inputs --
nextStateProcess:process(current_state, ex_en, reset)
begin
  next_state <= current_state;
  if reset = '1' then
    next_state <= idle;
  else
  case(current_state) is
    when idle => 
      if ex_en = '1' then
        next_state <= fetch;
	  else
	    next_state <= current_state;
      end if;
    when fetch =>
      next_state <= decode;
    when decode =>
	    next_state <= execute;
    when execute =>
      if ex_en = '1' then    
        next_state <= fetch;
      end if;
    when others =>
      next_state <= idle;
  end case;
  end if;
end process;

instr_counter:process(clk,reset)
begin
  if reset = '1' then
    instr_address <= "00000";
  elsif rising_edge(clk) then
    if current_state = fetch then
	  instr_address <= std_logic_vector(unsigned(instr_address) + 1);
    end if;
  end if;
end process;

-- decode:process(current_state)
-- begin
  -- if current_state = decode then
    -- if instruction(7 downto 6) = "00" --play
      -- if instruction(6) = '1'
        -- repeat = '1'
-- end process;

  -- loop audio file
  process(clk,reset,instruction)
  begin 
    if (reset = '1') then 
      data_address <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (sync = '1') then
	    if instruction(7 downto 6) = "00" then --play
		  if data_address = "11111111111111" then -- we reach end of audio clip
		    data_address <= (others => '0');
            firstPlay <= '0';
		  elsif firstPlay = '1' or instruction(5) = '1' then --only play if it's the first play or repeat bit is 1
            data_address <= std_logic_vector(unsigned(data_address) + 1 );
		  end if;
		elsif instruction(7 downto 6) = "11" then --stop
		  data_address <= (others => '0');
          firstPlay <= '1';
		elsif instruction(7 downto 6) = "01" then --pause
		  --data_address <= data_address;
          firstPlay <= '1';
		elsif instruction(7 downto 6) = "10" then --seek
		  data_address <= instruction(4 downto 0) & "000000000";
          firstPlay <= '1';
        end if;
      end if;
    end if;
  end process;

  led <= instruction;

end beh;