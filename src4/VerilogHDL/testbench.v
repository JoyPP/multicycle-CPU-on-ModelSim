module testbench();
    reg         clk ;
    reg         rst ;
    
    initial
    begin
        clk <= 1 ;
        rst <= 1 ;
        #10   rst <= 0 ;
        
        U_mini_machine.U_MIPS.DATAPATH.U_md.hi <= 32'b0 ;
        U_mini_machine.U_MIPS.DATAPATH.U_md.lo <= 32'b0 ;   
        
       // U_mini_machine.U_TIMER.preset <= 32'd100 ;
       // U_mini_machine.U_TIMER.count <= 32'd100 ;
        //U_mini_machine.HWInt <= 6'b0 ;
        #30000 $stop;
    end
    
    mini_machine  U_mini_machine(clk,rst);
    
    
    
    always   #20 clk = ~clk;
endmodule