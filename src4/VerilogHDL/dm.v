module dm_4k(addr, be, din, we, clk, dout);
    input   [13:2]   addr ; //aluout[13:2]
    input   [3:0]    be ;   //enable
    input   [31:0]   din ;  //aluout
    input            we ;   //write enable
    input            clk ;  //clock
    output  [31:0]   dout ; //output data
    
    reg   [31:0]   dm[3071:0] ;//32-bit 3072 registers
    
    initial
    $readmemh("data.txt",dm);
    
    //load from dm
    assign dout = dm[addr] ;
      
    //store into dm
    always @(negedge clk)
    begin
        if (we)
        begin
            case(be)
                4'b1111: dm[addr] <= din ;               //sw
                4'b0011: dm[addr][15:0] <= din[15:0] ;   //sh
                4'b1100: dm[addr][31:16] <= din[15:0] ;   
                4'b0001: dm[addr][7:0] <= din[7:0] ;     //sb
                4'b0010: dm[addr][15:8] <= din[7:0] ;
                4'b0100: dm[addr][23:16] <= din[7:0] ;
                4'b1000: dm[addr][31:24] <= din[7:0] ;
            endcase   
        end
    end     
endmodule
