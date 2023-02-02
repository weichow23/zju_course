`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:02:46 11/22/2022
// Design Name:   CSR_LATCH
// Module Name:   E:/lab/10/MyLATCHS/test_csr.v
// Project Name:  MyLATCHS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CSR_LATCH
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_csr;

	// Inputs
	reg R;
	reg S;
	reg C;

	// Outputs
	wire Q;
	wire NQ;

	// Instantiate the Unit Under Test (UUT)
	CSR_LATCH uut (
		.R(R), 
		.S(S), 
		.C(C), 
		.Q(Q), 
		.NQ(NQ)
	);

	initial begin
	C=1;R=1;S=1; #50;
	R=1;S=0; #50;
	R=1;S=1; #50;
	R=0;S=1; #50;
	R=1;S=1; #50;
	R=0;S=0; #50;
	R=1;S=1; #50;	 
	C=0;R=1;S=1; #50;
	R=1;S=0; #50;
	R=1;S=1; #50;
	R=0;S=1; #50;
	R=1;S=1; #50;
	R=0;S=0; #50;
	R=1;S=1; #50;
	end
      
endmodule

