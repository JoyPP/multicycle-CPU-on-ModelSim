module timer(clk,rst,addr,we,din,dout,irq);
    input            clk,rst ;
    input   [3:2]    addr ;
    input            we ;
    input   [31:0]   din ;
    output  [31:0]   dout ;
    output           irq ;      //interrupt request
    
 
    reg   [31:0]   ctrl ;      //control register
    reg   [31:0]   preset ;   //preset data
    reg   [31:0]   count ;
    reg            en_irq ;   //if preset ,en_irq is valid
    wire           state ; //model
    
    parameter   CTRL = 2'b00 , PRESET = 2'b01 , COUNT = 2'b10 ;
     
    assign dout = (addr[3:2] == CTRL)   ? ctrl :
                  (addr[3:2] == PRESET) ? preset :
                  (addr[3:2] == COUNT)  ? count :
                                          32'habcdeeff ;
                                        
    assign state = (ctrl[2:1] == 2'b00) ? 1'b0 :
                   (ctrl[2:1] == 2'b01) ? 1'b1 : 1'bx ;
                                          
    assign irq = !state && (count == 32'b0) && (ctrl[3] == 1'b1) && en_irq ;   //state=0,interrupt permission,count=0
    
    always @(posedge clk)
    begin
        if (rst)
        begin
           ctrl <= 32'b0 ;
           preset <= 32'b0 ;
           count <= 32'b0 ;
        end
        else 
        begin
           if (we)   //if write enable
           case (addr[3:2])
               CTRL   : ctrl <= din ;
               PRESET :
                begin
                   preset = din ;
                   count = preset ;
                   ctrl[0] <= 1 ;
                end 
           endcase
           ctrl[3] = (state) ? 0 : 1 ;
           if ((!state) && count == 32'b0)    //state=0,count=0,count unable
              ctrl[0] <= 0 ;                    //ctrl[0] = enable
           if (ctrl[0] && (count != 32'b0))   //count!=0,count enable
              count <= count - 1 ;
           else if (((count == 32'b0) || (!ctrl[0])) && state)   //state=1,count=0 or count unable
              begin
                 count <= preset ;
                 ctrl[0] <= 1 ;
              end
           
        end
    end
    
    always @(posedge clk)
    begin
        if (rst)
           en_irq <= 0 ;
        else
           en_irq <= (we && (addr[3:2] == PRESET)) ? 1 : en_irq ;
    end
    
endmodule
