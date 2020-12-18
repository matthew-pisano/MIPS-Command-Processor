.data
echoStr:	.word 0
		.asciiz "echo"
space:		.word 0x20
clear:		.word 0
tokenTable:	.word 0
		.space 16
		.space 16
		.space 16
		.space 16
endTbl:		.word 0
.globl		parseTokens
.text
#takes input string from $s1
parseTokens:	addi	$sp, $sp, -12		# Save registers. 
		sw   	$s0, 8($sp)       	# save $s0 on stack
        	sw   	$s1, 4($sp)       	# save $s1 on stack
        	sw   	$ra, 0($sp)       	# save $ra on stack
        	lw  	$s2, space	     	# load the space into $s2
        	add  	$s0, $zero, $zero 	# i = 0
        	add  	$t8, $zero, $zero 	# tblIndex = 0
        	add  	$t9, $zero, $zero 	# isEcho = 0
        	la	$s3, tokenTable		#clears token table from provious call
        	jal	clrTbl
        	la	$s3, tokenTable
        	
loop: 	add  	$t1, $s0, $s1     	# addr of y[i] in $t1
        lbu  	$t2, 0($t1)       	# $t2 = y[i]
        beq  	$t2, $s2, nxtTkn      	# next token if y[i] == " "  (20 in Hex)
loop2:	add  	$t3, $s0, $s3     	# addr of x[i] in $t3
        sb   	$t2, 0($t3)       	# x[i] = y[i]
        beq  	$t2, $zero, ret   	# exit loop if y[i] == 0  
        addi 	$s0, $s0, 1       	# i = i + 1
        j 	loop              	# next iteration of loop
nxtTkn:	bnez 	$t9, loop2		#skip if isEcho is not 0
	bnez 	$t8, after		#skip test if not at token 0
	move	$t7, $s1		#save $s1
	move	$a0, $s3
	la	$a1, echoStr		#load 'echo'
	addi	$a1, $a1, 4
	jal	stringCompare		#compare token to 'echo'     
					#allows for the text after the echo command 
					#to contain spaces while still being counted as one argument
	move	$t9, $s1		#set isEcho
	move	$s1, $t7		#restore $s1
after:	addi	$s0, $s0, 1		#jump over space
	add	$s1, $s1, $s0		#start at substring after space
	addi	$s3, $s3, 16		#next element of token table
	addi	$t8, $t8, 1		#increment tblIndex
	add  	$s0, $zero, $zero 	# i = 0
	j 	loop              	# next iteration of loop

ret: 	la	$s3, tokenTable
	lw   	$ra, 0($sp)       	# restore saved $ra
	lw   	$s1, 4($sp)       	# restore saved $s1
	la    	$s0, 8($sp)       	# restore saved $s0
	la	$a0, 0($s3)
	la	$a1, 16($s3)
	la	$a2, 32($s3)
	la	$a3, 48($s3)
        addi 	$sp, $sp, 12
        jr   	$ra               	# and return
        
clrTbl:	lw	$t1, clear		#clear table for next use
	la	$t2, endTbl
clrLoop:sw	$t1, ($s3)
	addi	$s3, $s3, 4
	blt 	$s3, $t2, clrLoop
	jr	$ra
