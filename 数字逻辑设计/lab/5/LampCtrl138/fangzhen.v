// Verilog test fixture created from schematic E:\lab\5\LampCtrl138\LampCtrl138.sch - Tue Nov 01 15:53:59 2022

`timescale 1ns / 1ps

module LampCtrl138_LampCtrl138_sch_tb();

// Inputs
   reg XLXN_26;
   reg XLXN_27;
   reg XLXN_29;
   reg XLXN_30;
   reg XLXN_31;
   reg XLXN_32;

// Output
   wire XLXN_38;

// Bidirs

// Instantiate the UUT
   LampCtrl138 UUT (
		.XLXN_26(XLXN_26), 
		.XLXN_27(XLXN_27), 
		.XLXN_29(XLXN_29), 
		.XLXN_30(XLXN_30), 
		.XLXN_31(XLXN_31), 
		.XLXN_32(XLXN_32), 
		.XLXN_38(XLXN_38)
   );
// Initialize Inputs
	 integer i;
	 initial begin
		for(i=0;i<=8;i=i+1)
			begin
			{S3,S2,S1} <= i;
			#50;
		end
	end
endmodule
