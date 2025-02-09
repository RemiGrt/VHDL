# quit sim (if in simulation already)
quit -sim

# Call general settings
do config.do

# Entity to test (should be same as file name)
set entityName debouncer

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
# sync
force sync 1, 0 $clkPeriod -r 1000 ns
# debouncer_in
force debouncer_in 00 0, 11 2500 ns,\
    00 5000 ns, 11 6000 ns,\
    00 6400 ns, 11 8000 ns,\
    00 8200 ns

# Add waves
add wave *

# Run simulation
run 10000 ns
