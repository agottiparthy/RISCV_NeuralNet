.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:

    # Prologue
    #index where we are multiplying = 0
    add t1 x0 x0
    #current sum = 0
    add t2 x0 x0


loop_start:
    bge t1 a2 loop_end

    #load Arguments
    lw t3 0(a0)
    lw t4 0(a1)

    #multiply element
    mul t5 t3 t4
    #increment sum
    add t2 t2 t5

    addi t5 x0 4
    mul t6 t5 a3
    #increment a0
    add a0 a0 t6


    mul t6 t5 a4
    #increment a1
    add a1 a1 t6

    #increment index
    addi t1 t1 1

    j loop_start


loop_end:
    add a0 t2 x0
    # Epilogue


    ret
