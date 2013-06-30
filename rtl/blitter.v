`timescale 1ns / 1ps

`include "blitter.vh"

module blitter(
	input				clk,
	input				hires,
	
	input	[2:0]		operation,
	input	[11:0]	src,
	input [3:0]		srcHeight,
	input	[6:0]		destX,
	input	[5:0]		destY,
	input				enable,
	
	output reg		ready,
	output reg		collision,
	
	input			[15:0]	buf_out,
	output reg	[8:0]		buf_addr,
	output reg	[15:0]	buf_in,
	output reg				buf_enable,
	output reg				buf_write,
	
	input			[7:0]		cpu_out,
	output reg	[11:0]	cpu_addr);

`define STATE_WAITING	2'd0
`define STATE_RUNNING	2'd1
`define STATE_DONE		2'd2

wire[8:0] bufSize;
assign bufSize = hires ? 9'd511 : 9'd127;

reg[1:0] state = `STATE_WAITING;
reg[2:0]	subState;

// 
// Clear framebuffer
//

task init_clear;
begin
	buf_addr <= 0;
	buf_in <= 0;
	buf_enable <= 1;
	buf_write <= 1;
end;
endtask;

task run_clear;
begin
	if (buf_addr == bufSize) begin
		buf_enable <= 0;
		buf_write <= 0;
		state <= `STATE_DONE;
	end else begin
		buf_addr <= buf_addr + 1'd1;
	end;
end;
endtask;

//
// Scroll left/right
//

reg	[3:0]	scrollCarry;

assign hiresLineStart = buf_addr[2:0] == 3'b000;
assign loresLineStart = buf_addr[1:0] == 2'b00;
assign lineStart = hires ? hiresLineStart : loresLineStart;

assign hiresLineEnd = (hires) && (buf_addr[2:0] == 3'b111);
assign loresLineEnd = (!hires) && (buf_addr[1:0] == 2'b11);
assign lineEnd = hires ? hiresLineEnd : loresLineEnd;

assign scrollLeft = operation == `BLIT_OP_SCROLL_LEFT;

`define SCROLL_STATE_WAIT_READ	2'd0
`define SCROLL_STATE_READ_WRITE	2'd1
`define SCROLL_STATE_NEXT			2'd2
`define SCROLL_STATE_CLEAR			2'd3

task init_scroll;
begin
	buf_enable <= 1;
	buf_write <= 0;
	subState <= `SCROLL_STATE_WAIT_READ;
	buf_addr <= scrollLeft ? bufSize : 9'd0;
end;
endtask;

task run_scroll;
begin
	case(subState)
		`SCROLL_STATE_WAIT_READ: begin
			subState <= `SCROLL_STATE_READ_WRITE;
		end
		`SCROLL_STATE_READ_WRITE: begin
			buf_write <= 1;
			subState <= `SCROLL_STATE_NEXT;

			if (scrollLeft) begin
				buf_in <= {buf_out[11:0], lineEnd ? 4'd0 : scrollCarry};
				scrollCarry <= buf_out[15:12];
			end else begin
				buf_in <= {lineStart ? 4'd0 : scrollCarry, buf_out[15:4]};
				scrollCarry <= buf_out[3:0];
			end;
		end
		`SCROLL_STATE_NEXT: begin
			if ((scrollLeft && buf_addr == 0) || (!scrollLeft && buf_addr == bufSize)) begin
				buf_enable <= 0;
				state <= `STATE_DONE;
			end else if (scrollLeft) begin
				buf_addr <= buf_addr - 1'd1;
			end else begin
				buf_addr <= buf_addr + 1'd1;
			end
			buf_write <= 0;
			subState <= `SCROLL_STATE_WAIT_READ;
		end
	endcase
end;
endtask;

//
// Scroll down
//

wire	[6:0] hiresScrollSrc;
assign hiresScrollSrc = {destY[3:0], 3'd0};
wire	[5:0] loresScrollSrc;
assign loresScrollSrc = {destY[3:0], 2'd0};
wire	[8:0] scrollSrc;
assign scrollSrc = bufSize - (hires ? hiresScrollSrc : loresScrollSrc);

reg	[8:0]	scrollDownDest, scrollDownSrc;

task init_scroll_down;
begin
	buf_enable <= 1;
	buf_write <= 0;
	subState <= `SCROLL_STATE_WAIT_READ;
	scrollDownDest <= bufSize;
	scrollDownSrc <= scrollSrc;
	buf_addr <= scrollSrc;
end;
endtask;

task run_scroll_down;
begin
	case(subState)
		`SCROLL_STATE_WAIT_READ: begin
			subState <= `SCROLL_STATE_READ_WRITE;
		end
		`SCROLL_STATE_READ_WRITE: begin
			subState <= `SCROLL_STATE_NEXT;
			
			buf_write <= 1;
			buf_in <= buf_out;
			buf_addr <= scrollDownDest;
			
			scrollDownDest <= scrollDownDest - 1'd1;
		end
		`SCROLL_STATE_NEXT: begin
			if (scrollDownSrc == 0) begin
				subState <= `SCROLL_STATE_CLEAR;
				buf_write <= 1;
				buf_in <= 0;
				buf_addr <= buf_addr - 1'd1;
			end else begin
				subState <= `SCROLL_STATE_WAIT_READ;
				scrollDownSrc <= scrollDownSrc - 1'd1;
				buf_addr <= scrollDownSrc - 1'd1;
				buf_write <= 0;
			end;
		end
		`SCROLL_STATE_CLEAR: begin
			if (buf_addr == 0) begin
				state <= `STATE_DONE;
				buf_enable <= 0;
				buf_write <= 0;
			end else begin
				buf_addr <= buf_addr - 1'd1;
			end;
		end
	endcase
end;
endtask;


//
// Sprite 16
//

`define SPRITE_STATE_WAIT1			3'd0
`define SPRITE_STATE_RW1			3'd1
`define SPRITE_STATE_SETUP2		3'd2
`define SPRITE_STATE_WAIT2			3'd3
`define SPRITE_STATE_RW2			3'd4
`define SPRITE_STATE_SETUP1		3'd5

reg [15:0]	spriteCarry;

wire [3:0]	spriteScroll;
assign spriteScroll = destX[3:0];

wire	[8:0] hiresSpriteLine;
assign hiresSpriteLine = {destY, 3'b000};

wire	[8:0] loresSpriteLine;
assign loresSpriteLine = {destY, 2'b00};

wire	[8:0]	spriteOffset;
assign spriteOffset = destX[6:4];

wire	[8:0] spriteDestBegin;
assign spriteDestBegin = (hires ? hiresSpriteLine : loresSpriteLine) + spriteOffset;

wire	[8:0] spriteModuloLores;
assign spriteModuloLores = 3;

wire	[8:0] spriteModuloHires;
assign spriteModuloHires = 7;

wire	[8:0] spriteModulo;
assign spriteModulo = hires ? spriteModuloHires : spriteModuloLores;

//
// Sprite
//

reg	[3:0] spriteLineCount;

wire [31:0] spriteScrolledBitmap8;
assign spriteScrolledBitmap8 = {cpu_out, 24'd0} >> spriteScroll;

task init_sprite;
begin
	subState <= `SPRITE_STATE_WAIT1;
	
	buf_enable <= 1;
	buf_write <= 0;
	buf_addr <= spriteDestBegin;
	
	cpu_addr <= src;
	
	collision <= 0;
	
	spriteLineCount <= srcHeight - 1'd1;
end;
endtask;

task run_sprite;
begin;
	case(subState)
		`SPRITE_STATE_WAIT1: begin
			subState <= `SPRITE_STATE_RW1;
		end
		`SPRITE_STATE_RW1: begin
			buf_write <= 1;
			buf_in <= buf_out ^ spriteScrolledBitmap8[31:16];
			collision <= collision | |(spriteScrolledBitmap8[31:16] & buf_out);
			subState <= `SPRITE_STATE_SETUP2;
		end
		`SPRITE_STATE_SETUP2: begin
			buf_addr <= buf_addr + 1'd1;
			buf_write <= 0;
			subState <= `SPRITE_STATE_WAIT2;
		end
		`SPRITE_STATE_WAIT2: begin
			subState <= `SPRITE_STATE_RW2;
		end
		`SPRITE_STATE_RW2: begin
			buf_write <= 1;
			buf_in <= buf_out ^ spriteScrolledBitmap8[15:0];
			collision <= collision | |(buf_out & spriteScrolledBitmap8[15:0]);
			subState <= `SPRITE_STATE_SETUP1;
		end
		`SPRITE_STATE_SETUP1: begin
			cpu_addr <= cpu_addr + 1'd1;
			buf_addr <= buf_addr + spriteModulo;
			buf_write <= 0;
			
			if (spriteLineCount == 0) begin
				state <= `STATE_DONE;
				buf_enable <= 0;
			end else begin
				subState <= `SPRITE_STATE_WAIT1;
				spriteLineCount <= spriteLineCount - 1'd1;
			end;
		end
	endcase;
end;
endtask;


//
// Main blitter state machine
//

always @ (posedge clk) begin
	case (state)
		`STATE_WAITING: begin
			ready <= 1'b1;
			if (enable) begin
				ready <= 1'b0;
				state <= `STATE_RUNNING;
				case (operation)
					`BLIT_OP_CLEAR: 			init_clear;
					`BLIT_OP_SCROLL_LEFT:	init_scroll;
					`BLIT_OP_SCROLL_RIGHT:	init_scroll;
					`BLIT_OP_SCROLL_DOWN:	init_scroll_down();
					`BLIT_OP_SPRITE:			init_sprite();
					//`BLIT_OP_SPRITE_16:		init_sprite_16();
				endcase
			end
		end
		`STATE_RUNNING: begin
			ready <= 1'b0;
			case (operation)
				`BLIT_OP_CLEAR: 			run_clear;
				`BLIT_OP_SCROLL_LEFT:	run_scroll;
				`BLIT_OP_SCROLL_RIGHT:	run_scroll;
				`BLIT_OP_SCROLL_DOWN:	run_scroll_down();
				`BLIT_OP_SPRITE:			run_sprite();
				//`BLIT_OP_SPRITE_16:		run_sprite_16();
			endcase
		end
		`STATE_DONE: begin
			ready <= 1'b1;
			if (enable == 0)
				state <= `STATE_WAITING;
		end
	endcase;
end;

endmodule
