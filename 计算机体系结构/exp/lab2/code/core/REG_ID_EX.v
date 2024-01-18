`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:34:44 03/12/2012
// Design Name:
// Module Name:    REGS ID/EX Latch
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

module    REG_ID_EX(input clk,                                         //ID/EX Latch
                    input rst,
                    input EN,                                          //��ˮ�Ĵ���ʹ��
                    input flush,                                       //���ݾ���������ȴ���DStall
                    input [31:0] IR_ID,                                //��ǰ����ָ��(����)
                    input [31:0] PCurrent_ID,                          //��ǰ����ָ��洢��ָ��
                    input [4:0] rs1_addr,                               //��ǰָ������Ĵ���A��ַ
                    input [4:0] rs2_addr,                               //��ǰָ������Ĵ���B��ַ
                    input [31:0] rs1_data,                             //��ǰָ������Ĵ���A����
                    input [31:0] rs2_data,                             //��ǰָ������Ĵ���A����
                    input [31:0] Imm32,                                //��ǰָ���������չ2λ������
                    input [4:0]  rd_addr,                              //��ǰָ�����Ŀ�Ĳ�������ַ
                    input ALUSrc_A,                             //��ǰָ�����룺ALU Aͨ������
                    input ALUSrc_B,                             //��ǰָ�����룺ALU Bͨ������
                    input [3:0]  ALUC,                                 //��ǰָ�����룺ALU��������
                    input DatatoReg,                            //��ǰָ�����룺REGд����ͨ��ѡ��
                    input RegWrite,                                    //��ǰָ�����룺�Ĵ���д�ź�
                    input WR,                                          //��ǰָ�����룺�洢����д�ź�
                    input [2:0] u_b_h_w,
                    input mem_r,
                    input csr_rw,
                    input csr_w_imm_mux,
                    input mret,
                    input[1:0] exp_vector,

                    output reg[31:0] PCurrent_EX,                      //���浱ǰ����ָ���ַ
                    output reg[31:0] IR_EX,                            //���浱ǰ����ָ��(����)
                    output reg[4:0]  rs1_EX,
                    output reg[4:0]  rs2_EX,
                    output reg[31:0] A_EX,                             //���浱ǰ����ָ������Ĵ���A����
                    output reg[31:0] B_EX,                             //���浱ǰ����ָ������Ĵ���B����
                    output reg[31:0] Imm32_EX,                          //���浱ǰ����ָ��32λ������
                    output reg[4:0]  rd_EX,                            //���浱ǰ����ָ��дĿ�ļĴ�����ַ
                    output reg       ALUSrc_A_EX,                      //���浱ǰ����ָ��ALU Aͨ������
                    output reg       ALUSrc_B_EX,                      //���浱ǰ����ָ��ALU Bͨ������(����)
                    output reg[3:0]  ALUC_EX,                          //���浱ǰ����ָ��ALU�������ܿ���
                    output reg       DatatoReg_EX,                     //���浱ǰ����ָ��REGд����ͨ��ѡ��
                    output reg       RegWrite_EX,                      //���浱ǰ����ָ��Ĵ���д�ź�
                    output reg       WR_EX,                            //���浱ǰ����ָ��洢����д�ź�
                    output reg[2:0]  u_b_h_w_EX,
                    output reg       mem_r_EX,
                    output reg       isFlushed,
                    output reg       csr_rw_EX,
                    output reg       csr_w_imm_mux_EX,
                    output reg       mret_EX,
                    output reg[1:0]  exp_vector_EX
                );

    always @(posedge clk or posedge rst) begin                           //ID/EX Latch
        if(rst) begin
            rd_EX         <= 0;
            RegWrite_EX   <= 0;
            WR_EX         <= 0;
            IR_EX         <= 32'h00000000;
            PCurrent_EX   <= 32'h00000000 ;
            rs1_EX        <= 0;
            rs2_EX        <= 0;
            mem_r_EX        <= 0;
            isFlushed     <= 0;
            csr_rw_EX     <= 0;
            mret_EX       <= 0;
            exp_vector_EX <= 0;
        end
        else if(EN)begin
            if(flush)begin                               //���ݳ�ͻʱ��ˢ��ˮ�߽�ֹ�ı�CPU״̬
                IR_EX         <= 32'h00000000;             //nop,������ǰȡ֬ : ����32'h00000013
                rd_EX         <= 0;                        //cancel Instruction write address
                RegWrite_EX   <= 0;                        //�Ĵ���д�źţ���ֹ�Ĵ���
                WR_EX         <= 0;                        //cancel write memory
                PCurrent_EX   <= PCurrent_ID;              //����PC(����)
                mem_r_EX        <= 0;
                isFlushed     <= 1;
                csr_rw_EX     <= 0;
                mret_EX       <= 0;
                exp_vector_EX <= 0;
            end
            else begin                                       //�����ݳ�ͻ�������䵽EX
                PCurrent_EX      <= PCurrent_ID;              //���ݵ�ǰָ���ַ
                IR_EX            <= IR_ID;                    //���ݵ�ǰָ���ַ(����)
                A_EX             <= rs1_data;                 //���ݼĴ���A��������
                B_EX             <= rs2_data;                 //���ݼĴ���B��������
                Imm32_EX         <= Imm32;                    //������չ��������
                rd_EX            <= rd_addr;                  //����дĿ�ļĴ�����ַ
                rs1_EX           <= rs1_addr;
                rs2_EX           <= rs2_addr;
                ALUSrc_A_EX      <= ALUSrc_A;                 //����ALU Aͨ�������ź�
                ALUSrc_B_EX      <= ALUSrc_B;                 //����ALU Bͨ�������ź�
                ALUC_EX          <= ALUC;                     //����ALU�������ܿ����ź�
                DatatoReg_EX     <= DatatoReg;               //����REGд����ͨ��ѡ��
                RegWrite_EX      <= RegWrite;                 //���ݼĴ���д�ź�
                WR_EX            <= WR;                       //���ݴ洢����д�ź�
                u_b_h_w_EX       <= u_b_h_w;
                mem_r_EX         <= mem_r;
                isFlushed        <= 0;
                csr_rw_EX        <= csr_rw;
                mret_EX          <= mret;
                exp_vector_EX    <= exp_vector;
                csr_w_imm_mux_EX <= csr_w_imm_mux;
            end
        end
    end

endmodule