onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /acc_gyr_tb/clock
add wave -noupdate /acc_gyr_tb/reset
add wave -noupdate /acc_gyr_tb/captur
add wave -noupdate /acc_gyr_tb/accel
add wave -noupdate /acc_gyr_tb/gyro
add wave -noupdate /acc_gyr_tb/period_accel
add wave -noupdate /acc_gyr_tb/period_gyro
add wave -noupdate /acc_gyr_tb/period_accel_h
add wave -noupdate /acc_gyr_tb/period_gyro_h
add wave -noupdate /acc_gyr_tb/dut/clk
add wave -noupdate /acc_gyr_tb/dut/rst_n
add wave -noupdate /acc_gyr_tb/dut/acc
add wave -noupdate /acc_gyr_tb/dut/gyr
add wave -noupdate /acc_gyr_tb/dut/captur_period
add wave -noupdate /acc_gyr_tb/dut/period_acc
add wave -noupdate /acc_gyr_tb/dut/period_gyr
add wave -noupdate /acc_gyr_tb/dut/period_etat_h_acc
add wave -noupdate /acc_gyr_tb/dut/period_etat_h_gyr
add wave -noupdate /acc_gyr_tb/dut/state_acc
add wave -noupdate /acc_gyr_tb/dut/state_gyr
add wave -noupdate /acc_gyr_tb/dut/period_acc_h_s
add wave -noupdate /acc_gyr_tb/dut/period_acc_s
add wave -noupdate /acc_gyr_tb/dut/period_gyr_h_s
add wave -noupdate /acc_gyr_tb/dut/period_gyr_s
add wave -noupdate /acc_gyr_tb/dut/temp1
add wave -noupdate /acc_gyr_tb/dut/temp2
add wave -noupdate /acc_gyr_tb/dut/temp3
add wave -noupdate /acc_gyr_tb/dut/temp4
add wave -noupdate /acc_gyr_tb/dut/captur_en_acc
add wave -noupdate /acc_gyr_tb/dut/captur_en_gyr
add wave -noupdate /acc_gyr_tb/dut/temp5
add wave -noupdate /acc_gyr_tb/dut/temp6
add wave -noupdate /acc_gyr_tb/dut/acc_en
add wave -noupdate /acc_gyr_tb/dut/temp7
add wave -noupdate /acc_gyr_tb/dut/temp8
add wave -noupdate /acc_gyr_tb/dut/gyr_en
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {484043 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 196
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
WaveRestoreZoom {0 ps} {1050 ns}
