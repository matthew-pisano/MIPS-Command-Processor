.data
memStart:	.align 2
		.asciiz "--Memory Display--\n"
friendly:	.space 128	#stores friendly format of memroy to be displayed
.globl memory
.text
#arg1 is memory address, arg2 is length to print
memory:	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
	la	$s1, memStart
	jal	writeString
	
	move	$s3, $a1	#copy address of arg1
	addi	$s0, $zero, 1	#tell to convert to hex
	jal	cvtStr		#convert
	move	$a1, $s3	#set arg1 to converted string
	
	move	$s3, $a2	#copy address of arg2
	addi	$s0, $zero, 0	#tell to convert to decimal
	jal	cvtStr		#convert
	move	$a2, $s3	#set arg2 to converted string
	
	add	$a2, $a1, $a2	#address + limit = end address
	la	$s0, friendly
memLoop:lb	$s1, ($a1)		#load next byte of memory
	addi	$s2, $zero, 0
	bne	$s1, $s2, normal	#if byte not equal to zero skip to normal
	addi	$s2, $zero, 95		#load "_" as byte instead of zero
	sb	$s2, ($s0)
	j	after
normal:	sb	$s1, ($s0)		#move byte to write register
after:	addi	$a1, $a1, 1		#increment inceces
	addi	$s0, $s0, 1
	blt	$a1, $a2, memLoop	#loop

	la	$s1, friendly		#write scring contained in friendly
	jal	writeString
	la	$s1, newLn
	jal	writeString		#write \n
	lw   	$ra, 0($sp) 		#epilogue
	lw	$t9, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
