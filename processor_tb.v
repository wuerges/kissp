module processor_tb();

reg clk;

initial begin
    $dumpvars;

// insn_m.bank[00] = 'b0_0_0_0_0_00000_00000_00000_00000;

#0 
clk = 0;
insn_m.bank[00] = 'b0_0_1_1_0_00001_00001_00000_00000;   // r1 = 1
insn_m.bank[01] = 'b0_0_1_1_0_00010_00010_00000_00000;   // r2 = 2
insn_m.bank[02] = 'b0_0_1_1_0_00011_00011_00000_00000;   // r3 = 3
insn_m.bank[03] = 'b0_0_1_1_0_00000_00100_00010_00011;   // r4 = r2 + r3 # 5
insn_m.bank[04] = 'b1_0_1_0_0_11111_00000_00000_00000;   // b - 2
insn_m.bank[05] = 'b0_0_1_1_0_00000_00100_00100_00100;   // r4 = r4 + r4 # A
insn_m.bank[06] = 'b0_0_0_0_0_00000_00000_00000_00000;  
insn_m.bank[07] = 'b0_0_0_0_0_00000_00000_00000_00000;
insn_m.bank[08] = 'b0_0_0_0_0_00000_00000_00000_00000;
insn_m.bank[09] = 'b0_0_0_0_0_00000_00000_00000_00000;
insn_m.bank[10] = 'b0_0_0_0_0_00000_00000_00000_00000;



#1000 $finish;
end

wire [31:0] pc, insn;

wire [31:0] data_addr, data_in, data_out;
wire m_w;

processor_p p1(
    clk, 
    insn, pc, 
    m_w,
    data_out, // data to write to memory
    data_in,  // data read from memory
    data_addr // address to read/write
    );
memory insn_m(clk, 0, pc, 0, insn);
memory data(clk, m_w, data_addr, data_out, data_in);


always #5 clk = !clk;

endmodule
