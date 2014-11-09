/* FPGA Chip-8
	Copyright (C) 2013  Carsten Elton S�rensen

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

`include "blitter.vh"

module mist_top(
	// 27 MHz clocks
	input	[1:0]		CLOCK_27,
	
	// Yellow led
	output			LED,
  
	// VGA
	output			VGA_HS,
	output			VGA_VS,
	output [5:0]	VGA_R,
	output [5:0]	VGA_G,
	output [5:0]	VGA_B,
	
  // SPI
  inout          SPI_DO,
  input          SPI_DI,
  input          SPI_SCK,
  input          SPI_SS2,		// data_io
  input          SPI_SS3,		// OSD
  input          SPI_SS4,		// unused in this core
  input          CONF_DATA0	// SPI_SS for user_io
	
);

wire clk_100M;
wire clk_25M;
wire clk_12k;
wire cpu_clk;

mist_pll	mist_pll_inst (
//	.areset ( areset_sig ),
	.inclk0 ( CLOCK_27[0] ),
	.c0 ( clk_100M ),
	.c1 ( clk_25M ),
	.c2 ( clk_12k ),
//	.locked ( locked_sig )
);

clk_divider  #(.divider(5000)) Clock_20kHz(
	1'b0,
	clk_100M,
	cpu_clk
);

//wire [1:0] buttons;

//assign LED = |buttons;

wire ps2_data;
wire ps2_clk;

localparam CONF_STR = {
	"Chip;CH8;",
	"O1,Monitor,4:3,16:9;"
};

user_io #(.STRLEN(9 + 20)) UserIO(
	.conf_str		(CONF_STR			),

	.SPI_CLK     	(SPI_SCK          ),
	.SPI_SS_IO     (CONF_DATA0       ),
	.SPI_MISO      (SPI_DO           ),   // tristate handling inside user_io
	.SPI_MOSI      (SPI_DI           ),

	.core_type(8'ha4),
	
//   .SWITCHES      (switches         ),
//	.BUTTONS       (buttons          ),

//   .JOY0          (joyA             ),
//   .JOY1          (joyB             ),

//   .status        (status           ),

   .clk           (clk_12k          ),   // should be 10-16kHz for ps2 clock
   .ps2_data      (ps2_data         ),
   .ps2_clk       (ps2_clk          )
);

wire [5:0] chip8_R;
wire [5:0] chip8_G;
wire [5:0] chip8_B;
wire chip8_hs;
wire chip8_vs;

osd #(15,0,5) OSD(
	clk_25M,
	
	SPI_SCK,
	SPI_SS3,
	SPI_DI,
	
	chip8_R, chip8_G, chip8_B,
	chip8_hs, chip8_vs,

	VGA_R, VGA_G, VGA_B,
	VGA_HS, VGA_VS
);

// Chip-8 machine

wire [15:0] current_opcode;

chip8 chip8machine(
	clk_25M,
	cpu_clk,
	clk_100M,
	
	1'b0,
	
	chip8_hs, chip8_vs,
	chip8_R[5:3], chip8_G[5:3], chip8_B[5:4],
	
	current_opcode,
	
	ps2_data, ps2_clk
);




endmodule

