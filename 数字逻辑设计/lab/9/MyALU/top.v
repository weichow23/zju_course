`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:49:47 11/16/2022 
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
	input wire [1:0]btn,
	input wire [1:0]SW1,
	input wire [1:0]SW2, 
	output wire [3:0]AN,
	output wire [7:0]SEGMENT,
	output wire BTNX4
    );
	 wire[7:0] num;
	 wire[3:0] C;
	 wire Co;
	 
	 assign BTNX4 = 1'b0; //按钮使能
	 CreatNumber m0(.clk(clk),.btn(btn[1:0]),.sw(SW1[1:0]),.num(num[7:0]));
	 ALU m1(.S(SW2[1:0]),.A(num[7:4]),.B(num[3:0]),.C(C),.Co(Co));
	 DisNum m2(.clk(clk),.AN(AN[3:0]),.LED(SEGMENT[6:0]),.point(SEGMENT[7]),.HEXS({3'b0,Co,C,num}),.LES(4'b1111),.points(4'b1111),.RST(1'b0));//LES,points接定值，保持开
endmodule

