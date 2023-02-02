`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:02 11/16/2022 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
	input [1:0] S,
	input [3:0] A,
	input [3:0] B,
	output [3:0] C,
	output Co
    );
	wire [3:0] ss;
	wire co;
	wire [3:0] c1,c2;
	AddSub4b ab1(.Ctrl(S[0]),.B(B[3:0]),.A(A[3:0]),.S(ss[3:0]),.Co(co));
	myAnd2b4 va(.A(A[3:0]),.B(B[3:0]),.C(c1[3:0]));
	myOR2b4 vb(.A(A[3:0]),.B(B[3:0]),.C(c2[3:0]));
   Mux4to1b4 vc(.s(S[1:0]),.I0(ss[3:0]),.I1(ss[3:0]),.I2(c1[3:0]),.I3(c2[3:0]),.o(C[3:0]));
	Mux4to1 vd(.s(S[1:0]),.I0(co),.I1(co),.I2(1'b0),.I3(1'b0),.o(Co));
endmodule
