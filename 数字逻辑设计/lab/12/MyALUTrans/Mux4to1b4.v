`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:03 11/08/2022 
// Design Name: 
// Module Name:    Mux4to1b4 
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
module Mux4to1b4(
	input[1:0]s,
	input[3:0]I0,
	input[3:0]I1,
	input[3:0]I2,
	input[3:0]I3,
	output reg[3:0]o
    );
	 always@(*)
	 begin
		case(s)
		2'b00:o=I0;
		2'b01:o=I1;
		2'b10:o=I2;
		2'b11:o=I3;
		endcase
	 end
endmodule
