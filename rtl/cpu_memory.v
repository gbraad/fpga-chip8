`timescale 1ns / 1ps

module cpu_memory(
	input					a_clk,
	
	input					a_en,
	input					a_write,
	output	[7:0]		a_out,
	input		[7:0]		a_in,
	input		[11:0]	a_addr,
	
	input					b_clk,
	output	[7:0]		b_out,
	input		[11:0]	b_addr
);

BRAM_TDP_MACRO #(
	.BRAM_SIZE("18Kb"), // Target BRAM: "9Kb" or "18Kb" 
	.DEVICE("SPARTAN6"), // Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6" 
	.DOA_REG(0),        // Optional port A output register (0 or 1)
	.DOB_REG(0),        // Optional port B output register (0 or 1)
	.INIT_A(36'h0000000),  // Initial values on port A output port
	.INIT_B(36'h00000000), // Initial values on port B output port
	.INIT_FILE ("NONE"),
	.READ_WIDTH_A (4),   // Valid values are 1-36
	.READ_WIDTH_B (4),   // Valid values are 1-36
	.SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY", 
											//   "GENERATE_X_ONLY" or "NONE" 
	.SRVAL_A(36'h00000000), // Set/Reset value for port A output
	.SRVAL_B(36'h00000000), // Set/Reset value for port B output
	.WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
	.WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
	.WRITE_WIDTH_A(4), // Valid values are 1-36
	.WRITE_WIDTH_B(4), // Valid values are 1-36
	.INIT_00(256'h0004421F_000F9F8F_000F1F8F_00011F99_000F1F1F_000F8F1F_00072262_000F999F),
	.INIT_01(256'h00088F8F_000F8F8F_000E999E_000F888F_000E9E9E_00099F9F_000F1F9F_000F9F9F),
	.INIT_02(256'h00000037C0000C73_00000037C00136FF_0000001351111113_00000037CCCCCC73),
	.INIT_03(256'h000000FF00013666_00000037CCFFCC73_000000FFCCFF0C73_00000000136CFF00),
	.INIT_04(256'h0000000000000000_0000000000000000_00000037CC730037_00000037CC77CC73),
	.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),

//`include "game_pong_upper.vh"
`include "game_blinky_upper.vh"
			
	// The next set of INITP_xx are for the parity bits
	.INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000)

) buffer1 (
	.DOA(a_out[7:4]),	// Output port-A data, width defined by READ_WIDTH_A parameter
	.ADDRA(a_addr),	// Input port-A address, width defined by Port A depth
	.CLKA(a_clk),		// 1-bit input port-A clock
	.DIA(a_in[7:4]),	// Input port-A data, width defined by WRITE_WIDTH_A parameter
	.ENA(a_en),			// 1-bit input port-A enable
	.REGCEA(1'd0),		// 1-bit input port-A output register enable
	.RSTA(1'd0),		// 1-bit input port-A reset
	.WEA(a_write),		// Input port-A write enable, width defined by Port A depth

	.DOB(b_out[7:4]),	// Output port-B data, width defined by READ_WIDTH_B parameter
	.ADDRB(b_addr),	// Input port-B address, width defined by Port B depth
	.CLKB(b_clk),		// 1-bit input port-B clock
	.DIB(4'd0),			// Input port-B data, width defined by WRITE_WIDTH_B parameter
	.ENB(1'd1),			// 1-bit input port-B enable
	.REGCEB(1'd0),		// 1-bit input port-B output register enable
	.RSTB(1'd0),		// 1-bit input port-B reset
	.WEB(1'd0)			// Input port-B write enable, width defined by Port B depth
);

BRAM_TDP_MACRO #(
	.BRAM_SIZE("18Kb"), // Target BRAM: "9Kb" or "18Kb" 
	.DEVICE("SPARTAN6"), // Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6" 
	.DOA_REG(0),        // Optional port A output register (0 or 1)
	.DOB_REG(0),        // Optional port B output register (0 or 1)
	.INIT_A(36'h0000000),  // Initial values on port A output port
	.INIT_B(36'h00000000), // Initial values on port B output port
	.INIT_FILE ("NONE"),
	.READ_WIDTH_A (4),   // Valid values are 1-36
	.READ_WIDTH_B (4),   // Valid values are 1-36
	.SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY", 
											//   "GENERATE_X_ONLY" or "NONE" 
	.SRVAL_A(36'h00000000), // Set/Reset value for port A output
	.SRVAL_B(36'h00000000), // Set/Reset value for port B output
	.WRITE_MODE_A("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
	.WRITE_MODE_B("WRITE_FIRST"), // "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
	.WRITE_WIDTH_A(4), // Valid values are 1-36
	.WRITE_WIDTH_B(4), // Valid values are 1-36
	.INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_02(256'h000000CE33EE33EC_000000EF36C800FF_000000888888888C_000000CE333333EC),
	.INIT_03(256'h000000FF36C80000_000000EC00CE33EC_000000FF00CE33EC_0000006EE666FF66),
	.INIT_04(256'h0000000000000000_0000000000000000_000000CE33FF33EC_000000CE33EE33EC),
	.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),

//`include "game_pong_lower.vh"
`include "game_blinky_lower.vh"
			
	// The next set of INITP_xx are for the parity bits
	.INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000)

) buffer2 (
	.DOA(a_out[3:0]),	// Output port-A data, width defined by READ_WIDTH_A parameter
	.ADDRA(a_addr),	// Input port-A address, width defined by Port A depth
	.CLKA(a_clk),		// 1-bit input port-A clock
	.DIA(a_in[3:0]),	// Input port-A data, width defined by WRITE_WIDTH_A parameter
	.ENA(a_en),			// 1-bit input port-A enable
	.REGCEA(1'b0),		// 1-bit input port-A output register enable
	.RSTA(1'b0),		// 1-bit input port-A reset
	.WEA(a_write),		// Input port-A write enable, width defined by Port A depth

	.DOB(b_out[3:0]),	// Output port-B data, width defined by READ_WIDTH_B parameter
	.ADDRB(b_addr),	// Input port-B address, width defined by Port B depth
	.CLKB(b_clk),		// 1-bit input port-B clock
	.DIB(4'd0),			// Input port-B data, width defined by WRITE_WIDTH_B parameter
	.ENB(1'd1),			// 1-bit input port-B enable
	.REGCEB(1'd0),		// 1-bit input port-B output register enable
	.RSTB(1'd0),		// 1-bit input port-B reset
	.WEB(1'd0)			// Input port-B write enable, width defined by Port B depth
);



endmodule
