.data
		.align 2
startTxt:	.asciiz "--Paint--\nOpen Bitmap Display\nStarting Paint...(Press Enter To Exit)\n:/Paint> "
		.align 2
exitTxt:	.asciiz "Paint Closed Succesfully\n"
.globl paint
.text

# Example of drawing a rectangle; left x-coordinate is 100, width is 25
# top y-coordinate is 200, height is 50. Coordinate system starts with
# (0,0) at the display's upper left corner and increases to the right
# and down.  (Notice that the y direction is the opposite of math tradition.)
paint:
	addi	$sp, $sp, -8	#prologue
	sw	$ra, 0($sp)
	sw	$t9, 4($sp)
	
	li 	$a0,200		#x
	li 	$a1,2		#width
	li 	$a2,100		#y
	li 	$a3,2		#height
	
	la	$s1, startTxt	#write status
	jal	writeString
	
	jal	enableMovement	#movement procedure
	
	la	$s1, exitTxt	#write exit text
	jal	writeString
	
	j	scan		#exit
