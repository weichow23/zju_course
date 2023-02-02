`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:53 12/13/2022 
// Design Name: 
// Module Name:    My74LS161 
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
module My74LS161(
	input wire CR,CP,CTP,CTT,Ld,
	input wire[3:0] D,
	output reg[3:0] Q,
	output wire Co
    );
	wire[3:0] a,b;
	assign Co=Q[3]&&Q[2]&&Q[1]&&Q[0]&&CTT;
	assign a=D;
	assign b=Q+4'b0001;
	initial begin
		Q=4'h0; //��ʼ��
	end
	always @(posedge CP or negedge CR) //ʱ�������ش���
		begin
		if(CR==0)
			Q<=4'b0000; //�첽����
		else 
			begin
			if(Ld==0) Q<=a;
			else if(CTT && CTP) Q<=b;//��������һ
			else Q<=Q;//���ֳ�ֵ
			end
		end
endmodule
