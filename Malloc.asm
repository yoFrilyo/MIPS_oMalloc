# Malloc.asm
# Owen Gallegos

##################################################
# maxHeapSize:	amount of available space on the
#   heap in bytes. Default is 1024 (1KB)
#
# blockCounter:	stores the number of blocks on the
#   heap to know when to call sbrk. Do not change
#   this value.
#
#
#
# .globl malloc:
# in:   0($sp) = amount of bytes to store
# out:  4($sp) = address of data block (0 if there
#   is no more space available on the heap)
# def:  Finds next available block of memory that
#   can store the specified amount of bytes, then
#   returns the address or 0 if there is not enough
#   space on the heap.
# uses:	$v: 0
#	$a: 0
#	$t: 0, 1, 2, 3
#
#
#
# .globl free:
# in:   0($sp) = address of data block
# out:  NULL
# def:  Deallocates block specified on the heap.
# uses: $t: 0, 1
##################################################
.data

    maxHeapSize: .word 1024
    blockCounter: .word 0		# do not change this variable


        
.text
.globl malloc, free



malloc:
    lw $a0, 0($sp)          # load amount of bytes to store
    
    addi $a0, $a0, 8	    # add 2 words to bytes to store (1st is for next block address, 2nd is for block state)
    li $t0, 0x10040000	    # load current heap address
    lw $t1, blockCounter    # load blockCounter ($t1 = temp block counter)
    
    findLoop:
    	beqz $t1, sbrk		# call sbrk if there are no more blocks to check
    	
    	lw $t2, 4($t0)		# load state of block (in use = 1, free = 0)
    	bnez $t2, incompatible	# branch to incompatible if block is in use
    	
    	lw $t3, ($t0)		# load next block address
    	sub $t3, $t3, $t0	# calculate size of current block
    	ble $a0, $t3, store	# branch to store if block is large enough, else block is incompatible
    	
    	incompatible:
    	    lw $t0, ($t0)	# move to next address in heap
    	    addi $t1, $t1, -1	# decrement temp block counter
    	    j findLoop		# jump to findLoop
    	# end incompatible
    # end findLoop
   
    sbrk:
    	lw $t1, maxHeapSize		# change $t1 to maxHeapSize
    	addiu $t1, $t1, 0x10040000	# set $t1 to last index of heap
    	addu $t2, $a0, $t0		# change $t2 to address of next block
    	bgt $t2, $t1, noSpace		# branch to noSpace if the block does not have enough space to store
    	li $v0, 9			# 9 is sbrk by $a0 bytes
    	syscall				# heap space is made available
    	sw $t2, ($t0)			# save address to address section of current block
    # end sbrk
    	
    store:
    	lw $t2, blockCounter	# change $t2 to block counter
    	addiu $t2, $t2, 1	# increment $t2
    	sw $t2, blockCounter	# increment blockCounter
    	
    	li $t1, 1	    	# change $t1 to 1
    	sw $t1, 4($t0)	    	# change block state to in use
    	addiu $t0, $t0, 8   	# change $t0 to 1st index of actual block
    	
    	sw $t0, 4($sp)	    	# return address of block
    	jr $ra		   	# return
    # end store
    
    noSpace:
    	li $t0, 0	    # change $t0 to 0
    	sw $t0, 4($sp)	    # return 0
    	jr $ra		    # return
    # end noSpace
# end malloc



free:
    lw $t0, 0($sp)          # load address of block to free
    
    lw $t1, blockCounter    # load blockCounter
    addi $t1, $t1, -1       # decrement $t1
    sw $t1, blockCounter    # decrement blockCounter
    
    addi $t0, $t0, -4       # load address of in use variable
    li $t1, 0               # 0 means block is freed
    sw $t1, ($t0)           # set block in use to false
    
    jr $ra		    # return
# end free