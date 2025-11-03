-------------------------------------------------------------------------------
-- Jacob Kraft
-- Address Controller for memory
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity addr_ctrl is
    port (
        CLK   : in std_logic;                      --! Clock
        RST   : in std_logic;                      --! Reset
        MS    : in std_logic;                      --! Button of MS
        MR    : in std_logic;                      --! Button of MR
        EXEC  : in std_logic;                      --! Button of Execution
        WE    : out std_logic;                     --! Write Enable
        ADDR  : out std_logic_vector(1 downto 0);  --! Address to write too
        STATE : out std_logic_vector(4 downto 0)   --! State instantiation to go to seven seg display
    );
end entity addr_ctrl;


architecture beh of addr_ctrl is

    /*
    | STATE      | DETAILS
    | :----:     | :------:
    | IDLE       | IDLE state, Read working Register 
    | WR_NO_OP   | Write with no operator to working register
    | WRITE_W    | Write with operator to working register
    | WRITE_S    | Write to save register
    | READ_S     | Read to save register
    */
    type ADDR_CTRL_STM is (IDLE, WR_NO_OP, WRITE_W, WRITE_S, READ_S, HOLD);

    signal cur_st : ADDR_CTRL_STM;
    signal nxt_st : ADDR_CTRL_STM;

begin

    /* Transition from current state to whatever next state is */
    state_transition : process(CLK, RST)
    begin
        if RST = '0' then
            cur_st <= IDLE;
        elsif rising_edge(CLK) then
            cur_st <= nxt_st;
        end if;
    end process state_transition;

    /* Conditions to transition to next state */
    nxt_st_proc : process(all)
    begin
        if RST = '0' then
            nxt_st <= IDLE;
        end if;
        case cur_st is
            when WR_NO_OP =>
                nxt_st <= WRITE_W;
            when WRITE_W =>
                nxt_st <= IDLE;
            when WRITE_S =>
                nxt_st <= IDLE;
            when READ_S =>
                    nxt_st <= HOLD;
            when HOLD =>
                if EXEC = '1' then
                    nxt_st <= WR_NO_OP;
                end if;
            when others => --IDLE State
                if EXEC = '1' then
                    nxt_st <= WR_NO_OP;
                elsif MS = '1' then
                    nxt_st <= WRITE_S;
                elsif MR = '1' then
                    nxt_st <= READ_S;
                else
                    nxt_st <= IDLE;
                end if;
        end case;
    end process nxt_st_proc;

    /* Address and write enable next state output */
    addr_proc : process(CLK, RST)
    begin
        if RST = '0' then
            ADDR <= (others => '0');
            WE   <= '0';
        elsif rising_edge(CLK) then
            if nxt_st = WRITE_W then
                ADDR <= b"00";
                WE   <= '1';
            elsif nxt_st = WRITE_S then
                ADDR <= b"01";
                WE   <= '1';
            elsif nxt_st = READ_S then
                ADDR <= b"01";
                WE   <= '0';
            else
                ADDR <= b"00";
                WE   <= '0';
            end if;
        end if;
    end process addr_proc;

    /* State instantion process */
    state_proc : process(CLK, RST)
    begin
        if RST = '0' then
            STATE <= (others => '0');
        elsif rising_edge(CLK) then
            STATE <= (others => '0');
            case nxt_st is
                when WR_NO_OP => 
                    STATE <= b"00010";
                when WRITE_W =>
                    STATE <= b"00100";
                when WRITE_S =>
                    STATE <= b"01000";
                when HOLD =>
                    STATE <= b"10000";
                when others => -- IDLE STATE
                    STATE <= b"00001"; 
            end case;
        end if;
    end process state_proc;

end beh;
