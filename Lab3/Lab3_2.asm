# CS224
# Lab 3
# Section 3
# Ahmed Salih Cezayir
# 21802918
# A subprogram that calculates division of a number by using recursion

	.text
start:	
	li	$v0, 4
	la	$a0, prompt1
	syscall
	
	li	$v0, 5
	syscall
			
	move	$t0, $v0			# $t0 holds the dividend
	
getDivisor:	
	li	$v0, 4
	la	$a0, divisor
	syscall
	
	li	$v0, 5
	syscall	
	
	move	$t1, $v0			# $t1 also holds the divisor
	
	beqz	$v0, error			# If the divisor is zero print an error message
	j	calculate
error:
	li	$v0, 4
	la	$a0, divby0	
	syscall
	
	j	getDivisor
	
calculate:
	move	$a0, $t0			# $a0 holds the dividend
	move	$a1, $t1			# $a1 holds the divisor
	li	$a2, 0			# $a2 is a counter(This will be the result)
	
	jal	RecursiveDivision
	
	move	$t2, $v0			# $t2 holds the result of division
	
	# Print some messages for the putput result
	li	$v0, 4
	la	$a0, prompt3
	syscall
	
	li	$v0, 1
	move	$a0, $t0
	syscall
	
	li	$v0, 11
	li	$a0, '/'
	syscall
	
	li	$v0, 1
	move	$a0, $t1
	syscall
	
	li	$v0, 4
	la	$a0, prompt4
	syscall
	
	li	$v0, 1
	move	$a0, $t2
	syscall
	
	# Get user input to continue performing divisions
	li	$v0, 4
	la	$a0, prompt2
	syscall
	
	li	$v0, 12
	syscall
	
	li	$t3, 'Y'
	li	$t4, 'y'
	
	# If user enters lowercase y, make it uppercase
	beq	$v0, $t4, makeUpper
cont:
	# If the ouput is Y, start the loop again
	beq	$v0, $t3, start
	
	# Terminate the program 
	li	$v0, 10
	syscall
	
makeUpper:	
	li	$v0, 'Y'
	j	cont
	
#===========================================================================
RecursiveDivision:
	addi	$sp, $sp, -24
	
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$a0, 8($sp)
	sw	$a1, 4($sp)
	sw	$ra, 0($sp)
	
	move	$s0, $a0		# $s0 holds the dividend
	move	$s1, $a1		# $s1 holds the divisor
	
	addi	$s2, $a2, 0		# This is a counter
	
	bge	$s0, $s1, else
	move	$v0, $s2
here:
	lw	$ra, 0($sp)
	lw	$a1, 4($sp)
	lw	$a0, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	
	addi	$sp, $sp, 24
	
	jr	$ra
	
else:	
	sub	$s0, $s0, $s1	# Dividend = dividend - divisor
	addi	$s2, $s2, 1		# Increment the counter
	
	move	$a0, $s0		# Call this subprogram again for new dividen = dividen - divisor
	move	$a1, $s1
	move 	$a2, $s2
	
	# Call this subprogram again for new dividen = dividen - divisor
	jal 	RecursiveDivision
	j	here				
		
#===========================================================================																								
	.data
prompt1:	.asciiz	"\nPlease enter the dividend and divisor\nDividend: "
prompt2: 	.asciiz	"\nIf you want to continue enter Y\n "
prompt3: 	.asciiz	"The result of "
prompt4: 	.asciiz	" is "
divisor:	.asciiz	"Divisor: "
divby0:	.asciiz	"\nDivisor cannot be zero!\n"
