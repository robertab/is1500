  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "xx:xx\0"
	.text
main:
	# print timstr
	la	$a0,timstr	
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0, 1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

hexasc:	
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
	li $t1,20 # ms 
	
	while:
		ble $a0, 0, done
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
	
	li $t4, 0x00 # null
	li $t5, 0x3A # :
	and $t7, $a1, 0xff
	

	jal hexasc
	POP $s0
	nop
	move $s0, $v0 # 8
	
	srl $a1, $a1, 4
	jal hexasc
	POP $s1
	nop
	move $s1, $v0 # 5
	
	srl $a1, $a1, 4
	jal hexasc
	POP $s2
	nop
	move $s2, $v0 # 9
	
	srl $a1, $a1, 4
	jal hexasc
	POP $s3
	nop
	move $s3, $v0 # 5
	
	

	li $t1, 0x58 # X
	beq $t7, $0, xprint
	
	sb $s3, 0($a0) 
	sb $s2, 1($a0)
	sb $t5, 2($a0)
	sb $s1, 3($a0)
	sb $s0, 4($a0)
	sb $t4, 5($a0)
	
	POP $ra
	jr $ra
	nop
	
xprint:
	sb $s3, 0($a0) 
	sb $s2, 1($a0)
	sb $t5, 2($a0)
	sb $s1, 3($a0)
	sb $s0, 4($a0)
	sb $t1, 5($a0)
	sb $t4, 6($a0)
	
	
	
	POP $ra
	jr $ra
	nop

 stop: j stop
 nop
