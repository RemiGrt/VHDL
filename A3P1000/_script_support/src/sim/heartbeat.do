# quit sim (if in simulation already)
quit -sim

# Call general settings
do config.do

# Entity to test (should be same as file name)
set entityName heartbeat

# file to test
set fileName $entityName.vhd

# Compile and simulate
vcom -reportprogress 300 -work work $hdlPath$fileName
vsim $entityName -gg_clk_frequency=40000000

# Stimulus
# 40 MHz Clock 25 ns period, 50% duty cycle
force clk    1 , 0 12.5  ns -r $clkPeriod
# reset_n
force rst_n 0, 1 100 ns

# Add waves
add wave *

radix signal sim:/$entityName/pwm unsigned
radix signal sim:/$entityName/lum unsigned

# Run simulation
run 1000 ms
