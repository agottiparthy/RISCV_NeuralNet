.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
	  addi sp sp -36
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    sw a2 12(sp)

    #set a1 to a0 for fopen call
    add a1 a0 x0

    #set a2 to file permissions
    add a2 x0 x0

    #call fopen
    jal ra fopen

    #ensure success
    addi t0 x0 -1
    beq a0 t0 eof_or_error

    #16(sp) = file descriptor
    sw a0 16(sp)

    #read # of rows
    #set a1 to file descriptor, a2 to the row arg (existing ptr to int), a3 to 4 bytes
    #8(sp) = pointer to # of rows
    lw a1 16(sp)
    lw a2 8(sp)
    addi a3 x0 4

    #read 4 bytes from file
    jal ra fread

    #check if # of bytes read is = to # wanted to read
    bne a3 a0 eof_or_error

    #read # of columns
    #12(sp) = pointer to # of columns
    lw a1 16(sp)
    lw a2 12(sp)
    addi a3 x0 4

    #read next 4
    jal ra fread

    # check output
    bne a3 a0 eof_or_error

    #load pointers to rows and columns into t0 and t1
    lw t0 8(sp)
    lw t1 12(sp)

    #load values into t2 = rows and t3 = cols
    lw t2 0(t0)
    lw t3 0(t1)

    #20(sp) = rows and 24(sp) = columns
    sw t2 20(sp)
    sw t3 24(sp)

    #arguments for t2 * t3 * 4 bytes malloc
    mul a0 t2 t3
    addi t4 x0 4
    mul a0 a0 t4

    # save # of bytes to be read in matrix, 28(sp)
    sw a0 28(sp)

    #malloc space for fread
    jal ra malloc

    #save location for pointer to matrix heap, 32(sp)
    sw a0 32(sp)

    #load args for fread
    lw a1 16(sp)
    lw a2 32(sp)
    lw a3 28(sp)

    #read matrix into file
    jal ra fread

    # check that # of bytes is = to # desired
    bne a3 a0 eof_or_error

    #close file
    lw a1 16(sp)
    jal ra fclose

    #check if successful
    bne a0 x0 eof_or_error

    #set a1 and a2 to rows columns, a0 to pointer to matrix
    # to pointers!!!!
    lw a1 8(sp)
    lw a2 12(sp)
    lw a0 32(sp)

    # Epilogue
    lw ra 0(sp)
    addi sp sp 36

    ret

eof_or_error:
    li a1 1
    jal exit2
