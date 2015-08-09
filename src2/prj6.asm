# MARS的memory configura应选择第2个模式，即“Compact, Data at Address 0”
    .data
array: .word  0 : 24                # "array" of 20 words
size: .byte  0                      # size of "array" 
      
    .text
    
    la      $sp, array              # $sp: point to the base address of array
    addi    $sp, $sp, 0x100         # set the start address of stack
    la      $s0, array

Test_Begin :
    lui     $t1, 0xedca
    sw      $t1, 0($s0)
    addi    $s0, $s0, 4
    bgtz    $t1, Test_B_Err
    bgez    $t1, Test_B_Err
    
    lui     $t1, 0xafad
    sw      $t1, 0($s0)
    addi    $s0, $s0, 4
    slti    $t2, $t1, 0
    beq     $t2, $zero, Test_B_Err     
    
    lui     $t1, 0xcadb
    sw      $t1, 0($s0)
    addi    $s0, $s0, 4
    blez    $t1, Test_Continue

Test_B_Err :
    j       Test_B_Err
    
Test_Continue :    
    la      $s0, array
    
    addi    $s0, $s0, 32            
    move    $a0, $s0
    jal     F_TEST_LOADSTORE
    
    addi    $s0, $s0, 32            
    move    $a0, $s0
    jal     F_TEST_ARITHMETIC

    addi    $s0, $s0, 32            
    move    $a0, $s0
    jal     F_TEST_LOGIC

    addi    $s0, $s0, 32            
    move    $a0, $s0
    la      $t1, F_TEST_SHIFT
    jalr    $t1
    
Test_End :
    b       Test_End

F_TEST_LOADSTORE :
    addiu   $sp, $sp, -16           # alloc 4 words from stack
    sw      $s0, 16($sp)            # push $s0: $s0 --> stack[3]
    move    $s0, $a0                # $s0: point to the base address of array

    ori     $t0, $zero, 0x2345
    sw      $t0, 0($s0)
    addi    $s0, $s0, 4
    sb      $t0, 0($s0)
    addi    $t0, $t0, 1
    sb      $t0, 1($s0)
    addi    $t0, $t0, 1
    sb      $t0, 2($s0)
    addi    $t0, $t0, 1
    sb      $t0, 3($s0)
    addi    $t0, $t0, 1
    addi    $s0, $s0, 4
    sh      $t0, 2($s0)
    addi    $s0, $s0, 4
    
    move    $t9, $a0
    lb      $t0, 10($t9)
    sw      $t0, 0($s0)
    
    lw      $s0, 16($sp)            # pop $s0
    addiu   $sp, $sp, 16            # restore stack
    jr      $ra

F_TEST_ARITHMETIC :
    addiu   $sp, $sp, -16           # alloc 4 words from stack
    sw      $s0, 16($sp)            # push $s0: $s0 --> stack[3]
    move    $s0, $a0                # $s0: point to the base address of array
    
    addi    $t0, $zero, -1
    
    ori     $t2, $zero, 1
    sub     $t1, $t0, $t2
    sw      $t1, 0($s0)
    addi    $s0, $s0, 4             # s0 += 4
   
    subu    $t1, $t2, $t0
    sw      $t1, 0($s0)
    addi    $s0, $s0, 4             # s0 += 4
    
    lw      $s0, 16($sp)            # pop $s0
    addiu   $sp, $sp, 16            # restore stack
    jr      $ra
    
F_TEST_LOGIC :                      # AND/XOR/XORI
    addiu   $sp, $sp, -16           # alloc 4 words from stack
    sw      $s0, 16($sp)            # push $s0: $s0 --> stack[3]
    move    $s0, $a0                # $s0: point to the base address of array
    
    addi    $t0, $zero, -1          # t0 = 0xFFFFFFFF
    
    lui     $t1, 0x5555             # t1 = 0x55555555
    ori     $t1, $t1, 0x5555
    and     $t1, $t0, $t1
    sw      $t1, 0($s0)
    addi    $s0, $s0, 4             # s0 += 4
    
    lui     $t2, 0xAAAA             # t1 = 0xAAAAAAAA
    ori     $t2, $t2, 0xAAAA
    and     $t2, $t0, $t2
    sw      $t2, 0($s0)
    addiu   $s0, $s0, 4             # s0 += 4
    
    xor     $t1, $t0, $t2           # *s0 = 0x55555555 
    sw      $t1, 0($s0)
    addiu   $s0, $s0, 4             
    
    xori    $t1, $t0, 0x5555        # *s0 = 0xFFFFAAAA
    sw      $t1, 0($s0)
    addiu   $s0, $s0, 4             # 
    
    NOR     $t1, $t2, $t2           # *s0 = 0x55555555
    sw      $t1, 0($s0)
    addiu   $s0, $s0, 4             # 
    
    lw      $s0, 16($sp)            # pop $s0
    addiu   $sp, $sp, 16            # restore stack
    jr      $ra
    

F_TEST_SHIFT :                      # test SLL/SRL/SRA
    addiu   $sp, $sp, -16           # alloc 4 words from stack
    sw      $s0, 16($sp)            # push $s0: $s0 --> stack[3]
    move    $s0, $a0                # $s0: point to the base address of array

    addi    $t0, $zero, -1          # t0 = 0xFFFFFFFF
    
    sll     $t1, $t0, 31
    sw      $t1, 0($s0)
    addiu   $s0, $s0, 4             # 
    # SRL
    srl     $t2, $t1, 31            # *s0 = 0x00000001
    sw      $t2, 0($s0)
    addiu   $s0, $s0, 4             # 
    # SRA
    sra     $t2, $t1, 31            # *s0 = 0xFFFFFFFF
    sw      $t2, 0($s0)
    addiu   $s0, $s0, 4             # 
    # SRLV
    ori     $t3, $zero, 23
    srlv    $t2, $t1, $t3
    sw      $t2, 0($s0)
    addiu   $s0, $s0, 4             # 
    # SRAV
    srav    $t2, $t1, $t3
    sw      $t2, 0($s0)
    addiu   $s0, $s0, 4             # 
    
    lw      $s0, 16($sp)            # pop $s0
    addiu   $sp, $sp, 16            # restore stack
    jr      $ra
