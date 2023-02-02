`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:11:48 12/08/2022
// Design Name:   Top
// Module Name:   E:/lab/12/MyALUTrans/texttop.v
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

module texttop;

	// Inputs
	reg clk;
	reg RST;
	reg [15:0] SW;

	// Outputs
	wire [3:0] Aoutput;
	wire [3:0] Boutput;
	wire [3:0] Coutput;
	wire LoadA;
	wire LoadB;
	wire LoadC;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.clk(clk), 
		.RST(RST), 
		.SW(SW), 
		.Aoutput(Aoutput), 
		.Boutput(Boutput), 
		.Coutput(Coutput), 
		.LoadA(LoadA), 
		.LoadB(LoadB), 
		.LoadC(LoadC)
	);
	initial forever begin
	 clk=0;#10;
	 clk=1;#10;
	end
	initial forever begin
	 SW[2]=0;SW[3]=0;SW[4]=0;
	 #30;
	 SW[2]=1;SW[3]=1;SW[4]=1;
	 #10;
	end
	initial forever begin
	 RST=0;#500;
	 RST=1;#50;
	 RST=1;
	end
	initial begin
		// Initialize Inputs
		SW = 0;
		//RST=0;
		// Wait 100 ns for global reset to finish
		#10;
		SW[15]=1;
		SW[1]=1;
		SW[5]=1;
		#600
		SW[15]=0;
		SW[8]=1;
		//#400;
	end

endmodule
