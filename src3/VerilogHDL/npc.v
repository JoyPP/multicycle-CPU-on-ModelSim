`include ".\\head.v"
module npc(PC,imminstr,NPC,turn,pcfour,validbr,jump,aluresult);
    input   [31:2]   PC ;//pc now
    input   [25:0]   imminstr ;//instr[25:0] imm
    input            turn ;
    input            validbr ;
    input   [2:0]    jump ;
    input   [31:0]   aluresult ;
    output  [31:2]   NPC ;//nextpc
    output  [31:2]   pcfour ;//pc+4
    
    reg   [31:2]   NPC ;
    reg   [31:2]   pcfour ;
    
    
    //count next pc
    always @(*)
    begin
        if (turn)
           pcfour <= PC + 1 ; 
        if (validbr)
           NPC <= {{14{imminstr[15]}},imminstr[15:0]} + PC  ;
        else if ((jump != `Nojump) && (jump != `JR) && (jump != `JALR))
              NPC <= {PC[31:28],imminstr} ;
        else if ((jump == `JR) || (jump == `JALR))
              NPC <= aluresult[31:2] ;
        else if (jump == `Nojump)
              NPC <= PC + 1 ;
      
    end              
    
    
endmodule
