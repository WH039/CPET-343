-------------------------------------------------------------------------------
-- Jacob Kraft
-- Generic Addition and Subtraction component
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    

/* Enhanced from lab 4, uses variables to not use double_dabble in top level, does sum and difference of a and b */
entity generic_add_sub is
    generic (
        bits : integer
    );
    port (
        CLK      : in std_logic;
        RESET    : in std_logic;
        A_SYNC   : in std_logic_vector(bits-1 downto 0);
        B_SYNC   : in std_logic_vector(bits-1 downto 0);
        STATE    : in std_logic_vector(3 downto 0);
        RESULT   : out std_logic_vector(bits downto 0)
    );
end entity generic_add_sub;

architecture rtl of generic_add_sub is

    /* state instantiatian signal */
    signal s_state  : std_logic_vector(3 downto 0);

    /* Signal to hold A value */
    signal s_a_val  : std_logic_vector(bits-1 downto 0);

    /* Signal to hold B value */
    signal s_b_val  : std_logic_vector(bits-1 downto 0);

begin

    /* s_state receives state */ 
    s_state <= STATE;

    /* Process to hold A and B values in between states, purposefully latched their values */
    hold_proc : process (CLK,RESET)
    begin
        if RESET = '1' then 
            s_a_val <= (others => '0');
            s_b_val <= (others => '0');
        elsif rising_edge(CLK) then
            if s_state(0) = '1' then
                s_a_val <= std_logic_vector(resize(unsigned(A_SYNC),s_a_val'length));
            elsif s_state(1) = '1' then
                s_b_val <= std_logic_vector(resize(unsigned(B_SYNC),s_b_val'length));
            end if;
        end if;
    end process hold_proc;

    /* Math process for subtraction and addition, converted to make double_dabble not needed */
    math_proc : process(all)
    variable a_ext, b_ext : unsigned(RESULT'length-1 downto 0);
    begin
        if RESET = '1' then
            RESULT <= (others => '0');
        end if;
            a_ext := resize(unsigned(s_a_val), RESULT'length);
            b_ext := resize(unsigned(s_b_val), RESULT'length);
    
            if s_state(3) = '1' then  -- subtract
                RESULT <= std_logic_vector(a_ext - b_ext);
            elsif s_state(2) = '1' then  -- add
                RESULT <= std_logic_vector(a_ext + b_ext);
            else
                RESULT <= RESULT;
            end if;
    end process;

end rtl;

