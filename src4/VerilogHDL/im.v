module im_4k(addr,dout);
    input   [12:2]   addr ;
    output  [31:0]   dout ;
    
    reg   [31:0]   im[2047:0] ;
    
    initial
    begin
       $readmemh("code.txt",im);
       $readmemh("yun.txt",im,1120);
    end
    
    assign dout = im[addr - 11'h400] ;
    
endmodule
