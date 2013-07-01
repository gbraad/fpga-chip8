/* FPGA Chip-8
	Copyright (C) 2013  Carsten Elton Sørensen

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

// The Chip-8 CPU's dual port memory
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
	.INIT_02(256'h00000037C0000C73_000000FF63100C73_0000003111111531_00000037CCCCCC73),
	.INIT_03(256'h00000066631000FF_00000037CCFFCC73_00000037C0FFCCFF_00000000FFC63100),
	.INIT_04(256'h0000000000000000_0000000000000000_000000730037CC73_00000037CC77CC73),
	.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),

//`include "game_pong_upper.vh"
`include "game_blinky_upper.vh"
//`include "test_upper.vh"
			
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
	.INIT_02(256'h000000CE33EE33EC_000000FF008C63FE_000000C888888888_000000CE333333EC),
	.INIT_03(256'h00000000008C63FF_000000CE33EC00CE_000000CE33EC00FF_00000066FF666EE6),
	.INIT_04(256'h0000000000000000_0000000000000000_000000CE33FF33EC_000000CE33EE33EC),
	.INIT_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
	.INIT_07(256'h0000000000000000000000000000000000000000000000000000000000000000),

//`include "game_pong_lower.vh"
`include "game_blinky_lower.vh"
//`include "test_lower.vh"
			
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
