`include ".\\head.v"
module alu(data1,data2,result,aluop,zero,more);
    
   input   [31:0]   data1,data2;
   input   [1:0]    aluop;
   output  [31:0]   result;
   output           zero,more;
   
   wire    [31:0]   result;
   wire             zero,more;
   wire    [31:0]   cha;
   
   assign   zero = (aluop == `SUB) && (result == 32'b0); 
   assign   more = (data1[31] != 1) && (data1 != 32'b0);
   assign   cha = data1 - data2 ;
   

   assign   result = (aluop == `ADD) ? data1 + data2 :
                     (aluop == `SUB) ? data1 - data2 :
                     (aluop == `OR)  ? data1 | data2 :
                     (cha[31] == 1) ? 1 : 0 ;
      
endmodule
