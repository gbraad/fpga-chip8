`timescale 1ns / 1ps
`include "blitter.vh"

module Chip8(
	input 			clk,
	input		[4:0]	btn,
	input		[7:0] sw,

	inout				PS2KeyboardData,
	inout				PS2KeyboardClk,
	
	output	[7:0]	Led,
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
// DCM_CLKGEN: Frequency Aligned Digital Clock Manager
//             Spartan-6
// Xilinx HDL Language Template, version 14.5

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
DCM_CLKGEN_inst (
	.CLKFX(vgaClk),         // 1-bit output: Generated clock output
	//.CLKFX180(CLKFX180), // 1-bit output: Generated clock output 180 degree out of phase from CLKFX.
	//.CLKFXDV(CLKFXDV),   // 1-bit output: Divided clock output
	//.LOCKED(LOCKED),     // 1-bit output: Locked output
	//.PROGDONE(PROGDONE), // 1-bit output: Active high output to indicate the successful re-programming
	//.STATUS(STATUS),     // 2-bit output: DCM_CLKGEN status
	.CLKIN(clk),           // 1-bit input: Input clock
	//.FREEZEDCM(FREEZEDCM), // 1-bit input: Prevents frequency adjustments to input clock
	//.PROGCLK(PROGCLK),     // 1-bit input: Clock input for M/D reconfiguration
	//.PROGDATA(PROGDATA),   // 1-bit input: Serial data input for M/D reconfiguration
	//.PROGEN(PROGEN),       // 1-bit input: Active high program enable
	.RST(1'b0)              // 1-bit input: Reset input pin
);

// BRAM_TDP_MACRO: True Dual Port RAM
//                 Spartan-6
// Xilinx HDL Language Template, version 14.5

//////////////////////////////////////////////////////////////////////////
// DATA_WIDTH_A/B | BRAM_SIZE | RAM Depth | ADDRA/B Width | WEA/B Width //
// ===============|===========|===========|===============|=============//
//     19-36      |  "18Kb"   |     512   |     9-bit     |    4-bit    //
//     10-18      |  "18Kb"   |    1024   |    10-bit     |    2-bit    //
//     10-18      |   "9Kb"   |     512   |     9-bit     |    2-bit    //
//      5-9       |  "18Kb"   |    2048   |    11-bit     |    1-bit    //
//      5-9       |   "9Kb"   |    1024   |    10-bit     |    1-bit    //
//      3-4       |  "18Kb"   |    4096   |    12-bit     |    1-bit    //
//      3-4       |   "9Kb"   |    2048   |    11-bit     |    1-bit    //
//        2       |  "18Kb"   |    8192   |    13-bit     |    1-bit    //
//        2       |   "9Kb"   |    4096   |    12-bit     |    1-bit    //
//        1       |  "18Kb"   |   16384   |    14-bit     |    1-bit    //
//        1       |   "9Kb"   |    8192   |    12-bit     |    1-bit    //
//////////////////////////////////////////////////////////////////////////

BRAM_TDP_MACRO #(
	.BRAM_SIZE("9Kb"), // Target BRAM: "9Kb" or "18Kb" 
	.DEVICE("SPARTAN6"), // Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6" 
	.DOA_REG(0),        // Optional port A output register (0 or 1)
	.DOB_REG(0),        // Optional port B output register (0 or 1)
	.INIT_A(36'h0000000),  // Initial values on port A output port
	.INIT_B(36'h00000000), // Initial values on port B output port
	.INIT_FILE ("NONE"),
	.READ_WIDTH_A (16),   // Valid values are 1-36
	.READ_WIDTH_B (16),   // Valid values are 1-36
	.SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY", 
											//   "GENERATE_X_ONLY" or "NONE" 
	.SRVAL_A(36'h00000000), // Set/Reset value for port A output
	.SRVAL_B(36'h00000000), // Set/Reset value for port B output
	.WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
	.WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
	.WRITE_WIDTH_A(16), // Valid values are 1-36
	.WRITE_WIDTH_B(16), // Valid values are 1-36
	.INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_10(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_11(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_12(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_13(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_14(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_15(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_16(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_17(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_18(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_19(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_1A(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_1B(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_1C(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_1D(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_1E(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_1F(256'h0000000000000000000000000000000000000000000000000000000000000000),
			
	// The next set of INITP_xx are for the parity bits
	.INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000)
) Framebuffer(
	.DOA(vgabuf_out),			// Output port-A data, width defined by READ_WIDTH_A parameter
	.ADDRA(vgabuf_addr),		// Input port-A address, width defined by Port A depth
	.CLKA(vgaClk),				// 1-bit input port-A clock
	.DIA(16'd0),				// Input port-A data, width defined by WRITE_WIDTH_A parameter
	.ENA(1'b1),					// 1-bit input port-A enable
	.REGCEA(1'b0),				// 1-bit input port-A output register enable
	.RSTA(1'b0),				// 1-bit input port-A reset
	.WEA(2'b0),					// Input port-A write enable, width defined by Port A depth

	.DOB(fbuf_out),			// Output port-B data, width defined by READ_WIDTH_B parameter
	.ADDRB(fbuf_addr),		// Input port-B address, width defined by Port B depth
	.CLKB(clk),					// 1-bit input port-B clock
	.DIB(fbuf_in),				// Input port-B data, width defined by WRITE_WIDTH_B parameter
	.ENB(fbuf_en),				// 1-bit input port-B enable
	.REGCEB(1'b0),				// 1-bit input port-B output register enable
	.RSTB(1'b0),				// 1-bit input port-B reset
	.WEB({2{fbuf_write}})	// Input port-B write enable, width defined by Port B depth
);

// PS/2 keyboard

assign PS2KeyboardData = 1'bZ;
assign PS2KeyboardClk = 1'bZ;

wire [7:0]	keyboardData;
wire			keyboardReady;
reg  [15:0]	keyboardMatrix;

assign Led = {keyboardMatrix[1], keyboardMatrix[4], keyboardMatrix[12], keyboardMatrix[13]};

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

clk_divider  #(.divider(2000)) clock50khz(
	1'b0,
	clk,
	cpu_clk);

// CPU memory

cpu_memory CpuBuffer (
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

vga_block vga(
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

blitter blitter(
	.clk(clk),
	.hires(vgaHires),

	.operation(blit_op),
	.src(blit_src),
	.srcHeight(blit_srcHeight),
	.destX(blit_destX), .destY(blit_destY),
	.enable(blit_enable),
	.ready(blit_ready),

	.buf_out(fbuf_out),
	.buf_addr(fbuf_addr),
	.buf_in(fbuf_in),
	.buf_enable(fbuf_en),
	.buf_write(fbuf_write),
	
	.cpu_out(cbuf_out),
	.cpu_addr(cbuf_addr)
);

wire	clk_1khz;

clk_divider  #(.divider(100000)) clock1khz(
	1'b0,
	clk,
	clk_1khz);


// Hex segment

wire	[15:0]	hexdigits;

hex_segment_driver hex(
	clk_1khz,
	hexdigits[15:12], 1'b1,
	hexdigits[11:8], 1'b1,
	hexdigits[7:4], 1'b1,
	hexdigits[3:0], 1'b1,
	seg, an);

// Buttons

wire	[4:0]		btn_down, btn_down_edge;

five_way_buttons buttons(
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

cpu cpu(
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
	
/*
always @ (posedge clk_1khz) begin
	if (blit_ready) begin
		blit_enable <= 0;
		if (btn_down_edge[3]) begin
			blit_op <= `BLIT_OP_SCROLL_DOWN;
			blit_destY <= 1;
			blit_enable <= 1;
			hexdigits <= hexdigits + 1'b1;
		end else if (btn_down_edge[4]) begin
			blit_op <= `BLIT_OP_SCROLL_RIGHT;
			blit_enable <= 1;
			hexdigits <= hexdigits + 1'b1;
		end else if (btn_down_edge[2]) begin
			blit_op <= `BLIT_OP_SCROLL_LEFT;
			blit_enable <= 1;
			hexdigits <= hexdigits + 1'b1;
		end else if (btn_down_edge[0]) begin
			blit_op <= `BLIT_OP_SPRITE;
			blit_src <= 0;
			blit_srcHeight <= 5;
			blit_destX <= 1;
			blit_destY <= 1;
			blit_enable <= 1;
			hexdigits <= hexdigits + 1'b1;
		end;
	end;
end;
*/

endmodule
