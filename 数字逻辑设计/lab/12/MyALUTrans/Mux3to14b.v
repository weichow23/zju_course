`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:33 12/06/2022 
// Design Name: 
// Module Name:    Mux3to14b 
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
module Mux3to14b(
	input wire[3:0] in1,in2,in3,
	input wire[1:0] op,
	output wire[3:0] out
    );
	assign out=op[1]==1?in3:(op[0]==1?in2:in1);
endmodule
