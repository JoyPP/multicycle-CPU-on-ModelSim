module cp0(din,HWInt,writereg,CP0Wr,exlset,exlclr,clk,rst,IntReq,epc,dout);
    input   [31:0]   din ;
    input   [7:2]    HWInt ;
    input   [15:11]  writereg ;   //rd
    input            CP0Wr ;   //cp0 write enable
    input            exlset ,exlclr ;   //set exl , clear exl
    input            clk ,rst ;
    output           IntReq ;
    output  [31:2]   epc ;
    output  [31:0]   dout ;
    
    reg   [31:0]   SR ;
    reg   [31:0]   Cause ;
    reg   [31:2]   epc ;
    reg   [15:10]  ip ;
    reg   [15:10]  im ;
    reg            exl ,ie ;
    reg   [31:0]   PrID ;
    
    assign  IntReq = | (HWInt[7:2] & im[15:10]) && !exl && ie ;
    
    always @(*)
    begin
       {im,exl,ie} = {SR[15:10],SR[1],SR[0]} ;
       Cause = HWInt[7:2] ;
       ip = Cause[15:10] ;
    end
    
    always @(posedge clk)
    begin
        if (rst)
        begin
            epc <= 30'b0 ;
            Cause <= 32'b0 ;
            SR <= 32'h00fc01;
            PrID <= 32'heeeeeeee ;
        end
        else
        begin
           if (CP0Wr && (writereg == 5'd12))
              SR <= din ;
           if (CP0Wr && (writereg == 5'd13))
              Cause <= din ;
           if (exlset)
           begin
              epc <= din[31:2] ;
              exl <= 1'b1 ;
              ie <= 1'b0 ;
           end
           else if (exlclr)
           begin
              exl <= 1'b0 ;
              ie <= 1'b1 ;
           end
        end
    end
    
    assign dout = (writereg == 5'd12) ? {16'b0,im,8'b0,exl,ie} :
                  (writereg == 5'd13) ? {16'b0,ip,10'b0} :
                  (writereg == 5'd14) ? {epc,2'b0} :
                  (writereg == 5'd15) ? {32'hffffffff} :
                  32'b0 ;
   
endmodule
