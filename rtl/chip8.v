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

module chip8(
	input		res,
	
	input		vgaClk,	 // 25.152.000 Hz clock
	input		cpu_clk,	 // 20.000 Hz clock
	input		blit_clk, // 100.000.000 Hz clock, or as fast as it can get. cpu_clk must be derived from this
	
	input		cpu_halt,
	
	input		wide,
	
	output			Hsync,
	output			Vsync,
	output [2:0]	vgaRed,
	output [2:0]	vgaGreen,
	output [2:1]	vgaBlue,
	
	output [15:0]	currentOpcode,
	
	output			audio_enable,
	
	input PS2KeyboardData,
	input PS2KeyboardClk,
	
	input				uploading,
	input				upload_en,
	input				upload_clk,
	input [11:0]	upload_addr,
	input [7:0]		upload_data,
	
	output	error
);

wire			vgaHires;
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

// VGA framebuffer

framebuffer VGAFramebuffer(
	vgaClk,
	vgabuf_addr,
	vgabuf_out,

	blit_clk,
	fbuf_en,
	fbuf_write,
	fbuf_addr,
	fbuf_in,
	fbuf_out
);

// PS/2 keyboard

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
endtask

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
		updateKey(keyboardData, kbdDown);
		kbdDown = 1;
	end;
end

// CPU memory

cpu_memory CPUMemory (
	.a_clk  (uploading ? upload_clk : cpu_clk),
	.a_en   (uploading ? upload_en : cpu_en),
	.a_write(uploading ? 1'b1 : cpu_wr),
	.a_out  (cpu_out),
	.a_in   (uploading ? upload_data : cpu_in),
	.a_addr (uploading ? upload_addr : cpu_addr),
	
	.b_out(cbuf_out),
	.b_addr(cbuf_addr),
	.b_clk(blit_clk)
);

vga_block VGA(
	.clk(vgaClk),
	.hires(vgaHires),
	.wide(wide),
	
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
	.clk(blit_clk),
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

// CPU

wire cpu_blit_ready;
util_sync_domain sync_blit_ready(cpu_clk, res, blit_ready, cpu_blit_ready);

cpu CPU(
	.res(res),
	
	.clk(cpu_clk),
	.clk_60hz(Vsync),
	.vsync(vgaOutside),
	.halt(cpu_halt || uploading || !cpu_blit_ready),
	
	.keyMatrix(keyboardMatrix),
	
	.ram_en(cpu_en),
	.ram_wr(cpu_wr),
	.ram_out(cpu_out),
	.ram_in(cpu_in),
	.ram_addr(cpu_addr),

	.hires(vgaHires),
	
	.audio_enable(audio_enable),

	.blit_op(blit_op),
	.blit_src(blit_src),
	.blit_srcHeight(blit_srcHeight),
	.blit_destX(blit_destX),
	.blit_destY(blit_destY),
	.blit_enable(blit_enable),
	.blit_done(cpu_blit_ready),
	.blit_collision(blit_collision),
	
	.cur_instr(currentOpcode),

	.error(error)
);
	


endmodule
