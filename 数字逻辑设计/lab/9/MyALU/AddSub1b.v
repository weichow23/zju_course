`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:10:22 11/15/2022 
// Design Name: 
// Module Name:    AddSub1b 
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
module AddSub1b(
	input wire a,b,ci,ctrl,
	output wire s,c0
    );
	wire bb;
	xor x1(bb,b,ctrl);
	adder_1bit a0(.a(a),.b(bb),.ci(ci),.s(s),.c0(c0));
endmodule
