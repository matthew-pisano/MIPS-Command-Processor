.data
.globl echo
.text
echo:	addi	$sp, $sp, -8	#prologue
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
	
	la	$s1, 0($a1)	#write second token (first parameter) to screen
	jal	writeString
	la	$s1, newLn	#write \n
	jal	writeString
	
	lw   	$ra, 0($sp) 	#epilogue
	lw	$t9, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
