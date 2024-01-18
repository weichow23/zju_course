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

module   REG_EX_MEM(input clk,                                      //EX/MEM Latch
                    input rst,
                    input EN,                                       //��ˮ�Ĵ���ʹ��
                    input flush,                                    //�쳣ʱ����쳣ָ��ȴ��жϴ���(����)
                    input [31:0] IR_EX,                             //��ǰִ��ָ��(����)
                    input [31:0] PCurrent_EX,                       //��ǰִ��ָ��洢��ָ��
                    input [31:0] ALUO_EX,                           //��ǰALUִ���������Ч��ַ��ALU����
                    input [31:0] B_EX,                              //ID�������Ĵ���B���ݣ�CPU�������
                    input [4:0]  rs1_EX, rd_EX,                    //���䵱ǰָ��дĿ�ļĴ�����ַ
                    input [31:0] rs1_data_EX,
                    input DatatoReg_EX,                      //���ݵ�ǰָ��REGд����ͨ��ѡ��
                    input RegWrite_EX,                              //���ݵ�ǰָ��Ĵ���д�ź�
                    input WR_EX,                                    //���ݵ�ǰָ��洢����д�ź�
                    input[2:0] u_b_h_w_EX,
                    input mem_r_EX,
                    input csr_rw_EX,
                    input csr_w_imm_mux_EX,
                    input mret_EX,
                    input[1:0] exp_vector_EX,

                    output reg[31:0] PCurrent_MEM,                  //���洫�ݵ�ǰָ���ַ
                    output reg[31:0] IR_MEM,                        //���洫�ݵ�ǰָ��(����)
                    output reg[31:0] ALUO_MEM,                      //����ALU�����������Ч��ַ��ALU����
                    output reg[31:0] Datao_MEM,                     //���洫�ݵ�ǰָ�����mem_r����
                    output reg[4:0]  rd_MEM,                        //���洫�ݵ�ǰָ��дĿ�ļĴ�����ַ
                    output reg[4:0]  rs1_MEM,
                    output reg[31:0] rs1_data_MEM,
                    output reg       DatatoReg_MEM,                 //���洫�ݵ�ǰָ��REGд����ͨ��ѡ��
                    output reg       RegWrite_MEM,                  //���洫�ݵ�ǰָ��Ĵ���д�ź�
                    output reg       WR_MEM,                         //���洫�ݵ�ǰָ��洢����д�ź�
                    output reg[2:0]  u_b_h_w_MEM,
                    output reg       mem_r_MEM,
                    output reg       isFlushed,
                    output reg       csr_rw_MEM,
                    output reg       csr_w_imm_mux_MEM,
                    output reg       mret_MEM,
                    output reg[1:0]  exp_vector_MEM
                );

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            IR_MEM         <= 0;
            PCurrent_MEM   <= 0;
            rd_MEM         <= 0;
            rs1_MEM        <= 0;
            RegWrite_MEM   <= 0;
            WR_MEM         <= 0;
            mem_r_MEM      <= 0;
            isFlushed      <= 0;
            csr_rw_MEM     <= 0;
            mret_MEM       <= 0;
            exp_vector_MEM <= 0;
        end
        else if(EN) begin                                      //EX���������䵽MEM��
            if(flush) begin
                IR_MEM         <= 0;
                PCurrent_MEM   <= PCurrent_EX;
                rd_MEM         <= 0;
                rs1_MEM        <= 0;
                RegWrite_MEM   <= 0;
                WR_MEM         <= 0;
                mem_r_MEM      <= 0;
                isFlushed      <= 1;
                csr_rw_MEM     <= 0;
                mret_MEM       <= 0;
                exp_vector_MEM <= 0;
            end
            else begin
                IR_MEM            <= IR_EX;
                PCurrent_MEM      <= PCurrent_EX;                 //�������浱ǰָ���ַ
                ALUO_MEM          <= ALUO_EX;                     //������Ч��ַ��ALU����
                Datao_MEM         <= B_EX;                        //��������CPU�������
                DatatoReg_MEM     <= DatatoReg_EX;                //��������REGд����ͨ��ѡ��
                RegWrite_MEM      <= RegWrite_EX;                 //��������Ŀ�ļĴ���д�ź�
                WR_MEM            <= WR_EX;                       //��������洢����д�ź�
                rd_MEM            <= rd_EX;                       //��������дĿ�ļĴ�����ַ
                rs1_MEM           <= rs1_EX;
                rs1_data_MEM      <= rs1_data_EX;
                u_b_h_w_MEM       <= u_b_h_w_EX;
                mem_r_MEM         <= mem_r_EX;
                isFlushed         <= 0;
                csr_rw_MEM        <= csr_rw_EX;
                csr_w_imm_mux_MEM <= csr_w_imm_mux_EX;
                mret_MEM          <= mret_EX;
                exp_vector_MEM    <= exp_vector_EX;
            end
        end
    end

endmodule