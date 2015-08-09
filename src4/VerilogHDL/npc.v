`include ".\\head.v"
module npc(PC,imminstr,NPC,turn,pcfour,validbr,jump,aluresult,epc,exlset,pc,exlclr);
    input   [31:2]   PC ;//pc now
    input   [25:0]   imminstr ;//instr[25:0] imm
    input            turn ;
    input            validbr ;
    input   [2:0]    jump ;
    input   [31:0]   aluresult ;
    input   [31:2]   epc ;
    input            exlset ; //exception happen
    input            exlclr ; //return from interrupt
    output  [31:2]   NPC ;//nextpc
    output  [31:2]   pcfour ;//PC+4
    output  [31:2]   pc ;   //pc is send to epc
    
    reg   [31:2]   NPC ;
    reg   [31:2]   pcfour ;
    reg   [31:2]   pc ;
    
    
    //count next pc
    always @(*)
    begin
        if (turn)
           pcfour <= PC + 1 ; 
        if (exlset)
           NPC <= 30'h00001060 ;
        else if (exlclr)
           NPC <= epc ;
        else if (validbr)
           NPC <= {{14{imminstr[15]}},imminstr[15:0]} + PC  ;
        else if ((jump != `Nojump) && (jump != `JR) && (jump != `JALR))
              NPC <= {PC[31:28],imminstr} ;
        else if ((jump == `JR) || (jump == `JALR))
              NPC <= aluresult[31:2] ;
        else if (jump == `Nojump)
              NPC <= PC + 1 ;
              
        pc <= PC ;
      
    end              
    
    
endmodule
