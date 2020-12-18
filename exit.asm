.data
exitMsg:.word 0	
	.asciiz "Have a good day!\nTerminating..."
.globl exit
.text
exit:	la	$s1, exitMsg	#write exitMsg to screen
	addi	$s1, $s1, 4
	jal	writeString
	li	$v0, 10		#terminate
	syscall
