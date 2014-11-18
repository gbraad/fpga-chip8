/* FPGA Chip-8
	Copyright (C) 2013-2014  Carsten Elton Sorensen

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

module vga_block(
	input				clk,
	input				res,
	
	input				hires,	// hires or lores mode
	input				wide,		// widescreen

	// Output
	output			hsync,
	output			vsync,
	output			beam_outside,	// high when not displaying the framebuffer
	
	output [2:0] 	red,
	output [2:0] 	green,
	output [1:0]	blue,
	
	// Framebuffer
	output [8:0]	fbuf_addr,
	input  [15:0]	fbuf_data
);


// VGA configuration

localparam hSyncStart = 16;
localparam hBackStart = 16 + 96;
localparam hDispStart = 16 + 96 + 48;
localparam hEnd       = 800 - 1;
	
localparam vSyncStart = 11;
localparam vBackStart = 11 + 2;
localparam vDispStart = 11 + 2 + 31;
localparam vEnd       = 524 - 1;

// positive sync signals from sync generator
wire hsync_syncgen;
wire vsync_syncgen;

assign vsync = !vsync_syncgen;
assign hsync = hsync_syncgen;

// Raw pixel/line counter
wire[10:0] hpos, vpos;

// The actual pixel
wire[10:0] pixel_x, pixel_y;

wire display_enable;

wire display_line_start = hpos == 0 && vpos >= vDispStart;



// Sync generator
	
vga_sync SyncGenerator(
	clk,
	res,
	
	hSyncStart, hBackStart, hDispStart, hEnd,
	vSyncStart, vBackStart, vDispStart, vEnd,
	hsync_syncgen, vsync_syncgen,
	hpos, vpos,
	pixel_x, pixel_y, display_enable
);

// Display generator

display Display(
	clk,
	res,
	
	hires,
	wide,
	display_enable,
	pixel_x, pixel_y,
	red, green, blue,
	vsync_syncgen, display_line_start,
	fbuf_addr, fbuf_data,
	beam_outside
);

endmodule
