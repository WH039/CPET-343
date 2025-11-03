--------------------------------
-- Kohl Carpenter            --
-- components.vhd           --
-- Component declarations    --
--------------------------------

library ieee;
use ieee.std_logic_1164.all;

package components is
    -- Rising edge synchronizer
    component rising_edge_synchronizer is
        port (
            clk     : in std_logic;
            reset   : in std_logic;
            input   : in std_logic;
            output  : out std_logic
        );
    end component;
    
    -- 8-bit synchronizer
    component synchronizer_8bit is
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            async_in  : in std_logic_vector(7 downto 0);
            sync_out  : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- Seven segment display
    component seven_seg is
        port (
            binary  : in std_logic_vector(3 downto 0);
            seg     : out std_logic_vector(6 downto 0)
        );
    end component;
    
    -- Memory (4x8)
    component memory is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            addr     : in std_logic_vector(1 downto 0);
            data_in  : in std_logic_vector(7 downto 0);
            wr_en    : in std_logic;
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- ALU
    component alu is
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            a        : in std_logic_vector(7 downto 0);
            b        : in std_logic_vector(7 downto 0);
            op       : in std_logic_vector(1 downto 0);
            result   : out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- Calculator
    component calculator is
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
    end component;

end package components;