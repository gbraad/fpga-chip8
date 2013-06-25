`timescale 1ns / 1ps

module internal_blitter(
	input						clk,
	
	input			[8:0]		src_fb_addr,
	input			[3:0]		src_fb_scroll,
	input			[3:0]		src_fb_mod,
	input			[15:0]	src_fb_mask,
	input						src_fb_en,
	
	input			[11:0]	src_ram_addr,
	input						src_ram_mod,
	input			[1:0]		src_ram_bytemask,
	input						src_ram_en,

	input			[8:0]		dest_fb_addr,
	input			[3:0]		dest_fb_mod,

	input			[2:0]		width,
	input			[5:0]		height,

	input						reverse,

	input						enable,
	output reg				ready,
	output reg				collision,

	input			[15:0]	buf_out,
	output reg	[8:0]		buf_addr,
	output reg	[15:0]	buf_in,
	output reg				buf_enable,
	output reg				buf_write,
	
	input			[7:0]		cpu_out,
	output reg	[11:0]	cpu_addr
);

`define STATE_WAITING			3'd0
`define STATE_WAIT_READ1		3'd1
`define STATE_SETUP_RAM_READ2	3'd2
`define STATE_WAIT_RAM_READ2	3'd3
`define STATE_COMBINE			3'd4
`define STATE_DONE				3'd7

reg	[2:0] 	state = `STATE_WAITING;
reg	[8:0]		src_fb_current;
reg	[8:0]		dest_fb_current;
reg	[7:0]		ram_buf;

wire	[15:0]	ram_word;
assign ram_word = src_ram_en ? {src_ram_bytemask[1] ? ram_buf : 8'd0, src_ram_bytemask[0] ? cpu_out : 8'd0} : 16'd0;

always @ (posedge clk)
begin
	case (state) begin
		`STATE_WAITING: begin
			if (enable) begin
				src_fb_current <= src_fb_addr;
				dest_fb_current <= dest_fb_addr;
				
				buf_addr <= src_fb_addr;
				buf_enable <= src_fb_en;
				buf_write <= 0;

				cpu_addr <= src_ram_addr;

				collision <= 0;
				ready <= 0;
				
				ram_buf <= 0;
				
				state <= `STATE_WAIT_READ1;
			end;
		end;
		`STATE_WAIT_READ1: begin
			if (src_ram_en) begin
				state <= `STATE_SETUP_RAM_READ2;
				src_ram_addr <= src_ram_addr + 1'd1;
			end else begin
				state <= `STATE_COMBINE;
			end;
		end;
		`STATE_SETUP_RAM_READ2: begin
			ram_buf <= cpu_out;
			
			cpu_addr <= src_ram_addr;
			src_ram_addr <= src_ram_addr + 1'd1;

			state <= `STATE_WAIT_RAM_READ2;
		end;
		`STATE_WAIT_RAM_READ2: begin
			state <= `STATE_COMBINE_AND_WRITE;
		end;
		`STATE_COMBINE_AND_WRITE: begin
			
		end;
			
	endcase;
end;


endmodule
