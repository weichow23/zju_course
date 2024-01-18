`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/21 14:20:23
// Design Name: 
// Module Name: MEMTEST
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module  CPUTEST(input[31:0]PC_IF,               //IF�׶�PCָ���ź�
                input[31:0]PC_ID,               //ID�׶�PCָ���ź�
                input[31:0]PC_EXE,              //EXE�׶�PCָ���ź�
                input[31:0]PC_MEM,              //MEM�׶�PCָ���ź�
                input[31:0]PC_WB,               //WB�׶�PCָ���ź�
                input[31:0]PC_next_IF,          //IF�׶�next PC
                input[31:0]PCJump,              //UJ/jalr/Bָ����������תPCָ��
                input[31:0]inst_IF,             //IF�׶ζ���ָ��
                input[31:0]inst_ID,             //ID�׶�ִ��ָ��
                input[31:0]inst_EXE,            //EXE�׶�ִ��ָ��
                input[31:0]inst_MEM,            //MEM�׶�ִ��ָ��
                input[31:0]inst_WB,             //WB�׶�ִ��ָ��
                
                input[31:0]RS1DATA,             //rs1�Ĵ��������� (ID�׶�)
                input[31:0]RS2DATA,             //rs2�Ĵ��������� (ID�׶�)
                input[31:0]Imm32,               //ImmGen�������32λ������ (ID�׶�)
                input[31:0]Datai,               //�ⲿ����CPU���� (MEM�׶�)
                input[31:0]Datao,               //CPU������� (��ӦMEM�׶�rs2�Ĵ������)
                input[31:0]Addr,                //CPU�����ַ(��ӦMEM�׶ε�ALU������)
                input[31:0]A,                   //ALU A�˿��������� (EXE�׶�)
                input[31:0]B,                   //ALU B�˿��������� (EXE�׶�)
                input[31:0]ALU_out,             //ALU������ (EXE�׶�)
                input[31:0]WDATA,               //�Ĵ���д������ (WB�׶�)
                input [3:0]ALUC,                //ALU�������ܱ��� (EXE�׶�)
                input [1:0]DatatoReg,           //�Ĵ���дͨ·���� (WB�׶�)
                input [1:0]PCSource,            //��һ��PCѡ���ź� (MEM�׶�)
                input [2:0]ImmSel,              //���������ɶ�·ѡ���ź� (ID�׶�)
                input PCEN,                     //PCʹ���ź�
                input Branch,                   //��ת�ź� (MEM�׶�)
                input ALUSrc_A,                 //�Ĵ���Aͨ������ (EXE�׶�)
                input ALUSrc_B,                 //�Ĵ���Bͨ������ (EXE�׶�)
                input WR,                       //�洢��д�ź� (MEM�׶�)
                input MIO,                      //�洢����д�ź� (MEM�׶�)
                input RegWrite,                 //�Ĵ���д�ź� (WB�׶�)
                input data_hazard,              //���ݳ�ͻ�����ź�
                input control_hazard,           //���Ƴ�ͻ�����ź�
                input[31:0] exp_sig,
                input[4:0]Debug_addr,           //����ʱ���ַ
                output reg [31:0] Test_signal   //�����������
                );

    always @* begin
        case (Debug_addr[4:0])
            0: Test_signal = PC_IF;
            1: Test_signal = inst_IF;
            2: Test_signal = RS1DATA;
            3: Test_signal = RS2DATA;

            4: Test_signal = PC_ID;      
            5: Test_signal = inst_ID;
            6: Test_signal = inst_ID[19:15];    // rs1 address
            7: Test_signal = inst_ID[24:20];    // rs2 address

            8: Test_signal = PC_EXE;      
            9: Test_signal = inst_EXE;    
            10: Test_signal = exp_sig;
            11: Test_signal = PCJump;

            12: Test_signal = PC_MEM; 
            13: Test_signal = inst_MEM;   
            14: Test_signal = {15'h0, Branch, 7'h0, PCEN, 6'h0, PCSource};  
            15: Test_signal = {15'h0, data_hazard, 15'h0, control_hazard}; 

            16: Test_signal = PC_WB;      
            17: Test_signal = inst_WB;        
            18: Test_signal = {14'h0, ImmSel, 7'h0, ALUSrc_A, 7'h0, ALUSrc_B};
            19: Test_signal = PC_next_IF;
                           
            20: Test_signal = A;
            21: Test_signal = ALU_out;
            22: Test_signal = Addr;
            23: Test_signal = ALUC; 

            24: Test_signal = B;
            25: Test_signal = WDATA;
            26: Test_signal = Datai;
            27: Test_signal = {15'h0, WR, 15'h0, MIO};

            28: Test_signal = Imm32;
            29: Test_signal = inst_WB[11:7]; // rd address
            30: Test_signal = Datao;
            31: Test_signal = {15'h0, RegWrite, 14'h0, DatatoReg};
            
            default: Test_signal = 32'hAA55_AA55;
        endcase
    end
                          
endmodule