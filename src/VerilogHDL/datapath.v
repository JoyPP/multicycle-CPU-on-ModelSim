module datapath(PCWr,IRWr,regdst,alusrc,memtoreg,regwe,memwe,branch,jump,extop,aluop,clk,rst,instr,zero,more,turn);
    input           PCWr ;
    input           IRWr ;
    input   [1:0]   regdst ;
    input           alusrc ;
    input   [1:0]   memtoreg ;
    input           regwe ;
    input           memwe ;
    input   [1:0]   branch ;
    input   [1:0]   jump ;
    input   [1:0]   extop ;
    input   [1:0]   aluop ;
    input           clk,rst ;
    input           turn ;
    output          zero,more ;
    output  [31:0]  instr ;        
    
    wire   [31:2]   PC ;
    wire   [31:2]   NPC ;
    wire   [31:0]   instrw ;
    wire   [31:0]   instr ;
    wire   [31:2]   pcfour ;
    wire   [4:0]    a3 ;   //gpr 3rd source
    wire   [31:0]   rd1,rd2 ;
    wire   [31:0]   extout ;
    wire   [31:0]   A,B ;
    wire   [31:0]   dmdin ;
    wire   [31:0]   result ;
    wire   [31:0]   aluout ;
    wire   [3:0]    be ;
    wire   [31:0]   dmout ;
    wire   [31:0]   drout ;
    wire   [31:0]   dataextout ;
    wire   [31:0]   writedata;
    
    //pc logic
    pc U_PC(NPC,PCWr,clk,rst,PC);
    
    //npc logic
    npc U_NPC(PC,instr[25:0],NPC,turn,pcfour,branch,zero,more,jump,aluout); 
    
    //im logic
    im_4k U_IM(PC[11:2],instrw);
    
    //ir logic
    ir U_IR(instrw,IRWr,clk,instr);
    
    //regfile logic
    mux3_5 mux1(instr[20:16],instr[15:11],5'b11111,regdst,a3);
    mux3_32 mux2(aluout,dataextout,{pcfour,2'b00},memtoreg,writedata);
    regfile U_RF(instr[25:21],instr[20:16],a3,writedata,rd1,rd2,regwe,clk,rst);
    
    //extender logic
    extender U_Ext(instr[15:0],extout,extop);
    
    //ab logic
    ab Asrc(rd1,clk,A);
    ab Bsrc(rd2,clk,dmdin);
    
    //alu logic
    mux2_32 mux3(dmdin,extout,alusrc,B);
    alu U_ALU(A,B,result,aluop,zero,more);
    
    //aluout logic
    aluout U_ALUOUT(result,clk,aluout);
    
    //BEext
    BEext U_BEext(instr[31:26],aluout[1:0],be);
    
    //dm logic
    dm_4k U_DM(aluout[11:2],be,dmdin,memwe,clk,dmout);
    
    //dr logic
    dr U_DR(dmout,clk,drout);
    
    //dataextender logic
    dataext U_DATAEXT(drout,instr[31:26],be,dataextout);
   
endmodule
