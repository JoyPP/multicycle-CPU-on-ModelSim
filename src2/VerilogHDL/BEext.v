`include ".\\head.v"
module BEext(opcode,aluout,be);
    input   [31:26] opcode ;//opcode  
    input   [1:0]   aluout ;//aluout last 2-bit
    output  [3:0]   be ;//

    reg   [3:0]   be ;
    
    always @(*)
    begin
        if (opcode == `sw | opcode == `lw)
           be <= 4'b1111 ;
        else if (opcode == `sh | opcode == `lh | opcode == `lhu)
           be <= (aluout[1] == 0) ? 4'b0011 :
                 (aluout[1] == 1) ? 4'b1100 :
                                    4'bxxxx ;
        else if (opcode == `sb | opcode == `lb | opcode == `lbu)
           be <= (aluout == 2'b00) ? 4'b0001 :
                 (aluout == 2'b01) ? 4'b0010 :
                 (aluout == 2'b10) ? 4'b0100 :
                 (aluout == 2'b11) ? 4'b1000 :
                                     4'bxxxx ;          
   end
endmodule