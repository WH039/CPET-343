--------------------------------
-- Kohl Carpenter            --
-- top.vhd                  --
-- Top level calculator      --
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components.all;

entity top is
    port (
        clk      : in std_logic;
        reset_n  : in std_logic;  -- Active low reset
        execute  : in std_logic;
        ms       : in std_logic;
        mr       : in std_logic;
        switch   : in std_logic_vector(7 downto 0);
        op       : in std_logic_vector(1 downto 0);
        led      : out std_logic_vector(3 downto 0);
        bcd_0    : out std_logic_vector(6 downto 0);
        bcd_1    : out std_logic_vector(6 downto 0);
        bcd_2    : out std_logic_vector(6 downto 0)
    );
end entity top;

architecture structural of top is
    -- Internal signals
    signal reset : std_logic;
    signal switch_sync : std_logic_vector(7 downto 0);
    signal working_reg : std_logic_vector(7 downto 0);
    signal display_value : std_logic_vector(8 downto 0);
    
    -- BCD conversion signals
    signal ones_bcd : std_logic_vector(3 downto 0);
    signal tens_bcd : std_logic_vector(3 downto 0);
    signal hundreds_bcd : std_logic_vector(3 downto 0);
    
begin
    -- Reset polarity conversion (active high internally)
    reset <= not reset_n;
    
    -- Switch synchronizer
    switch_sync_inst : synchronizer_8bit
        port map (
            clk => clk,
            reset => reset,
            async_in => switch,
            sync_out => switch_sync
        );
    
    -- Calculator core
    calculator_inst : calculator
        port map (
            clk => clk,
            reset => reset,
            execute_btn => execute,
            ms_btn => ms,
            mr_btn => mr,
            switch => switch_sync,
            op_sel => op,
            working_reg => working_reg,
            led => led
        );
    
    -- Display value (pad to 9-bit for BCD conversion)
    display_value <= '0' & working_reg;
    
    -- Binary to BCD conversion (from our lab5 integrated approach)
    binary_to_bcd : process(display_value)
        variable temp : unsigned(11 downto 0);
        variable bcd : unsigned(15 downto 0);
    begin
        temp := resize(unsigned(display_value), 12);
        bcd := (others => '0');
        
        for i in 0 to 11 loop
            if bcd(3 downto 0) > 4 then 
                bcd(3 downto 0) := bcd(3 downto 0) + 3;
            end if;
            if bcd(7 downto 4) > 4 then 
                bcd(7 downto 4) := bcd(7 downto 4) + 3;
            end if;
            if bcd(11 downto 8) > 4 then 
                bcd(11 downto 8) := bcd(11 downto 8) + 3;
            end if;
            
            bcd := bcd(14 downto 0) & temp(11);
            temp := temp(10 downto 0) & '0';
        end loop;
        
        ones_bcd <= std_logic_vector(bcd(3 downto 0));
        tens_bcd <= std_logic_vector(bcd(7 downto 4));
        hundreds_bcd <= std_logic_vector(bcd(11 downto 8));
    end process;
    
    -- Seven segment displays
    seg_ones : seven_seg
        port map (
            binary => ones_bcd,
            seg => bcd_0
        );
        
    seg_tens : seven_seg
        port map (
            binary => tens_bcd,
            seg => bcd_1
        );
        
    seg_hundreds : seven_seg
        port map (
            binary => hundreds_bcd,
            seg => bcd_2
        );

end architecture structural;