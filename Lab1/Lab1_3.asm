# CS224
# Lab01
# Section 3
# Ahmed Salih Cezayir
# 21802918
# 16/02/2021
# A program to find min, maximum, and average value of the elements of an array.
	.text
	li	$v0, 4
	la	$a0, line1	
	syscall
	
	la	$a0, line2	
	syscall
	
	la	$a0, line3	
	syscall		
		
	# Load array related data to registers
	la 	$t0, array		# $t0 holds the array
	lw	$t1, arrsize	# $t1 hold the array size
	li	$t2, 0		# $t2 is a counter for array looping
	lw	$t4, 0($t0)		# $t4 is used to store MIN
	lw	$t5, 0($t0)		# $t5 is used to store MAX
	li	$t6, 0		# $t6 is used to store the SUM
	
	
start:	lw	$t3, 0($t0)		# $t3 holds the first array element
	#Print the address
	li 	$v0, 34
	move 	$a0, $t0
	syscall
	#Print a tab
	li	$v0, 11
	li	$a0, '\t'			
	syscall
	#Print the array element
	li	$v0, 1
	move	$a0, $t3
	syscall								
	#Print an endline
	li	$v0, 11
	li	$a0, '\n'			
	syscall	
	
	add	$t6, $t6, $t3	# Increase the sum
	blt	$t3, $t4, minAssg	# Check whether current value is smaller than min value
cont1:	bgt	$t3, $t5, maxAssg	# Check whether current value is bigger than max value
	
cont2:	addi	$t2, $t2, 1		# Increment the array loop counter by 1
	addi	$t0, $t0, 4		# Increment the array element address by 4
	bne	$t2, $t1, start	# If loop counter is not equal to the array size branch
																															
	# Print the average
	li	$v0, 4
	la	$a0, average
	syscall
	
	div	$t6, $t1
	li	$v0, 1
	mflo	$a0
	syscall
	
	li	$v0, 11
	li	$a0, '\n'
	syscall	
	
	# Print the max
	li	$v0, 4
	la	$a0, max
	syscall
	
	li	$v0, 1
	move	$a0, $t5
	syscall
	
	li	$v0, 11
	li	$a0, '\n'
	syscall																																																																																																																																																																											
	
	# Print the min
	li	$v0, 4
	la	$a0, min
	syscall
	
	li	$v0, 1
	move	$a0, $t4
	syscall
	
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	# Terminate the program																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																				
	li	$v0, 10
	syscall
	
# These are for assigning min and max
minAssg:	move 	$t4, $t3
	j	cont1
	
maxAssg:	move 	$t5, $t3
	j 	cont2			
	
	.data
array:	.word	26, 53, 47, 34, 0, -99, 95, -2
arrsize: 	.word	8
line1:	.asciiz	"Memory Address\tArray Element\n"
line2:	.asciiz	"Position (hex)\tValue (int)\n"
line3:	.asciiz	"=============\t=============\n"
average:	.asciiz	"Average:"                  
max:	.asciiz	"Max:"
min:	.asciiz 	"Min:"
