`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:21:13 11/08/2022 
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
	input wire[7:0]SW,
	input wire[3:0]btn,
	output wire[3:0]AN,
	output wire[7:0]SEGMENT
    );
	wire[15:0]num;
	CreatNumber c0(.btn(btn),.num(num));
	//disp_num d0(clk,num,SW[7:4],SW[3:0],1'b0,AN,SEGMENT);
	DisNum d0(.clk(clk),.RST(1'b0),.HEXS(num[15:0]),.LES(SW[7:4]),.points(SW[3:0]),.AN(AN[3:0]),.point(SEGMENT[7]),.LED(SEGMENT[6:0]));
endmodule