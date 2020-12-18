.data
helpStart:	.align 2
		.asciiz "--Help Menu--\n"
helpEcho:	.align 2
		.asciiz "echo\tPrints an inputted phrase to the screen\n\t\targ1: The phrase to print\n"
helpExit:	.align 2
		.asciiz "exit\tTerminates the program\n"
helpHelp:	.align 2
		.asciiz "help\tDisplays command list and usages\n"
helpMemory:	.align 2
		.asciiz "memory\tDisplays a specified section of memory\n\t\targ1: The hexadecimal memory address\n\t\targ2 (Optional): The length of memory to print in decimal, if no arg2 then print out the bit at the address\n"
helpPaint:	.align 2
		.asciiz "paint\tDraws on a bitmap display\n\t\t--Controls--\n\t\t\tw: Moves the brush up\n\t\t\ta: Moves the brush left\n\t\t\ts: Moves the brush down\n\t\t\td: Moves the brush right\n\t\t\tt: Toggles between draw and erase\n\t\t\t+: Increases the brush size\n\t\t\t-: Decreases the brush size\n\t\t\tR: Increases the Redness of the brush\n\t\t\tr: Decreases the Redness of the brush\n\t\t\tG: Increases the Greenness of the brush\n\t\t\tg: Decreases the Greenness of the brush\n\t\t\tB: Increases the Blueness of the brush\n\t\t\tb: Decreases the Blueness of the brush\n"
helpIntro:	.align 2
		.asciiz "intro\tPlays the intro theme\n"	
helpMidi:	.align 2
		.asciiz "midi\tPlays a MIDI sound\n\t\targ1: The pitch (0-127)\n\t\targ2: The duration in miliseconds\n\t\targ3: The instrument (0-127)\n"

#------Conversion Commands------#
helpDecHex:	.align 2
		.asciiz "dechex\tConverts the argument from decimal to hexadecimal\n\t\targ1: The decimal number ot be converted\n"
helpHexDec:	.align 2
		.asciiz "hexdec\tConverts the argument from hexadecimal to decimal\n\t\targ1: The hexadecimal number ot be converted\n"		

#------Math Commands------#
helpAdd:	.align 2
		.asciiz "add\tAdds the two decimal arguments\n\t\targ1: The first addend\n\t\targ2: The second addend\n"
helpAddh:	.align 2
		.asciiz "addh\tAdds the two hexadecimal arguments\n\t\targ1: The first addend\n\t\targ2: The second addend\n"

helpSub:	.align 2
		.asciiz "sub\tSubtracts the two decimal arguments\n\t\targ1: The minuend\n\t\targ2: The subtrahend\n"
helpSubh:	.align 2
		.asciiz "subh\tSubtracts the two hexadecimal arguments\n\t\targ1: The minuend\n\t\targ2: The subtrahend\n"
		
helpDiv:	.align 2
		.asciiz "div\tDivides the two decimal arguments\n\t\targ1: The dividend\n\t\targ2: The divisor\n"
helpDivh:	.align 2
		.asciiz "divh\tDivides the two hexadecimal arguments\n\t\targ1: The dividend\n\t\targ2: The divisor\n"
		
helpMul:	.align 2
		.asciiz "mul\tMultiplies the two decimal arguments\n\t\targ1: The first factor\n\t\targ2: The second factor\n"
helpMulh:	.align 2
		.asciiz "mulh\tMultiplies the two hexadecimal arguments\n\t\targ1: The first factor\n\t\targ2: The second factor\n"
.globl help
.text
help:	addi	$sp, $sp, -8	#epilogue
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
	
	la	$s1, helpStart	#Help header
	jal	writeString
	
	la	$s1, helpEcho	#Echo help
	jal	writeString
	
	la	$s1, helpExit	#Exit help
	jal	writeString
	
	la	$s1, helpHelp	#Help help
	jal	writeString
	
	la	$s1, helpMemory	#Memory help
	jal	writeString
	
	la	$s1, helpMidi	#Midi help
	jal	writeString
	
	la	$s1, helpPaint	#Paint help
	jal	writeString
	
	la	$s1, helpIntro	#intro help
	jal	writeString
	
	la	$s1, helpDecHex	#DecHex help
	jal	writeString
	
	la	$s1, helpHexDec	#HexDec help
	jal	writeString
	
	la	$s1, helpAdd	#Add help
	jal	writeString
	la	$s1, helpAddh	#Addh help
	jal	writeString
	
	la	$s1, helpSub	#Sub help
	jal	writeString
	la	$s1, helpSubh	#Subh help
	jal	writeString
	
	la	$s1, helpMul	#Mul help
	jal	writeString
	la	$s1, helpMulh	#Mulh help
	jal	writeString
	
	la	$s1, helpDiv	#Div help
	jal	writeString
	la	$s1, helpDivh	#Divh help
	jal	writeString
	
	lw   	$ra, 0($sp) 	#prlogue
	lw	$t9, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
