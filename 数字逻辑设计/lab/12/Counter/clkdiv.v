`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:53:31 11/08/2022 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
	input clk,
	input rst,
	output reg[31:0]clkdiv
    );
	reg[31:0] clkdiv2=0;
	always@(posedge clk or posedge rst) 
		begin
			if(rst) clkdiv2 <=0;
			else clkdiv2 <=clkdiv2+1'b1;
			clkdiv<=clkdiv2;	
		end
endmodule