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
	input wire [1:0]sw,
	output reg [7:0]num
	);
	
	wire [31:0] div;
	clkdiv cd0(.clkdiv(div),.clk(clk),.rst(1'b0));
	wire [3:0]A,B;
	wire A1,B1;
	wire [1:0] temp_btn;
	
	initial num <= 0;
	
	AddSub4b a0(.A(num[3:0]), .B(4'b1), .Ctrl(sw[0]), .S(A), .Co(A1));
	AddSub4b a1(.A(num[7:4]), .B(4'b1), .Ctrl(sw[1]), .S(B), .Co(B1));

	pbdebounce p0(.clk_1ms(div[17]),.button(btn[0]),.pbreg(temp_btn[0]));
	pbdebounce p1(.clk_1ms(div[17]),.button(btn[1]),.pbreg(temp_btn[1]));
	always@(posedge temp_btn[0]) num[3:0] <=A;
	always@(posedge temp_btn[1]) num[7:4] <=B;

endmodule
