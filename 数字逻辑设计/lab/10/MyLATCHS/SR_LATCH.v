`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:38 11/22/2022 
// Design Name: 
// Module Name:    SR_LATCH 
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
module SR_LATCH(R, S,Q,NQ);
	input R, S;
	output Q, NQ;
	wire wq, wnq;
	nand nd1(wq, S, wnq), nd2(wnq, R, wq);
	assign Q = wq;
	assign NQ = wnq;
endmodule
