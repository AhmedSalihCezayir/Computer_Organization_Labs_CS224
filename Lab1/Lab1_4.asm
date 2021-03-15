# CS224
# Lab01
# Section 3
# Ahmed Salih Cezayir
# 21802918
# 16/02/2021
# A program that computes an equation by using user given values
	.text
	li	$v0, 4
	la	$a0, prompt
	syscall 
	
	# Get the value 'B' and store at the $t0
	la	$a0, B
	syscall
	
	li	$v0, 5
	syscall
	move	$t0, $v0	
	
	# Get the value 'C' and store at the $t1
	li	$v0, 4
	la	$a0, C
	syscall
	
	li	$v0, 5
	syscall
	move	$t1, $v0		
	
	# Get the value 'D' and store at the $t2
	li	$v0, 4
	la	$a0, D
	syscall
	
	li	$v0, 5
	syscall
	move	$t2, $v0	
	
	# Start of the calculation
	div	$t2, $t1
	mflo	$t3		# $t3 holds the D/C
	
	mult 	$t3, $t1
	mflo	$t3		# $t3 holds the C*(D/C)
	
	add	$t3, $t0, $t3	# $t3 holds the B+(C*(D/C))
	
	div	$t3, $t0
	mfhi	$t3		# $t3 holds the (B+(C*(D/C)))%B
	
	blt	$t3, $zero, negative
	
cont:	# Print the result prompt	
	li	$v0, 4
	la	$a0, result1
	syscall
	
	li 	$v0, 11
	li	$a0, '('
	syscall
	
	li	$v0, 1
	move 	$a0, $t0
	syscall	
	
	li 	$v0, 11
	li	$a0, '+'
	syscall
	
	li	$v0, 1
	move 	$a0, $t1
	syscall
	
	li	$v0, 4
	la	$a0, result2
	syscall
	
	li	$v0, 1
	move 	$a0, $t2
	syscall	
	
	li 	$v0, 11
	li	$a0, '/'
	syscall
	
	li	$v0, 1
	move 	$a0, $t1
	syscall
	
	li	$v0, 4
	la	$a0, result3
	syscall
	
	li	$v0, 1
	move 	$a0, $t0
	syscall
	
	li	$v0, 4
	la	$a0, result4
	syscall
	
	# Print the result
	li 	$v0, 1
	move	$a0, $t3
	syscall
		
	li 	$v0, 10
	syscall

negative:	add	$t3, $t3, $t0
	blt	$t3, $zero, negative
	j 	cont
	
	.data
prompt:	.asciiz	"Please enter values for equation (B+C*(D/C))%B"

B:	.asciiz	"\nB:"
C:	.asciiz	"\nC:"
D:	.asciiz	"\nD:"
result1:	.asciiz	"\nThe result of the equation "
result2:	.asciiz	"*("
result3:	.asciiz	"))%"
result4:	.asciiz	" is "