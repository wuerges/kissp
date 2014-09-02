module processor(
    input clk,
    input[31:0] insn,
    output[31:0] insn_addr,
    
    output data_w,
    output[31:0] data_out,
    input[31:0] data_in,
    output[31:0] data_addr
);
    reg[4:0] src1, src2, dst;
    reg signed[31:0] imm;

    reg r_w, m_w, op, r_src, b;

    wire[31:0] src1_v, src2_v, src3_v, mr_v, alu_out, w_v;
    reg signed [31:0] pc;


    assign insn_addr = pc;

    alu a1(src1_v, src2_v, imm, op, alu_out);
    registers bank(clk, r_w, dst, src1, src2, w_v, 
        src1_v, src2_v, src3_v);
        
    assign w_v  = ~r_src ? alu_out : mr_v;
    assign mr_v = data_in;

    initial begin
        pc = 0;
    end

    always @( posedge clk ) begin
        src1 <= insn[4:0];
        src2 <= insn[9:5];
        dst  <= insn[14:10];
        imm  <= $signed(insn[19:15]);

        m_w  <= insn[20];
        r_w  <= insn[21];
        op   <= insn[22];
        r_src <= insn[23];
        b <= insn[24];

        if (b)
            pc <= pc + w_v;
        else
            pc <= pc + 1;
    end

endmodule

