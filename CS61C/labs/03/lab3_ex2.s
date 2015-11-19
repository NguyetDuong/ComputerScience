
main:	add $t0, $0, $0
	add $t1, $1, $t0
	add $t2, $t1, $t0
	add $t3, $t1, $t2
	add $t4, $t3, $t2
	add $t5, $t4, $t3
	add $t6, $t5, $4
	add $t7, $t6, $t7
	addi $a0, $t4, 1
finish: li $v0, 1
	syscall