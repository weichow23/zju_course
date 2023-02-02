`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:17:39 11/22/2022
// Design Name:   MS_FLIPFLOP
// Module Name:   E:/lab/10/MyLATCHS/text_flipflop.v
// Project Name:  MyLATCHS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MS_FLIPFLOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text_flipflop;

	// Inputs
	reg S;
	reg C;
	reg R;

	// Outputs
	wire Q;
	wire NQ;

	// Instantiate the Unit Under Test (UUT)
	MS_FLIPFLOP uut (
		.S(S), 
		.C(C), 
		.R(R), 
		.Q(Q), 
		.NQ(NQ)
	);

initial begin
	R=1;S=1; #50;
	R=1;S=0; #50;
	R=1;S=1; #50;
	R=0;S=1; #50;
	R=1;S=1; #50;
	R=0;S=0; #50;
	R=1;S=1; #50;	 
end
always begin
	C=0;#20;
	C=1;#20;
end
      
endmodule

