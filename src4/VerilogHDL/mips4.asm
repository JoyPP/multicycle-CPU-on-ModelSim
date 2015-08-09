.text
  
 
 ori $t0,$0,0x7f00
 ori $t1,$0,49
 ori $t2,$0,50
 #sw  $t2,0($t0)
 sw  $t1,4($t0)
 #lw  $t3,8($t0)
 
 
 mflo $t2
 
 li $2, 7
 li $16, -8
 li $17, -3
 #mtc0 $17,$13
 div $16, $17
 mfhi $16
 li $17, -2
 bne $16, $17, err
 mflo $16
 #mtc0 $16,$12
 

 
 
 
 
 test_divu:
 li $2, 8
 li $16, 11
 li $17, 7
 divu $16, $17
 mfhi $16
 li $17, 4
 bne $16, $17, err
 mflo $16
 li $17, 1
 bne $16, $17, err
mfc0 $17,$13

test_mult:
 li $2, 9
 li $16, 65538
 li $17, -65537
 mult $16, $17
 mfhi $16
 li $17, 0xfffffffe
 bne $16, $17, err
 mflo $16
 li $17, 0xfffcfffe
 bne $16, $17, err
 
 test_multu:
 li $2, 10
 li $16, 65539
 li $17, 65541
 multu $16, $17
 mfhi $16
 li $17, 1
 bne $16, $17, err
 mflo $16
 li $17, 0x0008000f
 bne $16, $17, err
 
 
  err: add $0,$0,$0
  
  
 .ktext	0x00004180
	
	ori $t1,$0,19
 	sw  $t1,4($t0)
	eret
 
