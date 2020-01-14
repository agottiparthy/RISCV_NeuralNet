.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -28
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    sw a2 12(sp)
    sw a3 16(sp)

    #set args for fopen
    lw a1 04(sp)
    addi a2 x0 1

    jal ra fopen

    #ensure success
    addi t0 x0 -1
    beq a0 t0 eof_or_error

    #store file descriptor at 20(sp)
    sw a0 20(sp)


    #create a buffer to store 8 bytes for # of rows and columns
    addi a0 x0 8

    jal ra malloc

    #pointer to heap memory for rows and columns
    sw a0 24(sp)

    #store rows and columns in this heap
    lw t1 24(sp)
    lw t2 12(sp)
    lw t3 16(sp)
    sw t2 0(t1)
    addi t1 t1 4
    sw t3 0(t1)

    #write the rows and columns at the top
    lw a1 20(sp)
    lw a2 24(sp)
    addi a3 x0 2
    addi a4 x0 4

    jal ra fwrite

    bne a0 a3 eof_or_error

    #args for fwrite for the matrix data
    lw a1 20(sp)
    lw a2 8(sp)
    lw t0 12(sp)
    lw t1 16(sp)
    mul a3 t0 t1
    addi a4 x0 4

    jal ra fwrite

    bne a0 a3 eof_or_error

    # close file
    lw a1 20(sp)

    jal ra fclose

    #ensure success
    addi t0 x0 -1
    beq a0 t0 eof_or_error

    # Epilogue
    lw ra 0(sp)
    lw a0 4(sp)
    lw a1 8(sp)
    lw a2 12(sp)
    lw a3 16(sp)
    addi sp sp 28

    ret

eof_or_error:
    li a1 1
    jal exit2
