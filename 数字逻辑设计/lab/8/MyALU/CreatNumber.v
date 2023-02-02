`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:11:59 11/08/2022 
// Design Name: 
// Module Name:    CreatNumber 
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
module CreatNumber(
	input wire clk,
	input wire [1:0]btn,
	output reg [7:0]num,
	output C1,
	output [3:0]sum
	);
	
	wire [31:0] div;
	clkdiv cd0(.clkdiv(div),.clk(clk),.rst(1'b0));
	wire [3:0]A,B;
	wire A1,B1;
	wire [1:0] temp_btn;
	
	initial num <= 0;
	
	adder_4bit a0(.FA(num[3:0]), .FB(4'b1), .Cin(1'b0), .Sum(A), .Cout(A1));//A=num[3:0]+1
	adder_4bit a1(.FA(num[7:4]), .FB(4'b1), .Cin(1'b0), .Sum(B), .Cout(B1));//B=num[7:4]+1
	adder_4bit a2(.FA(num[3:0]), .FB(num[7:4]), .Cin(1'b0), .Sum(sum), .Cout(C1));//sum=num[3:0]+num[7:4],进位输出C1和sum

	pbdebounce p0(.clk_1ms(div[17]),.button(btn[0]),.pbreg(temp_btn[0]));
	pbdebounce p1(.clk_1ms(div[17]),.button(btn[1]),.pbreg(temp_btn[1]));
	always@(posedge temp_btn[0]) num[3:0] <=A;
	always@(posedge temp_btn[1]) num[7:4] <=B;

endmodule
