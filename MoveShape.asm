#Matthew Pisano
#10/17/20

# Important: do not put any other data before the frameBuffer
# Also: the Bitmap Display tool must be connected to MARS and set to
#   display width in pixels: 512
#   display height in pixels: 256
#   base address for display: 0x10010000 (static data)
.data
rotStep:	.word 0x3d4ccccd	#how far to rotate with each keystroke
fiveFac:	.word 0x42f00000	#used for taylor series
fourFac:	.word 0x41c00000
threeFac:	.word 0x40c00000
twoFac:		.word 0x40000000
oneFac:		.word 0x3f800000

.globl	enableMovement
.text
enableMovement:	addi	$sp, $sp, -4
		sw	$ra, 0($sp)
		
		lwc1 	$f2, rotStep		#load into FPU
		add	$t9, $zero, 0x0000ff00	#sets initial color to pure green
		la 	$t0, draw		#sets initial color to green
		jalr	$s5, $t0
		jal 	rectangle		#draws rectangle
		
moveLoop:	addi	$sp, $sp, -4		#save color
		sw	$t9, 0($sp)
		jal	readChar		#gets key from simulator
		lw   	$t9, 0($sp) 		#restore color
		addi	$sp, $sp, 4
		
		lb	$v0, ($s1)
		la 	$t0, eraseOn		#sets color to black
		jalr	$s5, $t0
		beq 	$t8, 1, afterErase	#skips erase rectangle if in draw mode
		jal	rectangle
afterErase:					#recalculates position
		beq	$v0, 119, plusY		#w
w:		beq	$v0, 97, minusX		#a
a:		beq	$v0, 115, minusY	#s
s:		beq	$v0, 100, plusX		#d
d:		beq	$v0, 113, plusRot	#q
q:		beq	$v0, 101, minusRot	#e
e:		beq	$v0, 116, toggleDraw	#t
t:		beq	$v0, 43, sizeUp		#+
pl:		beq	$v0, 45, sizeDown	#-
mn:		beq	$v0, 82, redUp		#R
R:		beq	$v0, 114, redDown	#r
r:		beq	$v0, 71, greenUp	#G
G:		beq	$v0, 103, greenDown	#g
g:		beq	$v0, 66, blueUp		#B
B:		beq	$v0, 98, blueDown	#b
bl:		#add	$t9, $zero, 0x0000ff00	#sets initial color to pure green
		la 	$t0, draw		#set color to color
		jalr	$s5, $t0
		
		jal	rectangle		#draws rectangle with selected color
		bne	$v0, 10, moveLoop	#loops
		
		lw   	$ra, 0($sp) 
		addi	$sp, $sp, 4
		jr	$ra
		
		
plusX:		addi	$a0, $a0, 1		#increments x
		add	$a0, $a0, $a1		#add width to x
		bgt	$a0, 512, zeroX		#checks if right pixel is too large
		sub	$a0, $a0, $a1		#un-adds width
		j	d
		
zeroX:		add	$a0, $zero, $zero	#resets x to zero
		j	d
		
minusX:		addi	$a0, $a0, -1		#decrements x
		bltz	$a0, maxX		#checks if x is negative
		j	a
		
maxX:		addi	$a0, $zero, 512		#sets x to bitmap width
		j	a
		
plusY:		addi	$a2, $a2, -1		#decrements y
		bltz	$a2, maxY		#checks if y is negative
		j	w
		
maxY:		addi	$a2, $zero, 256		#resets y to the bitmap height
		j	w
		
minusY:		addi	$a2, $a2, 1		#increments y
		add	$a2, $a2, $a3		#adds height to y
		bgt	$a2, 256, zeroY		#checks if top is too large
		sub	$a2, $a2, $a3		#remove height
		j	s
		
zeroY:		add	$a2, $zero, $zero	#resets y to zero
		j	s
		
plusRot:	add.s	$f1, $f1, $f2		#increments rotation
		j	q

minusRot:	sub.s	$f1, $f1, $f2		#decrements rotation
		j	e
		
toggleDraw:	beq	$t8, 1, drawOff		#skip to draw off it drawing, fall through to drawOn if not

drawOn:		add	$t8, $zero, 1		#drawing mode
		j	t		
drawOff:	add	$t8, $zero, 0		#erase mode
		j	t
		
sizeUp:		add	$a1, $a1, 1		#increase width and height by 1
		add	$a3, $a3, 1
		j	pl
		
sizeDown:	beq	$a1, 1, skipDown	#decrease width and height by 1, branch out in not
		add	$a1, $a1, -1
		add	$a3, $a3, -1
skipDown:	j	mn

redUp:		add	$t9, $t9, 655360	#increase red value, unless it would overflow
		add	$v0, $zero, 0
		bgt	$t9, 0xffffff, redDown
		j	R
redDown:	add	$t9, $t9, -655360	#decrease red value, unless it would underflow
		blt	$t9, 0, redUp
		j	r
		
greenUp:	add	$t9, $t9, 2560		#increase green value, unless it would overflow
		add	$v0, $zero, 0
		bgt	$t9, 0xffffff, greenDown
		j	G
greenDown:	add	$t9, $t9, -2560		#decrease green value, unless it would underflow
		blt	$t9, 0, greenUp
		j	g
		
blueUp:		add	$t9, $t9, 10		#increase blue value, unless it would overflow
		add	$v0, $zero, 0
		bgt	$t9, 0xffffff, blueDown
		j	B
blueDown:	add	$t9, $t9, -10		#decrease blue value, unless it would underflow
		blt	$t9, 0, blueUp
		j	bl

draw: 		move 	$t0, $t9		#moves costom color in toctiv drawing register
		jr	$s5
		
eraseOn:	add	$t0, $zero, 0x00000000	#moves black into active draeing register
		jr	$s5
		
sine:		mov.s  	$f3, $f1		#moves theta into $f3
		mul.s 	$f3, $f3, $f3
		mul.s 	$f3, $f3, $f3
		mul.s 	$f3, $f3, $f3
		mul.s 	$f3, $f3, $f3	 	#x^5
		lwc1 	$f4, fiveFac
		div.s	$f5, $f3, $f4		#x^5/5!
		mov.s  	$f3, $f1		#reset $f3 to #f1
		mul.s 	$f3, $f3, $f3
		mul.s 	$f3, $f3, $f3 		#x^3
		lwc1 	$f4, threeFac
		div.s	$f3, $f3, $f4		#x^3/3!
		
		sub.s	$f3, $f1, $f3		#1-x^3/3!
		add.s	$f3, $f3, $f5		#x-x^3/3!+x^5/5!
		jr	$s5
		
cosine:		mov.s  	$f3, $f1		#moves theta into $f3
		mul.s 	$f3, $f3, $f3
		mul.s 	$f3, $f3, $f3
		mul.s 	$f3, $f3, $f3 		#x^4
		lwc1 	$f4, fourFac
		div.s	$f5, $f3, $f4		#x^4/4!
		mov.s  	$f3, $f1		#reset $f3 to #f1
		mul.s 	$f3, $f3, $f3 		#x^2
		lwc1 	$f4, twoFac
		div.s	$f3, $f3, $f4		#x^2/2!
		
		lwc1 	$f4, oneFac
		sub.s	$f3, $f4, $f3		#x-x^2/2!
		add.s	$f3, $f3, $f5		#1-x^2/2!+x^4/4!
		jr	$s5
		
rectangle:
# $a0 is xmin (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is ymin  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)
beq	$a1,$zero,rectangleReturn # zero width: draw nothing
beq 	$a3,$zero,rectangleReturn # zero height: draw nothing

#li $t0,-1 # color: white
la 	$t1, frameBuffer
add	$s1, $a0, $zero		#stores $a0 through $a3
add	$s2, $a1, $zero
add	$s3, $a2, $zero
add	$s4, $a3, $zero
add 	$a1,$a1,$a0 		# simplify loop tests by switching to first too-far value
add 	$a3,$a3,$a2
sll 	$a0,$a0,2 		# scale x values to bytes (4 bytes per pixel)
sll 	$a1,$a1,2
sll 	$a2,$a2,11 		# scale y values to bytes (512*4 bytes per display row)
sll 	$a3,$a3,11
addu 	$t2,$a2,$t1 		# translate y values to display row starting addresses
addu 	$a3,$a3,$t1
addu 	$a2,$t2,$a0 		# translate y values to rectangle row starting addresses
addu 	$a3,$a3,$a0
addu 	$t2,$t2,$a1 		# and compute the ending address for first rectangle row
li 	$t4,0x800 		# bytes per display row

rectangleYloop:
move 	$t3,$a2 		# pointer to current pixel for X loop; start at left edge

rectangleXloop:
sw 	$t0,($t3)		#stores color at dwaring address
addiu 	$t3,$t3,4
bne 	$t3,$t2,rectangleXloop 	# keep going if not past the right edge of the rectangle

addu 	$a2,$a2,$t4 		# advace one row worth for the left edge
addu 	$t2,$t2,$t4 		# and right edge pointers

bne 	$a2,$a3,rectangleYloop 	# keep going if not off the bottom of the rectangle

rectangleReturn:
add	$a0, $s1, $zero		#renews $a0 through $a3
add	$a1, $s2, $zero
add	$a2, $s3, $zero
add	$a3, $s4, $zero
jr 	$ra
