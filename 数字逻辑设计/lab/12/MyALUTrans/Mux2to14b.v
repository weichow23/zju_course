`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:48:17 12/06/2022 
// Design Name: 
// Module Name:    Mux2to14b 
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
module Mux2to14b(
	input wire[3:0] in1,
	input wire[3:0] in2,
	input wire op,
	output wire[3:0] out
    );
	assign out=(op==1)?in2:in1;

endmodule
