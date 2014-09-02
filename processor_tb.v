module processor_tb();

reg clk;

initial begin
    $dumpvars;

#0 
p1.insn_m.bank[00] = 0;
p1.insn_m.bank[01] = 0;
p1.insn_m.bank[02] = 0;
p1.insn_m.bank[03] = 0;
p1.insn_m.bank[04] = 0;
p1.insn_m.bank[05] = 0;
p1.insn_m.bank[06] = 0;
p1.insn_m.bank[07] = 0;
p1.insn_m.bank[08] = 0;
p1.insn_m.bank[09] = 0;
p1.insn_m.bank[10] = 0;

#50 $finish;
end

processor p1(clk);

always #1 clk = !clk;

endmodule
