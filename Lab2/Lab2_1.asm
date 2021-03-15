# CS224
# Lab02
# Section 3
# Ahmed Salih Cezayir
# 21802918
# 21/02/2021
# A a program with three subprograms for integer array processing. The subprograms to be written prints an array,
# checks if the array is symmetric, and find maximum and minimum elements of an array.
	.text
	la	$a1, array		# $a1 points to the array
	lw	$a2, arrSize	# $a2 holds the arraySize
	
	jal	PrintArray
	beqz	$a2, end
	
	jal 	CheckSymmetric
	jal 	FindMinMax
	
	move	$t0, $v0		# This is MIN
	move	$t1, $v1		# This is MAX
	
	li	$v0, 4
	la	$a0, minPrompt
	syscall
	
	li 	$v0, 1
	move	$a0, $t0
	syscall
	
	li	$v0, 4
	la	$a0, maxPrompt
	syscall
	
	li 	$v0, 1
	move	$a0, $t1
	syscall
	
end:	# Terminate the program
	li	$v0, 10
	syscall
	
#=======================================================================	
PrintArray:
	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
	
	move	$s0, $a1		# $s0 points to the array
	move	$s1, $a2		# $s1 holds arraySize
	
	beqz	$s1, arrayEmpty
arrayLoop:	
	lw	$s2, 0($s0)
	
	# Print the array element
	li	$v0, 1
	move	$a0, $s2
	syscall
	
	li	$v0, 11
	li	$a0, ' '
	syscall
	
	addi	$s0, $s0, 4
	addi	$s1, $s1, -1
	bnez	$s1, arrayLoop	
cont:	
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	lw	$s2, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	
	jr	$ra
	
#=======================================================================
CheckSymmetric:
	addi	$sp, $sp, -24
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	sw	$s5, 20($sp)
	
	move	$s0, $a1		# $s0 points to the array
	move	$s1, $a2		# $s1 holds the arraySize
	li	$s2, 2	
	div	$s1, $s2
	mflo	$s3		# How many moves needed	
	addi	$s1, $s1, -1	# $s1 now holds arraySize - 1
	li	$s2, 4
	mult	$s1, $s2		
	mflo	$s2		# Byte range
	add	$s2, $s0, $s2	# $s2 holds the last element's address 
	
	lw	$s4, 0($s0)		# $s4 holds the first element
	lw	$s5, 0($s2)		# $s2 holds the last element
	
again:	
	bne	$s4, $s5, notsymm
	addi	$s0, $s0, 4
	addi	$s2, $s2, -4
	lw	$s4, 0($s0)
	lw	$s5, 0($s2)
	addi	$s3, $s3, -1
	beqz	$s3, symm
	j 	again
	
cont2:	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 24
	
	jr	$ra

#=======================================================================
FindMinMax:
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	move	$s0, $a1		# $s0 points to the array
	move 	$s1, $a2		# $s1 holds the arraySize
	lw	$s2, 0($s0)		# This will hold the MIN
	lw	$s3, 0($s0)		# This will hold the MAX

arrayLoop2:
	lw	$s4, 0($s0)	# This holds the current element
	blt	$s4, $s2, min
cont3:	bgt	$s4, $s3, max

cont4:	addi	$s1, $s1, -1
	addi	$s0, $s0, 4
	bnez	$s1, arrayLoop2 
	
	move	$v0, $s2		# RETURN THE MIN USING $v0
	move	$v1, $s3 		# RETURN THE MAX USING $v1
	
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 20
	
	jr	$ra	
	
#=======================================================================
# Printing an message if array is empty		
arrayEmpty:	
	li 	$v0, 4
	la	$a0, empty
	syscall
	j	cont
	
# If the array is not symmetric
notsymm:	
	li	$v0, 4	
	la	$a0, negmess
	syscall
	
	li	$v0, 0		# RETURNS 0 BECAUSE ARRAY IS NOT SYMMETRIC
	j	cont2

# If the array is symmetric	
symm: 	
	li	$v0, 4	
	la	$a0, posmess
	syscall
	
	li	$v0, 1		# RETURN 1 BECAUSE ARRAY IS SYMMETRIC
	j 	cont2

# Setting new min value
min:	move	$s2, $s4
	j 	cont3
	
# Setting new max value
max:	move	$s3, $s4
	j 	cont4
	
	
	.data
array:	.word	7, 6, 8, 1, 5, 1, 8, 6, 7
arrSize:	.word	9
empty:	.asciiz	"The array is empty"
posmess:	.asciiz	"The above array is symmetric\n"
negmess:	.asciiz	"The above array is not symmetric\n"
maxPrompt:	.asciiz	"\nThe max element is: "
minPrompt:	.asciiz	"The min element is: "
