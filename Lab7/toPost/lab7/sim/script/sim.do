
vlib work
vcom -2008 -work altera_mf "C:/intelFPGA_lite/18.1/quartus/eda/sim_lib/altera_mf_components.vhd"
vcom -2008 -work altera_mf "C:/intelFPGA_lite/18.1/quartus/eda/sim_lib/altera_mf.vhd" 
vcom -2008 -work work ../../src/rom/blink_rom.vhd
vcom -2008 -work work ../../src/memory.vhd
vcom -2008 -work work ../../src/seven_segment_full.vhd
vcom -2008 -work work ../../src/rising_edge_synchronizer.vhd
vcom -2008 -work work ../../src/alu.vhd
vcom -2008 -work work ../../src/addr_ctrl.vhd
vcom -2008 -work work ../../src/top.vhd
vcom -2008 -work work ../src/instruct_tb.vhd
vsim -voptargs=+acc instruct_tb
do wave.do
run 5 us
