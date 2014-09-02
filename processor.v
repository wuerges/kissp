
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

    wire[31:0] insn, src1_v, src2_v, src3_v, alu_out, pc, w_v;

    alu a1(src1_v, src2_v, imm, op, alu_out);
    registers bank(r_w, dst, src1, src2, w_v, 
        src1_v, src2_v, src3_v, pc);


    always @( posedge clk ) begin

    end

endmodule

