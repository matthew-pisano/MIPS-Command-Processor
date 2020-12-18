# Matthew Pisano
# Assignment 5
# 9/19/20
# stringCompare Procedure
.globl stringCompare
.text
#arguments from $a0, $a1
stringCompare: addi $sp, $sp, -12# adjust stack
        sw   $s0, 0($sp)       	# save $s0 on stack
        sw   $t1, 4($sp)       	# save $t1 on stack
        sw   $t3, 8($sp)       	# save $t3 on stack
        add  $s0, $zero, $zero 	# i = 0
loop: 	add  $t1, $s0, $a1     	# addr of y[i] in $t1
        lbu  $t2, 0($t1)       	# $t2 = y[i]
        add  $t3, $s0, $a0     	# addr of x[i] in $t3
        lbu  $t4, 0($t3)       	# $t4 = x[i]
        bne  $t2, $t4 nEqual    # exit loop if y[i] != x[i]
        beq  $t2, 0, equal      # exit loop if y[i] == null
        addi $s0, $s0, 1       	# i = i + 1
        j    loop              	# next iteration of loop
equal: 	lw   $s0, 0($sp)       	# restore saved $s0
	lw   $t1, 4($sp)       	# restore saved $t1
	lw   $t3, 8($sp)       	# restore saved $t3
        addi $sp, $sp, 12       # items from stack
        li   $s1, 1		# store 1 as the return value in $s1
        jr   $ra               	# and return
nEqual: lw   $s0, 0($sp)       	# restore saved $s0
	lw   $t1, 4($sp)       	# restore saved $t1
	lw   $t3, 8($sp)       	# restore saved $t3
        addi $sp, $sp, 12       # items from stack
        li   $s1, 0		# store 0 as the return value in $s1
        jr   $ra               	# and return
