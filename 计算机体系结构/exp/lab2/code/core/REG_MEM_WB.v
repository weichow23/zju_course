`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS EX/MEM Latch
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
module   REG_MEM_WB(input clk,                                      //MEM/WB Latch
                    input rst,
                    input EN,                                       //��ˮ�Ĵ���ʹ��
                    input [31:0] IR_MEM,                             //��ǰִ��ָ��(����)
                    input [31:0] PCurrent_MEM,                       //��ǰִ��ָ��洢��ָ��
                    input [31:0] ALUO_MEM,                           //��ǰALUִ���������Ч��ַ��ALU����
                    input [31:0] Datai,                              //MIOl����CPU����
                    input [4:0]  rd_MEM,                             //���ݵ�ǰָ��дĿ�ļĴ�����ַ
                    input DatatoReg_MEM,                      //���ݵ�ǰָ��REGд����ͨ��ѡ��
                    input RegWrite_MEM,                              //���ݵ�ǰָ��Ĵ���д�ź�
                    input flush,
                    input [3:0]  exp_vector_MEM,
                    output reg[31:0] PCurrent_WB,                  //���洫�ݵ�ǰָ���ַ
                    output reg[31:0] IR_WB,                        //���洫�ݵ�ǰָ��(����)
                    output reg[31:0] ALUO_WB,                      //����ALU�����������Ч��ַ��ALU����
                    output reg[31:0] MDR_WB,                       //����MIO��CPU��������
                    output reg[4:0]  rd_WB,                        //���洫�ݵ�ǰָ��дĿ�ļĴ�����ַ
                    output reg       DatatoReg_WB,                 //���洫�ݵ�ǰָ��REGд����ͨ��ѡ��
                    output reg       RegWrite_WB,                  //���洫�ݵ�ǰָ��Ĵ���д�ź�
                    output reg       isFlushed,
                    output reg[3:0]  exp_vector_WB
                );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rd_WB         <= 0;
            RegWrite_WB   <= 0;
            IR_WB         <= 0;
            PCurrent_WB   <= 0;
            isFlushed     <= 0;
            exp_vector_WB <= 0;
        end
        else if(EN)begin                                      //EX���������䵽MEM��
            if(flush) begin
                IR_WB         <= 0;
                PCurrent_WB   <= PCurrent_MEM;  
                rd_WB         <= 0;
                RegWrite_WB   <= 0;
                isFlushed     <= 1;
                exp_vector_WB <= 0;
            end
            else begin
                IR_WB         <= IR_MEM;
                PCurrent_WB   <= PCurrent_MEM;            ////MEM/WB.PC
                ALUO_WB       <= ALUO_MEM;                    //ALU�������дĿ�ļĴ�������
                MDR_WB        <= Datai;                      //�洢���������ݣ�дĿ�ļĴ���
                rd_WB         <= rd_MEM;                        //дĿ�ļĴ�����ַ
                RegWrite_WB   <= RegWrite_MEM;            //�Ĵ���д�ź�
                DatatoReg_WB  <= DatatoReg_MEM;          //REGд����ͨ��ѡ��
                isFlushed     <= 0;
                exp_vector_WB <= exp_vector_MEM;
            end
        end
    end
endmodule