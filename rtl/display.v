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

module display(
	input	clk,
	input	res,
	
	input	hires,
	input	wide,

	input			 enable_pixel,
	input	[10:0] h_pixel,
	input [10:0] v_pixel,
	
	output [2:0] red,
	output [2:0] green,
	output [1:0] blue,
	
	input	vsync,	// positive vsync
	input hsync,
	
	output reg [8:0]	fbuf_addr,
	input		  [15:0]	fbuf_data,
	
	output	outside_playfield
);

wire[7:0] display_pixel_width = hires ? 8'd128 : 8'd64;

wire[3:0] h_pixel_mult = hires ? 4'd5 : 4'd10;
wire[3:0] v_pixel_mult = wide ? (hires ? 4'd6 : 4'd12) : h_pixel_mult;

reg[7:0] fbuf_h_pixel = 0;
reg[3:0] fbuf_v_pixel = 0;

reg[8:0] fbuf_line_addr = 0;

wire inside_playfield = wide ? (v_pixel >= 48 && v_pixel < 432) : (v_pixel >= 80 && v_pixel < 400);
assign outside_playfield = !inside_playfield;

always @ (posedge clk) begin : AddressGenerator
	if (res) begin
		fbuf_addr <= 0;
		fbuf_line_addr <= 0;
		fbuf_h_pixel <= 0;
		fbuf_v_pixel <= 0;
	end else if (vsync) begin
		fbuf_addr <= 0;
		fbuf_line_addr <= 0;
		fbuf_v_pixel <= v_pixel_mult - 1'b1;
	end else if(inside_playfield) begin
		if (hsync) begin
			fbuf_addr <= fbuf_line_addr;
			if (fbuf_v_pixel == 0) begin
				fbuf_v_pixel <= v_pixel_mult - 1'b1;
				fbuf_line_addr <= fbuf_line_addr + (display_pixel_width >> 4);
			end else begin
				fbuf_v_pixel <= fbuf_v_pixel - 1'b1;
			end;
			fbuf_h_pixel <= {h_pixel_mult, 4'd0} - 1'b1;
		end else if (enable_pixel) begin
			if (fbuf_h_pixel == 0) begin
				fbuf_h_pixel <= {h_pixel_mult,4'd0} - 1'b1;
			end else begin
				if (fbuf_h_pixel == 8)
					fbuf_addr <= fbuf_addr + 1'd1;
					
				fbuf_h_pixel <= fbuf_h_pixel - 1'b1;
			end;
		end;
	end;
end

wire pixel;

bit_shifter Shifter(
	.clk    (clk),
	.enable (enable_pixel),
	.load   (h_pixel == -11'h4),
	.mult   (h_pixel_mult - 1'b1),
	
	.d (fbuf_data),
	.q (pixel)
);

wire [1:0] color =
	(enable_pixel) && (v_pixel == 0 || v_pixel == 479) ? 2'd1 :
	(inside_playfield && enable_pixel) ? {1'b1, pixel} :
	2'd0;

assign {red, green, blue} =
	color == 0 ? 8'h00 :
	color == 1 ? 8'hFF :
	color == 2 ? {3'd6, 3'd6, 2'd1} :
	{3'd3, 3'd3, 2'd1};


endmodule
