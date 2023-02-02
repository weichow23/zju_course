// Verilog test fixture created from schematic E:\lab\5\D_74LS138\D_74LS138.sch - Tue Nov 01 14:12:25 2022

`timescale 1ns / 1ps

module D_74LS138_D_74LS138_sch_tb();

// Inputs
   reg A;
   reg B;
   reg C;
   reg G;
   reg G2A;
   reg G2B;

// Output
   wire [7:0] Y;

// Bidirs

// Instantiate the UUT
   D_74LS138 UUT (
		.A(A), 
		.B(B), 
		.C(C), 
		.G(G), 
		.G2A(G2A), 
		.G2B(G2B), 
		.Y(Y)
   );
// Initialize Inputs
	integer i;
	initial begin
		B=0;
		A=0;
		C=0;
		G=1;
		G2A=0;
		G2B=0;
		#50;
		
		for(i=0;i<=7;i=i+1) begin
			{C,B,A}=i;
		#50;
		end
		
		assign G=0;
		assign G2A=1;
		assign G2B=0;
		#50;
		
		assign G=1;
		assign G2A=0;
		assign G2B=1;
		#50;
		
	end
		
endmodule
