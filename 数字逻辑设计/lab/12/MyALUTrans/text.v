`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:39:29 12/06/2022
// Design Name:   Top
// Module Name:   E:/lab/12/MyALUTrans/text.v
// Project Name:  MyALUTrans
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module text;

	// Inputs
	reg clk;
	reg [15:0] SW;
	reg BTN_Y;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.clk(clk), 
		.SW(SW), 
		.BTN_Y(BTN_Y)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		SW = 0;
		BTN_Y = 0;

		// Wait 100 ns for global reset to finish
		#50;
      SW[15]=1;
		#20
		SW[0]=1;
		SW[1]=1;
		#20
		SW[2]=1;
		SW[3]=1;
	end
	
      
endmodule

