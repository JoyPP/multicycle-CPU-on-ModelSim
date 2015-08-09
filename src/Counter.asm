    .data
fibs: .word  0 : 20                 # "array" of 20 words to contain fib values
nouse: .word 0
size: .word  20                     # size of "array" 

    .text
    
    ori	$a2,$zero,0xbd	# a2 = 0xbd
    sb $a2,0($a0)	# dm[0]=0x000000bd
    
    ori $a2,$zero,0xac	# a2 = 0xac
    sb $a2,1($a0)	# dm[0]=0x0000acbd
    
    addi $a2,$zero,0x1234	# a2 = 0x1234	
    sh $a2,2($a0)	# dm[0]=0x1234acbd
    
    addiu $a3,$a3,4	# a3 = a3 + 4
# array[2]:0xFFFFFF80, array[3]:0x00000080
    ori     $a2, $zero, 0x80	    # a2 = 0x80
    sb      $a2, 0($a3)		    # dm[1]= 0x00000080
    lb      $a2, 0($a3)             # a2 = 0xFFFFFF80
    sw      $a2, 4($a3)             # dm[2] = 0xffffff80
    lbu     $a2, 0($a3)		    # a2 = 0x00000080
    sw      $a2, 8($a3)		    # dm[3] = 0x00000080
# lb. 
    lh      $a2, 0($a3)             #  a2 = 0x00000080
    li      $a3, 0xFFFFFF80	    #  a3 = 0xffffff80
  
    
    addi $t2,$zero,1	# t2 = 1
    
    ori	$t0,$zero,0	# t0 = 0
    addiu $t1,$zero,21	# t1 = 21
    
    addu $t0,$t0,$t2	# t0 = t0 + t2 = t1 + 1
    subu $t1,$t1,$t2	# t1 = t1 - t2 = t1 - 1
    
    addiu $a0,$a0,32	# a0 = a0 + 32
    sw	$t0,0($a0)	# store start number $t0 into dm0
    sw  $t1,4($a0)	# store end number $t1 into dm1
    
    addu $v0,$t0,$t1	# v0 = t0 + t1
    sw  $v0,8($a0)	# store v0
       
LOOP:
	addiu	$a0,$a0,12	# a0 = a0 + 12
	addi	$t0,$t0,1	# t0 = t0 + 1
	addi	$t1,$t1,-1	# t1 = t1 - 1
	slt	$a1,$t1,$t0	# a1 = 1 if t1 < t0, else a1 = 0
	beq	$a1,$t2,LOOPEND # a1 == t2 == 1, jump to LOOPEND
	sw	$t0,0($a0)	# store  number $t0 
    	sw  	$t1,4($a0)	# store  number $t1
	jal	count		# v0 = v0 + t0 +t1
	j	LOOP		# jump to LOOP
LOOPEND:
	lui	$t3,2		# t3 = 0x20000
	subu	$t3,$t3,$v0	# t3 = t3- v0
	sw	$t3,0($a0)	# store t3
	lw	$t4,0($a0)	# t4 = t3
	
	lb	$v1,-1($a1)
	lhu	$at,-2($a0)
	sh	$v1,($a0)
	lh	$s4,3($a1)
	sb	$s4,4($a0)
	lbu	$s5,-4($a0)
	
LOOPFOREVER:
	j	LOOPFOREVER	# jump forever
	
count:
	addu	$v0,$v0,$t0	# $v0 = $v0 +$t0
	addu	$v0,$v0,$t1	# $v0 = $v0 +$t1
	sw	$v0,8($a0)	# store $v0
	jr	$ra		# return
	
