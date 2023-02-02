`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:39 11/16/2022 
// Design Name: 
// Module Name:    myOR2b4 
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
module myOR2b4(
	input[3:0] A,
	input[3:0] B,
	output[3:0]  C
	);
	assign C=(A|B);
endmodule
