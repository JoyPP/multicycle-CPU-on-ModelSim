module aluout(din,clk,dout);
    input   [31:0]   din ;
    input            clk ;
    output  [31:0]   dout ;
    
    reg   [31:0]   dout ;
    
    always @(posedge clk)
       dout <= din ;
    
    
endmodule
