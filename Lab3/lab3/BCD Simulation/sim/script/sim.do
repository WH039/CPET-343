vlib work
vcom -2008 -work work ../../src/generic_adder_beh.vhd
vcom -2008 -work work ../../src/generic_counter.vhd
vcom -2008 -work work ../../src/seven_seg.vhd
vcom -2008 -work work ../../src/seven_seg_top.vhd
vcom -2008 -work work ../src/seven_seg_top_tb.vhd
vsim -voptargs=+acc seven_seg_top_tb
do wave.do
run 500 ns
