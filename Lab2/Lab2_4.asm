# CS224
# Lab02
# Section 3
# Ahmed Salih Cezayir
# 21802918
# 23/02/2021
# A program for counting patterns in a hexadecimal number	
		.text
	# Get the pattern and store at $t0
	li	$v0, 4
	la	$a0, prompt1
	syscall
	
	li	$v0, 5
	syscall
	
	move	$t0, $v0
	
	# Get the number and store at $t1
	li	$v0, 4
	la	$a0, prompt2
	syscall
	
	li	$v0, 5
	syscall
	
	move	$t1, $v0
	
	# Get the bit number of the pattern and store at $t2
	li	$v0, 4
	la	$a0, prompt3
	syscall
	
	
	li	$v0, 5
	syscall
	
	move	$t2, $v0
	
	li	$v0, 4
	la	$a0, prompt7
	syscall	
		
	move	$a0, $t0
	move	$a1, $t1
	move	$a2, $t2
	
	jal 	CountBitPattern
	
	move	$t3, $v0		# $t3 holds the count for pattern
	
	li	$v0, 4
	la	$a0, prompt5
	syscall
	
	li	$v0, 34
	move	$a0, $t0
	syscall
	
	li	$v0, 4
	la	$a0, prompt6
	syscall
	
	li	$v0, 34
	move	$a0, $t1
	syscall
	
	li	$v0, 4
	la	$a0, prompt4
	syscall
	
	li	$v0, 1
	move	$a0, $t3
	syscall
	
	# Terminate the program
	li	$v0, 10
	syscall
	
#======================================================================================
CountBitPattern:
	addi	$sp, $sp, -24
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	
	move 	$s0, $a0		# $s0 holds the pattern
	move	$s1, $a1		# $s1 holds the number
	move	$s2, $a2		# $s2 holds the pattern size
	
	li	$s3, 32
	sub	$s3, $s3, $s2	# $s3 will hold the shift amount for getting last bits 
		
	li	$s4, 0		# $s4 is a counter
	
loop:	move	$s5, $s1
	sllv	$s5, $s5, $s3
	srlv	$s5, $s5, $s3	# $s5 now holds the number's last 'size' bits
	
	beq	$s5, $s0, increment
	srl	$s1, $s1, 1	
cont1:		
	bnez	$s1, loop
	
	move	$v0, $s4		# $v0 RETURNS THE COUNT
	
	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

#======================================================================================
increment:
	addi 	$s4, $s4, 1
	srlv	$s1, $s1, $s2
	j	cont1
	
	.data
prompt1:	.asciiz	"\nPlease enter a pattern: "
prompt2:	.asciiz	"\nPlease enter a number: "
prompt3:	.asciiz	"\nPlease enter bit number for the pattern: "
prompt4:	.asciiz	"\n\nThe pattern count is "
prompt5:	.asciiz	"\nYour pattern: "
prompt6:	.asciiz	"\n\nYour number: "
prompt7:	.asciiz	"==============================================="
