# Malloc.asm
# Owen Gallegos

##################################################
# .globl malloc:
# in:   0($sp) = amount of bytes to store
# out:  4($sp) = address of data block
# def:  Finds next available block of memory that
#   can store the specified amount of bytes, then
#   returns the address or 0 if there is not enough
#   space on the heap.
#
# .globl realloc:
# in:   0($sp) = address of data block
#       4($sp) = new amount of bytes to store
# out:  8($sp) = new address of data block
# def:  Finds next available block of memory that
#   can store the specified amount of bytes. If the
#   specified amount of bytes is smaller than the
#   previous amount of allocated data, the address
#   data may be lost.
#
# .globl free:
# in:   0($sp) = address of data block
# out:  NULL
# def:  Deallocates space
##################################################
.data

    oheap: .space 400


        
.text
.globl malloc, realloc, free

malloc:
    li $t1, 0($sp)          # load amount of bytes to store

    addiu $sp, $sp, -8      # allocate stack space
    sw $t1, 0($sp)          # save amount of bytes to store
    sw $ra, 6($sp)
    jal find                # call find
    lw $ra, 6($sp)
    lw $t0, 4($sp)          # load found address from return
    lw $t1, 0($sp)          # load amount of bytes to store
    addiu $sp, $sp, 8       # deallocate stack space

    sw $t0, 4($sp)          # save found address to return
    jr $ra                  # return
# end malloc



realloc:



# end realloc



free:



# end free



find:
    li $t1, 0($sp)          # load amount of bytes to store

    


# end find