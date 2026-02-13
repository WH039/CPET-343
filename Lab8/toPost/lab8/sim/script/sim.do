vlib work

vcom -2008 -work altera_mf "C:/intelFPGA_lite/18.1/quartus/eda/sim_lib/altera_mf_components.vhd"
vcom -2008 -work altera_mf "C:/intelFPGA_lite/18.1/quartus/eda/sim_lib/altera_mf.vhd" 
vcom -2008 -work work ../../src/rom_data/rom_data.vhd
vcom -2008 -work work ../../src/rom_instructions/rom_instructions.vhd
vcom -2008 -work work ../../src/rising_edge_synchronizer.vhd
vcom -2008 -work work ../../src/generic_counter.vhd
vcom -2008 -work work ../../src/dj_roomba_3000.vhd
vcom -2008 -work work ../src/dj_roomba_3000_tb.vhd
vsim -voptargs=+acc dj_roomba_3000_tb
do wave.do
run 2 ms