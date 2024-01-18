`timescale 1ns / 1ps


module CtrlUnit(
    input[31:0] inst,
    input cmp_res,
    output Branch, ALUSrc_A, ALUSrc_B, DatatoReg, RegWrite, mem_w,
        mem_r, rs1use, rs2use,
    output [1:0] hazard_optype,
    output [2:0] ImmSel, cmp_ctrl,
    output [3:0] ALUControl,
    output JALR, MRET,

    output csr_rw, csr_w_imm_mux,

    output[1:0] exp_vector
);

    wire[6:0] funct7 = inst[31:25];
    wire[2:0] funct3 = inst[14:12];
    wire[6:0] opcode = inst[6:0];

    wire Rop = opcode == 7'b0110011;
    wire Iop = opcode == 7'b0010011;
    wire Bop = opcode == 7'b1100011;
    wire Lop = opcode == 7'b0000011;
    wire Sop = opcode == 7'b0100011;
    wire CSRop = opcode == 7'b1110011;

    wire funct7_0  = funct7 == 7'h0;
    wire funct7_32 = funct7 == 7'h20;

    wire funct3_0 = funct3 == 3'h0;
    wire funct3_1 = funct3 == 3'h1;
    wire funct3_2 = funct3 == 3'h2;
    wire funct3_3 = funct3 == 3'h3;
    wire funct3_4 = funct3 == 3'h4;
    wire funct3_5 = funct3 == 3'h5;
    wire funct3_6 = funct3 == 3'h6;
    wire funct3_7 = funct3 == 3'h7;

    wire ADD  = Rop & funct3_0 & funct7_0;
    wire SUB  = Rop & funct3_0 & funct7_32;
    wire SLL  = Rop & funct3_1 & funct7_0;
    wire SLT  = Rop & funct3_2 & funct7_0;
    wire SLTU = Rop & funct3_3 & funct7_0;
    wire XOR  = Rop & funct3_4 & funct7_0;
    wire SRL  = Rop & funct3_5 & funct7_0;
    wire SRA  = Rop & funct3_5 & funct7_32;
    wire OR   = Rop & funct3_6 & funct7_0;
    wire AND  = Rop & funct3_7 & funct7_0;

    wire ADDI  = Iop & funct3_0;	
    wire SLTI  = Iop & funct3_2;
    wire SLTIU = Iop & funct3_3;
    wire XORI  = Iop & funct3_4;
    wire ORI   = Iop & funct3_6;
    wire ANDI  = Iop & funct3_7;
    wire SLLI  = Iop & funct3_1 & funct7_0;
    wire SRLI  = Iop & funct3_5 & funct7_0;
    wire SRAI  = Iop & funct3_5 & funct7_32;

    wire BEQ = Bop & funct3_0;                            //to fill sth. in 
    wire BNE = Bop & funct3_1;                            //to fill sth. in 
    wire BLT = Bop & funct3_4;                            //to fill sth. in 
    wire BGE = Bop & funct3_5;                            //to fill sth. in 
    wire BLTU = Bop & funct3_6;                           //to fill sth. in 
    wire BGEU = Bop & funct3_7;                           //to fill sth. in 

    wire LB =  Lop & funct3_0;                            //to fill sth. in 
    wire LH =  Lop & funct3_1;                            //to fill sth. in 
    wire LW =  Lop & funct3_2;                            //to fill sth. in 
    wire LBU = Lop & funct3_4;                            //to fill sth. in 
    wire LHU = Lop & funct3_5;                            //to fill sth. in 

    wire SB = Sop & funct3_0;                             //to fill sth. in 
    wire SH = Sop & funct3_1;                             //to fill sth. in 
    wire SW = Sop & funct3_2;                             //to fill sth. in 

    wire LUI   = opcode == 7'b0110111;                    //to fill sth. in 
    wire AUIPC = opcode == 7'b0010111;                    //to fill sth. in 

    wire JAL  = opcode == 7'b1101111;                     //to fill sth. in 
    assign JALR = (opcode == 7'b1100111) & funct3_0;      //to fill sth. in 

    wire CSRRW = CSRop & funct3_1;
    wire CSRRS = CSRop & funct3_2;
    wire CSRRC = CSRop & funct3_3;
    wire CSRRWI = CSRop & funct3_5;
    wire CSRRSI = CSRop & funct3_6;
    wire CSRRCI = CSRop & funct3_7;

    assign MRET = inst == 32'b0011000_00010_00000_000_00000_1110011;
    wire ECALL = inst == 32'b0111_0011;

    wire R_valid = AND | OR | ADD | XOR | SLL | SRL | SRA | SUB | SLT | SLTU;
    wire I_valid = ANDI | ORI | ADDI | XORI | SLLI | SRLI | SRAI | SLTI | SLTIU;
    wire B_valid = BEQ | BNE | BLT | BGE | BLTU | BGEU;
    wire L_valid = LW | LH | LB | LHU | LBU;
    wire S_valid = SW | SH | SB;
    wire CSR_valid = CSRRW | CSRRS | CSRRC | CSRRWI | CSRRSI | CSRRCI;


    assign Branch = (B_valid & cmp_res) | JAL | JALR;                       //to fill sth. in 

    localparam Imm_type_I = 3'b001;
    localparam Imm_type_B = 3'b010;
    localparam Imm_type_J = 3'b011;
    localparam Imm_type_S = 3'b100;
    localparam Imm_type_U = 3'b101;
    assign ImmSel = {3{I_valid | JALR | L_valid}} & Imm_type_I |
                    {3{B_valid}}                  & Imm_type_B |
                    {3{JAL}}                      & Imm_type_J |
                    {3{S_valid}}                  & Imm_type_S |
                    {3{LUI | AUIPC}}              & Imm_type_U ;

    localparam cmp_EQ  = 3'b001;
    localparam cmp_NE  = 3'b010;
    localparam cmp_LT  = 3'b011;
    localparam cmp_LTU = 3'b100;
    localparam cmp_GE  = 3'b101;
    localparam cmp_GEU = 3'b110;    
    assign cmp_ctrl = BEQ ? cmp_EQ  :
                      BNE ? cmp_NE  :
                      BLT ? cmp_LT  :
                      BLTU ? cmp_LTU :
                      BGE ? cmp_GE  :
                      BGEU ? cmp_GEU : cmp_EQ ;            //to fill sth. in

    assign ALUSrc_A = AUIPC | JAL | JALR;                         //to fill sth. in 

    assign ALUSrc_B = I_valid | L_valid | S_valid | AUIPC | LUI;                         //to fill sth. in 

    localparam ALU_ADD  = 4'b0001;
    localparam ALU_SUB  = 4'b0010;
    localparam ALU_AND  = 4'b0011;
    localparam ALU_OR   = 4'b0100;
    localparam ALU_XOR  = 4'b0101;
    localparam ALU_SLL  = 4'b0110;
    localparam ALU_SRL  = 4'b0111;
    localparam ALU_SLT  = 4'b1000;
    localparam ALU_SLTU = 4'b1001;
    localparam ALU_SRA  = 4'b1010;
    localparam ALU_Ap4  = 4'b1011;
    localparam ALU_Bout = 4'b1100;
    assign ALUControl = {4{ADD | ADDI | L_valid | S_valid | AUIPC}} & ALU_ADD  |
                        {4{SUB}}                                    & ALU_SUB  |
                        {4{AND | ANDI}}                             & ALU_AND  |
                        {4{OR | ORI}}                               & ALU_OR   |
                        {4{XOR | XORI}}                             & ALU_XOR  |
                        {4{SLL | SLLI}}                             & ALU_SLL  |
                        {4{SRL | SRLI}}                             & ALU_SRL  |
                        {4{SLT | SLTI}}                             & ALU_SLT  |
                        {4{SLTU | SLTIU}}                           & ALU_SLTU |
                        {4{SRA | SRAI}}                             & ALU_SRA  |
                        {4{JAL | JALR}}                             & ALU_Ap4  |
                        {4{LUI}}                                    & ALU_Bout ;

    assign DatatoReg = L_valid | CSR_valid;

    assign RegWrite = R_valid | I_valid | JAL | JALR | L_valid | LUI | AUIPC | CSR_valid;

    assign mem_w = S_valid;

    assign mem_r = L_valid;

    assign rs1use =  R_valid | I_valid | B_valid | L_valid | S_valid | JALR | CSRRW | CSRRS | CSRRC;                        //to fill sth. in 

    assign rs2use = R_valid | B_valid | S_valid;                         //to fill sth. in 

    localparam HAZARD_NO  = 2'b00 ;
    localparam HAZARD_EX  = 2'b01 ;
    localparam HAZARD_MEM = 2'b10 ;
    localparam HAZARD_ST  = 2'b11 ;
    assign hazard_optype = (R_valid | I_valid | JAL | JALR | LUI | AUIPC) ? HAZARD_EX : 
                           (L_valid | CSR_valid) ? HAZARD_MEM :
                           (S_valid) ? HAZARD_ST : HAZARD_NO;                  //to fill sth. in 
    
    assign csr_rw = CSR_valid;

    assign csr_w_imm_mux = CSRRWI | CSRRSI | CSRRCI ;

    wire illegal_inst = ~(R_valid | I_valid | B_valid | JAL | JALR | L_valid | S_valid |
        LUI | AUIPC | CSR_valid | MRET | ECALL);
    
    assign exp_vector = {illegal_inst, ECALL};

endmodule