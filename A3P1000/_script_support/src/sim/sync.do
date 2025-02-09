# quit sim (if in simulation already)
quit -sim

# Call general settings
do config.do

# Entity to test (should be same as file name)
set entityName sync

# file to test
set fileName $entityName.vhd

# Compile and simulate
vcom -reportprogress 300 -work work $hdlPath$fileName
vsim $entityName

# Stimulus
# 40 MHz Clock 25 ns period, 50% duty cycle
force clk    1 , 0 12.5  ns -r $clkPeriod
# reset_n
force rst_n 0, 1 100 ns

radix signal sim:/$entityName/sig_cnt_us unsigned
radix signal sim:/$entityName/sig_cnt_ms unsigned

# Add waves
add wave *

# Run simulation
run 10 ms
