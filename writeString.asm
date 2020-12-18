.data
.text
.globl writeString
.globl writeRet
writeString:    lui    	$t0,0xffff              # load address of memory mapped I/O words into register     
		addi	$sp, $sp, -4
		sw	$ra, 0($sp)		#stores return address on stack for return to caller
		
		ori	$t1, $0,0			
		la	$t7, enable_outint	#enables output interrupts
   		jalr	$t7 

		lb	$s0, 0($s1)		#loads character at index $s1 into $s0
		sw      $s0, 0xc($t0)         	# when ready write character in $s0 to output register.
                
writeRet: 	lw	$ra, 0($sp)
		addi	$sp, $sp, 4		#return to caller
		jr	$ra
