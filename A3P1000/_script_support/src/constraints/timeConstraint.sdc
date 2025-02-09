# Create main clock (T=25ns F=40Mhz)
create_clock -name {CLK1} -period 25 -waveform {0 12 } [ get_ports { clk } ]
create_clock -name {CLK2} -period 25 -waveform {0 12 } [ get_ports { clk_ext } ]
# Define PLL clock at 80MHz (50*4800/60*50)
#create_generated_clock -name {PLL_0} -multiply_by 4800 -divide_by 3000 -source [ get_ports { CLK1_50M } ] [ get_ports { OUT0_FABCLK_0 } ]
#create_generated_clock -name {PLL_1} -multiply_by 4800 -divide_by 3000 -source [ get_ports { CLK1_50M } ] [ get_ports { OUT1_FABCLK_0 } ]
# set_false_path -from { * } -to [ get_ports { LED1_GREEN LED1_RED LED2_GREEN LED2_RED } ]
set_false_path -to [ get_ports { led_green led_red } ]
# False path from Buttons
set_false_path -from [ get_ports { rst_n btn } ]
