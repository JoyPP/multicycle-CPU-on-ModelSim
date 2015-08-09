`include ".\\head.v"
module npc(PC,imminstr,NPC,turn,pcfour,branch,zero,more,jump,aluresult);
    input   [31:2]   PC ;//pc now
    input   [25:0]   imminstr ;//instr[25:0] imm
    input            turn ;
    input   [1:0]    branch ;
    input            zero,more ;
    input   [1:0]    jump ;
    input   [31:0]   aluresult ;
    output  [31:2]   NPC ;//nextpc
    output  [31:2]   pcfour ;//pc+4
    
    reg   [31:2]   NPC ;
    reg   [31:2]   pcfour ;
    
    always @(*)
    begin
        if (turn)
           pcfour <= PC + 1 ; 
        if ((( branch == `BEQ ) && zero) || (( branch == `BGTZ) && more) || (branch == `BNE)&&(!zero))
           NPC <= {{14{imminstr[15]}},imminstr[15:0]} + PC  ;
        else if ((jump != `Nojump)&&(jump != `JR))
              NPC <= {PC[31:28],imminstr} ;
        else if (jump == `JR)
              NPC <= aluresult[31:2] ;
        else if (jump == `Nojump)
              NPC <= PC + 1 ;
      
    end              
    
    
endmodule
