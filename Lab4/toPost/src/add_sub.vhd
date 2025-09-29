------------------------------------
-- Weicheng Huang                 --
-- top level adder and subtractor --
------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        a           : in std_logic_vector(2 downto 0);
        b           : in std_logic_vector(2 downto 0);
        add_btn     : in std_logic;
        sub_btn     : in std_logic;
        a_bcd       : out std_logic_vector(6 downto 0);
        b_bcd       : out std_logic_vector(6 downto 0);
        result_bcd  : out std_logic_vector(6 downto 0)
    );
end entity add_sub;

architecture top of add_sub is
    -- Synchronized signals
    signal a_sync : std_logic_vector(2 downto 0);
    signal b_sync : std_logic_vector(2 downto 0);
    signal add_btn_edge : std_logic;
    signal sub_btn_edge : std_logic;
    
    -- Add/Sub unit signals
    signal mode : std_logic;
    signal result : std_logic_vector(3 downto 0);
    
    -- Display signals
    signal a_display : std_logic_vector(3 downto 0);
    signal b_display : std_logic_vector(3 downto 0);
    
    -- Mode register
    signal mode_reg : std_logic;
    
begin
    -- Input synchronizers
    sync_a : entity work.synchronizer_3bit
        port map (
            clk => clk,
            reset => reset,
            async_in => a,
            sync_out => a_sync
        );
        
    sync_b : entity work.synchronizer_3bit
        port map (
            clk => clk,
            reset => reset,
            async_in => b,
            sync_out => b_sync
        );
    
    -- Button edge detectors
    add_edge : entity work.rising_edge_synchronizer
        port map (
            clk => clk,
            reset => reset,
            input => add_btn,
            output => add_btn_edge
        );
        
    sub_edge : entity work.rising_edge_synchronizer
        port map (
            clk => clk,
            reset => reset,
            input => sub_btn,
            output => sub_btn_edge
        );
    
    -- Mode selection process
    process(clk, reset)
    begin
        if reset = '1' then
            mode_reg <= '0'; -- Default to add mode
        elsif rising_edge(clk) then
            if add_btn_edge = '1' then
                mode_reg <= '0'; -- Add mode
            elsif sub_btn_edge = '1' then
                mode_reg <= '1'; -- Subtract mode
            end if;
        end if;
    end process;
    
    mode <= mode_reg;
    
    -- Add/Subtract unit
    add_sub_unit : entity work.generic_add_sub
        generic map (
            WIDTH => 3
        )
        port map (
            a => a_sync,
            b => b_sync,
            flag => mode,
            c => result
        );
    
    -- Prepare display values (zero-extend 3-bit inputs to 4-bit)
    a_display <= '0' & a_sync;
    b_display <= '0' & b_sync;
    
    -- Seven segment displays
    seg_a: entity work.seven_seg
        port map (
            binary => a_display,
            seg => a_bcd
        );
        
    seg_b: entity work.seven_seg
        port map (
            binary => b_display,
            seg => b_bcd
        );
        
    seg_result: entity work.seven_seg
        port map (
            binary => result,
            seg => result_bcd
        );

end top;