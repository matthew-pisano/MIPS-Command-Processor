.data
addMsg:	.asciiz " + "
subMsg:	.asciiz " - "
divMsg:	.asciiz " / "
mulMsg:	.asciiz " * "
equal:	.asciiz " = "
	.align 2
ans:	.space 4
.globl addDec	#global math commands
.globl addHex
.globl subDec
.globl subHex
.globl divDec
.globl divHex
.globl mulDec
.globl mulHex
.text
addDec:	addi	$s4, $zero, 0	#set hex or def
	addi	$s5, $zero, 0	#set operation
	j	ops
	
addHex:	addi	$s4, $zero, 1	#set hex or def
	addi	$s5, $zero, 0	#set operation
	j	ops
	
subDec:	addi	$s4, $zero, 0	#set hex or def
	addi	$s5, $zero, 1	#set operation
	j	ops
	
subHex:	addi	$s4, $zero, 1	#set hex or def
	addi	$s5, $zero, 1	#set operation
	j	ops
	
divDec:	addi	$s4, $zero, 0	#set hex or def
	addi	$s5, $zero, 2	#set operation
	j	ops
	
divHex:	addi	$s4, $zero, 1	#set hex or def
	addi	$s5, $zero, 2	#set operation
	j	ops
	
mulDec:	addi	$s4, $zero, 0	#set hex or def
	addi	$s5, $zero, 3	#set operation
	j	ops
	
mulHex:	addi	$s4, $zero, 1	#set hex or def
	addi	$s5, $zero, 3	#set operation
	j	ops

ops:	addi	$sp, $sp, -8
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
				#print out result
	
	move	$s1, $a1	#Num 1
	jal	writeString
	
	
	beq	$s5, 0, addOp	#determines which operation to do
	beq	$s5, 1, subOp
	beq	$s5, 2, divOp
	beq	$s5, 3, multOp
	
	
	addOp:	la	$s1, addMsg	#add symbol
	j	strDone
	subOp:	la	$s1, subMsg	#suntract symbol
	j	strDone
	divOp:	la	$s1, divMsg	#divide symbol
	j	strDone
	multOp:	la	$s1, mulMsg	#multiply symbol
	
	strDone:jal	writeString
	
	move	$s1, $a2	#Num 2
	jal	writeString
	
	la	$s1, equal	#"="
	jal	writeString
	
	
	move	$s3, $a1	#copy address of arg1
	move 	$s0, $s4	#tell to convert to hex or dec
	jal	cvtStr		#convert
	move	$a1, $s3	#set arg1 to converted string
	
	move	$s3, $a2	#copy address of arg2
	move 	$s0, $s4	#tell to convert to hex or dec
	jal	cvtStr		#convert
	move	$a2, $s3	#set arg2 to converted string
	
	beq	$s5, 0, addr	#determines which operation to do
	beq	$s5, 1, subbr
	beq	$s5, 2, divdr
	beq	$s5, 3, multr
	
	
addr:	add	$a1, $a1, $a2	#adds two numbers together
	j	opDone
subbr:	sub	$a1, $a1, $a2	#subtracts two numbers
	j	opDone
divdr:	div 	$a1, $a1, $a2	#divites two numbers
	j	opDone
multr:	mul 	$a1, $a1, $a2	#multiplies two numbers together
	
opDone:	sw	$a1, ans	#stores the answer at ans address
	la	$s3, ans	#load address of ans
	move 	$s0, $s4	#tell to convert from hex or dec
	jal	cvtNum		#convert
	lw 	$s3, ans	#set arg2 to converted string
	
	la	$s1, ans	#ans
	jal	writeString
	
	la	$s1, newLn	#\n
	jal	writeString
	
	lw   	$ra, 0($sp) 	#epilogue
	lw	$t9, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
