`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:29 11/22/2022 
// Design Name: 
// Module Name:    CSR_LATCH 
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
module CSR_LATCH(
	input R,S,C,
	output Q,NQ
    );
	wire s,r;
	nand m1(s,S,C),m2(r,R,C);
	nand m3(Q,s,NQ),m4(NQ,r,Q);
endmodule
