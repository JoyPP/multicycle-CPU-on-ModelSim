module datapath(PCWr,IRWr,CP0Wr,regdst,alusrc,memtoreg,regwe,memwe,validbr,jump,extop,
            aluop,clk,rst,instr,compare,turn,cp0sel,exlset,exlclr,IntReq,addr,dev_din,dmdin,HWInt);
    input           PCWr ;
    input           IRWr ;
    input           CP0Wr ;
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
    input           cp0sel ;
    input           exlset ,exlclr ;
    input   [31:0]  dev_din ;
    input   [7:2]   HWInt ;
    output  [2:0]   compare ;//compare = {zero,more,notless}
    output  [31:0]  instr ;      
    output          IntReq ;   //interrupt requestion  
    output  [31:2]  addr ;
    output  [31:0]  dmdin ;
    
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
    wire   [31:2]   epc ,pc ;
    wire   [31:0]   cp0data ,cp0read ;//cp0data is data written into cp0,cp0read is reading from cp0
    
    assign addr = aluout[31:2] ;
    
    //pc logic
    pc U_PC(NPC,PCWr,clk,rst,PC);
    
    //npc logic
    npc U_NPC(PC,instr[25:0],NPC,turn,pcfour,validbr,jump,aluout,epc,exlset,pc,exlclr);
    
    //cp0 logic 
    mux2_32 U_mux4({pc,2'b0},dmdin,cp0sel,cp0data) ;
    cp0 U_CP0(cp0data,HWInt,instr[15:11],CP0Wr,exlset,exlclr,clk,rst,IntReq,epc,cp0read);
    
    //im logic
    im_4k U_IM(PC[12:2],instrw);
    
    //ir logic
    ir U_IR(instrw,IRWr,clk,instr);
    
    //regfile logic
    mux3_5 U_mux1(instr[20:16],instr[15:11],5'b11111,regdst,a3);
    mux7_32 U_mux2(aluout,dataextout,{pcfour,2'b00},hi,lo,cp0read,dev_din,memtoreg,writedata);
    regfile U_RF(instr[25:21],instr[20:16],a3,writedata,rd1,rd2,regwe,clk,rst);
    
    //extender logic
    extender U_Ext(instr[15:0],extout,extop);
    
    //ab logic
    ab U_Asrc(rd1,clk,A);
    ab U_Bsrc(rd2,clk,dmdin);
    
    //mul/div logic
    muldiv U_md(A,dmdin,clk,instr[31:26],instr[5:0],hi,lo);
    
    //alu logic
    mux2_32 U_mux3(dmdin,extout,alusrc,B);
    alu U_ALU(A,B,instr[10:6],result,aluop,compare);
    
    //aluout logic
    aluout U_ALUOUT(result,clk,aluout);
    
    //BEext logic
    BEext U_BEext(instr[31:26],aluout[1:0],be);
    
    //dm logic
    dm_4k U_DM(aluout[13:2],be,dmdin,memwe,clk,dmout);
    
    //dr logic
    dr U_DR(dmout,clk,drout);
    
    //dataextender logic
    dataext U_DATAEXT(drout,instr[31:26],be,dataextout);
   
endmodule
