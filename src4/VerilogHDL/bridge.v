module bridge(PrAddr,PrRd,PrWd,wen,dev_addr,dev_rd,dev_wd,we_timer);
    input   [31:2]   PrAddr ;
    input   [31:0]   dev_rd ;
    input   [31:0]   PrWd ;
    input            wen ;   //data is coming
    output  [3:2]    dev_addr ;
    output  [31:0]   PrRd ;
    output  [31:0]   dev_wd ;
    output           we_timer ;
    
    wire   we_timer ;
    wire   hit_timer ;
    reg   [3:2]   dev_addr ;
    reg   [31:0]  PrRd ;
    reg   [31:0]  dev_wd ; 
    
    assign we_timer = (PrAddr[31:4] == 28'h00007f0) && (PrAddr[3] == 1'b0) && wen ;
    assign hit_timer = (PrAddr[31:4] == 28'h00007f0) && (PrAddr[3:2] != 2'b11) ;
    
    always @(*)
    begin 
       dev_addr <= PrAddr[3:2] ;
       if (hit_timer)
          PrRd <= dev_rd ;
       if (we_timer)
          dev_wd <= PrWd ;
    end
        
endmodule
