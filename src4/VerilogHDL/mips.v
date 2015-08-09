module mips(clk,rst,HWInt,be,wen,addr,din,dout);
    input            clk ;
    input            rst ;
    input   [7:2]    HWInt ;
    input   [31:0]   din ;
    output   [3:0]   be ;
    output           wen ;   //write enable
    output  [31:2]   addr ;
    output  [31:0]   dout ;
    
    wire           PCWr ;
    wire           IRWr ;
    wire           CP0Wr ;
    wire   [1:0]   RegDst ;
    wire           ALUSrc ;
    wire   [2:0]   MemtoReg ;
    wire           RegWe ;
    wire           MemWe ;
    wire           ValidBr ;
    wire   [2:0]   Jump ;
    wire   [1:0]   ExtOp ;
    wire   [3:0]   ALUOp ;
    wire   [31:0]  Instr ;
    wire   [2:0]   compare ;
    wire           turn ;   //next instruction start
    wire           cp0sel ; //select cp0's writedata between pc and B
    wire           exlset ,exlclr ;
    wire           IntReq ;
    
     
    controller CONTROL(Instr,PCWr,IRWr,CP0Wr,RegDst,ALUSrc,MemtoReg,RegWe,MemWe,ValidBr,Jump,ExtOp,
                      ALUOp,compare,clk,rst,turn,cp0sel,exlset,exlclr,IntReq,addr,wen);
                      
    datapath   DATAPATH(PCWr,IRWr,CP0Wr,RegDst,ALUSrc,MemtoReg,RegWe,MemWe,ValidBr,Jump,ExtOp,ALUOp,
                      clk,rst,Instr,compare,turn,cp0sel,exlset,exlclr,IntReq,addr,din,dout,HWInt);
    
endmodule
