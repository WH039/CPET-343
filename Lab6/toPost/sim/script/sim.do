vlib work
vcom -2008 -work work ../../src/rising_edge_synchronizer.vhd
vcom -2008 -work work ../../src/synchronizer_8bit.vhd
vcom -2008 -work work ../../src/alu.vhd
vcom -2008 -work work ../../src/double_dabble.vhd
vcom -2008 -work work ../../src/memory.vhd
vcom -2008 -work work ../../src/seven_segment.vhd
vcom -2008 -work work ../../src/components.vhd
vcom -2008 -work work ../../src/calculator.vhd
vcom -2008 -work work ../../src/top.vhd
vcom -2008 -work work ../src/calculator_tb.vhd
vsim -voptargs=+acc calculator_tb
do wave.do
run 500 ns
