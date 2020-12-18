  

.data
newLine: .word 10   				#stores \n
errorMsg: .asciiz "Error: Check your arguments\n"
.text
.globl readString
.globl enable_outint
.globl readChar

readChar:	addi	$t5, $zero, 0		#sets readString to false
		addi	$t6, $zero, 0		#sets hasReadChar to false
		j	initRead
readString:	addi	$t5, $zero, 1		#sets readString to true
initRead:	la 	$s0, newLine		#loads address of newLine into $s0
		lw 	$s0, 0($s0)		#Stores the data (hex value of \n) contained in newLine into $s0 
		add	$s2, $ra, $zero		#stores return address in $s2 for return to caller
		add 	$s4, $zero, $zero	#set complete flag to zero
		li	$s3, 0			#sets \n flag to zero		
		la	$t7, clrInp		#clears input
   		jalr	$t7 
		
		la	$t7, resetIndex		#sets index to base address of input
   		jalr	$t7 
		
		ori	$t1, $0,0			
		la	$t7, enable_rxint	#enables keyboard interrupts
   		jalr	$t7 
   		
   		beqz	$t5, charLoop

readLoop:	beq	$s3, 1, return		#return the program if the inputted character  is equal to \n
       		j 	readLoop		#loops 
       		
charLoop:	bne	$s3, 1, notEnter
		li	$t2 10
		sb	$t2, 0($s1)		#store the user inputted character into the index of the input array
		li	$t6, 1
notEnter:	beq	$t6, 1, return		#return the program if character has been inputted
       		j 	charLoop		#loops        
                 
return: 	addi	$s1, $s1, 1		#increment index
        	add 	$t2, $zero, $zero	#set $t2 to zero
        	sb	$t2, 0($s1)        	#store the null character (this is the end of the string)
        	
        	la	$t7, resetIndex		#sets index to base address of input
   		jalr	$t7 
		jr 	$s2			#jumps to caller  



.ktext 0x80000180				# Forces interrupt routine below to be
						# located at address 0x80000180.
			
#checks of interrupt is a read or write interrupt, if it is foreign, print the error msg and retun to 'scan' procedure			
ckCause:mfc0	$t9, $13
	beq	$t9, 256, rwInt		#if either read or write interrupt, skip to rwInt
	beq	$t9, 20, rwInt
	mtc0	$0, $13			#clear cause register
	
	la	$s1, errorMsg		#print error message if it is an error
	la	$t9, writeString
	jalr	$t9

	la	$t9, scan		#return to scan
	jr	$t9
	eret
rwInt:
	# interrupt handler - all registers are precious
	addiu	$sp,$sp,-32	# Save registers. 
	sw	$at,28($sp)	# so we can use it.

	# Save registers.  Remember, this is an interrupt routine
	# so it has to save anything it touches, including $t registers.
	sw	$ra,24($sp)
	sw	$a0,20($sp)
	sw	$v0,16($sp)
	sw	$t3,12($sp)
	sw	$t2,8($sp)
	sw	$t1,4($sp)
	sw	$t0,0($sp)	

	lui     $t0,0xffff		# prep base address of control regs
	
	lw	$t1,0($t0)	        # get rcv ctrl
	andi	$t1,$t1,0x0001		# extract rcv ready bit
	beq	$t1,$0,outputInt	# possible output interrupt
	lw	$a0,4($t0)		# get keyboard entered ASCII value
	
	beq	$a0, $s0, inDone	#branch to flagDone if the inputted character  is equal to \n
	
	beq	$a0, 8, bkSp
	sb	$a0, 0($s1)		#store the user inputted character into the index of the input array
        addi	$s1, $s1, 1		#increment the index of the input array of characters
        
        beq	$t5, 1, intDone		#exits if readString is false
	addi	$t6, $zero, 1
	j	inDone
	
bkSp:		la	$t0, input
		beq	$s1, $t0, bkspDone	#skip if address too low
		addi	$s1, $s1, -1		#decrement the index of the input array of characters
		addi	$t0, $t0, 0
		sb	$t0, 0($s1)
bkspDone:	j	intDone
	
	
outputInt: 	lw	$t1,8($t0)		# get output ctrl word
		andi	$t1,$t1,0x0001  	# extract ready bit 
		beq	$t1,$0,intDone		# false interrupt
		addi	$s3, $zero, 1		#sets flag to break recording loop
		lb	$s0, 0($s1)		#loads character at index $s1 into $s0
		beq	$s0, 0, exitRestore	#breaks from interrupt and halts writing
		sw      $s0, 0xc($t0)         	# when ready write character in $s0 to output register.
		addi	$s1, $s1, 1		#increment the index of the input array of characters
		j	intDone
		
resetIndex:	la 	$s1, input		#loads the address reserved for the user input in $s1
		jr	$ra			#returns to caller
	
inDone:		addi 	$s3, $zero, 1		#sets flag to break recording loop
		j	intDone
exitRestore:					#gracefully exits to writeString exit
	## Clear Cause register
	mfc0	$t0,$13				# get Cause register, then clear it
	mtc0	$0, $13

	## restore registers 
	lw	$t0,0($sp)
	lw	$t1,4($sp) 
	lw	$t2,8($sp) 
	lw	$t3,12($sp) 
	lw	$v0,16($sp) 
	lw	$a0,20($sp)
	lw	$ra,24($sp) 
	lw 	$at,28($sp) 
	addiu	$sp,$sp,32
	la	$t7, writeRet
   	jalr	$t7 
	
intDone:
	## Clear Cause register
	mfc0	$t0, $13				# get Cause register, then clear it
	mtc0	$0, $13

	## restore registers 
	lw	$t0,0($sp)
	lw	$t1,4($sp) 
	lw	$t2,8($sp) 
	lw	$t3,12($sp) 
	lw	$v0,16($sp) 
	lw	$a0,20($sp)
	lw	$ra,24($sp) 
	lw 	$at,28($sp) 
	addiu	$sp,$sp,32
	eret 					# rtn from int and reenable ints

enable_rxint:	
	li	$t0, 0x0000ff11
	andi	$t0, $t0, 0xFFFE		# clear int enable flag
	mtc0    $t0, $12			# turn interrupts off.	
	lui     $t0, 0xffff			# load control word base address 
	lw	$t1, 0($t0)	        	# read rcv ctrl
	ori	$t1, $t1, 0x0002		# set the *input* interupt enable
	sw	$t1, 0($t0)	        	# update rcv ctrl
	mfc0	$t0, $12			# get interrupt state into work register
	ori	$t0, $t0, 0x0001		# set int enable flag
	mtc0    $t0, $12			# Turn interrupts back on
	la 	$s1, input			#loads the address reserved for the user input in $s1
	jr	$ra

enable_outint:
	mfc0	$t0, $12			# get interrupt state into work register
	andi	$t0, $t0, 0xFFFE		# clear int enable flag
	mtc0    $t0, $12			# turn interrupts off.	
	lui     $t0, 0xffff			# load control word base address 
	lw	$t1, 0($t0)	        	# read rcv ctrl
	ori	$t1, $t1, 0x0002		# set the *input* interupt enable
	sw	$t1, 0($t0)	        	# update rcv ctrl
	mfc0	$t0, $12			# get interrupt state into work register
	ori	$t0, $t0, 0x0001		# set int enable flag
	mtc0    $t0, $12			# Turn interrupts back on
	jr	$ra
	
clrInp:	la	$t0, input			#clear the input space to all zeros for next call
	la	$t1, input
	addi	$t2, $zero, 0
	addi	$t1, $t1, 64
clrLp:	sw	$t2, ($t0)
	addi	$t0, $t0, 4
	blt	$t0, $t1, clrLp
	jr	$ra
.kdata
# you can put any data needed by the interrupt handler here
input: 	.word 0
	.space 512			#reserves space for user inputted string
