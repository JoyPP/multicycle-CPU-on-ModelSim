/////////////////////////////////////////////////////////////////////////////////////////////
//description:this part is about arithmetic of multiplication and division
//
//by:fpp   2014.02.04
//
/////////////////////////////////////////////////////////////////////////////////////////////
 
`include ".\\head.v"
module muldiv(da,db,clk,op,funct,hi,lo);
    input   [31:0]   da ;
    input   [31:0]   db ;
    input            clk ;   //clock
    input   [31:26]  op ;
    input    [5:0]   funct ;    
    output  [31:0]   hi ;
    output  [31:0]   lo ;
    
    reg   [31:0]   hi ;
    reg   [31:0]   lo ;
    wire  [31:0]   a,b ;
    
    assign a = (~da) + 1 ;   // a = -da
    assign b = (~db) + 1 ;   // b = -db
    
    always @(posedge clk)
    begin
        if ((op == 6'b0) && (funct == `F_multu))
           {hi,lo} <= da * db ;
           
        else if ((op == 6'b0) && (funct == `F_mult))
        begin
            if ((da[31] == 1) && (db[31] == 1))
               {hi,lo} <= a * b ;
            else if ((da[31] == 1) && (db[31] != 1))
               {hi,lo} <= ~(a * db) + 1 ;
            else if ((da[31] != 1) && (db[31] == 1))
               {hi,lo} <= ~(da * b) + 1 ;
            else   {hi,lo} <= da * db ;
        end
        
        else if ((op == 6'b0) && (funct == `F_divu))
        begin
           lo <= da / db ;
           hi <= da % db ;
        end
        
        else if ((op == 6'b0) && (funct == `F_div))
        begin
            if ((da[31] == 1) && (db[31] == 1))
            begin
               lo <= a / b ;
               hi <= da - (db * lo) ;
            end
            else if ((da[31] != 1) && (db[31] == 1))
            begin
               lo <= (~(da / b)) + 1 ;
               hi <= da - (b * (da / b)) ;
            end
            else if ((da[31] == 1) && (db[31] != 1))
            begin
               lo <= (~(a / db)) + 1 ;
               hi <= da + (db * (a / db)) ;
            end       
            else   
            begin
               lo <= da / db ;
               hi <= da % db ;
            end     
        end
        
        else if ((op == 6'b0) && (funct == `F_mthi))
           hi <= da ;
           
        else if ((op == 6'b0) && (funct == `F_mtlo))
           lo <= da ;
           
    end
    
endmodule
