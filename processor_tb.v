module processor_tb();

reg clk;

initial begin
    $dumpvars;

// insn_m.bank[00] = 'b0_0_0_0_0_00000_00000_00000_00000;

#0 
clk = 0;
// load immediate 1 to reg 1
insn_m.bank[00] = 'b0_0_0_1_0_00001_00001_00000_00000;
// load immediate 2 to reg 2
insn_m.bank[01] = 0;
// load immediate 3 to reg 3
insn_m.bank[02] = 0;
insn_m.bank[03] = 0;
insn_m.bank[04] = 0;
insn_m.bank[05] = 0;
insn_m.bank[06] = 0;
insn_m.bank[07] = 0;
insn_m.bank[08] = 0;
insn_m.bank[09] = 0;
insn_m.bank[10] = 0;

#50 $finish;
end

wire [31:0] pc, insn;

wire [31:0] data_addr, data_in, data_out;
wire m_w;

processor p1(
    clk, 
    insn, pc, 
    m_w,
    data_out, // data to write to memory
    data_in,  // data read from memory
    data_addr // address to read/write
    );
memory insn_m(0, pc, 0, insn);
memory data(m_w, data_addr, data_out, data_in);


always #5 clk = !clk;

endmodule