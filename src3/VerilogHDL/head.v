    //R-type funct
    `define   F_add    6'b100000
    `define   F_addu   6'b100001 
      
    `define   F_subu   6'b100011
    `define   F_sub    6'b100010
    
    `define   F_slt    6'b101010
    `define   F_sltu   6'b101011 
    
    `define   F_jr     6'b001000
    `define   F_jalr   6'b001001
    
    `define   F_or     6'b100101
    `define   F_xor    6'b100110
    `define   F_nor    6'b100111
    
    `define   F_and    6'b100100
    
    `define   F_sll    6'b000000
    `define   F_sllv   6'b000100
    `define   F_sra    6'b000011
    `define   F_srav   6'b000111
    `define   F_srl    6'b000010
    `define   F_srlv   6'b000110
    
    `define   F_mult   6'b011000
    `define   F_multu  6'b011001
    `define   F_div    6'b011010
    `define   F_divu   6'b011011
    
    `define   F_mfhi   6'b010000
    `define   F_mflo   6'b010010
    `define   F_mthi   6'b010001
    `define   F_mtlo   6'b010011
    
    
    //I-type  opcode
    `define   O_addi   6'b001000
    `define   O_addiu  6'b001001
    
    `define   O_ori    6'b001101
    `define   O_xori   6'b001110
    
    `define   O_andi   6'b001100
    
    `define   O_slti   6'b001010
    `define   O_sltiu  6'b001011
    
    `define   O_beq    6'b000100
    `define   O_bne    6'b000101
    `define   O_bgtz   6'b000111
    `define   O_blez   6'b000110
    `define   O_bltz   6'b000001
    `define   O_bgez   6'b000001
    
    `define   O_j      6'b000010
    `define   O_jal    6'b000011
    
    `define   O_lw     6'b100011
    `define   O_lh     6'b100001  
    `define   O_lhu    6'b100101
    `define   O_lb     6'b100000
    `define   O_lbu    6'b100100
    
    `define   O_sw     6'b101011
    `define   O_sh     6'b101001 
    `define   O_sb     6'b101000
    
    `define   O_lui    6'b001111

    //[1:0]regdst   
    `define RD 2'b00
    `define RT 2'b01
    `define RA 2'b10
    
    //[2:0]memtoreg
    `define Alu    3'b000
    `define DM     3'b001   
    `define PCfour 3'b010
    `define HI     3'b011
    `define LO     3'b100
    
    //[2:0]jump
    `define Nojump  3'b000
    `define J       3'b001
    `define JAL     3'b010
    `define JR      3'b011
    `define JALR    3'b100
    
    //[1:0]extop
    `define O_ExT    2'b00
    `define sign_ExT 2'b01
    `define lui_ExT  2'b10
    
    //[3:0]aluop
    `define ADD   4'b0000
    `define SUB   4'b0001
    `define OR    4'b0010
    `define SLTI  4'b0011
    `define SLTU  4'b0100
    `define AND   4'b0101
    `define XOR   4'b0110
    `define NOR   4'b0111
    `define SLL   4'b1000
    `define SLLV  4'b1001
    `define SRL   4'b1010
    `define SRLV  4'b1011
    `define SRA   4'b1100
    `define SRAV  4'b1101
    
    
    //[2:0]branch
    `define NoBranch  3'b000
    `define BEQ       3'b001
    `define BGTZ      3'b010
    `define BNE       3'b011
    `define BLEZ      3'b100
    `define BLTZ      3'b101
    `define BGEZ      3'b110
     
