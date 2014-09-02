
module registers(
    input w,
    input[4:0] dst,
    input[4:0] src1,
    input[4:0] src2,
    input[31:0] w_v,
    output[31:0] src1_v,
    output[31:0] src2_v,
    output[31:0] src3_v,
    output[31:0] reg_31
);

reg [31:0] bank [0:31];

assign src1_v = bank[src1];
assign src2_v = bank[src2];
assign src2_v = bank[dst];
assign reg_31 = bank[0];

always @(w, dst, w_v)
    if (w)
        bank[dst] = w_v;

endmodule


module memory(
    input w,
    input[31:0] addr,
    input[31:0] w_v,
    output[31:0] r_v
);

reg[31:0] bank [0:31];

assign r_v = bank[addr];

always @(w, addr, w_v)
    if (w)
        bank[addr] = w_v;

endmodule


module alu(
    input signed [31:0] src1_v,
    input signed [31:0] src2_v,
    input signed [31:0] src3_v,
    input op,
    output signed [31:0] out
);

assign out = op ? 
                src1_v + src2_v + src3_v : 
                src1_v - src2_v + src3_v;
endmodule


module processor(
    input clk
);
    reg[4:0] src1, src2, dst;
    reg signed[4:0] imm;
    reg r_w, m_w, op, r_src;

    wire[31:0] src1_v, src2_v, src3_v, alu_out, pc, w_v, mr_v;
    wire[31:0] insn;

    assign w_v = r_src ? alu_out : mr_v;

    alu a1(src1_v, src2_v, imm, op, alu_out);
    registers bank(r_w, dst, src1, src2, w_v, 
        src1_v, src2_v, src3_v, pc);

    memory data(m_w, alu_out, src3_v, mr_v);
    memory insn_m(0, pc, 0, insn);


    always @( posedge clk ) begin
        src1 = insn[4:0];
        src2 = insn[9:5];
        dst  = insn[14:10];
        imm  = insn[19:15];
        m_w  = insn[20];
        r_w  = insn[21];
        op   = insn[22];
        r_src = insn[23];
    end

endmodule

