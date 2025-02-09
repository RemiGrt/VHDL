onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_tb/rst_n
add wave -noupdate /uart_tb/uart_rx_out
add wave -noupdate /uart_tb/uart_tx_in
add wave -noupdate /uart_tb/data_in
add wave -noupdate /uart_tb/data_in_v
add wave -noupdate /uart_tb/data_out
add wave -noupdate /uart_tb/dv
add wave -noupdate /uart_tb/clk
add wave -noupdate /uart_tb/run_sim
add wave -noupdate /uart_tb/g_baudrate
add wave -noupdate /uart_tb/g_clk_frequency
add wave -noupdate /uart_tb/clk_period
add wave -noupdate /uart_tb/half_clk_period
add wave -noupdate -obj /uart_tb/WaveGen_Proc/row
add wave -noupdate /uart_tb/WaveGen_Proc/v_data_row_counter
add wave -noupdate -radix hexadecimal /uart_tb/WaveGen_Proc/data_from_file
add wave -noupdate -divider DUT
add wave -noupdate /uart_tb/DUT/g_clks_per_bit
add wave -noupdate /uart_tb/DUT/clk
add wave -noupdate /uart_tb/DUT/rst_n
add wave -noupdate /uart_tb/DUT/uart_tx_in
add wave -noupdate /uart_tb/DUT/data_in
add wave -noupdate /uart_tb/DUT/data_in_v
add wave -noupdate /uart_tb/DUT/data_in_sent
add wave -noupdate /uart_tb/DUT/data_out
add wave -noupdate /uart_tb/DUT/dv
add wave -noupdate /uart_tb/DUT/state
add wave -noupdate /uart_tb/DUT/uart_rx_out
add wave -noupdate /uart_tb/DUT/state_tx
add wave -noupdate /uart_tb/DUT/rx_d
add wave -noupdate /uart_tb/DUT/rx_dd
add wave -noupdate /uart_tb/DUT/clk_Count
add wave -noupdate /uart_tb/DUT/clk_count_tx
add wave -noupdate /uart_tb/DUT/data_count
add wave -noupdate /uart_tb/DUT/data_count_tx
add wave -noupdate -radix hexadecimal /uart_tb/DUT/data
add wave -noupdate -radix hexadecimal /uart_tb/DUT/data_tx
add wave -noupdate -radix hexadecimal /uart_tb/tx_data_check
add wave -noupdate /uart_tb/tx_process_check/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4508970 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1315830 ps}
