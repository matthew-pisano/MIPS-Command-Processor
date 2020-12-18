.data
	.word 0
midiTxt:.asciiz "Playing MIDI sound...\n"
.globl midi
.text
midi:	addi	$sp, $sp, -8	#prologue
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
	
	la	$s1, midiTxt	#write status
	jal	writeString
	
	move	$s3, $a1	#copy address of arg1
	addi	$s0, $zero, 0	#tell to convert to dec
	jal	cvtStr		#convert
	move	$a1, $s3	#set arg1 to converted string
	
	move	$s3, $a2	#copy address of arg2
	addi	$s0, $zero, 0	#tell to convert to dec
	jal	cvtStr		#convert
	move	$a2, $s3	#set arg2 to converted string
	
	move	$s3, $a3	#copy address of arg3
	addi	$s0, $zero, 0	#tell to convert to dec
	jal	cvtStr		#convert
	move	$a3, $s3	#set arg3 to converted string
	
	move	$a0, $a1	#move arguments to appropriate registers for midi syscall
	move	$a1, $a2
	addi	$a1, $a1, 400	#add 400ms to duration (curcumvents possinble delay 
	move	$a2, $a3
	addi	$a3, $zero, 100	#set volume to 100
	
	addi	$v0, $zero, 31
	syscall			#midi syscall
	
	lw   	$ra, 0($sp) 	#epilogue
	lw	$t9, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
