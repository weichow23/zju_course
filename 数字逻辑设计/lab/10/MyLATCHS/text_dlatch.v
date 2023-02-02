`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:02:11 11/22/2022
// Design Name:   D_LATCH
// Module Name:   E:/lab/10/MyLATCHS/text_dlatch.v
// Project Name:  MyLATCHS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: D_LATCH
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text_dlatch;

	// Inputs
	reg D;
	reg C;

	// Outputs
	wire Q;
	wire NQ;

	// Instantiate the Unit Under Test (UUT)
	D_LATCH uut (
		.D(D), 
		.C(C), 
		.Q(Q), 
		.NQ(NQ)
	);

	initial begin
	C=1;D=1; #50;
	D=0; #50;
	C=0;D=1; #50;
	D=0;
	end
      
endmodule

