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

    memSpaceTracker: .word 0


        
.text
.globl malloc, realloc, free

#malloc:
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
    li $t0, 0($sp)          # load address of block to free
    addi $t0, $t0, -4       # load address of in use variable
    li $t1, 0               # 0 means block is freed
    sw $t1, ($t0)           # set block in use to false
# end free



malloc:
    li $t0, 0($sp)          # load amount of bytes to store
    addiu $t0, $t0, 8       # add two words to $t0 (1st is next block address, 2nd is size of block)
    li $t1, memSpaceTracker # load memSpaceTracker
    li $t2, 0               # load heap address counter

    findLoop:
        add $t3, $t2, $t0       # $t3 = heap counter + amount of bytes to store
        bgeu $t3, $t1, sbrk     # if required space is not available, increase heap space

        lw $t4, 4($t2)          # load size of current block

        lw $t2, ($t2)           # load next heap address at heap address counter
        j findLoop
        
        sbrk:
            sub $a0, $t1, $t2
            sub $a0, $t0, $a0       # calculate amount of space to increase
            addiu $a0, $a0, 4       # add 4 bytes
            li $v0, 9               # 9 is sbrk
            syscall                 # address stored in $v0
            j returnMalloc
        # end sbrk
    # end findLoop
    returnMalloc:
        addiu $t0, $t0, -4      # get block in use word
        li $t5, 1               # 1 means block is in use
        sw $t5, ($t0)           # set block in use to true
        addiu $t0, $t0, 4       # set $t0 to first index in block
        
        sw $t0, 4($sp)          # return address of first index in block
        jr $ra                  # return
    # end return
# end find