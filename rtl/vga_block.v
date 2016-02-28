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
	
	input				ntsc,
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


// VGA configuration (640x480)

wire [10:0] hSyncStart_VGA = 16;
wire [10:0] hBackStart_VGA = 16 + 96;
wire [10:0] hDispStart_VGA = 16 + 96 + 48;
wire [10:0] hDispEnd_VGA   = 800 - 1;
	
wire [10:0] vSyncStart_VGA = 11;
wire [10:0] vBackStart_VGA = 11 + 2;
wire [10:0] vDispStart_VGA = 11 + 2 + 31;
wire [10:0] vDispEnd_VGA   = 524 - 1;

// NTSC configuration 240p (720x240)

wire [10:0] hSyncStart_NTSC = 16;
wire [10:0] hBackStart_NTSC = 16 + 64;
wire [10:0] hDispStart_NTSC = 16 + 64 + 58;
wire [10:0] hDispEnd_NTSC   = 858 - 1;
	
wire [10:0] vSyncStart_NTSC = 2;
wire [10:0] vBackStart_NTSC = 2 + 4;
wire [10:0] vDispStart_NTSC = 2 + 4 + 16;
wire [10:0] vDispEnd_NTSC   = 262 - 1;


// positive sync signals from sync generator
wire hsync_syncgen;
wire vsync_syncgen;

assign vsync = !vsync_syncgen;
assign hsync = ntsc ^ hsync_syncgen;

// Raw pixel/line counter
wire[10:0] hpos, vpos;

// The actual pixel
wire[10:0] pixel_x, pixel_y;

wire display_enable;



// Sync generator
	
vga_sync SyncGenerator(
	.clk (clk),
	.res (res),
	
	.h_sync_start (ntsc ? hSyncStart_NTSC : hSyncStart_VGA),
	.h_back_start (ntsc ? hBackStart_NTSC : hBackStart_VGA),
	.h_disp_start (ntsc ? hDispStart_NTSC : hDispStart_VGA),
	.h_disp_end   (ntsc ? hDispEnd_NTSC : hDispEnd_VGA),
	
	.v_sync_start (ntsc ? vSyncStart_NTSC : vSyncStart_VGA),
	.v_back_start (ntsc ? vBackStart_NTSC : vBackStart_VGA),
	.v_disp_start (ntsc ? vDispStart_NTSC : vDispStart_VGA),
	.v_disp_end   (ntsc ? vDispEnd_NTSC : vDispEnd_VGA),
	
	.h_sync (hsync_syncgen),
	.v_sync (vsync_syncgen),
	
	.h_pos (hpos),
	.v_pos (vpos),

	.h_pixel (pixel_x),
	.v_pixel (pixel_y),
	
	.pixel_enable (display_enable)
);

// Display generator

display Display(
	.clk (clk),
	.res (res),
	
	.hires (hires),
	.ntsc  (ntsc),
	.wide  (wide),
	
	.enable_pixel (display_enable),
	.h_pixel      (pixel_x),
	.v_pixel      (pixel_y),
	
	.red   (red),
	.green (green),
	.blue  (blue),
	
	.vsync (vsync_syncgen),
	.hsync (hpos == 0),
	
	.fbuf_addr (fbuf_addr),
	.fbuf_data (fbuf_data),
	
	.outside_playfield (beam_outside)
);

endmodule
