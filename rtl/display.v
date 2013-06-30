`timescale 1ns / 1ps

module display(
	input clk,
	input hires,
	input pixelEnable,
	input[10:0] pixelX, pixelY,
	output[2:0] r,
	output[2:0] g,
	output[1:0] b,
	input frameStart,
	input lineStart,
	output reg[8:0] fbAddr,
	input[15:0] fbData);

wire pixel;

wire[7:0] fieldPixelWidth = hires ? 8'd128 : 8'd64;
wire[6:0] fieldPixelHeight = hires ? 7'd64 : 7'd32;
wire[3:0] hPixelMult = hires ? 4'd5 : 4'd10;
wire[3:0] vPixelMult = hires ? 4'd6 : 4'd12;

reg[7:0] hPixelCounter = 0;
reg[3:0] vPixelCounter = 0;

reg[8:0] lineAddr = 0;

wire inPlayfield = pixelY >= 48 && pixelY < 432;

always @ (posedge clk) begin : AddressGenerator
	if (frameStart) begin
		fbAddr <= 0;
		lineAddr <= 0;
		vPixelCounter <= vPixelMult - 1'b1;
	end else if(inPlayfield) begin
		if (lineStart) begin
			fbAddr <= lineAddr;
			if (vPixelCounter == 0) begin
				vPixelCounter <= vPixelMult - 1'b1;
				lineAddr <= lineAddr + (fieldPixelWidth >> 4);
			end else begin
				vPixelCounter <= vPixelCounter - 1'b1;
			end;
			hPixelCounter <= {hPixelMult,4'd0} - 1'b1;
		end else if (pixelEnable) begin
			if (hPixelCounter == 0) begin
				hPixelCounter <= {hPixelMult,4'd0} - 1'b1;
			end else begin
				if (hPixelCounter == 8)
					fbAddr <= fbAddr + 1'd1;
					
				hPixelCounter <= hPixelCounter - 1'b1;
			end;
		end;
	end;
end;

wire [1:0] color =
	(pixelEnable) && (pixelY == 0 || pixelY == 479) ? 1 :
	(inPlayfield && pixelEnable) ? {1'b1,pixel} :
	0;

assign {r,g,b} =
	color == 0 ? 8'h00 :
	color == 1 ? 8'hFF :
	color == 2 ? {3'd6,3'd6,2'd1} :
	{3'd3,3'd3,2'd1};

bit_shifter shifter(
	clk,
	fbData,
	pixelX == -11'h4,
	pixelEnable,
	hPixelMult - 1'b1,
	pixel);

endmodule
