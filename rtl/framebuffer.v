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

module framebuffer(
	input         vgaClk,
	input  [8:0]  vgabuf_addr,
	output [15:0] vgabuf_out,

	input         clk,
	input         fbuf_en,
	input         fbuf_write,
	input  [8:0]  fbuf_addr,
	input  [15:0] fbuf_in,
	output [15:0] fbuf_out
);

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
	.WRITE_WIDTH_B(16) // Valid values are 1-36
) VGAFramebuffer(
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


endmodule
