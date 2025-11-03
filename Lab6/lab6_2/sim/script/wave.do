onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0011000" "9" -color "red",
    "7'b0001000" "A" -color "red",
    "7'b0000011" "b" -color "red",
    "7'b1000110" "C" -color "red",
    "7'b0100001" "d" -color "red",
    "7'b0000110" "E" -color "red",
    "7'b0001110" "F" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /math_top_tb2/clk
add wave -noupdate /math_top_tb2/reset
add wave -noupdate /math_top_tb2/operator
add wave -noupdate /math_top_tb2/b_input
add wave -noupdate /math_top_tb2/ms
add wave -noupdate /math_top_tb2/mr
add wave -noupdate /math_top_tb2/exec
add wave -noupdate /math_top_tb2/result_hex_one
add wave -noupdate /math_top_tb2/result_hex_two
add wave -noupdate /math_top_tb2/result_hex_three
add wave -noupdate /math_top_tb2/state_led
add wave -noupdate /math_top_tb2/current_test_state
add wave -noupdate /math_top_tb2/test_step_counter
add wave -noupdate /math_top_tb2/CLK_PERIOD
add wave -noupdate /math_top_tb2/OP_ADD
add wave -noupdate /math_top_tb2/OP_SUB
add wave -noupdate /math_top_tb2/OP_MULT
add wave -noupdate /math_top_tb2/OP_DIV
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {499050 ps} {500050 ps}
