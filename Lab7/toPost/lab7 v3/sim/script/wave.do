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
add wave -noupdate /instruct_tb/uut/CLK
add wave -noupdate /instruct_tb/uut/RESET
add wave -noupdate /instruct_tb/uut/EXEC
add wave -noupdate /instruct_tb/uut/RESULT_HEX_ONE
add wave -noupdate /instruct_tb/uut/RESULT_HEX_TWO
add wave -noupdate /instruct_tb/uut/RESULT_HEX_THREE
add wave -noupdate /instruct_tb/uut/STATE_LED
add wave -noupdate /instruct_tb/uut/s_state
add wave -noupdate /instruct_tb/uut/s_q_sig
add wave -noupdate /instruct_tb/uut/s_exec_sync
add wave -noupdate /instruct_tb/uut/s_data_out
add wave -noupdate /instruct_tb/uut/s_b_data
add wave -noupdate /instruct_tb/uut/s_we
add wave -noupdate /instruct_tb/uut/s_addr
add wave -noupdate /instruct_tb/uut/s_pg_cnt
add wave -noupdate /instruct_tb/uut/cur_st
add wave -noupdate /instruct_tb/uut/nxt_st
add wave -noupdate /instruct_tb/uut/MS_INSTR
add wave -noupdate /instruct_tb/uut/MR_INSTR
add wave -noupdate /instruct_tb/uut/OP_INSTR
add wave -noupdate /instruct_tb/uut/A_INSTR
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
WaveRestoreZoom {0 ps} {1 ns}
