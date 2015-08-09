`include ".\\head.v"
module controller(op,funct,PCWr,IRWr,regdst,alusrc,memtoreg,regwe,memwe,branch,jump,extop,aluop,zero,more,clk,rst,turn);
    input   [5:0]   op;       //6-bit opcode
    input   [5:0]   funct ;   //6-bit function
    input           zero,more ;    //for beq
    input           clk,rst ; //clock,reset
    output          PCWr ;    //pc write enable
    output          IRWr ;    //ir write enable
    output  [1:0]   regdst;   //destinate register
    output          alusrc;   //alu's 2nd data's source
    output  [1:0]   memtoreg; //data's source written into reg 
    output          regwe;    //GPR write enable
    output          memwe;    //dm write enable
    output   [1:0]  branch;   //branch
    output   [1:0]  jump;     //jump
    output   [1:0]  extop;    //extender signal
    output   [1:0]  aluop;    //alu signal
    output          turn ;
 
    wire         load ;
    wire         store ;
    wire         Rtype ;
    wire         Itype ;
    wire         SignExt ;
    wire         Slt ;
    reg   [3:0]  FSM ;
    
    parameter  s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100 ;
    parameter  s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000, s9 = 4'b1001 ;
    
    assign  turn  = (FSM == s0) ; 
    assign  load  = (op == `lw) | (op == `lh) | (op == `lhu) | (op == `lb)|(op == `lbu) ;//lw,lh,lhu,lb,lbu
    assign  store = (op == `sw) | (op == `sh) | (op == `sb) ;//sw,sh,sb
    assign  Rtype = (op == 6'b0) & ((funct == `addu) || (funct == `subu) | (funct == `slt) | (funct == `sltu)) ;
    assign  Itype = (op == `addi) || (op == `addiu) || (op == `ori) || (op == `lui) || (op == `slti) || (op == `sltiu);
    assign  SignExt = (op == `addi) || (op == `addiu) || (op == `beq) || (op == `bne) || (op == `bgtz) || (op == `slti) || (op == `sltiu) ;
    assign  branch = (((FSM == s1) || (FSM == s8)) && (op == `beq)) ?  2'b01 : 
                     (((FSM == s1) || (FSM == s8)) && (op == `bgtz)) ? 2'b10 :
                     (((FSM == s1) || (FSM == s8)) && (op == `bne)) ?  2'b11 :
                                                                      2'b00 ;
                                                                      
    assign  jump = (((FSM == s1) || (FSM == s9)) && (op == `j))  ?   2'b01 :
                   (((FSM == s1) || (FSM == s9)) && (op == `jal)) ?  2'b10 :
                   (((FSM == s1) || (FSM == s9)) && ((op == 6'b0)&(funct == `jr))) ? 2'b11 :2'b00 ;    
    
    assign  Slt = ((op == 6'b0) && ((funct == `slt) || (funct == `sltu))) || (op == `slti) || (op == `sltiu) ;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
           FSM <= s0 ;
        else   
          case(FSM)
              s0:   FSM <= s1 ;
              s1:   begin
                      if (Rtype | Itype)   FSM <= s6 ;
                      else if (branch != `NoBranch)   FSM <= s8 ;
                      else if (jump != `Nojump)   FSM <= s9 ;
                      else    FSM <= s2 ;
                    end
              s2:   begin
                      if (load)   FSM <= s3 ;
                      else if (store)   FSM <= s5 ;
                      else if (Rtype | Itype)   FSM <= s6 ;
                    end  
              s3:   FSM <= s4 ;
              s4:   FSM <= s0 ;
              s5:   FSM <= s0 ;
              s6:   FSM <= s7 ;
              s7:   FSM <= s0 ;
              s8:   FSM <= s0 ;
              s9:   FSM <= s0 ;    
           endcase
    end
       

   assign   PCWr = (FSM == s0) || ((((branch == `BEQ) && zero) || ((branch == `BGTZ) && more) || ((branch == `BNE) && (!zero))) && (FSM == s8)) || (FSM == s9) ;
   assign   IRWr = (FSM == s0) ;
   assign   regdst[1] = (op == `jal) && ((FSM == s1) || (FSM ==s9)) ;
   assign   regdst[0] = Rtype && ((FSM == s1) || (FSM == s6) || (FSM == s7)) ;
   assign   alusrc = load || store || (Itype && ((FSM == s1) || (FSM == s6) || (FSM == s7))) ;
   assign   memtoreg[1] = (op == `jal) ;
   assign   memtoreg[0] = load ;
   assign   regwe = (load && (FSM == s4)) || (FSM == s7) || ((op == `jal) && (FSM == s9)) ;
   assign   memwe = store && (FSM == s5) ;
   assign   extop[1] = (op == `lui) && ((FSM == s1) || (FSM == s6) || (FSM == s7)) ;
   assign   extop[0] = load || store || (SignExt && ((FSM == s1) || (FSM == s6) || (FSM == s7) || (FSM == s8))) ;
   assign   aluop[1] = ((op == `ori) || Slt) && ((FSM == s1) || (FSM == s6) || (FSM == s7)) ;
   assign   aluop[0] = ((((op == 6'b0) && (funct == `subu)) || Slt) && ((FSM == s1) || (FSM == s6) || (FSM == s7))) 
                     || ((branch != `NoBranch) && ((FSM == s1) || (FSM == s8)));    
       
       
endmodule