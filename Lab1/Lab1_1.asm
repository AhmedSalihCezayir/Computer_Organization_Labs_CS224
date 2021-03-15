	.text
	la	$t0, array		# First address of the array
	li 	$t1, 0
	li	$t2, 0 		# How many moves so far
	li 	$t3, 2
	lw 	$t4, arrsize	# Array Size
	
	beq	$t4, 1, symm
	
#Print the array
start: 	
	li $v0, 1
	lw $a0, 0($t0)
	syscall
	
	li $v0, 11
	li $a0, ' '
	syscall
	
	addi $t1, $t1, 1
	addi $t0, $t0, 4
	bne $t1, $t4, start
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	la 	$t0, array
	div 	$t4, $t3  		
	mflo	$t5		# How many moves needed 
	li 	$t3, 4
	subi	$t4, $t4, 1  	# Array Size - 1	
	mult	$t4, $t3
	mflo	$t3	
	lw 	$t6, 0($t0)		# First element of the array
	add 	$t7, $t3, $t0	# Last address of the array
	lw 	$t8, 0($t7)	 	# Last element
	
again:	
	bne	$t6, $t8, notsymm 
	addi	$t0, $t0, 4
	subi	$t7, $t7, 4
	lw	$t6, 0($t0)
	lw	$t8, 0($t7)
	addi        $t2, $t2, 1 
	beq	$t2, $t5, symm
	j 	again
	
# If the array is not symmetric
notsymm:	
	li	$v0, 4	
	la	$a0, negmess
	syscall
	
	li	$v0, 10
	syscall

# If the array is symmetric	
symm: 	
	li	$v0, 4	
	la	$a0, posmess
	syscall

	li	$v0, 10
	syscall
	
	.data
array:    	.word 	1, 5, 4, 5, 1 
arrsize:	.word 	5
posmess:	.asciiz	"The above array is symmetric"
negmess:	.asciiz	"The above array is not symmetric"
