.globl cvtNum
.text
#$s0: convert from hex?
#$s3: the address to confert from
#return $s3: the address of the converted number
cvtNum:	move	$t1, $s0		#save $s0
	addi	$s0, $zero, 0
	#move	$s0, $s3
	move	$t2, $s3		#save original address
	lw	$s3, 0($s3)		#loads number
	move	$t3, $s3		#temp number
	addi	$s1, $zero, 0		#init count to 0
	beq	$t1, 1, hexCt
	addi	$s2, $zero, 10
	j	count
hexCt:	addi	$s2, $zero, 16
count:	div	$t3, $t3, $s2		#counts the number of digits in the number
	addi	$s1, $s1, 1		#stores the number of digits
	bnez	$t3, count
	
	add	$t2, $t2, $s1		#the number is at most 4 digits long
cvtLp:	beq	$t1, 1, hexMod
	addi	$s1, $zero, 10
	div	$s3, $s1
	j	noHexMd
hexMod:	addi	$s1, $zero, 16
	div	$s3, $s1
noHexMd:mflo	$s3		#$s3/10 or $s3/16
	mfhi 	$s1		#load digit
	#beq	$s1, 0, cvtRet
	bgt	$s1, 9, ldHex
	addi	$s1, $s1, 48
	j	noLdHx
ldHex:	addi	$s1, $s1, 87
noLdHx:	subi	$t2, $t2, 1		#decrement address
	sb	$s1, ($t2)		#store character
	bnez 	$s3, cvtLp
cvtRet:	jr	$ra
