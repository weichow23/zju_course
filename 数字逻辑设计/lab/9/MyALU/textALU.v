`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:44:39 11/16/2022
// Design Name:   ALU
// Module Name:   E:/lab/9/MyALU/textALU.v
// Project Name:  MyALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module textALU;

	// Inputs
	reg [1:0] S;
	reg [3:0] A;
	reg [3:0] B;

	// Outputs
	wire [3:0] C;
	wire Co;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.S(S), 
		.A(A), 
		.B(B), 
		.C(C), 
		.Co(Co)
	);

	integer i;
	initial begin
	A=4'b1010; B=4'b0111; S=2'b00; i=0;
	#100;
	B=4'b0011;
	for (i=0; i<=2'b11;i=i+1) begin
		#100;S=i;end
	end
endmodule
