`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:47:11 11/22/2022
// Design Name:   SR_LATCH
// Module Name:   E:/lab/10/MyLATCHS/text_srlatch.v
// Project Name:  MyLATCHS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SR_LATCH
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text_srlatch;

	// Inputs
	reg R;
	reg S;

	// Outputs
	wire Q;
	wire NQ;

	// Instantiate the Unit Under Test (UUT)
	SR_LATCH uut (
		.R(R), 
		.S(S), 
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
      
endmodule

