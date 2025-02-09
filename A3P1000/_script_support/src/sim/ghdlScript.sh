#!/bin/bash

#analyse
ghdl -a -fsynopsys ../hdl/uart.vhd
ghdl -a -fsynopsys ./tb/uart_tb.vhd
#elaborate
ghdl -e -fsynopsys uart_tb
#run
ghdl -r -fsynopsys uart_tb --wave=wave.ghw
#display
gtkwave wave.ghw
