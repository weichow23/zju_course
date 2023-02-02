`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:48:19 11/22/2022
// Design Name:   D_FLIPFLOP
// Module Name:   E:/lab/10/MyLATCHS/test_dflipflop.v
// Project Name:  MyLATCHS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: D_FLIPFLOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_dflipflop;

	// Inputs
	reg D;
	reg C;
	reg R;
	reg S;

	// Outputs
	wire Q;
	wire NQ;

	// Instantiate the Unit Under Test (UUT)
	D_FLIPFLOP uut (
		.D(D), 
		.C(C), 
		.R(R), 
		.S(S), 
		.Q(Q), 
		.NQ(NQ)
	);

initial begin
           S = 0;
           R = 0;
	D = 0; #150;
	D = 1; #150;	 
end

always begin
	C=0; #50;
	C=1; #50;
end

      
endmodule

