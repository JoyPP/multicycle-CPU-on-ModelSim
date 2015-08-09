module mips(clk,rst);
    input      clk ;
    input      rst ;
    
    wire   [31:26] opcode;
    wire   [5:0]   funct;
    wire           PCWr;
    wire           IRWr;
    wire   [1:0]   RegDst;
    wire           ALUSrc;
    wire   [1:0]   MemtoReg;
    wire           RegWe;
    wire           MemWe;
    wire   [1:0]   Branch;
    wire   [1:0]   Jump;
    wire   [1:0]   ExtOp;
    wire   [1:0]   ALUOp;
    wire   [31:0]  Instr;
    wire           zero,more;
    wire           turn;
    
    assign opcode = Instr[31:26];
    assign funct = Instr[5:0];
    
    controller CONTROL(opcode,funct,PCWr,IRWr,RegDst,ALUSrc,MemtoReg,RegWe,MemWe,Branch,Jump,ExtOp,ALUOp,zero,more,clk,rst,turn);
    datapath   DATAPATH(PCWr,IRWr,RegDst,ALUSrc,MemtoReg,RegWe,MemWe,Branch,Jump,ExtOp,ALUOp,clk,rst,Instr,zero,more,turn);
    
endmodule
