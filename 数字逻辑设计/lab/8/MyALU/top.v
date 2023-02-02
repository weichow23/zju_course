`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:21:46 11/15/2022 
// Design Name: 
// Module Name:    top 
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
module top(
	input wire clk,
	input wire [7:0]SW,
	input wire [1:0]btn,
	output wire [3:0]AN,
	output wire [7:0]SEGMENT
    );
	 wire [7:0]num;
	 wire [3:0]sum;
	 wire C1;
	 CreatNumber c0(.btn(btn), .num(num),
	 .clk(clk),
	 .sum(sum),
	 .C1(C1));
	 DisNum d0(.clk(clk),.HEXS({3'b0,C1,sum,num}),.LES(SW[7:4]),
	 .points(SW[3:0]),.RST(1'b0),.AN(AN),
	 .LED(SEGMENT[6:0]),.point(SEGMENT[7]));
endmodule
