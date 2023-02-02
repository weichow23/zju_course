`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:28:59 11/15/2022 
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
module adder_1bit(
	input wire a,b,ci,
	output wire s,c0
    );
	wire c1,c2,c3;
	and m0(c1,a,b);
	and m1(c2,b,ci);
	and m2(c3,a,ci);
	xor m3(s1,a,b);
	xor m4(s,s1,ci);
	or m5(c0,c1,c2,c3);
endmodule