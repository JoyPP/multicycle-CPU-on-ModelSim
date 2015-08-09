module datapath(PCWr,IRWr,regdst,alusrc,memtoreg,regwe,memwe,validbr,jump,extop,aluop,clk,rst,instr,compare,turn);
    input           PCWr ;
    input           IRWr ;
    input   [1:0]   regdst ;
    input           alusrc ;
    input   [2:0]   memtoreg ;
    input           regwe ;
    input           memwe ;
    input           validbr ;//branch is valid
    input   [2:0]   jump ;
    input   [1:0]   extop ;
    input   [3:0]   aluop ;
    input           clk,rst ;
    input           turn ;   //FSM == s0
    output  [2:0]   compare ;//compare = {zero,more,notless}
    output  [31:0]  instr ;        
    
    wire   [31:2]   PC ;      //pc at now
    wire   [31:2]   NPC ;     //next pc
    wire   [31:0]   instrw ;  //instr from im
    wire   [31:0]   instr ;   //instr from ir
    wire   [31:2]   pcfour ;  //pc+4
    wire   [4:0]    a3 ;      //gpr 3rd source
    wire   [31:0]   rd1,rd2 ;
    wire   [31:0]   extout ;  //data be extended
    wire   [31:0]   A,B ;
    wire   [31:0]   dmdin ;
    wire   [31:0]   result ;   //alu result
    wire   [31:0]   aluout ;   //data from aluout
    wire   [3:0]    be ;       //byte enable
    wire   [31:0]   dmout ;
    wire   [31:0]   drout ;
    wire   [31:0]   dataextout ;
    wire   [31:0]   hi ;
    wire   [31:0]   lo ;
    wire   [31:0]   writedata;
    
    //pc logic
    pc U_PC(NPC,PCWr,clk,rst,PC);
    
    //npc logic
    npc U_NPC(PC,instr[25:0],NPC,turn,pcfour,validbr,jump,aluout); 
    
    //im logic
    im_4k U_IM(PC[11:2],instrw);
    
    //ir logic
    ir U_IR(instrw,IRWr,clk,instr);
    
    //regfile logic
    mux3_5 mux1(instr[20:16],instr[15:11],5'b11111,regdst,a3);
    mux5_32 mux2(aluout,dataextout,{pcfour,2'b00},hi,lo,memtoreg,writedata);
    regfile U_RF(instr[25:21],instr[20:16],a3,writedata,rd1,rd2,regwe,clk,rst);
    
    //extender logic
    extender U_Ext(instr[15:0],extout,extop);
    
    //ab logic
    ab Asrc(rd1,clk,A);
    ab Bsrc(rd2,clk,dmdin);
    
    //mul/div logic
    muldiv md(A,dmdin,clk,instr[31:26],instr[5:0],hi,lo);
    
    //alu logic
    mux2_32 mux3(dmdin,extout,alusrc,B);
    alu U_ALU(A,B,instr[10:6],result,aluop,compare);
    
    //aluout logic
    aluout U_ALUOUT(result,clk,aluout);
    
    //BEext logic
    BEext U_BEext(instr[31:26],aluout[1:0],be);
    
    //dm logic
    dm_8k U_DM(aluout[12:2],be,dmdin,memwe,clk,dmout);
    
    //dr logic
    dr U_DR(dmout,clk,drout);
    
    //dataextender logic
    dataext U_DATAEXT(drout,instr[31:26],be,dataextout);
   
endmodule
