`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:09:35 12/08/2022
// Design Name:   Top
// Module Name:   E:/lab/12/Counter/texttop.v
// Project Name:  Counter
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

module texttop;

	// Inputs
	reg clk;
	reg [15:0] SW;

	// Outputs
	wire [3:0] regNum;
	wire out;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.clk(clk), 
		.SW(SW), 
		.regNum(regNum), 
		.out(out)
	);
	
	initial forever begin
	 clk=0;#20;
	 clk=1;#20;
	end
	initial forever begin
	 SW[2]=0;#30;
	 SW[2]=1;#30;
	end
	initial begin		
		SW=0;
		#10;
		SW[15]=1;
		#100;
		SW[15]=0;
		SW[0]=0;
		#10;
		// Add stimulus here		
	end      
endmodule

