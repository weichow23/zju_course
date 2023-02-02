`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:46:03 11/22/2022
// Design Name:   D_FLIPFLOP
// Module Name:   E:/lab/10/MyLATCHS/text_d_flipflop.v
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

module text_d_flipflop;

	// Inputs
	reg D;
	reg CP;
	reg R;
	reg S;

	// Outputs
	wire Q;
	wire NQ;

	// Instantiate the Unit Under Test (UUT)
	D_FLIPFLOP uut (
		.D(D), 
		.CP(CP), 
		.R(R), 
		.S(S), 
		.Q(Q), 
		.NQ(NQ)
	);

initial begin
   S = 1;
   R = 1;
	D = 0; #150;
	D = 1; #150;	 
end

always begin
	C=0; #50;
	C=1; #50;
end

      
endmodule

