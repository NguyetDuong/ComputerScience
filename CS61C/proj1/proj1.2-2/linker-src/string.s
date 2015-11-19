# CS 61C Spring 2015 Project 1-2 
# string.s

#==============================================================================
#                              Project 1-2 Part 1
#                               String README
#==============================================================================
# In this file you will be implementing some utilities for manipulating strings.
# The functions you need to implement are:
#  - strlen()
#  - strncpy()
#  - copy_of_str()
# Test cases are in linker-tests/test_string.s
#==============================================================================

.data
newline:	.asciiz "\n"
tab:	.asciiz "\t"

.text
#------------------------------------------------------------------------------
# function strlen()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string input
#
# Returns: the length of the string (0 if empty)
#------------------------------------------------------------------------------
strlen:
	# YOUR CODE HERE
	addu $t1 $0 $0	# Our counter.
strlen_loop:
	lb $t0 0($a0)
	beq $t0 $0 strlen_end
	addiu $t1 $t1 1 	# Not end.
	addiu $a0 $a0 1
	j strlen_loop
strlen_end:
	addu $v0 $t1 $0
	jr $ra

#------------------------------------------------------------------------------
# function strncpy()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = pointer to destination array
#  $a1 = source string
#  $a2 = number of characters to copy
#
# Returns: the destination array
#------------------------------------------------------------------------------
strncpy:
	# YOUR CODE HERE
	#lw $t0 0($a0)	# dereference array pointer
	addu $t0 $a0 $0	# Save array pointer
	addu $t1 $0 $0	# Our counter
strncpy_loop:
	beq $a1 $0 strncpy_end	# Reached end of str
	beq $t1 $a2 strncpy_end
	lb $t2 0($a1)	# Not end
	sb $t2 0($t0)
	addiu $t1 $t1 1
	addiu $a1 $a1 1
	addiu $t0 $t0 1
	j strncpy_loop
strncpy_end:
	#lw $t0 0($a0)	# dereference array pointer
	addu $v0 $a0 $0
	jr $ra

#------------------------------------------------------------------------------
# function copy_of_str()
#------------------------------------------------------------------------------
# Creates a copy of a string. You will need to use sbrk (syscall 9) to allocate
# space for the string. strlen() and strncpy() will be helpful for this function.
# In MARS, to malloc memory use the sbrk syscall (syscall 9). See help for details.
#
# Arguments:
#   $a0 = string to copy
#
# Returns: pointer to the copy of the string
#------------------------------------------------------------------------------
copy_of_str:
	# YOUR CODE HERE
	addu $t7 $ra $0	# Save $ra
	addu $t6 $a0 $0	# save a0
	jal strlen
	addiu $a0 $v0 1 # set a0 to strlen + 1
	addiu $v0 $0 9
	syscall
	addu $a2 $a0 $0	# Setup for strncpy
	addu $a0 $v0 $0
	addu $a1 $t6 $0
	addu $t5 $a2 $0	# Save strlen. strncpy doesn't modify $a2, but we can't assume that.
	jal strncpy 	# v0 is now copied string
	addu $t5 $v0 $t5	# adrress of our null terminator
	lb $0 0($t5)	# Set null terminator
	addu $ra $t7 $0	# restore $ra
	jr $ra

###############################################################################
#                 DO NOT MODIFY ANYTHING BELOW THIS POINT                       
###############################################################################

#------------------------------------------------------------------------------
# function streq() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string 1
#  $a1 = string 2
#
# Returns: 0 if string 1 and string 2 are equal, -1 if they are not equal
#------------------------------------------------------------------------------
streq:
	beq $a0, $0, streq_false	# Begin streq()
	beq $a1, $0, streq_false
streq_loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	bne $t0, $t1, streq_false
	beq $t0, $0, streq_true
	j streq_loop
streq_true:
	li $v0, 0
	jr $ra
streq_false:
	li $v0, -1
	jr $ra			# End streq()

#------------------------------------------------------------------------------
# function dec_to_str() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Convert a number to its unsigned decimal integer string representation, eg.
# 35 => "35", 1024 => "1024". 
#
# Arguments:
#  $a0 = int to write
#  $a1 = character buffer to write into
#
# Returns: the number of digits written
#------------------------------------------------------------------------------
dec_to_str:
	li $t0, 10			# Begin dec_to_str()
	li $v0, 0
dec_to_str_largest_divisor:
	div $a0, $t0
	mflo $t1		# Quotient
	beq $t1, $0, dec_to_str_next
	mul $t0, $t0, 10
	j dec_to_str_largest_divisor
dec_to_str_next:
	mfhi $t2		# Remainder
dec_to_str_write:
	div $t0, $t0, 10	# Largest divisible amount
	div $t2, $t0
	mflo $t3		# extract digit to write
	addiu $t3, $t3, 48	# convert num -> ASCII
	sb $t3, 0($a1)
	addiu $a1, $a1, 1
	addiu $v0, $v0, 1
	mfhi $t2		# setup for next round
	bne $t2, $0, dec_to_str_write
	jr $ra			# End dec_to_str()
