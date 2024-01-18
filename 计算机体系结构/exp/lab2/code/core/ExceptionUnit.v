`timescale 1ns / 1ps

module ExceptionUnit(
    input clk, rst,
    // csr读写所需的输入输出
    input csr_rw_in,
    input[1:0] csr_wsc_mode_in,
    input csr_w_imm_mux,
    input[11:0] csr_rw_addr_in,
    input[31:0] csr_w_data_reg,
    input[4:0] csr_w_data_imm,
    output[31:0] csr_r_data_out,
    // 中断异常的相关信息
    input interrupt,
    input illegal_inst,
    input l_access_fault,
    input s_access_fault,
    input ecall_m,

    input mret,
    // 这两个epc是用来在中断异常发生的时候设置mepc的
    input[31:0] epc_cur,
    input[31:0] epc_next,
    // 将pc重定向到mtvec或者是mepc里保存的地址的,用来控制进入和退出trap的 
    output[31:0] PC_redirect,
    output redirect_mux,
    // flush流水线寄存器的
    output reg_FD_flush, reg_DE_flush, reg_EM_flush, reg_MW_flush, 
    output RegWrite_cancel //控制flush WB阶段写寄存器
);

    reg[11:0] csr_raddr, csr_waddr;
    reg[31:0] csr_wdata;
    reg csr_w;
    reg[1:0] csr_wsc;

    wire[31:0] mstatus;

    CSRRegs csr(.clk(clk),.rst(rst),.csr_w(csr_w),.raddr(csr_raddr),.waddr(csr_waddr),
        .wdata(csr_wdata),.rdata(csr_r_data_out),.mstatus(mstatus),.csr_wsc_mode(csr_wsc));

    //According to the diagram, design the Exception Unit
    // + --------------------------------------------------- + 
    localparam CSR_MSTATUS = 12'h300;
    localparam CSR_MIE = 12'h304;
    localparam CSR_MTVEC = 12'h305;
    localparam CSR_MEPC = 12'h341;
    localparam CSR_MCAUSE = 12'h342;
    localparam CSR_MTVAL = 12'h343;
    localparam CSR_MIP = 12'h344;

    localparam CSR_WRITE = 2'b01;
    localparam CSR_SET = 2'b10;
    localparam CSR_CLEAR = 2'b11;

    assign trap_in = (interrupt & mstatus[3]) | illegal_inst | l_access_fault | s_access_fault | ecall_m;

    reg [31:0] epc;
    reg [31:0] cause;

    // 3 个状态 : idle, mepc, mcause
    localparam STATE_IDLE = 2'b00;
    localparam STATE_MEPC = 2'b01;
    localparam STATE_MCAUSE = 2'b10;

    reg[1:0] cur_state, next_state;  // 状态机
    
    always@(posedge clk) begin  // 状态转换
        if(rst) begin
            cur_state <= STATE_IDLE;
        end
        else begin
            cur_state <= next_state;
        end
    end

    // record epc and cause at the posedge of trap_in 
    // to prevent epc and cause from being overwritten/flushed
    always @(posedge trap_in) begin
        if (trap_in) begin
            if (interrupt) begin
                epc <= epc_next;
                cause <= 32'h8000000b;
            end
            else if (illegal_inst) begin
                epc <= epc_cur;
                cause <= 32'h00000002;
            end
            else if (l_access_fault) begin
                epc <= epc_cur;
                cause <= 32'h00000005;
            end
            else if (s_access_fault) begin
                epc <= epc_cur;
                cause <= 32'h00000007;
            end
            else if (ecall_m) begin
                epc <= epc_cur;
                cause <= 32'h0000000b;
            end
        end else begin
            epc <= epc;
            cause <= cause;
        end
    end

    always@(*) begin
        case(cur_state)
            STATE_IDLE: begin
                if (trap_in) begin
                    // write mstatus (mstatus[7] = mstatus[3], mstatus[3] = 0)
                    csr_waddr = CSR_MSTATUS;
                    csr_wdata = {mstatus[31:8], mstatus[3], mstatus[6:4], 1'b0, mstatus[2:0]};
                    csr_w = 1'b1;
                    csr_wsc = CSR_WRITE;
                    csr_raddr = CSR_MSTATUS;
                    next_state = STATE_MEPC;
                end else if (mret) begin
                    // write mstatus (mstatus[3] = mstatus[7], mstatus[7] = 1)
                    csr_waddr = CSR_MSTATUS;
                    csr_wdata = {mstatus[31:8], 1'b1, mstatus[6:4], mstatus[7], mstatus[2:0]};
                    csr_w = 1'b1;
                    csr_wsc = CSR_WRITE;
                    // read mepc
                    csr_raddr = CSR_MEPC;
                    next_state = STATE_IDLE;
                end else if (csr_rw_in) begin
                    // csr operations
                    csr_waddr = csr_rw_addr_in;
                    csr_raddr = csr_rw_addr_in;
                    csr_wdata = csr_w_imm_mux ? {27'b0, csr_w_data_imm[4:0]} : csr_w_data_reg;
                    csr_w = 1'b1;
                    csr_wsc = csr_wsc_mode_in;
                    next_state = STATE_IDLE;
                end else begin
                    // do nothing
                    csr_waddr = 12'h0;
                    csr_raddr = 12'h0;
                    csr_wdata = 32'h0;
                    csr_w = 1'b0;
                    csr_wsc = 2'b00;
                    next_state = STATE_IDLE;
                end
            end
            STATE_MEPC: begin
                // write epc to mepc
                csr_waddr = CSR_MEPC;
                csr_wdata = epc;
                csr_w = 1'b1;
                csr_wsc = CSR_WRITE;
                // read mtvec
                csr_raddr = CSR_MTVEC;
                next_state = STATE_MCAUSE;
            end
            STATE_MCAUSE: begin
                // write cause to mcause
                csr_waddr = CSR_MCAUSE;
                csr_wdata = cause;
                csr_w = 1'b1;
                csr_wsc = CSR_WRITE;
                next_state = STATE_IDLE;
            end
        endcase
    end
    
    // pc重定向，pipeline register flush
    assign PC_redirect = csr_r_data_out;
    assign redirect_mux = (cur_state == STATE_MEPC) |           // trap to mtvec
                          ((cur_state == STATE_IDLE) & mret);   // mret to mepc

    assign reg_MW_flush = ((cur_state == STATE_IDLE) & trap_in);
    assign reg_EM_flush = ((cur_state == STATE_IDLE) & trap_in) |
                        ((cur_state == STATE_IDLE) & mret);
    assign reg_DE_flush = ((cur_state == STATE_IDLE) & trap_in) |
                        ((cur_state == STATE_IDLE) & mret);
    assign reg_FD_flush = ((cur_state == STATE_IDLE) & trap_in) |
                        (cur_state == STATE_MEPC) |
                        ((cur_state == STATE_IDLE) & mret);
    assign RegWrite_cancel = ((cur_state == STATE_IDLE) & trap_in & ~(interrupt & mstatus[3]));
    // + --------------------------------------------------- + 
endmodule