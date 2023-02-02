`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:58:17 11/15/2022
// Design Name:   adder_1bit
// Module Name:   E:/lab/8/MyALU/text_add_1.v
// Project Name:  MyALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder_1bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text_add_1;

	// Inputs
	reg a;
	reg b;
	reg ci;

	// Outputs
	wire s;
	wire c0;

	// Instantiate the Unit Under Test (UUT)
	adder_1bit uut (
		.a(a), 
		.b(b), 
		.ci(ci), 
		.s(s), 
		.c0(c0)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		ci = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule
