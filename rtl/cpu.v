`timescale 1ns / 1ps
`include "blitter.vh"

module CpuRegisters(
	input				clk,
	
	input		[3:0]	x,
	input		[3:0]	y,
	input		[3:0]	d,
	
	output	[7:0]	vx,
	output	[7:0]	vy,
	
	input				wx,
	input		[7:0]	nx,
	
	input				wd,
	input		[7:0]	nd
);

reg [7:0]	vreg[0:15];

assign vx = vreg[x];
assign vy = vreg[y];

always @ (posedge clk) begin
	if (wx)
		vreg[x] <= nx;
	if (wd)
		vreg[d] <= nd;
end;

endmodule

module cpu(

	input	clk,
	input	clk_60hz,
	input	vsync,
	input	halt,

	input			[15:0]	keyMatrix,

	output reg				ram_en,
	output reg				ram_wr,
	input			[7:0]		ram_out,
	output reg	[7:0]		ram_in,
	output reg	[11:0]	ram_addr,
	
	output reg				hires = 0,
	
	output reg	[2:0]		blit_op = 0,
	output reg	[11:0]	blit_src = 0,
	output reg	[3:0]		blit_srcHeight = 0,
	output reg	[6:0] 	blit_destX = 0,
	output reg	[5:0] 	blit_destY = 0,
	output reg 				blit_enable = 0,
	
	output reg	[15:0]	cur_instr = 16'h1337
	
);

wire [7:0] randomNumber;

rng rng(
	.clk(clk),
	.number_o(randomNumber)
);

reg  [7:0] bcd_in;
wire [1:0] bcd_out1;
wire [3:0] bcd_out2;
wire [3:0] bcd_out3;

bcd bcd(
	.in(bcd_in),
	.out1(bcd_out1),
	.out2(bcd_out2),
	.out3(bcd_out3)
);

reg [11:0]	pc = 12'h200;
reg [11:0]	i = 0;
reg [11:0]	stack[0:15];
reg [4:0]	sp = 0;
reg [7:0]	delay_timer = 0;
reg [7:0]	sound_timer = 0;

reg [7:0] instr_buf;

wire [15:0] instr = {instr_buf, ram_out};

wire [3:0] fvx = instr[11:8];
wire [3:0] fvy = instr[7:4];
wire [7:0] fkk = instr[7:0];

wire [7:0] vx;
wire [7:0] vy;

reg x_write;
reg [7:0] x_new;

reg d_write;
reg [7:0] d_new;
reg [3:0] d_reg;

reg [3:0] bytecounter;

CpuRegisters registers(
	.clk(clk),

	.x(fvx),
	.y(fvy),
	
	.vx(vx),
	.vy(vy),
	
	.wx(x_write),
	.nx(x_new),
	
	.wd(d_write),
	.nd(d_new),
	.d(d_reg)
);

task store_vx;
	input [7:0] v;
	begin
		x_write <= 1;
		x_new <= v;
	end
endtask

task store_vfvx;
	input [15:0] v;
	begin
		{d_new, x_new} <= v;
		d_reg <= 15;
		x_write <= 1;
		d_write <= 1;
	end
endtask

`define STATE_SETUP_R1			4'd0
`define STATE_WAIT				4'd1
`define STATE_SETUP_R2			4'd2
`define STATE_EXECUTE			4'd3
`define STATE_STORE_BCD_1		4'd4
`define STATE_STORE_BCD_2		4'd5
`define STATE_STORE_BCD_3		4'd6
`define STATE_MEM_R				4'd7

reg [2:0] state = `STATE_SETUP_R1;
reg [2:0] nstate;

wire clk_60hz_edge;
edge_detect clk60edge(clk, clk_60hz, clk_60hz_edge);

always @ (posedge clk) begin
	if (clk_60hz_edge) begin
		if (delay_timer != 0)
			delay_timer <= delay_timer - 1'd1;
		
		if (sound_timer != 0)
			sound_timer <= sound_timer - 1'd1;
	end;
	
	case (state)
		`STATE_SETUP_R1: begin
			ram_en <= 1;
			ram_wr <= 0;
			ram_addr <= pc;
			pc <= pc + 1'd1;
			state <= `STATE_WAIT;
			nstate <= `STATE_SETUP_R2;
			blit_enable <= 1'd0;
			x_write <= 0;
			d_write <= 0;
		end
		`STATE_WAIT: begin
			state <= nstate;
		end
		`STATE_SETUP_R2: begin
			instr_buf <= ram_out;
			ram_addr <= pc;
			pc <= pc + 1'd1;
			state <= `STATE_WAIT;
			nstate <= `STATE_EXECUTE;
		end
		`STATE_EXECUTE: begin
			cur_instr <= instr;
			if (!halt) begin
				ram_en <= 0;
				casez (instr)
					16'h00EE: begin
						pc <= stack[sp - 1];
						sp <= sp - 1'd1;
						state <= `STATE_SETUP_R1;
					end
					16'h1???: begin
						pc <= instr[11:0];
						state <= `STATE_SETUP_R1;
					end
					16'h2???: begin
						stack[sp] <= pc;
						sp <= sp + 1;
						pc <= instr[11:0];
						state <= `STATE_SETUP_R1;
					end
					16'h3???: begin
						if (fkk == vx)
							pc <= pc + 2;
						state <= `STATE_SETUP_R1;
					end
					16'h4???: begin
						if (fkk != vx)
							pc <= pc + 2;
						state <= `STATE_SETUP_R1;
					end
					16'h5??0: begin
						if (vx == vy)
							pc <= pc + 2;
						state <= `STATE_SETUP_R1;
					end					
					16'h6???: begin
						store_vx(fkk);
						state <= `STATE_SETUP_R1;
					end
					16'h7???: begin
						store_vx(vx + fkk);
						state <= `STATE_SETUP_R1;
					end
					16'h8??0: begin
						store_vx(vy);
						state <= `STATE_SETUP_R1;
					end
					16'h8??1: begin
						store_vx(vx | vy);
						state <= `STATE_SETUP_R1;
					end
					16'h8??2: begin
						store_vx(vx & vy);
						state <= `STATE_SETUP_R1;
					end
					16'h8??3: begin
						store_vx(vx ^ vy);
						state <= `STATE_SETUP_R1;
					end
					16'h8??4: begin
						store_vfvx(vx + vy + 0);
						state <= `STATE_SETUP_R1;
					end
					16'h8??5: begin
						store_vfvx(vx - vy + 9'h100);
						state <= `STATE_SETUP_R1;
					end
					16'h8?06: begin
						store_vfvx({vx[0], 1'd0, vx[7:1]});
						state <= `STATE_SETUP_R1;
					end
					16'h8??7: begin
						store_vfvx((vy - vx) ^ 9'h100);
						state <= `STATE_SETUP_R1;
					end
					16'h8?0E: begin
						store_vfvx({vx, 1'd0});
						state <= `STATE_SETUP_R1;
					end
					16'hA???: begin
						i <= instr[11:0];
						state <= `STATE_SETUP_R1;
					end
					16'hC???: begin
						store_vx(randomNumber & fkk);
						state <= `STATE_SETUP_R1;
					end
					16'hD???: begin
						if (vsync) begin
							blit_op <= `BLIT_OP_SPRITE;
							blit_src <= i;
							blit_srcHeight <= instr[3:0];
							blit_destX <= vx;
							blit_destY <= vy;
							blit_enable <= 1'd1;
							state <= `STATE_SETUP_R1;
						end;
					end
					16'hE?9E: begin
						if (keyMatrix[vx])
							pc <= pc + 2;
						state <= `STATE_SETUP_R1;
					end
					16'hE?A1: begin
						if (!keyMatrix[vx])
							pc <= pc + 2;
						state <= `STATE_SETUP_R1;
					end
					16'hF?07: begin
						store_vx(delay_timer);
						state <= `STATE_SETUP_R1;
					end
					16'hF?15: begin
						delay_timer <= vx;
						state <= `STATE_SETUP_R1;
					end
					16'hF?18: begin
						sound_timer <= vx;
						state <= `STATE_SETUP_R1;
					end
					16'hF?29: begin
						i <= {vx[3:0], 3'd0};
						state <= `STATE_SETUP_R1;
					end
					16'hF?33: begin
						bcd_in <= vx;
						state <= `STATE_STORE_BCD_1;
					end
					16'hF?65: begin
						bytecounter <= 0;
						ram_en <= 1'd1;
						ram_wr <= 1'd0;
						ram_addr <= i;
						state <= `STATE_WAIT;
						nstate <= `STATE_MEM_R;
					end
				endcase
			end
		end
		`STATE_STORE_BCD_1: begin
			ram_en <= 1'd1;
			ram_wr <= 1'd1;
			ram_in <= bcd_out1;
			ram_addr <= i;
			state <= `STATE_STORE_BCD_2;
		end
		`STATE_STORE_BCD_2: begin
			ram_in <= bcd_out2;
			ram_addr <= ram_addr + 1;
			state <= `STATE_STORE_BCD_3;
		end
		`STATE_STORE_BCD_3: begin
			ram_in <= bcd_out3;
			ram_en <= 0;
			state <= `STATE_SETUP_R1;
		end
		`STATE_MEM_R: begin
			d_new <= ram_out;
			d_write <= 1;
			d_reg <= bytecounter;
			if (bytecounter == fvx) begin
				ram_en <= 1'd0;
				state <= `STATE_SETUP_R1;
			end else begin
				ram_addr <= ram_addr + 1;
				bytecounter <= bytecounter + 1;
				state <= `STATE_WAIT;
				nstate <= `STATE_MEM_R;
			end;
		end
	endcase

end;

endmodule
