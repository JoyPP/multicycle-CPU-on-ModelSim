module mips(clk,rst);
    input      clk ;
    input      rst ;
    
    wire           PCWr;
    wire           IRWr;
    wire   [1:0]   RegDst;
    wire           ALUSrc;
    wire   [2:0]   MemtoReg;
    wire           RegWe;
    wire           MemWe;
    wire           ValidBr;
    wire   [2:0]   Jump;
    wire   [1:0]   ExtOp;
    wire   [3:0]   ALUOp;
    wire   [31:0]  Instr;
    wire   [2:0]   compare;
    wire           turn;
    
     
    controller CONTROL(Instr,PCWr,IRWr,RegDst,ALUSrc,MemtoReg,RegWe,MemWe,ValidBr,Jump,ExtOp,ALUOp,compare,clk,rst,turn);
    datapath   DATAPATH(PCWr,IRWr,RegDst,ALUSrc,MemtoReg,RegWe,MemWe,ValidBr,Jump,ExtOp,ALUOp,clk,rst,Instr,compare,turn);
    
endmodule
