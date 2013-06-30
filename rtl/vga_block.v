`timescale 1ns / 1ps

module vga_block(
	input clk,
	input hires,

	// Output
	output hSync,
	output vSync,
	output vOutside,
	
	output[2:0] r,
	output[2:0] g,
	output[1:0] b,
	
	// Framebuffer
	output[8:0] fbAddr,
	input[15:0] fbData);

// VGA configuration
localparam hSyncStart = 16;
localparam hBackStart = 16 + 96;
localparam hDispStart = 16 + 96 + 48;
localparam hTotal     = 800;
	
localparam vSyncStart = 11;
localparam vBackStart = 11 + 2;
localparam vDispStart = 11 + 2 + 31;
localparam vTotal     = 524;

wire hSyncSignal;
wire vSyncSignal;
wire displayLineStart = hPos == 0 && vPos >= vDispStart;

wire[10:0] hPos, vPos;
wire[10:0] pixelX, pixelY;
wire dispEnable;

// Sync generator
	
vga_sync VGASync(
	clk,
	hSyncStart, hBackStart, hDispStart, hTotal,
	vSyncStart, vBackStart, vDispStart, vTotal,
	hSyncSignal, vSyncSignal,
	hPos, vPos,
	pixelX, pixelY, dispEnable);
	
assign vSync = !vSyncSignal;
assign hSync = hSyncSignal;
assign vOutside = vPos < vDispStart + 48;

display Display(
	clk,
	hires,
	dispEnable,
	pixelX, pixelY,
	r, g, b,
	vSyncSignal, displayLineStart,
	fbAddr, fbData);

endmodule
