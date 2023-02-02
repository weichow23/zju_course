`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:15:49 11/08/2022
// Design Name:   Mux4to1b4
// Module Name:   E:/lab/7/Mux4to1b4/test.v
// Project Name:  Mux4to1b4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Mux4to1b4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg [1:0] s;
	reg [3:0] I0;
	reg [3:0] I1;
	reg [3:0] I2;
	reg [3:0] I3;

	// Outputs
	wire [3:0] o;

	// Instantiate the Unit Under Test (UUT)
	Mux4to1b4 uut (
		.s(s), 
		.I0(I0), 
		.I1(I1), 
		.I2(I2), 
		.I3(I3), 
		.o(o)
	);

	initial begin
		// Initialize Inputs
		s = 0;
		I0 = 4'b0001;
		I1 = 4'b0010;
		I2 = 4'b0100;
		I3 = 4'b1000;
		
		while(s<3)
		begin
			#100
			s=s+1;
		end
		#100
		s=s+1;
	end
      
endmodule

