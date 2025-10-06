-------------------------------------------------------------------------------
-- Weicheng Huang
-- Generic Addition and Subtraction component
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

/* Component to control the displays and what math is occurring */
entity ctrl_stm is 
    port(
        CLK    : in std_logic;
        RST    : in std_logic;
        BUTTON : in std_logic;
        STATE  : out std_logic_vector(3 downto 0)
    );
end entity ctrl_stm;

architecture beh of ctrl_stm is

    /*
    | STATE      | DETAILS
    | :----:     | :------:
    | IDLE       | IDLE state (INPUT_A) 8 bits for the first input of the add/sub circuit & display value 
    | INPUT_B    | INPUT_B state input 8 bits for the first input of the add/sub & display value
    | DISP_SUM   | DISP_SUM state sum of A and B & display value
    | DISP_DIF   | DISP_DIFF state subtract A and B & display value
    */
    type CTRL_MATH_STM is (IDLE, INPUT_B, DISP_SUM, DISP_DIF);

    signal cur_st : CTRL_MATH_STM;
    signal nxt_st : CTRL_MATH_STM;

begin

    /* Transition from current state to whatever next state is */
    state_transition : process(CLK, RST)
    begin
        if RST = '1' then
            cur_st <= IDLE;
        elsif rising_edge(clk) then
            cur_st <= nxt_st;
        end if;
    end process state_transition;

    /*State transition requirements process */
    state_proc : process(all)
    begin
        if RST = '1' then
            nxt_st <= IDLE;
        end if;
        case cur_st is
            when INPUT_B =>
                if BUTTON = '1' then
                    nxt_st <= DISP_SUM;
                else
                    nxt_st <= INPUT_B;
                end if;
            when DISP_SUM =>
                if BUTTON = '1' then
                    nxt_st <= DISP_DIF;
                else
                    nxt_st <= DISP_SUM;
                end if;
            when DISP_DIF =>
                if BUTTON = '1' then
                    nxt_st <= IDLE;
                else
                    nxt_st <= DISP_DIF;
                end if;
            when others => --IDLE STATE (INPUT_A)
                if BUTTON = '1' then
                    nxt_st <= INPUT_B;
                else
                    nxt_st <= IDLE;
                end if;
        end case;
    end process state_proc;

    /* State output goes to add_sum component uses each bit to tell it what to do */
    state_out : process(CLK, RST)
    begin
        if RST = '1' then
            STATE <= (others => '0');
        elsif rising_edge(CLK) then
            STATE <= (others => '0');
            case cur_st is
            when INPUT_B =>
                STATE(1) <= '1';
            when DISP_SUM =>
                STATE(2) <= '1';
            when DISP_DIF =>
                STATE(3) <= '1';
            when others => --IDLE STATE (INPUT_A)
                STATE(0) <= '1';
            end case;
        end if;
    end process state_out;

end beh;

    
