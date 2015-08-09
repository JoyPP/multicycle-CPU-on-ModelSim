module pc(NPC,PCWr,clk,rst,PC);
    input   [31:2]   NPC ;//nextpc
    input            PCWr ;//PC enable write
    input            clk, rst ;//clock,reset
    output  [31:2]   PC ;   //pc
    
    reg   [31:2]   PC ;
    
    always @(posedge clk or posedge rst)
    begin
        if (rst)
           PC <= 30'h0c00 ;
        else if (PCWr) 
           PC <= NPC ;
    end
    
endmodule
