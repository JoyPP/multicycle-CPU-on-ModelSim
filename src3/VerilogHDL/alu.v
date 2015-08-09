`include ".\\head.v"
module alu(data1,data2,shamt,result,aluop,compare);
    
   input   [31:0]   data1,data2;
   input   [3:0]    aluop;
   input   [4:0]    shamt;
   output  [31:0]   result;
   output  [2:0]    compare;//{zero,more,notless}
   
   wire    [31:0]   result;
   wire             zero;
   wire             more;
   wire             notless;     
   wire    [31:0]   diff;   //data1-data2
   wire    [2:0]    compare;//compare with 0
   wire    [31:0]   shiftbit;//shift choose
   wire             leftshift,rightshift,arithshift;//shift left,right,arithmetic
   
   assign   compare = {zero,more,notless};
   assign   zero = (aluop == `SUB) && (result == 32'b0) ; //==0
   assign   more = (data1[31] != 1) && (data1 != 32'b0) ;// >0
   assign   notless = (data1[31] != 1) ;//>=0
   assign   shiftbit = ((aluop == `SLLV) || (aluop == `SRLV) || (aluop == `SRAV)) ? data1 : {27'b0,shamt} ;
   assign   diff = data1 - data2 ;
   assign   leftshift = (aluop == `SLLV) || (aluop == `SLL) ;
   assign   rightshift = (aluop == `SRLV) || (aluop == `SRL) ;
   assign   arithshift = (aluop == `SRAV) || (aluop == `SRA) ;

   assign   result = (aluop == `ADD)  ? data1 + data2 :
                     (aluop == `SUB)  ? data1 - data2 :
                     (aluop == `OR)   ? data1 | data2 :
                     (aluop == `AND)  ? data1 & data2 :
                     (aluop == `XOR)  ? data1 ^ data2 :
                     (aluop == `NOR)  ? ~(data1 | data2) :
                     (leftshift)      ? data2 << shiftbit :
                     (rightshift)     ? data2 >> shiftbit :
                     (arithshift)     ? (data2 >> shiftbit) | ( {32{data2[31]}} << (32 - shiftbit)) :
                     ((aluop == `SLTI)&&(diff[31] == 1))||((aluop == `SLTU)&&(data1 < data2))  ? 1 : 0 ;
      
endmodule
