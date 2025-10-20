-------------------------------------------------------------------------------
-- Jacob Kraft
-- Seven Segment HEX_ONE for two hex HEX_ONEs (tens and ones)
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;  

entity seven_segment_full is
    generic(
        bits : integer
    );
    port(
        RESET       : in std_logic;
        STATE       : in std_logic_vector(3 downto 0);
        A_BCD       : in std_logic_vector(bits-1 downto 0);
        B_BCD       : in std_logic_vector(bits-1 downto 0);
        BCD         : in std_logic_vector(bits downto 0);
        HEX_ONE     : out std_logic_vector(6 downto 0);
        HEX_TWO     : out std_logic_vector(6 downto 0);
        HEX_THREE   : out std_logic_vector(6 downto 0)
    );
end entity seven_segment_full;

architecture beh of seven_segment_full is

    /* Constants */
    constant C_ZERO     : std_logic_vector(6 downto 0) := 7b"1000000";
    constant C_ONE      : std_logic_vector(6 downto 0) := 7b"1111001";
    constant C_TWO      : std_logic_vector(6 downto 0) := 7b"0100100";
    constant C_THREE    : std_logic_vector(6 downto 0) := 7b"0110000";
    constant C_FOUR     : std_logic_vector(6 downto 0) := 7b"0011001";
    constant C_FIVE     : std_logic_vector(6 downto 0) := 7b"0010010";
    constant C_SIX      : std_logic_vector(6 downto 0) := 7b"0000010";
    constant C_SEVEN    : std_logic_vector(6 downto 0) := 7b"1111000";
    constant C_EIGHT    : std_logic_vector(6 downto 0) := 7b"0000000";
    constant C_NINE     : std_logic_vector(6 downto 0) := 7b"0011000";
    constant C_BLANK    : std_logic_vector(6 downto 0) := 7b"1111111";

    /* Signals  */

    /* Signal of tens place for HEX_TWO */
    signal   s_tens     : unsigned(3 downto 0);

    /* Signal of singles place for HEX_ONE */
    signal   s_singles  : unsigned(3 downto 0);

    /* Signal of Hundreds place for HEX_THREE */
    signal   s_hundreds : unsigned(3 downto 0);

    /* Signal of result */
    signal   s_result   : unsigned(bits downto 0);

begin

    s_hundreds <= resize(s_result / 100,s_hundreds'length);
    s_tens     <= resize((s_result / 10) mod 10,s_tens'length); --DIVIDE BY 10 FOR NUMBER IN 10TH PLACE
    s_singles  <= resize(s_result mod 10,s_singles'length);

    /* Recieves state signal from control and chooses what BCD to use */
    state_proc : process(all)
    begin
        if RESET = '1' then
            s_result <= (others => '0');
        end if;
        if STATE(1) = '1' then
            s_result <= resize(unsigned(B_BCD),s_result'length); --Input_B
        elsif STATE(2) = '1' or STATE(3) = '1' then
            s_result <= resize(unsigned(BCD),s_result'length);   --Sum or DIF
        else
            s_result <= resize(unsigned(A_BCD),s_result'length); --INPUT_A
        end if;
    end process state_proc;

    hex_one_proc : process(all)
    begin
        if RESET = '1' then
            HEX_ONE <= C_ZERO;
        end if;
        case s_singles is
        when x"0" =>
            HEX_ONE <= C_ZERO;
        when x"1" =>
            HEX_ONE <= C_ONE;
        when x"2" =>
            HEX_ONE <= C_TWO;
        when x"3" =>
            HEX_ONE <= C_THREE;
        when x"4" =>
            HEX_ONE <= C_FOUR;
        when x"5" =>
            HEX_ONE <= C_FIVE;
        when x"6" =>
            HEX_ONE <= C_SIX;
        when x"7" =>
            HEX_ONE <= C_SEVEN;
        when x"8" =>
            HEX_ONE <= C_EIGHT;
        when x"9" =>
            HEX_ONE <= C_NINE;
        when others =>
            HEX_ONE <= C_BLANK;
        end case;
    end process hex_one_proc;

    hex_two_proc :  process(all)
    begin
        if RESET = '1' then
            HEX_TWO <= C_ZERO;
        end if;
        case s_tens is
        when x"0" =>
            HEX_TWO <= C_ZERO;
        when x"1" =>
            HEX_TWO <= C_ONE;
        when x"2" =>
            HEX_TWO <= C_TWO;
        when x"3" =>
            HEX_TWO <= C_THREE;
        when x"4" =>
            HEX_TWO <= C_FOUR;
        when x"5" =>
            HEX_TWO <= C_FIVE;
        when x"6" =>
            HEX_TWO <= C_SIX;
        when x"7" =>
            HEX_TWO <= C_SEVEN;
        when x"8" =>
            HEX_TWO <= C_EIGHT;
        when x"9" =>
            HEX_TWO <= C_NINE;
        when others =>
            HEX_TWO <= C_BLANK;
        end case;
    end process hex_two_proc;

    hex_three_proc :  process(all)
    begin
        if RESET = '1' then
            HEX_THREE <= C_ZERO;
        end if;
        case s_hundreds is
        when x"0" =>
            HEX_THREE <= C_ZERO;
        when x"1" =>
            HEX_THREE <= C_ONE;
        when x"2" =>
            HEX_THREE <= C_TWO;
        when x"3" =>
            HEX_THREE <= C_THREE;
        when x"4" =>
            HEX_THREE <= C_FOUR;
        when x"5" =>
            HEX_THREE <= C_FIVE;
        when x"6" =>
            HEX_THREE <= C_SIX;
        when x"7" =>
            HEX_THREE <= C_SEVEN;
        when x"8" =>
            HEX_THREE <= C_EIGHT;
        when x"9" =>
            HEX_THREE <= C_NINE;
        when others =>
            HEX_THREE <= C_BLANK;
        end case;
    end process hex_three_proc;
    
end beh;
