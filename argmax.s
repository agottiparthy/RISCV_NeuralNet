.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    #t1 is the index we are checking rn =   1
    addi t1 x0 1
    #index of biggest element = 0
    add t2 x0 x0
    #value of biggest element = a[0]
    lw t3 0(a0)
    #a0 = a[1]
    addi a0 a0 4
loop_start:
  #exit to loop end when counter > a1
    bge t1 a1 loop_end

    lw t4 0(a0)
    # go to loop continue if element is less than the current max
    bge t3 t4 loop_continue
    add t2 t1 x0
    add t3 t4 x0

loop_continue:
    addi t1 t1 1
    addi a0 a0 4
    j loop_start

loop_end:
    add a0 t2 x0
    # Epilogue

    ret
