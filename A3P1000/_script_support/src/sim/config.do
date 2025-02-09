# Manage work folder
if {[file exist work]} {
    puts "Folder work OK"    
} else {
    vlib work
}

# Set path to hdl sources
set hdlPath ../hdl/

# Set path to tb sources
set tbPath ../sim/tb/

# Set variable for clk Period
set clkPeriod "25 ns"

# Configure wave viewer
configure wave -signalnamewidth 1
