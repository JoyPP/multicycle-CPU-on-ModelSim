`include ".\\head.v"
module controller(instr,PCWr,IRWr,regdst,alusrc,memtoreg,regwe,memwe,ValidBr,jump,extop,aluop,compare,clk,rst,turn);
    input   [31:0]  instr;      
    input   [2:0]   compare ;  //for branch.COMPARE = {zero,more,notless};
    input           clk,rst ; //clock,reset
    output          PCWr ;    //pc write enable
    output          IRWr ;    //ir write enable
    output  [1:0]   regdst;   //destinate register
    output          alusrc;   //alu's 2nd data's source
    output  [2:0]   memtoreg; //data's source written into reg 
    output          regwe;    //GPR write enable
    output          memwe;    //dm write enable
    output          ValidBr;   //branch
    output   [2:0]  jump;     //jump            
    output   [1:0]  extop;    //extender signal
    output   [3:0]  aluop;    //alu signal
    output          turn ;    //signal of FSM == s0
 
    wire [31:26] op;       //6-bit opcode
    wire [5:0]   funct ;   //6-bit function
    wire [20:16] rt ;      //5-bit rt
    wire  [2:0]  branch ;
    wire         load ;    //load from dm
    wire         store ;   //store into dm
    wire         Rtype ;   //R type
    wire         Itype ;   //I type
    wire         SignExt ; //be sign_extended
    wire         Slti ;    //sign compare
    wire         Sltu ;    //unsign compare
    wire         ShiftRS ; //shift "rs"
    wire         ShiftSHAMT ;//shift "shamt"
    wire         Lroad ;   //load road
    wire         Sroad ;   //store road
    wire         RIroad ;  //R and I road
    wire         Broad ;   //Branch road
    wire         Jroad ;   //Jump road
    wire         ValidBr ; //branch is valid
    wire         And ,Xor ,Or ,Sub;//and,xor,or,sub
    wire         Mul ,Div ,MF ,MT;   //multiplication, division, write into register
    reg   [3:0]  FSM ;
    
    parameter  s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100 ;
    parameter  s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000, s9 = 4'b1001 ;
    
    assign  op = instr[31:26] ;
    assign  funct = instr[5:0] ;
    assign  rt = instr[20:16] ;
    
    assign  Lroad = (FSM == s1) || (FSM == s2) || (FSM == s3) || (FSM == s4) ;
    assign  Sroad = (FSM == s1) || (FSM == s2) || (FSM == s5) ;
    assign  RIroad = (FSM == s1) || (FSM == s6) || (FSM == s7) ;
    assign  Broad = (FSM == s1) || (FSM == s8) ;
    assign  Jroad = (FSM == s1) || (FSM == s9) ;
    assign  ValidBr = ((( branch == `BEQ )&&compare[2])  || (( branch == `BGTZ)&&compare[1])    || 
                      (( branch == `BNE)&&(!compare[2])) || (( branch == `BLEZ)&&(!compare[1])) || 
                      ((branch == `BLTZ)&&(!compare[0])) || (( branch == `BGEZ)&&compare[0])) ;
    
    assign  turn  = (FSM == s0) ; 
    assign  load  = (op == `O_lw) || (op == `O_lh) || (op == `O_lhu) || (op == `O_lb) || (op == `O_lbu) ;//lw,lh,lhu,lb,lbu
    assign  store = (op == `O_sw) || (op == `O_sh) || (op == `O_sb) ;//sw,sh,sb
    assign  Rtype = ((op == 6'b0) && ((funct == `F_add) || (funct == `F_addu) || (funct == `F_sub) || (funct == `F_subu)  || (funct == `F_and) || 
                      (funct == `F_slt) || (funct == `F_sltu) || (funct == `F_or) || (funct == `F_xor) || (funct == `F_nor))) || MF || MT || ShiftRS || ShiftSHAMT || Mul || Div;
                      
    assign  Itype = (op == `O_addi) || (op == `O_addiu) || (op == `O_ori) || (op == `O_xori) || (op == `O_andi) || (op == `O_lui) || (op == `O_slti) || (op == `O_sltiu);
    assign  SignExt = (op == `O_addi) || (op == `O_addiu) || (op == `O_slti) || (op == `O_sltiu) ;
    assign  branch = (Broad && (op == `O_beq))  ?  3'b001 : 
                     (Broad && (op == `O_bgtz)) ?  3'b010 :
                     (Broad && (op == `O_bne))  ?  3'b011 :
                     (Broad && (op == `O_blez)) ?  3'b100 :
                     (Broad && (op == `O_bltz) && (rt == 5'b0)) ?  3'b101 :
                     (Broad && (op == `O_bgez) && (rt == 5'b1)) ?  3'b110 :
                                                                   3'b000 ;
                                                                      
    assign  jump = (Jroad && (op == `O_j))   ?   3'b001 :
                   (Jroad && (op == `O_jal)) ?   3'b010 :
                   (Jroad && ((op == 6'b0) && (funct == `F_jr)))   ? 3'b011 :
                   (Jroad && ((op == 6'b0) && (funct == `F_jalr))) ? 3'b100 : 3'b000 ;    
    
    assign  Slti = ((op == 6'b0) && (funct == `F_slt)) || (op == `O_slti);
    assign  Sltu = ((op == 6'b0) && (funct == `F_sltu)) || (op == `O_sltiu) ;
    assign  ShiftRS = (op == 6'b0) && ((funct == `F_sllv) || (funct == `F_srav) || (funct == `F_srlv)) ;
    assign  ShiftSHAMT = (op == 6'b0) && ((funct == `F_sll) || (funct == `F_sra) || (funct == `F_srl)) ;
    assign  And = (op == `O_andi) || ((op == 6'b0) && (funct == `F_and)) ;
    assign  Xor = (op == `O_xori) || ((op == 6'b0) && (funct == `F_xor)) ;
    assign  Or = (op == `O_ori) || ((op == 6'b0) && (funct == `F_or)) ;
    assign  Sub = (op == 6'b0) && ((funct == `F_subu) || (funct == `F_sub)) ;
    assign  Mul = (op == 6'b0) && ((funct == `F_mult) || (funct == `F_multu)) ;
    assign  Div = (op == 6'b0) && ((funct == `F_div) || (funct == `F_divu)) ;
    assign  MF = (op == 6'b0) && ((funct == `F_mfhi) || (funct == `F_mflo)) ;
    assign  MT = (op == 6'b0) && ((funct == `F_mthi) || (funct == `F_mtlo)) ;
    
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
       

   assign   PCWr = (FSM == s0) || ( ValidBr && (FSM == s8) ) || (FSM == s9) ;
   assign   IRWr = (FSM == s0) ;
   assign   regdst[1] = ((op == `O_jal) || ((op == 6'b0) && (funct == `F_jalr))) && Jroad ;
   assign   regdst[0] = Rtype && RIroad ;
   assign   alusrc = load || store || (Itype && RIroad) ;
   assign   memtoreg[2] = ((op == 6'b0) && (funct == `F_mflo)) || Mul || Div ;
   assign   memtoreg[1] = (op == `O_jal) || ((op == 6'b0) && ((funct == `F_jalr) || (funct == `F_mfhi))) ;
   assign   memtoreg[0] = load || ((op == 6'b0) && (funct == `F_mfhi)) ;
   assign   regwe = (load && (FSM == s4)) || (((Rtype && !Mul && !Div && !MT) || Itype) && (FSM == s7)) || (((op == `O_jal) || ((op == 6'b0) && (funct == `F_jalr))) && (FSM == s9)) ;
   assign   memwe = store && (FSM == s5) ;
   assign   extop[1] = (op == `O_lui) && RIroad ;
   assign   extop[0] = Lroad || Sroad || (SignExt && RIroad) ;
   assign   aluop[3] = (ShiftRS || ShiftSHAMT) && RIroad ;
   assign   aluop[2] = (Sltu || And || Xor || ((op == 6'b0)&&((funct == `F_nor) || (funct == `F_sra) || (funct == `F_srav)))) && RIroad ;
   assign   aluop[1] = (Or || Xor || Slti || ((op == 6'b0)&&((funct == `F_nor) || (funct == `F_srl) || (funct == `F_srlv)))) && RIroad ;
   assign   aluop[0] = ((Sub || Slti || And || ShiftRS || ((op == 6'b0) && (funct == `F_nor))) && RIroad) 
                     || ((branch != `NoBranch) && Broad);    
       
       
endmodule