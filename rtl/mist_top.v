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
	
	// VGA
	output			VGA_HS,
	output			VGA_VS,
	output [5:0]	VGA_R,
	output [5:0]	VGA_G,
	output [5:0]	VGA_B
);

wire clk_100M;
wire clk_25M;
wire cpu_clk;

mist_pll	mist_pll_inst (
//	.areset ( areset_sig ),
	.inclk0 ( CLOCK_27[0] ),
	.c0 ( clk_100M ),
	.c1 ( clk_25M ),
//	.locked ( locked_sig )
);

clk_divider  #(.divider(5000)) Clock_20kHz(
	1'b0,
	clk_100M,
	cpu_clk
);

// Chip-8 machine

wire [15:0] current_opcode;

chip8 chip8machine(
	clk_25M,
	cpu_clk,
	clk_100M,
	
	1'b0,
	
	VGA_HS, VGA_VS,
	VGA_R[5:3], VGA_G[5:3], VGA_B[5:4],
	
	current_opcode,
	
	1'b0, 1'b0
);




endmodule

