
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

wire[31:0] d_r0, d_r1, d_r2, d_r3, d_r4;
assign d_r0 = bank[0];
assign d_r1 = bank[1];
assign d_r2 = bank[2];
assign d_r3 = bank[3];
assign d_r4 = bank[4];

initial begin
	bank[00] = 'b0_0_1_1_0_00001_00001_00000_00000;   // r1 = 1
	bank[01] = 'b0_0_1_1_0_00010_00010_00000_00000;   // r2 = 2
	bank[02] = 'b0_0_1_1_0_00011_00011_00000_00000;   // r3 = 3
	bank[03] = 'b0_0_1_1_0_00000_00100_00010_00011;   // r4 = r2 + r3 # 5
	bank[04] = 'b1_0_1_0_0_11111_00000_00000_00000;   // b - 2
	bank[05] = 'b0_0_1_1_0_00000_00100_00100_00100;   // r4 = r4 + r4 # A
	bank[06] = 'b0_0_0_0_0_00000_00000_00000_00000;  
	bank[07] = 'b0_0_0_0_0_00000_00000_00000_00000;
	bank[08] = 'b0_0_0_0_0_00000_00000_00000_00000;
	bank[09] = 'b0_0_0_0_0_00000_00000_00000_00000;
	bank[10] = 'b0_0_0_0_0_00000_00000_00000_00000;
end


always @(negedge clk)
    if (w)
        bank[dst] <= w_v;
endmodule



module memory(
    input clk,
    input w,
    input[31:0] addr,
    input[31:0] w_v,
    output[31:0] r_v
);

reg[31:0] bank [0:4096];

assign r_v = bank[addr];

always @(negedge clk)
    if (w)
        bank[addr] <= w_v;
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


