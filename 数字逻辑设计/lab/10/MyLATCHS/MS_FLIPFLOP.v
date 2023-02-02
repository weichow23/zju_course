`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:30 11/22/2022 
// Design Name: 
// Module Name:    MS_FLIPFLOP 
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
module MS_FLIPFLOP(
	input S,C,R,
	output Q,NQ
    );
	wire q,nq;
	CSR_LATCH c1(.S(S),.C(C),.R(R),.Q(q),.NQ(nq)),c2(.S(q),.C(~C),.R(nq),.Q(Q),.NQ(NQ));
endmodule
