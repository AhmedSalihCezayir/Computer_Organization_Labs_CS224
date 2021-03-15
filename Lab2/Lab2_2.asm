# CS224
# Lab02
# Section 3
# Ahmed Salih Cezayir
# 21802918
# 21/02/2021
# A subprogram that receives a decimal number and reverses the order of its bits 
# and returns the reversed form as its result.
	.text
	lw	$a0, number
	move	$a1, $a0		# Now $a1 holds the number	
	
	li 	$v0, 4
	la	$a0, hexPrompt
	syscall
	
	# Print the hexadecimal version of the number
	li	$v0, 34	
	move	$a0, $a1			
	syscall
	
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	jal 	Reverse
	
	move	$t0, $v0
	
	li	$v0, 4
	la	$a0, prompt2
	syscall
	
	# Print the reversed version of the number
	li 	$v0, 34
	move	$a0, $t0
	syscall
	
	li	$v0, 10
	syscall
	
#========================================================================
Reverse:
	addi	$sp, $sp, -16
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	
	move	$s0, $a1		# $s0 hold the number
	li	$s1, 32		# This is a counter
	li	$s2, 0		# $s1 will hold the result number

start:	beq	$s1, $zero, end
	andi	$s3, $s0, 1		# $s3 holds the last nibble
	srl	$s0, $s0, 1		# Now last nibble is the one comes one before the last
	sll	$s2, $s2, 1
	or	$s2, $s2, $s3	# Now first nibble of the result is the value at $s3
	sub	$s1, $s1, 1
	j 	start
 	
end:	move	$v0, $s2

	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 16
	
	jr	$ra
	
	.data
number:	.word	3
hexPrompt:	.asciiz	"Hexadecimal form of the number is "
prompt1:	.asciiz	"Please enter a decimal number: "
prompt2:	.asciiz	"The reverse bits of the number is "	
