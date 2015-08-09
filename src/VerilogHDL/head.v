    //R-type funct
    `define   addu   6'b100001   
    `define   subu   6'b100011
    `define   slt    6'b101010
    `define   jr     6'b001000
    `define   sltu   6'b101011 
    
    //I-type  opcode
    `define   addi   6'b001000
    `define   addiu  6'b001001
    `define   ori    6'b001101
    `define   slti   6'b001010
    `define   sltiu  6'b001011
    `define   beq    6'b000100
    `define   bne    6'b000101
    `define   j      6'b000010
    `define   jal    6'b000011
    `define   lw     6'b100011
    `define   sw     6'b101011
    `define   lui    6'b001111
    `define   bgtz   6'b000111
    `define   lh     6'b100001  
    `define   lhu    6'b100101
    `define   lb     6'b100000
    `define   lbu    6'b100100
    `define   sh     6'b101001 
    `define   sb     6'b101000

    //[1:0]regdst   
    `define RD 2'b00
    `define RT 2'b01
    `define RA 2'b10
    
    //[1:0]memtoreg
    `define Alu 2'b00
    `define DM 2'b01   
    `define PCfour 2'b10
    
    //[1:0]jump
    `define Nojump 2'b00
    `define J 2'b01
    `define JAL 2'b10
    `define JR 2'b11
    
    //[1:0]extop
    `define O_ExT 2'b00
    `define sign_ExT 2'b01
    `define lui_ExT 2'b10
    
    //[1:0]aluop
    `define ADD 2'b00
    `define SUB 2'b01
    `define OR 2'b10
    `define SLT 2'b11
    
    //[1:0]branch
    `define NoBranch 2'b00
    `define BEQ 2'b01
    `define BGTZ 2'b10
    `define BNE 2'b11
     
