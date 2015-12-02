  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,-1	# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

hexasc: 			#Funktionen hexasc täcker fallet om a0 är mindre än 16 men ej mindre än 0.
	
 	ble $a0, -1, stop
 	ble $a0, 9, less
 	ble $a0, 15, more
 	
 	j stop
 	
	less:
		addi $v0, $a0, 0x30
		jr $ra
	more:
		addi $v0, $a0, 0x37
		jr  $ra
