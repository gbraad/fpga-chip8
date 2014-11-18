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

module vga_block(
	// VGA clock
	input					clk,
	input					res,
	
	// Hires or lores mode
	input					hires,
	input					wide,

	// Output
	output				hSync,
	output				vSync,
	output				vOutside,	// high when not displaying the framebuffer
	
	output	[2:0] 	r,
	output	[2:0] 	g,
	output	[1:0]		b,
	
	// Framebuffer
	output	[8:0]		fbAddr,
	input		[15:0]	fbData);


// VGA configuration
localparam hSyncStart = 16;
localparam hBackStart = 16 + 96;
localparam hDispStart = 16 + 96 + 48;
localparam hEnd       = 800 - 1;
	
localparam vSyncStart = 11;
localparam vBackStart = 11 + 2;
localparam vDispStart = 11 + 2 + 31;
localparam vEnd       = 524 - 1;

wire hSyncSignal;
wire vSyncSignal;
wire displayLineStart = hPos == 0 && vPos >= vDispStart;

wire[10:0] hPos, vPos;
wire[10:0] pixelX, pixelY;
wire dispEnable;

// Sync generator
	
vga_sync VGASync(
	clk,
	res,
	
	hSyncStart, hBackStart, hDispStart, hEnd,
	vSyncStart, vBackStart, vDispStart, vEnd,
	hSyncSignal, vSyncSignal,
	hPos, vPos,
	pixelX, pixelY, dispEnable
);
	
assign vSync = !vSyncSignal;
assign hSync = hSyncSignal;

display Display(
	clk,
	res,
	
	hires,
	wide,
	dispEnable,
	pixelX, pixelY,
	r, g, b,
	vSyncSignal, displayLineStart,
	fbAddr, fbData,
	vOutside
);

endmodule
