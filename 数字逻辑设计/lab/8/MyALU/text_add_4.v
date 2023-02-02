`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:00:07 11/15/2022
// Design Name:   adder_4bit
// Module Name:   E:/lab/8/MyALU/text_add_4.v
// Project Name:  MyALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder_4bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text_add_4;

	// Inputs
	reg [3:0] FA;
	reg [3:0] FB;
	reg Cin;

	// Outputs
	wire [3:0] Sum;
	wire Cout;

	// Instantiate the Unit Under Test (UUT)
	adder_4bit uut (
		.FA(FA), 
		.FB(FB), 
		.Cin(Cin), 
		.Sum(Sum), 
		.Cout(Cout)
	);
	
	integer i,j;
	initial begin
		// Initialize Inputs
		Cin = 1'b1;
		for(i=0; i<16; i=i+1)
			begin
			for(j=0;j<16;j=j+1)
				begin
				FA=i;
				FB=j;
				#50;
				end
			end
	end     
endmodule
