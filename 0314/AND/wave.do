onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /AND_tb/y_out
add wave -noupdate -format Logic /AND_tb/a_in
add wave -noupdate -format Logic /AND_tb/b_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
WaveRestoreZoom {0 ns} {126 ns}
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
