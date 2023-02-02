// Verilog test fixture created from schematic E:\lab\11\MyCounter\Counter4b.sch - Tue Nov 29 14:20:08 2022

`timescale 1ns / 1ps

module Counter4b_Counter4b_sch_tb();

// Inputs
   reg clk;

// Output
   wire Qa;
   wire Qb;
   wire Qc;
   wire Qd;
   wire Rc;

// Bidirs

// Instantiate the UUT
   Counter4b UUT (
		.clk(clk), 
		.Qa(Qa), 
		.Qb(Qb), 
		.Qc(Qc), 
		.Qd(Qd), 
		.Rc(Rc)
   );
// Initialize Inputs
	initial clk = 0;
	always begin
		#10 clk = ~clk;
	end
endmodule
