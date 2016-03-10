## Generated SDC file "mist_top.out.sdc"

## Copyright (C) 1991-2014 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.1.4 Build 182 03/12/2014 SJ Web Edition"

## DATE    "Thu Mar 10 20:51:52 2016"

##
## DEVICE  "EP3C25E144C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************



#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks -create_base_clocks


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -exclusive -group [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -group [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[3]}] 
set_clock_groups -exclusive -group [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}] -group [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set False Path
#**************************************************************

# Cut paths from pixel clocks to CPU clocks
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[3]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[3]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]

# Cut paths from blitter clock to CPU clocks
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]

# Cut paths from PS/2 clock to CPU clocks
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[0]}]
set_false_path  -from  [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  -to  [get_clocks {cpu_clock_inst|mist_pll_cpu_inst|altpll_component|auto_generated|pll1|clk[1]}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

