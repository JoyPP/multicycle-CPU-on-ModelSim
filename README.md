# multicycle-CPU-on-ModelSim
a multicycle CPU done on ModelSim


Design Description:

1, the CPU support instructions:   
a) addu, subu, ori, lw, sw, beq, lui.   
b) addi, addiu, slt, j, jal, jr   
c) lb, lbu, lh, lhu, sb, sh, slti  


2, the CPU is multicycle and programmed in Verilog   


Based on codes in "src", add some instructions in "src2", the instructions supported:    
a) lb, lbu, lh, lhu, lw   
b) sb, sh, sw   
c) add, addu, addi, addiu, sub, subu   
d) sll, srl, sra, sllv, srlv, srav   
e) and, or, xor, nor, andi, ori, xori, lui, sltiu   
f) beq, bne, blez, bgtz, bltz, bgez  
g) j, jal, jalr, jr    

For more information, please opent the Experiment Report.   
