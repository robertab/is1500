  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain.
	


.global delay, time2string, enable_interrupt


.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg, 0($sp)
.endm

.macro	POP reg
	lw	\reg, 0($sp)
	addi	$sp,$sp,4
.endm
	.data	


	.text
hexasc: 
			# Hexasc gör om siffrorna till ASCII. Poppas ut från stacken innan de används
	li $t0, 0xf
	and $t1, $a1, $t0 
	ble $t1, 9, less
	addi $t2, $t1, 0x37
	jr $ra
	nop
	less:
		addi $t1, $t1, 0x30
		move $v0, $t1
		
		jr $ra
		nop


delay: 				# Delayfunktion som skrevs om från C
	PUSH $ra
	li $t1,12000  # grŠns till i
	
	while:
		beq $a0, 0, done
		nop
		sub $a0, $a0, 1
		li $t0, 0 # i = 0
	
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
	PUSH $ra
	PUSH $s0
	PUSH $s1
	PUSH $s2
	PUSH $s3
	
	li $t4, 0x00
	li $t5, 0x3A
	li $t1, 0x45
	and $t7, $a1, 0xff

	jal hexasc

	nop

	move $s0, $v0 # 8
	srl $a1, $a1, 4
	jal hexasc
	nop

	move $s1, $v0 # 5
	srl $a1, $a1, 4
	jal hexasc
	nop

	move $s2, $v0 # 9
	srl $a1, $a1, 4
	jal hexasc
	nop

	move $s3, $v0 # 5
	jal hexasc
	nop


	li $t1, 0x58 # X





	sb $s3, 0($a0) 
	sb $s2, 1($a0)
	sb $t5, 2($a0)
	sb $s1, 3($a0)
	sb $s0, 4($a0)
	sb $t4, 5($a0)

	POP $s3				
	POP $s2	
	POP $s1
	POP $s0
	POP $ra
	jr $ra
	nop


enable_interrupt:
	ei 
	jr $ra
	nop
	
