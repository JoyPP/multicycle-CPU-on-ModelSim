`include ".\\head.v"
module dataext(din,opcode,be,dout);
    input   [31:0]   din ;
    input   [31:26]  opcode ;
    input   [3:0]    be ;
    output  [31:0]   dout ;
    
    reg   [31:0]   dout ;
    
    always @(*)
    begin
        if (opcode == `O_lw) 
           dout <= din ;
        else if (opcode == `O_lh) 
           dout <= ( be == 4'b0011 ) ? {{16{din[15]}},din[15:0]} : 
                   ( be == 4'b1100 ) ? {{16{din[31]}},din[31:16]} :
                                       32'bx;
        else if (opcode == `O_lhu) 
           dout <= ( be == 4'b0011 ) ? {16'b0,din[15:0]} :
                   ( be == 4'b1100 ) ? {16'b0,din[31:16]} :
                                       32'bx;
        else if (opcode == `O_lb)
           dout <= ( be == 4'b0001 ) ? {{24{din[7]}},din[7:0]} :
                   ( be == 4'b0010 ) ? {{24{din[15]}},din[15:8]} :
                   ( be == 4'b0100 ) ? {{24{din[23]}},din[23:16]} :
                   ( be == 4'b1000 ) ? {{24{din[31]}},din[31:24]} :
                                       32'bx;
        else if (opcode == `O_lbu) 
            dout <= ( be == 4'b0001 ) ? {24'b0,din[7:0]} :
                    ( be == 4'b0010 ) ? {24'b0,din[15:8]} :
                    ( be == 4'b0100 ) ? {24'b0,din[23:16]} :
                    ( be == 4'b1000 ) ? {24'b0,din[31:24]} :
                                        32'bx;                           
    end            
           
endmodule
