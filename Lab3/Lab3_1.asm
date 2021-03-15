# CS224
# Lab 3
# Section 3
# Ahmed Salih Cezayir
# 21802918
# A subprogram that counts the add and lw instructions of a given code segment.

	.text
mainStart:
	la	$a0, mainStart
	la	$a1, mainEnd	
	
	jal 	InstructionCount
	
	move	$t0, $v0
	move	$t1, $v1
	
	li	$v0, 4
	la	$a0, prompt1
	syscall
	
	li	$v0, 1
	add	$a0, $t0, $zero
	syscall
	
	li	$v0, 4
	la	$a0, prompt2
	syscall
	
	li	$v0, 1
	add	$a0, $t1, $zero
	syscall
	
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	la	$a0, subStart
	la	$a1, subEnd
	
	jal 	InstructionCount
	
	move	$t0, $v0
	move	$t1, $v1
	
	li	$v0, 4
	la	$a0, prompt3
	syscall
	
	li	$v0, 1
	add	$a0, $t0, $zero
	syscall
	
	li	$v0, 4
	la	$a0, prompt4
	syscall
	
	li	$v0, 1
	add	$a0, $t1, $zero
	syscall
	
	li	$v0, 10
	syscall
mainEnd:	

#============================================================================
InstructionCount:
subStart:
	addi	$sp, $sp, -28
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s2, 16($sp)
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$s6, 0($sp)
	
	move	$s0, $a0			# $s0 holds the start address
	move 	$s1, $a1			# $s1 holds the end address
	
	li	$s2, 0			# $s2 is a counter for add instruction
	li	$s3, 0			# $s3 is a counter for lw instruction
loop:	
	bgt	$s0, $s1, done
	lw	$s4, 0($s0)			# $s4 holds the instruction itself

	srl	$s5, $s4, 26		# Get the first 6 bits of the instruction
	andi	$s6, $s4, 0x0000003F		# Get the last 6 bits of the instruction
	
	beq 	$s5, 35, itsLw		# If the first 6 bits is equal to 35, it is lw
	j	checkForAdd			# If it is not, check for whether it is add instruction or not
	
itsLw: 	
	addi	$s3, $s3, 1			# Increment lw counter
	j 	goToNextEle			# Go to the next instruction
	
checkForAdd:
	beq	$s5, $zero, checkForFunct	# If it is not lw, then it can be add if its opcode is 0. For that, check its function part(last 6 bits)
	j	goToNextEle			# If its opcode is not 0, go to the next instruction
	
checkForFunct:	
	beq	$s6, 32, itsAdd		# If its function is 32, it is an add instruction
	j 	goToNextEle			# If its function is not 32, go to the next instruction
	
itsAdd:
	addi	$s2, $s2, 1			# Increment add counter
	j 	goToNextEle			# Go to the next instruction
	
goToNextEle:
	addi	$s0, $s0, 4			# Increment the address by 4
	j	loop

done:	
	move	$v0, $s2			# RETURN ADD COUNTER USING $v0
	move	$v1, $s3			# RETURN LW	COUNTER USING $v1
	
	lw	$s6, 0($sp)
	lw	$s5, 4($sp)
	lw	$s4, 8($sp)
	lw	$s3, 12($sp)
	lw	$s2, 16($sp)
	lw	$s1, 20($sp)
	lw	$s0, 24($sp)
	addi	$sp, $sp, 28
	
	jr	$ra	
subEnd:	

#============================================================================
	.data
prompt1:	.asciiz	"\nThe add amount in main is: "
prompt2:	.asciiz	"\nThe lw amount in main is: "
prompt3:	.asciiz	"\nThe add amount in subprogram is: "
prompt4:	.asciiz	"\nThe lw amount in subprogram is: "	
