/* FPGA Chip-8
	Copyright (C) 2013  Carsten Elton Sørensen

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

module Chip8(
	input 			clk,
	input		[4:0]	btn,
	input		[7:0] sw,

	inout				PS2KeyboardData,
	inout				PS2KeyboardClk,
	
	output	[2:0]	vgaRed,
	output	[2:0]	vgaGreen,
	output	[2:1]	vgaBlue,
	output			Hsync,
	output			Vsync,
	output	[7:0]	seg,
	output	[3:0]	an);

wire			vgaHires;
wire 			vgaClk;
wire			vgaOutside;

// Framebuffer RAM wires, used by VGA circuit

wire	[15:0]	vgabuf_out;
wire	[8:0]		vgabuf_addr;

// Framebuffer RAM wires, used by blitter

wire	[15:0]	fbuf_out, fbuf_in;
wire	[8:0]		fbuf_addr;
wire				fbuf_en;
wire				fbuf_write;

// CPU RAM wires, used by blitter

wire	[7:0]		cbuf_out;
wire	[11:0]	cbuf_addr;

// CPU RAM wires, used by CPU

wire	[7:0]		cpu_out, cpu_in;
wire	[11:0]	cpu_addr;
wire				cpu_en;
wire				cpu_wr;

// Registers for blitter operations

wire	[2:0]		blit_op;
wire	[11:0]	blit_src;
wire	[3:0]		blit_srcHeight;
wire	[6:0] 	blit_destX;
wire	[5:0] 	blit_destY;
wire 				blit_enable;
wire				blit_ready;
wire				blit_collision;

// VGA clock

DCM_CLKGEN #(
	.CLKFXDV_DIVIDE(2),       // CLKFXDV divide value (2, 4, 8, 16, 32)
	.CLKFX_DIVIDE(163),       // Divide value - D - (1-256)
	.CLKFX_MD_MAX(0.0),       // Specify maximum M/D ratio for timing anlysis
	.CLKFX_MULTIPLY(41),      // Multiply value - M - (2-256)
	.CLKIN_PERIOD(10.0),      // Input clock period specified in nS
	.SPREAD_SPECTRUM("NONE"), // Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD", "CENTER_HIGH_SPREAD",
									  // "VIDEO_LINK_M0", "VIDEO_LINK_M1" or "VIDEO_LINK_M2" 
	.STARTUP_WAIT("FALSE")    // Delay config DONE until DCM_CLKGEN LOCKED (TRUE/FALSE)
)
VGAClock (
	.CLKFX(vgaClk),         // 1-bit output: Generated clock output
	.CLKIN(clk),           // 1-bit input: Input clock
	.RST(1'b0)              // 1-bit input: Reset input pin
);

// VGA framebuffer

framebuffer VGAFramebuffer(
	vgaClk,
	vgabuf_addr,
	vgabuf_out,

	clk,
	fbuf_en,
	fbuf_write,
	fbuf_addr,
	fbuf_in,
	fbuf_out
);

// PS/2 keyboard

assign PS2KeyboardData = 1'bZ;
assign PS2KeyboardClk = 1'bZ;

wire [7:0]	keyboardData;
wire			keyboardReady;
reg  [15:0]	keyboardMatrix;

task updateKey;
	input [7:0] code;
	input value;
	begin
		case (code)
			8'h16: keyboardMatrix[4'h1] = value;
			8'h1E: keyboardMatrix[4'h2] = value;
			8'h26: keyboardMatrix[4'h3] = value;
			8'h25: keyboardMatrix[4'hC] = value;
			8'h15: keyboardMatrix[4'h4] = value;
			8'h1D: keyboardMatrix[4'h5] = value;
			8'h24: keyboardMatrix[4'h6] = value;
			8'h2D: keyboardMatrix[4'hD] = value;
			8'h1C: keyboardMatrix[4'h7] = value;
			8'h1B: keyboardMatrix[4'h8] = value;
			8'h23: keyboardMatrix[4'h9] = value;
			8'h2B: keyboardMatrix[4'hE] = value;
			8'h1A: keyboardMatrix[4'hA] = value;
			8'h22: keyboardMatrix[4'h0] = value;
			8'h21: keyboardMatrix[4'hB] = value;
			8'h2A: keyboardMatrix[4'hF] = value;
		endcase
	end
endtask;

ps2in Keyboard(
	.ps2clk(PS2KeyboardClk),
	.ps2data(PS2KeyboardData),
	
	.ready(keyboardReady),
	.data(keyboardData)
);

reg kbdDown = 1;

always @ (posedge keyboardReady) begin
	if (keyboardData == 8'hF0) begin
		kbdDown = 0;
	end else begin
		updateKey(.code(keyboardData), .value(kbdDown));
		kbdDown = 1;
	end;
end;

// CPU clock 

wire cpu_clk;

clk_divider  #(.divider(5000)) Clock_20kHz(
	1'b0,
	clk,
	cpu_clk);

// CPU memory

cpu_memory CPUMemory (
	.a_clk(cpu_clk),
	.a_en(cpu_en),
	.a_write(cpu_write),
	.a_out(cpu_out),
	.a_in(cpu_in),
	.a_addr(cpu_addr),
	
	.b_out(cbuf_out),
	.b_addr(cbuf_addr),
	.b_clk(clk)
);

vga_block VGA(
	.clk(vgaClk),
	.hires(vgaHires),
	
	.hSync(Hsync),
	.vSync(Vsync),
	.vOutside(vgaOutside),
	
	.r(vgaRed), 
	.g(vgaGreen),
	.b(vgaBlue),
	
	.fbAddr(vgabuf_addr),
	.fbData(vgabuf_out)
);

blitter Blitter(
	.clk(clk),
	.hires(vgaHires),

	.operation(blit_op),
	.src(blit_src),
	.srcHeight(blit_srcHeight),
	.destX(blit_destX), .destY(blit_destY),
	.enable(blit_enable),
	.ready(blit_ready),
	.collision(blit_collision),

	.buf_out(fbuf_out),
	.buf_addr(fbuf_addr),
	.buf_in(fbuf_in),
	.buf_enable(fbuf_en),
	.buf_write(fbuf_write),
	
	.cpu_out(cbuf_out),
	.cpu_addr(cbuf_addr)
);

wire	clk_1khz;

clk_divider  #(.divider(100000)) Clock_1kHz(
	1'b0,
	clk,
	clk_1khz);


// Hex segment

wire	[15:0]	hexdigits;

hex_segment_driver HexDriver(
	clk_1khz,
	hexdigits[15:12], 1'b1,
	hexdigits[11:8], 1'b1,
	hexdigits[7:4], 1'b1,
	hexdigits[3:0], 1'b1,
	seg, an);

// Buttons

wire	[4:0]		btn_down, btn_down_edge;

five_way_buttons Buttons(
	.clk(clk_1khz),
	.but(btn),
	.down(btn_down),
	.down_edge(btn_down_edge));

// CPU single stepping

reg run = 1'd0;
reg run_prev = 1'd0;
wire halt = !(run && !run_prev);

always @ (posedge cpu_clk) begin
	run_prev <= run;
end;

always @ (posedge clk_1khz) begin
	if (blit_ready) begin
		run <= btn_down_edge[0];
	end;
end;

// CPU

cpu CPU(
	.clk(cpu_clk),
	.clk_60hz(Vsync),
	.vsync(vgaOutside),
	.halt((halt && sw[7]) | !blit_ready),
	
	.keyMatrix(keyboardMatrix),
	
	.ram_en(cpu_en),
	.ram_wr(cpu_write),
	.ram_out(cpu_out),
	.ram_in(cpu_in),
	.ram_addr(cpu_addr),

	.hires(vgaHires),

	.blit_op(blit_op),
	.blit_src(blit_src),
	.blit_srcHeight(blit_srcHeight),
	.blit_destX(blit_destX),
	.blit_destY(blit_destY),
	.blit_enable(blit_enable),
	.blit_done(blit_ready),
	.blit_collision(blit_collision),
	
	.cur_instr(hexdigits)
);
	
endmodule
