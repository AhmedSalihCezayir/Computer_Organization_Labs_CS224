	.text
	# Print the general prompt
	li	$v0, 4
	la 	$a0, prompt
	syscall
	
	# Get 'a' as input from the user
	li 	$v0, 4
	la	$a0, A
	syscall
	
	li	$v0, 5
	syscall
	
	move 	$t0, $v0	# $t0 = a	
	
	# Get 'b' as input from the user
	li 	$v0, 4
	la	$a0, B
	syscall
	
	li	$v0, 5
	syscall
	
	move 	$t1, $v0	# $t1 = b

	# Get 'c' as input from the user
	li 	$v0, 4
	la	$a0, C
	syscall
	
	li	$v0, 5
	syscall
	
	move 	$t2, $v0	# $t2 = c
	
	# Get 'd' as input from the user
	li 	$v0, 4
	la	$a0, D
	syscall
	
	li	$v0, 5
	syscall
	
	move 	$t3, $v0	# $t3 = d
	
	# Calculate the equation
	sub	$t4, $t1, $t2	#$t4 = b - c
	mult	$t0, $t4
	mflo	$t5		#t5 = a * (b - c)
	div	$t5, $t3
	mfhi	$t6		#t6 = a * (b - c) % d

	li	$v0, 4
	la	$a0, result	
	syscall
	
	li	$v0, 1
	move 	$a0, $t6
	syscall
	
	li 	$v0, 10
	syscall
	
	.data
prompt:	.asciiz 	"Please enter values for the expression a * (b - c) % d"
A:	.asciiz 	"\na:"
B:	.asciiz 	"\nb:"
C:	.asciiz 	"\nc:"
D:	.asciiz 	"\nd:"
result:	.asciiz	"\nThe result for the equation is: "