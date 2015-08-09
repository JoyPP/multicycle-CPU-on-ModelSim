module ir(din,IRWr,clk,dout);
    input   [31:0]   din ;//input instruction
    input            IRWr ;//IR write enable
    input            clk ;//clock
    output  [31:0]   dout ;//output instruction
    
    reg   [31:0]   dout ;
    
    always @(negedge clk)
       if (IRWr)
          dout <= din ;
    
    
endmodule
