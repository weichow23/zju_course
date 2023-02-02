`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:29 11/08/2022
// Design Name:   MyMC14495
// Module Name:   E:/lab/6/MyMC14495/test.v
// Project Name:  MyMC14495
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MyMC14495
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

// Inputs
	reg [3:0] D;
	reg LE;
	reg Point;

	// Outputs
	wire [6:0] LED;
	wire p;

	// Instantiate the Unit Under Test (UUT)
	MyMC14495 uut (
		.D(D), 
		.LE(LE), 
		.Point(Point), 
		.LED(LED), 
		.p(p)
	);

	integer i;
	initial begin
		D = 4'b0000;
		LE = 1;
		Point = 0;
		
		for (i=0; i<=15;i=i+1) begin
			D = i;
			Point = i;
		#50;
		end
		
		#50;
		LE = 0;
	end
      
endmodule

