onerror {resume}
radix define SSD {
    "7'b1000000" "0" -color "orange",
    "7'b1111001" "1" -color "orange",
    "7'b0100100" "2" -color "orange",
    "7'b0110000" "3" -color "orange",
    "7'b0011001" "4" -color "orange",
    "7'b0010010" "5" -color "orange",
    "7'b0000010" "6" -color "orange",
    "7'b1111000" "7" -color "orange",
    "7'b0000000" "8" -color "orange",
    "7'b0011000" "9" -color "orange",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Clock and Reset}
add wave -noupdate /instruct_tb/uut/CLK
add wave -noupdate /instruct_tb/uut/RESET
add wave -noupdate /instruct_tb/uut/EXEC
add wave -noupdate -divider {Hex Displays}
add wave -noupdate -radix SSD /instruct_tb/uut/RESULT_HEX_ONE
add wave -noupdate -radix SSD /instruct_tb/uut/RESULT_HEX_TWO
add wave -noupdate -radix SSD /instruct_tb/uut/RESULT_HEX_THREE
add wave -noupdate /instruct_tb/uut/STATE_LED
add wave -noupdate -divider {Program Instruction}
add wave -noupdate /instruct_tb/uut/MS_INSTR
add wave -noupdate /instruct_tb/uut/MR_INSTR
add wave -noupdate /instruct_tb/uut/OP_INSTR
add wave -noupdate -radix unsigned /instruct_tb/uut/A_INSTR
add wave -noupdate -divider {Address of ROM}
add wave -noupdate /instruct_tb/uut/s_pg_cnt
add wave -noupdate -divider Execution
add wave -noupdate /instruct_tb/uut/s_exec_sync
add wave -noupdate -divider ALU
add wave -noupdate -color Red -radix unsigned /instruct_tb/uut/math_alu/a
add wave -noupdate -color Red -radix unsigned /instruct_tb/uut/math_alu/b
add wave -noupdate -color Red /instruct_tb/uut/math_alu/op
add wave -noupdate -color Red -radix unsigned /instruct_tb/uut/math_alu/result
add wave -noupdate -divider Ram_ctrl
add wave -noupdate -color {Cornflower Blue} /instruct_tb/uut/ctrl_mem/MS
add wave -noupdate -color {Cornflower Blue} /instruct_tb/uut/ctrl_mem/MR
add wave -noupdate -color {Cornflower Blue} /instruct_tb/uut/ctrl_mem/EXEC
add wave -noupdate -color {Cornflower Blue} /instruct_tb/uut/ctrl_mem/WE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {304514 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 203
configure wave -valuecolwidth 41
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
WaveRestoreZoom {41184 ps} {745201 ps}
