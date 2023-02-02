`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:53:01 11/22/2022 
// Design Name: 
// Module Name:    D_LATCH 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module D_LATCH(
	input D,C,
	output Q,NQ
    );
	wire s,r;
	nand m1(s,D,C),m2(r,~D,C);
	nand m3(Q,s,NQ),m4(NQ,r,Q);
endmodule
