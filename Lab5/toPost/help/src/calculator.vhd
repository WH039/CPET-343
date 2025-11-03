--------------------------------
-- Kohl Carpenter            --
-- calculator.vhd           --
-- 8-bit calculator with memory --
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculator is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        execute_btn : in std_logic;
        ms_btn      : in std_logic;
        mr_btn      : in std_logic;
        switch      : in std_logic_vector(7 downto 0);
        op_sel      : in std_logic_vector(1 downto 0);
        working_reg : out std_logic_vector(7 downto 0);
        led         : out std_logic_vector(3 downto 0)
    );
end entity calculator;

architecture behavioral of calculator is
    -- Memory signals
    signal mem_addr : std_logic_vector(1 downto 0);
    signal mem_data_in : std_logic_vector(7 downto 0);
    signal mem_data_out : std_logic_vector(7 downto 0);
    signal mem_wr_en : std_logic;
    
    -- ALU signals
    signal alu_a : std_logic_vector(7 downto 0);
    signal alu_b : std_logic_vector(7 downto 0);
    signal alu_result : std_logic_vector(7 downto 0);
    
    -- Control signals
    signal execute_edge : std_logic;
    signal ms_edge : std_logic;
    signal mr_edge : std_logic;
    
    -- Internal registers
    signal working_reg_int : std_logic_vector(7 downto 0);
    
begin
    -- Button edge detectors
    execute_edge_detector : entity work.rising_edge_synchronizer
        port map (
            clk => clk,
            reset => reset,
            input => execute_btn,
            output => execute_edge
        );
        
    ms_edge_detector : entity work.rising_edge_synchronizer
        port map (
            clk => clk,
            reset => reset,
            input => ms_btn,
            output => ms_edge
        );
        
    mr_edge_detector : entity work.rising_edge_synchronizer
        port map (
            clk => clk,
            reset => reset,
            input => mr_btn,
            output => mr_edge
        );
    
    -- Memory instance
    memory_inst : entity work.memory
        port map (
            clk => clk,
            reset => reset,
            addr => mem_addr,
            data_in => mem_data_in,
            wr_en => mem_wr_en,
            data_out => mem_data_out
        );
    
    -- ALU instance (using provided alu.vhd)
    alu_inst : entity work.alu
        port map (
            clk => clk,
            reset => reset,
            a => alu_a,
            b => alu_b,
            op => op_sel,
            result => alu_result
        );
    
    -- Memory control
    mem_addr <= "00" when mr_edge = '1' else "01"; -- 00=working, 01=save
    mem_data_in <= working_reg_int;
    mem_wr_en <= ms_edge;
    
    -- ALU input selection
    alu_a <= mem_data_out when mr_edge = '1' else working_reg_int;
    alu_b <= switch;
    
    -- Working register update process
    process(clk, reset)
    begin
        if reset = '1' then
            working_reg_int <= (others => '0');
            led <= (others => '0');
        elsif rising_edge(clk) then
            -- Update working register on execute or mr
            if execute_edge = '1' then
                working_reg_int <= alu_result;
                led <= "0001"; -- Indicate execute operation
            elsif mr_edge = '1' then
                working_reg_int <= mem_data_out;
                led <= "0010"; -- Indicate memory recall
            elsif ms_edge = '1' then
                led <= "0100"; -- Indicate memory store
            else
                led <= (others => '0');
            end if;
        end if;
    end process;
    
    -- Output assignment
    working_reg <= working_reg_int;
    
end architecture behavioral;