vlib work
vcom -2008 -work work ../../src/components_pkg.vhd
vcom -2008 -work work ../../src/rising_edge_synchronizer.vhd
vcom -2008 -work work ../../src/sync_bits.vhd
vcom -2008 -work work ../../src/alu.vhd
vcom -2008 -work work ../../src/memory.vhd
vcom -2008 -work work ../../src/seven_segment_full.vhd
vcom -2008 -work work ../../src/addr_ctrl.vhd
vcom -2008 -work work ../../src/math_top.vhd
vcom -2008 -work work ../src/math_top_tb2.vhd
vsim -voptargs=+acc math_top_tb2
do wave.do
run 500 ns
