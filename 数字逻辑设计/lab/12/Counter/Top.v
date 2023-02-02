`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:47 12/06/2022 
// Design Name: 
// Module Name:    Top 
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
module Top(
	input clk,
	input wire[15:0] SW,
	output wire[3:0] regNum,
	output wire out
    );	
	//wire [3:0] Load_A;
	wire Load_A; //�����ź���һλ��
	wire [3:0] A,  A_IN, A1;
	wire [31:0] clk_div;
	MyRegister4b RegA(.clk(clk), .IN(A_IN), .Load(Load_A), .OUT(A));
	Load_Gen m0(.clk(clk), .clk_1ms(clk_div[17]), .btn_in(SW[2]),.Load_out(Load_A));	//�Ĵ���A��Load�ź�
	//Load_Gen m0(.clk(clk), .clk_1ms(clk_div[2]), .btn_in(SW[2]),.Load_out(Load_A));  
	clkdiv m3(clk, 1'b0, clk_div);
	AddSub4b m4(.A(A), .B(4'b0001), .Ctrl(SW[0]), .S(A1));//����/�Լ��߼�
	assign A_IN = (SW[15] == 1'b0)? A1: 4'b0000;	//2ѡ1��·����������λ
	assign regNum = A;  //���ڷ���ʱ�۲����
	assign out=Load_A;
endmodule
	