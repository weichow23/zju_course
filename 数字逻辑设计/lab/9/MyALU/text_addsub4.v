`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:38:02 11/16/2022
// Design Name:   AddSub4b
// Module Name:   E:/lab/9/MyALU/text_addsub4.v
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

module text_addsub4;

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

	integer i,j,k;
	initial begin
		// Initialize Inputs
		for(i=0; i<16; i=i+1)
			begin
			for(j=0;j<16;j=j+1)
				begin
				A=i;
				B=j;
				for(k=0;k<2;k=k+1)
					begin
					Ctrl=k;
					#50;
					end
				end
			end
	end     
      
endmodule

