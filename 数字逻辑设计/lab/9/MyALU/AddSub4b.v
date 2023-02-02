`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:31:31 11/15/2022 
// Design Name: 
// Module Name:    AddSub4b 
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
module AddSub4b( Ctrl,B,A,S,Co);
	input wire Ctrl;
	input [3:0] B;
	input [3:0] A;
	output [3:0] S;
	//reg signed [3:0] S;
	output wire Co;
	reg [4:0]sum;
	always@(Ctrl,A,B)
	begin
	if(Ctrl==0)
		sum<=A+B;
	else
	   sum<=A-B;
	end
	assign Co=sum[4];
	assign S=sum[3:0];	
endmodule    

