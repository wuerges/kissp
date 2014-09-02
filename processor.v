
module registers(
    input clk,
    input w,
    input[4:0] dst,
    input[4:0] src1,
    input[4:0] src2,
    input[31:0] w_v,
    output[31:0] src1_v,
    output[31:0] src2_v,
    output[31:0] src3_v
);

reg [31:0] bank [0:31];
assign src1_v = src1 == 0 ? 0 : bank[src1];
assign src2_v = src2 == 0 ? 0 : bank[src2];
assign src3_v = dst  == 0 ? 0 : bank[dst];

always @(negedge clk)
begin
    if (w)
        bank[dst] <= w_v;
end
endmodule


module memory(
    input w,
    input[31:0] addr,
    input[31:0] w_v,
    output[31:0] r_v
);

reg[31:0] bank [0:4096];

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


    //memory data(m_w, alu_out, src3_v, mr_v);
    //memory insn_m(0, pc, 0, insn);

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

