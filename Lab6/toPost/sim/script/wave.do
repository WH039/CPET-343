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
add wave -noupdate /calculator_tb/uut/clk
add wave -noupdate /calculator_tb/uut/reset_n
add wave -noupdate /calculator_tb/uut/execute
add wave -noupdate /calculator_tb/uut/ms
add wave -noupdate /calculator_tb/uut/mr
add wave -noupdate /calculator_tb/uut/switch
add wave -noupdate /calculator_tb/uut/op
add wave -noupdate /calculator_tb/uut/led
add wave -noupdate /calculator_tb/uut/bcd_0
add wave -noupdate /calculator_tb/uut/bcd_1
add wave -noupdate /calculator_tb/uut/bcd_2
add wave -noupdate /calculator_tb/uut/reset
add wave -noupdate /calculator_tb/uut/sync_execute
add wave -noupdate /calculator_tb/uut/sync_ms
add wave -noupdate /calculator_tb/uut/sync_mr
add wave -noupdate /calculator_tb/uut/sync_switch
add wave -noupdate /calculator_tb/uut/sync_op
add wave -noupdate /calculator_tb/uut/calc_result
add wave -noupdate /calculator_tb/uut/state_led
add wave -noupdate /calculator_tb/uut/ones
add wave -noupdate /calculator_tb/uut/tens
add wave -noupdate /calculator_tb/uut/hundreds
add wave -noupdate /calculator_tb/uut/result_padded
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {129522 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {7463883 ns}
