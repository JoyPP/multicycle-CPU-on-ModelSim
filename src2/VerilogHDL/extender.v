`include ".\\head.v"
module extender(immext,extout,extop);
    input   [15:0]   immext;
    input   [1:0]    extop;
    output  [31:0]   extout;
    
    wire    [31:0]   extout;
    
    mux3_32 mux3_0({16'b0,immext},{{16{immext[15]}},immext},{immext,16'b0},extop,extout);
       
endmodule
