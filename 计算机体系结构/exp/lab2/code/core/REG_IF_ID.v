`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS IF/ID Latch
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

module    REG_IF_ID(input clk,                                      //IF/ID Latch
                    input rst,
                    input EN,                                       //��ˮ�Ĵ���ʹ��
                    input Data_stall,                               //���ݾ����ȴ�
                    input flush,                                    //���ƾ���������ȴ�
                    input [31:0] PCOUT,                             //ָ��洢��ָ��
                    input [31:0] IR,                                //ָ��洢�����

                    output reg[31:0] IR_ID,                         //ȡָ����
                    output reg[31:0] PCurrent_ID,                   //��ǰ����ָ���ַ
                    output reg isFlushed
                );

//reg[31:0]PCurrent_ID,IR_ID;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            IR_ID <= 32'h00000013;                            //��λ����
            PCurrent_ID <= 32'h00000000;                     //��λ����
            isFlushed <= 0;
        end
        else if(EN)begin
            if(Data_stall)begin
                IR_ID <= IR_ID;                          //IR waiting for Data Hazards ����ͣȡָ
                PCurrent_ID <= PCurrent_ID;           //�����ӦPCָ��
                isFlushed <= 0;
            end
            else if(flush)begin
                IR_ID <= 32'h00000013;              //IR waiting for Control Hazards i��s��ָ���ͣ
                PCurrent_ID <= PCurrent_ID;      //���ָ���ָ��(����)
                isFlushed <= 1;
            end
            else begin
                IR_ID <= IR;                       //����ȡָ,������һ��ˮ������
                PCurrent_ID <= PCOUT;           //��ǰȡָPC��ַ��Branch/Junpָ�����Ŀ���ַ��(��PC+4)
                isFlushed <= 0;
            end
        end
    end

endmodule