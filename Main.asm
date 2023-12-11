# Main.asm

##################################################
# Test driver for Malloc.asm
#
# The main function demonstrates how to use the
# functions in Malloc.asm. 
##################################################

.data



.text
main:
    li $t0, 200			# 256 will give 
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s1, 4($sp)		# should be 0x10040008
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s2, 4($sp)		# should be 0x10040008
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s3, 4($sp)		# should be 0x10040008
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s4, 4($sp)		# should be 0x10040008
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $s3, 0($sp)
    sw $t0, 4($sp)
    jal free
    lw $t0, 4($sp)
    lw $s3, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s5, 4($sp)		# should be equal to $s3
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s6, 4($sp)		# should be 0
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    addiu $sp, $sp, -8
    sw $t0, 0($sp)
    jal malloc
    lw $s7, 4($sp)		# should be 0
    lw $t0, 0($sp)
    addiu $sp, $sp, 8
    
    li $v0, 10   # End program
    syscall    
# end main
