# multicycle-CPU-on-ModelSim
a multicycle CPU done on ModelSim  
the CPU is multicycle and programmed in Verilog

src, src2 and src3 is multicycle CPU
src4 is a MIPS micro system, including multicycle CPU, system bridge, a timer and an exception handler.   

Design Description:

1, the CPU support instructions:   
a) addu, subu, ori, lw, sw, beq, lui.   
b) addi, addiu, slt, j, jal, jr   
c) lb, lbu, lh, lhu, sb, sh, slti  


Based on codes in "src", add some instructions in "src2", the instructions supported:    
a) lb, lbu, lh, lhu, lw   
b) sb, sh, sw   
c) add, addu, addi, addiu, sub, subu   
d) sll, srl, sra, sllv, srlv, srav   
e) and, or, xor, nor, andi, ori, xori, lui, sltiu   
f) beq, bne, blez, bgtz, bltz, bgez  
g) j, jal, jalr, jr     

"src3":   Based on "src2", add multiply and division insturctions:   
h) mult, multu, div, divu   
i) mfhi, mflo, mthi, mtlo     


 "src4":  Base on codes in "src3", add some insturctions:  
j) slt, sltu   
k) eret, mfc0, mtc0   
l) the program is a MIPS micro system, including MIPS CPU, system bridge and a timer   
m) MIPS micro system supports the timer hardware interrupt   

For more information, please read the Experiment Report.   
