  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain.
	


	.global delay, time2string


.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	$s7, 0($sp)
.endm

.macro	POP reg
	lw	$s7, 0($sp)
	addi	$sp,$sp,4
.endm
	.data	


	.text
hexasc:

	POP $s3
	POP $s2
	POP $s1
	POP $s0
	addi $s5, $0, 0x3A
	addi $s4, $0, 0x00
	addi $s0, $s0, 0x30
	addi $s1, $s1, 0x30
	addi $s2, $s2, 0x30
	addi $s3, $s3, 0x30
	sb $s3, 0($a0)
	sb $s2, 1($a0)
	sb $s5, 2($a0)
	sb $s1, 3($a0)
	sb $s0, 4($a0)
	sb $s4, 5($a0)
	jr $ra
	nop


delay: 
	PUSH $ra
	li $t1,10000 # grŠns till i
	nop
	while:
		beq $a0, 0, done
		nop
		sub $a0, $a0, 1
		li $t0, 0 # i = 0
		nop
		for:
			beq $t0, $t1, while
			nop
			addi $t0, $t0, 1
			j for
			nop
done:
	POP $ra
	jr $ra
	nop 
	

time2string:
	and $s0, $a1, 0xf
	srl $a1, $a1, 4
	and $s1, $a1, 0xf
	srl $a1, $a1, 4
	and $s2, $a1, 0xf
	srl $a1, $a1, 4
	and $s3, $a1, 0xf
	PUSH $s0
	PUSH $s1
	PUSH $s2
	PUSH $s3
	j hexasc
	nop
