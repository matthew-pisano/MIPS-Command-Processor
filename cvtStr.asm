.globl cvtStr
.text
#$s0: convert to hex?
#$s3: the address to confert from
#return $s3: the address of the converted string
cvtStr:	move	$t1, $s0
	move	$s0, $s3
	addi	$s3, $zero, 0		#where address is constructed
cvtLp:	lb	$s1, ($s0)		#load char
	beq	$s1, 0, cvtRet
	beq	$t1, 1, isHex
	mul 	$s3, $s3, 10
	j	notHex	
isHex:	mul 	$s3, $s3, 16
notHex:	bgt	$s1, 57, hex
	subi	$s1, $s1, 48		#shift for 0-9
	j	pastHex
hex:	subi	$s1, $s1, 87		#check for a-f

pastHex:add	$s3, $s3, $s1
	addi	$s0, $s0, 1		#increment index
	j	cvtLp
cvtRet:	jr	$ra
