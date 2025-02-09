# quit sim (if in simulation already)
quit -sim

# Call general settings
do config.do

# Entity to test (should be same as file name)
set entityName uart

# file to test
set fileName $entityName

# Compile and simulate
vcom -reportprogress 300 -work work $hdlPath$fileName.vhd
vcom -reportprogress 300 -work work $tbPath${fileName}_tb.vhd
vsim ${entityName}_tb -ggFilename=./tb/uart_tb_data.txt

# Stimulus
# 40 MHz Clock 25 ns period, 50% duty cycle

# Add waves
 if {[file exists "./wave_uart.do"]} then {
     do ./wave_uart.do
    }  else {
	add wave *
    }  

# Run simulation
run -all
