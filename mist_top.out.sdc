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

## DATE    "Sat Nov 15 11:44:15 2014"

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

create_clock -name {CLOCK_27[0]} -period 37.037 -waveform { 0.000 18.518 } [get_ports {CLOCK_27[0]}]
create_clock -name {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync} -period 32000.000 -waveform { 0.000 3840.000 } [get_registers { chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync }]
create_clock -name {SPI_SCK} -period 40.000 -waveform { 0.000 20.000 } [get_ports { SPI_SCK }]
create_clock -name {clk_divider:ClockDividerFast|clk_out} -period 200000.000 -waveform { 0.000 100000.000 } [get_registers { clk_divider:ClockDividerFast|clk_out }]
create_clock -name {chip8:chip8machine|ps2in:Keyboard|ready} -period 333000.000 -waveform { 0.000 33000.000 } [get_registers { chip8:chip8machine|ps2in:Keyboard|ready }]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {mist_pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 50 -divide_by 27 -master_clock {CLOCK_27[0]} [get_pins {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {mist_pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 25 -divide_by 27 -master_clock {CLOCK_27[0]} [get_pins {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]} -source [get_pins {mist_pll_inst|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 2250 -master_clock {CLOCK_27[0]} [get_pins {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}] -hold 0.080  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|ps2in:Keyboard|ready}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.090  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.110  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {SPI_SCK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {SPI_SCK}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[2]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.090  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.110  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {SPI_SCK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {SPI_SCK}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {SPI_SCK}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -rise_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_divider:ClockDividerFast|clk_out}] -fall_to [get_clocks {clk_divider:ClockDividerFast|clk_out}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -rise_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -fall_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -rise_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -setup 0.080  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -fall_to [get_clocks {mist_pll_inst|altpll_component|auto_generated|pll1|clk[1]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -rise_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}] -fall_to [get_clocks {chip8:chip8machine|vga_block:VGA|vga_sync:VGASync|hSync}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



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

