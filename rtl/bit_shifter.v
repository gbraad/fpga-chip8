`timescale 1ns / 1ps

module bit_shifter(
	input clk,				// pixelclock
	input[width-1:0] d,	// input data word
	input load,				// force load of word, reset counter
	input enable,			// enable output
	input[3:0] mult,		// pixel multiplier/repeater less one
	output reg q);			// output pixel
	
parameter width = 16;

reg[width-1:0] fifo = 16'h8000;
reg[3:0] counter = 0;

always @ (posedge clk) begin
	if (load) begin
		{q, fifo} <= {d, 1'b1};
		counter <= 0;
	end else if(enable) begin
		if (counter == mult) begin
			if (fifo == 16'h8000)
				{q, fifo} <= {d, 1'b1};
			else
				{q, fifo} <= {fifo, 1'b0};
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end;
	end;
end;

endmodule
