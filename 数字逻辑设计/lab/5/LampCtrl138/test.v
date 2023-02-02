// Verilog test fixture created from schematic E:\lab\5\LampCtrl138\LampCtrl138.sch - Tue Nov 01 16:04:43 2022

`timescale 1ns / 1ps

module LampCtrl138_LampCtrl138_sch_tb();

// Inputs
   reg S1;
   reg S2;
   reg S3;

// Output
   wire F;

// Bidirs

// Instantiate the UUT
   LampCtrl138 UUT (
		.S1(S1), 
		.S2(S2), 
		.S3(S3), 
		.F(F)
   );
// Initialize Inputs
	integer i;
	initial begin
		for(i=0;i<=8;i=i+1)begin
			{S3,S2,S1} <= i;
			#50;
		end
	end
endmodule
