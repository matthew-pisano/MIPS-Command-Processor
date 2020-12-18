.data
frameBuffer: 	.space 0x80000		#where the bitmap starts in memory
introTxt:	.asciiz "--Welcome To MIPS Command Processor--\nMatthew Pisano 2020.  No Rights Reserved\n"
newCmd:		.asciiz ":/> "
newLn:		.asciiz "\n"
missingNo:	.asciiz "Command not recognized\n"
table: 	.word 0
	.asciiz "help"
	.word help
	.asciiz "echo"
	.word echo
	.asciiz "exit"
	.word exit
	.asciiz "memory"
	.word memory
	.asciiz "midi"
	.word midi
	
	.asciiz "add"
	.space 1
	.word addDec
	.asciiz "addh"
	.word addHex
	
	.asciiz "sub"
	.space 1
	.word subDec
	.asciiz "subh"
	.word subHex
	
	.asciiz "div"
	.space 1
	.word divDec
	.asciiz "divh"
	.word divHex
	
	.asciiz "mul"
	.space 1
	.word mulDec
	.asciiz "mulh"
	.word mulHex
	
	.asciiz "paint"
	.word paint
	
	.asciiz "intro"
	.word intro
	
	.asciiz "dechex"
	.word decHex
	
	.asciiz "hexdec"
	.word hexDec
endTbl: .word 0
.globl newLn
.globl scan
.globl frameBuffer
.text

main:	la	$s1, introTxt		#print welcome text
	jal	writeString
	
	jal	intro			#introductory jingle
	
scan:	la	$s1, newCmd		#write prompt for new connand
	jal	writeString
	
	jal	readString		#wait for read
	jal	parseTokens
	jal	writeString		#write the user entered command
	la	$s1, newLn		#newline to prepare for command output
	jal	writeString
	la 	$t0, table		# load start of table into $t0
	addi	$t0, $t0, 4
	la 	$t1, endTbl		#load end of table into $t1
	addi	$t9, $zero, 0		#set commandRan flag
	
tblLoop:move	$t3, $a1		#save arg1
	move	$a1, $t0		#set arg1 to tableStart		
	jal	stringCompare
	move	$a1, $t3		#restore arg1
	beqz	$s1, after
	addi	$t9, $zero, 1		#set commandRan to 1
	lw	$t2, 8($t0)
	jalr	$t2			#run command at address $t2
	j	scan
after:	addi	$t0, $t0, 12		#increment table index
	bge 	$t0, $t1, noCmd		#branch if text did not match command
	j	tblLoop

noCmd:	beq 	$t9, 1, scan		#print error if commandRan == 0
	la	$s1, missingNo
	jal	writeString
	j	scan
	
intro:	addi	$a1, $zero, 4300	#set up notes and instruments for intro theme
	addi	$a2, $zero 80
	addi	$a3, $zero, 100
	addi	$v0, $zero, 31
	
	addi	$a0, $zero 60
	syscall			#midi syscall
	
	addi	$v0, $zero, 32
	addi	$a0, $zero, 700
	syscall
	
	addi	$a2, $zero 91
	
	addi	$a3, $zero, 70
	addi	$v0, $zero, 33
	addi	$a1, $zero, 1000
	
	addi	$a0, $zero 75
	syscall			#midi syscall
	
	
	addi	$a0, $zero 77
	syscall			#midi syscall
	
	addi	$a0, $zero 80
	syscall			#midi syscall
	
	addi	$a2, $zero 93
	
	addi	$a1, $zero, 2000
	addi	$a0, $zero 75
	syscall			#midi syscall
	
	jr	$ra
