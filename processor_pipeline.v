
module processor_pipeline(
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
        
    initial begin
        pc = 0;
    end


    reg[4:0] dst_s2;
    reg[31:0] alu_out_s2, src3_v_s2;
    reg r_w_s2, m_w_s2, r_src_s2;

    assign mr_v = data_in;
    assign data_out = src3_v_s2;
    assign data_addr = alu_out_s2;
    assign data_w = m_w_s2;
    assign w_v  = ~r_src_s2 ? alu_out_s2 : mr_v;

    registers bank(clk, r_w_s2, dst_s2, src1, src2, w_v, 
        src1_v, src2_v, src3_v);


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
            pc <= pc + alu_out;
        else
            pc <= pc + 1;

        /* Wall
        */
       alu_out_s2 <= alu_out;
       src3_v_s2 <= src3_v;
       m_w_s2 <= m_w;
       r_w_s2 <= r_w;
       r_src_s2 <= r_src;
       dst_s2 <= dst;
    end

endmodule

