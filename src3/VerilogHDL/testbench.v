module testbench();
    reg         clk ;
    reg         rst ;
    
    initial
    begin
        clk <= 1 ;
        rst <= 1 ;
        #10   rst <= 0 ;
           
        #30000 $stop;
    end
    
    mips  U_mips(clk,rst);
    
    
    
    always   #20 clk = ~clk;
endmodule