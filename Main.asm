# Main.asm

##################################################
#
#
#
#
#
##################################################

.data



.text
main:
    
    li $v0, 9
    li $a0, 4
    syscall
    
    sw $a0, 10040000
    sw $a0, 1($v0)
    sw $a0, 2($v0)
    sw $a0, 3($v0)
    sw $a0, 4($v0)
    sw $a0, 5($v0)

    li $v0, 0   # End program
    syscall    
# end main
