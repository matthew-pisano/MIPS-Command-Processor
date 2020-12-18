.data
cvtd:		.space	4
cvtMsg1:	.asciiz " in "
hexMsg:		.asciiz "hexadecimal"
decMsg:		.asciiz "decimal"
cvtMsg2:	.asciiz " is "
.globl decHex
.globl hexDec
.text

decHex:	li	$s4, 0		#convert input to decimal
	j	cvt
	
hexDec:	li	$s4, 1		#convert input to hexadecimal
	j	cvt
	
cvt:	addi	$sp, $sp, -8	#prologue
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
	
	move	$s1, $a1	#prints user input
	jal	writeString

	move	$s0, $s4
	move	$s3, $a1	#copy address of arg1
	jal	cvtStr
	
	beqz	$s4, toDec	#tell to convert from other base
	li	$s0, 0
	j	post
toDec:	li	$s0, 1	

post:	la	$t1, cvtd
	sw	$s3, 0($t1)
	la	$s3, cvtd
	jal	cvtNum
	
	la	$s1, cvtMsg1	#prints " in"  
	jal	writeString
	
	beqz	$s4, toHex1	#prints $s4 == 0 "decimal" or $s4 == 1 "hexadecimal"
	la	$s1, hexMsg
	j	post1
toHex1:	la	$s1, decMsg
post1:	jal	writeString

	la	$s1, cvtMsg2	#prints " is "
	jal	writeString
	
	la	$s1, cvtd	#prints the converted number
	jal	writeString
	
	la	$s1, cvtMsg1	#prints in
	jal	writeString
	
	beqz	$s4, toHex2	#prints $s4 == 1 "decimal" or $s4 == 0 "hexadecimal"
	la	$s1, decMsg
	j	post2
toHex2:	la	$s1, hexMsg

post2:	jal	writeString	#writes hex or dec decision
	
	la	$s1, newLn	#prints new line
	jal	writeString
	
	lw   	$ra, 0($sp) 	#epilogue
	lw	$t9, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
