module mini_machine(clk,rst) ;
    input      clk ;
    input      rst ;
    
    wire            wen ;   //write enable
    wire   [31:2]   PrAddr ;//address from CPU
    wire   [31:0]   PrRd , PrWd ;
    wire   [31:0]   dev_rd , dev_wd ;
    wire   [3:2]    dev_addr ;
    wire            we_timer ;
    wire   [7:2]    HWInt ; 
    
    mips U_MIPS(clk,rst,{5'b0,HWInt[2]},be,wen,PrAddr,PrRd,PrWd);
    bridge U_BRIDGE(PrAddr,PrRd,PrWd,wen,dev_addr,dev_rd,dev_wd,we_timer) ;
    timer U_TIMER(clk,rst,dev_addr,we_timer,dev_wd,dev_rd,HWInt[2]) ;
    
endmodule
