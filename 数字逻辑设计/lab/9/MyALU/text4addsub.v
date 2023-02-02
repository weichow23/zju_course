`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:31:33 11/22/2022
// Design Name:   AddSub4b
// Module Name:   E:/lab/9/MyALU/text4addsub.v
// Project Name:  MyALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AddSub4b
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text4addsub;

	// Inputs
	reg Ctrl;
	reg [3:0] B;
	reg [3:0] A;

	// Outputs
	wire [3:0] S;
	wire Co;

	// Instantiate the Unit Under Test (UUT)
	AddSub4b uut (
		.Ctrl(Ctrl), 
		.B(B), 
		.A(A), 
		.S(S), 
		.Co(Co)
	);

	initial begin
		// Initialize Inputs
		Ctrl = 0;
		A = 4'b1010;
		B = 4'b0011;
		#100;
		Ctrl =1;
		#100;
        
		// Add stimulus here

	end
      
endmodule

