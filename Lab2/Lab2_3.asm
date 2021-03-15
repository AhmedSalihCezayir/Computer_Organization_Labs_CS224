# CS224
# Lab02
# Section 3
# Ahmed Salih Cezayir
# 21802918
# 23/02/2021
# A program with four subprograms for dynamic integer array processing. The subprograms to be written 
# creates an array by user given values / prints them, checks if the array is symmetric, and find maximum and minimum
# elements of an array.
		.text
	li	$t4, 4		# $t4, $t5, $t6, $t7 registers will be used to check menu selection
	li	$t7, 1
	li	$t5, 2 
	li	$t6, 3
	li	$t8, 0		# $t8 register is for checking whether array is created or not
				# When array is created $t8 will hold 1
selectStart:
	# Print menu related texts
	li	$v0, 4
	la	$a0, menu5
	syscall
	
	li	$v0, 4
	la	$a0, menu1
	syscall
	
	li	$v0, 4
	la	$a0, menu2
	syscall
	
	li	$v0, 4
	la	$a0, menu3
	syscall
	
	li	$v0, 4
	la	$a0, menu4
	syscall
	
	# Get user selection
	li	$v0, 5
	syscall
	
	# Check user selection
	beq	$v0, $t4, end 
	beq	$v0, $s7, selectCreate
	beq	$v0, $t5, selectSymm
	beq	$v0, $t6, selectMinMax
	
selectCreate:			
	jal	GetArray
	move	$t0, $v0		# $t0 holds the array size
	move	$t1, $v1		# $t1 points to the array
	li	$t8, 1
	
	j	selectStart
		
selectSymm:	
	beqz 	$t8, arrayNotCreated
	move	$a0, $t1		# $a0 points to the array
	move 	$a1, $t0		# $a1 holds the array size		
	jal 	CheckSymmetric
	
	j 	selectStart

selectMinMax:
	beqz 	$t8, arrayNotCreated	
	move	$a0, $t1		# $a0 points to the array
	move 	$a1, $t0		# $a1 holds the array size
	
	jal	FindMinMax
	
	move	$t2, $v0		# $t2 holds the min
	move 	$t3, $v1		# $t3 holds the max
	
	li	$v0, 4
	la	$a0, minPrompt
	syscall
	
	li 	$v0, 1
	move	$a0, $t2
	syscall
	
	li	$v0, 4
	la	$a0, maxPrompt
	syscall
	
	li 	$v0, 1
	move	$a0, $t3
	syscall
	
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	j	selectStart
	
end:	li	$v0, 10
	syscall

#===============================================================================
GetArray:
	addi	$sp, $sp, -20 
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$ra, 16($sp)
	
	li	$v0, 4
	la	$a0, prompt1
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0		# $s0 holds the array size
	li	$s1, 4
	mult	$s0, $s1
	mflo	$s1		# $s1 holds the amount of memory required for the array(4 * arrSize)
	
	# Allocate enough memory for the array
	move	$a0, $s1
	li	$v0, 9
	syscall
	
	move 	$s1, $v0		# $s1 points to the array
	move	$s2, $v0		# $s2 also points to the array but this will change in the loop
	addi	$s3, $s3, 0		# $s3 is a counter 

# This loop initializes the array
initStart:	
	beq	$s3, $s0, initEnd 
	li	$v0, 5
	syscall
	
	sw	$v0, 0($s2)
	addi 	$s2, $s2, 4
	addi	$s3, $s3, 1
	
	j	initStart

initEnd:
	move 	$a0, $s1
	move	$a1, $s0
	
	jal	PrintArray
	
	move	$v0, $s0		# $v0 RETURNS THE ARRAY SIZE
	move 	$v1, $s1		# $v1 RETURNS THE ARRAY ADDRESS
	
	lw	$ra, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 20
	
	jr	$ra 
	 
#===============================================================================
PrintArray:
	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
	
	move	$s0, $a0		# $s0 points to the array
	move	$s1, $a1		# $s1 holds arraySize
	
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
	
	move	$s0, $a0		# $s0 points to the array
	move	$s1, $a1		# $s1 holds the arraySize
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

#===============================================================================
FindMinMax:
	addi	$sp, $sp, -20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$s3, 12($sp)
	sw	$s4, 16($sp)
	
	move	$s0, $a0		# $s0 points to the array
	move 	$s1, $a1		# $s1 holds the arraySize
	lw	$s2, 0($s0)		# This will hold the MIN
	lw	$s3, 0($s0)		# This will hold the MAX

arrayLoop2:
	lw	$s4, 0($s0)		# This holds the current element
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

#===============================================================================
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
	
	li	$v0, 0		# RETURN 0 BECAUSE ARRAY IS NOT SYMMETRIC
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

arrayNotCreated:
	li	$v0, 4
	la	$a0, prompt3
	syscall
	
	j	selectStart
	
	.data    
prompt1:	.asciiz	"\nPlease enter the array size: "
prompt2: 	.asciiz	"\nPlease enter array elements: "
empty:	.asciiz	"\nThe array is empty"
posmess:	.asciiz	"\nThe array is symmetric\n"
negmess:	.asciiz	"\nThe array is not symmetric\n"
maxPrompt:	.asciiz	"\nThe max element is: "
minPrompt:	.asciiz	"\nThe min element is: "
menu5:	.asciiz	"-----------------------------------\nFor array creation press 1"
menu1:	.asciiz	"\nFor symmetry check press 2"
menu2:	.asciiz	"\nFor finding min and max enter 3"
menu3:	.asciiz	"\nTo exit enter 4\n-----------------------------------\n"
menu4:	.asciiz	"\nPlease enter process you want to choose:"
prompt3:	.asciiz	"\nPlease first create an array!\n"
