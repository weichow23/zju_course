`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:27 11/22/2022 
// Design Name: 
// Module Name:    D_FLIPFLOP 
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
module D_FLIPFLOP(D,C,R,S,Q,NQ);
    input D,C,R,S;
    output Q,NQ;
    reg Q;//��ʼ�ź�
    always @ (posedge C,R,S)//����������ʱ���������������ź�
    begin
        if(R==0&&S==1)//�첽��λ�źţ�ֻҪ��λ�Ǹߵ�ƽ�ͻḴλ
				Q <=0;
		  else if(R==1&&S==0)
				Q <=1;
        else
				Q <=D;
    end    
	 assign NQ=~Q;
endmodule
