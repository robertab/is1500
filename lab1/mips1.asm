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
	li	$a0,2
	jal	delay
	nop
	# call tic
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

hexasc: 			#Funktionen hexasc tÃ¤cker fallet om a0 Ã¤r mindre Ã¤n 16 men ej mindre Ã¤n 0.
	addi $t2, $t0, 16
 	addi $t0, $0, 10 #GrÃ¤ns till 10.
 	slt $t1, $s1, $t0 #Kollar om a0 Ã¤r mindre Ã¤n grÃ¤nsen
 	bne $t1, $0, less #Om a0 Ã¤r mindre plussa pÃ¥ 0x30. annars 0x37
 	slt $t1, $a0, $t2
 	bne $t1, $0, more
 	j stop
 	nop
 	
	less:
		li $t4, 0x45
		POP $s3
		POP $s2
		POP $s1
		POP $s0
		and $t3, $s0, 1 #maskar bort alla utom 1
		addi $s5, $0, 0x3A
		addi $s4, $0, 0x00
		addi $s0, $s0, 0x30	
		addi $s1, $s1, 0x30
		addi $s2, $s2, 0x30
		addi $s3, $s3, 0x30
		sub $s6, $t4, $t3
		
		sb $s3, 0($a0)
		sb $s2, 1($a0)
		sb $s5, 2($a0)
		sb $s1, 3($a0)
		sb $s0, 4($a0)
		sb $s6, 5($a0)
		sb $s4, 6($a0)
		
		jr $ra
		nop
	more:
		addi $v0, $a0, 0x37
		jr  $ra
		nop
		
delay: 
	PUSH $ra
	li $t1, 2000 # grŠns till i
	
	while:
	beq $a0, 0, done
	sub $a0, $a0, 1
	li $t0, 0 # i = 0
	
	for:
	beq $t0, $t1, while
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
	
  # you can write your code for subroutine "hexasc" below this line
  #
  
 stop: j stop