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

wire[7:0] fieldPixelWidth;
wire[6:0] fieldPixelHeight;
wire[3:0] hPixelMult;
wire[3:0] vPixelMult;

reg[7:0] hPixelCounter = 0;
reg[3:0] vPixelCounter = 0;

reg[8:0] lineAddr = 0;

assign fieldPixelWidth = hires ? 8'd128 : 8'd64;
assign fieldPixelHeight = hires ? 7'd64 : 7'd32;
assign hPixelMult = hires ? 4'd5 : 4'd10;
assign vPixelMult = hires ? 4'd6 : 4'd12;

always @ (posedge clk) begin : AddressGenerator
	if (frameStart) begin
		fbAddr <= 0;
		lineAddr <= 0;
		vPixelCounter <= vPixelMult - 1'b1;
	end else if (lineStart) begin
		fbAddr <= lineAddr;
		hPixelCounter <= 8;
		if (vPixelCounter == 0) begin
			vPixelCounter <= vPixelMult - 1'b1;
			lineAddr <= lineAddr + (fieldPixelWidth >> 4);
		end else begin
			vPixelCounter <= vPixelCounter - 1'b1;
		end;
	end else if (pixelEnable) begin
		if (hPixelCounter == 0) begin
			hPixelCounter <= {hPixelMult,4'd0} - 1'b1;
			fbAddr <= fbAddr + 1'd1;
		end else begin
			hPixelCounter <= hPixelCounter - 1'b1;
		end;
	end;
end;

assign {r,g,b} = {8{pixelEnable && (pixel || pixelX == 0 || pixelY == 0 || pixelX == 639 || pixelY == 479)}};
//assign pixel = pixelX[0] ^ pixelY[0];

bit_shifter shifter(
	clk,
	fbData,
	pixelX == 0,
	pixelEnable,
	hPixelMult - 1'b1,
	pixel);

endmodule
