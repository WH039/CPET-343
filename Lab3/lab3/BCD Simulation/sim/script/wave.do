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
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /seven_seg_top_tb/uut/CLK
add wave -noupdate /seven_seg_top_tb/uut/RESET
add wave -noupdate /seven_seg_top_tb/uut/s_enable
add wave -noupdate -radix unsigned /seven_seg_top_tb/uut/s_sum
add wave -noupdate -radix unsigned /seven_seg_top_tb/uut/s_sum_sig
add wave -noupdate /seven_seg_top_tb/uut/CLK
add wave -noupdate /seven_seg_top_tb/uut/RESET
add wave -noupdate /seven_seg_top_tb/uut/ADD
add wave -noupdate /seven_seg_top_tb/uut/seven_seg_out
add wave -noupdate /seven_seg_top_tb/uut/s_sum_sig
add wave -noupdate /seven_seg_top_tb/uut/s_enable
add wave -noupdate /seven_seg_top_tb/uut/s_sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {192821 ps} 0}
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
WaveRestoreZoom {0 ps} {525 ns}
