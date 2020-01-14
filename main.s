.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args

    #we want 5 Arguments
    addi t1 x0 5
    bne a0 t1 eof_or_error

    #store variables

    #m0 = 4(sp), m1 = 8(sp), input= 12(sp), ouput = 16(sp)
    addi sp sp -76
    sw ra 0(sp)
    lw t1 4(a1)
    sw t1 4(sp)
    lw t2 8(a1)
    sw t2 8(sp)
    lw t3 12(a1)
    sw t3 12(sp)
    lw t4 16(a1)
    sw t4 16(sp)


	  #=====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0

    #malloc 2 4 byte heaps. 20(sp) = ptr rows of m0, 24(sp) = ptr columns of m0
    addi a0 x0 4
    jal ra malloc
    sw a0 20(sp)

    addi a0 x0 4
    jal ra malloc
    sw a0 24(sp)


    #set args to match read_matrix
    #call read matrix, save pointer to matrix
    lw a0 4(sp)
    lw a1 20(sp)
    lw a2 24(sp)

    jal ra read_matrix

    #save pointer to m0 at 28(sp)
    sw a0 28(sp)

    # Load pretrained m1. 32(sp) = rows of m1. 36(sp) = cols of m1.
    addi a0 x0 4
    jal ra malloc
    sw a0 32(sp)

    addi a0 x0 4
    jal ra malloc
    sw a0 36(sp)

    #set args to match read_matrix
    #call read matrix, save pointer to matrix
    lw a0 8(sp)
    lw a1 32(sp)
    lw a2 36(sp)

    jal ra read_matrix

    #save pointer to m1 at 40(sp)
    sw a0 40(sp)

    # Load input matrix. 44(sp) = rows of input. 48(sp) = cols of input.
    addi a0 x0 4
    jal ra malloc
    sw a0 44(sp)

    addi a0 x0 4
    jal ra malloc
    sw a0 48(sp)

    #set args to match read_matrix
    #call read matrix, save pointer to matrix
    lw a0 12(sp)
    lw a1 44(sp)
    lw a2 48(sp)

    jal ra read_matrix

    #save pointer to input at 52(sp).
    sw a0 52(sp)


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

  ########## Step 1 ###############
    #multiply m0 and input

    #malloc space for d, linear layer output. Rows of m0 * cols of input
    lw t1 20(sp)
    lw t3 0(t1)
    lw t2 48(sp)
    lw t4 0(t2)
    mul a0 t3 t4

    #save length of ouput at 56(sp)
    sw a0 56(sp)

    addi t4 x0 4
    mul a0 a0 t4

    jal ra malloc

    #store d at 60(sp)
    sw a0 60(sp)

    #set m0 args
    lw a0 28(sp)
    lw t1 20(sp)
    lw a1 0(t1)
    lw t2 24(sp)
    lw a2 0(t2)

    #set input args
    lw a3 52(sp)
    lw t1 44(sp)
    lw a4 0(t1)
    lw t2 48(sp)
    lw a5 0(t2)

    #set d arg
    lw a6 60(sp)

    jal ra matmul

############# Step 2 ######################

    #call relu on the output
    lw a0 60(sp)
    lw a1 56(sp)

    jal ra relu


############ Step 3 #######################

    #Multiply m1 * relu(d)

    #malloc space for d, linear layer output. rows of m1 * cols of input
    lw t1 32(sp)
    lw t3 0(t1)
    lw t2 48(sp)
    lw t4 0(t2)
    mul a0 t3 t4

    #save length of ouput at 64(sp)
    sw a0 64(sp)

    addi t4 x0 4
    mul a0 a0 t4

    jal ra malloc

    #store pointer to eventual score at 68(sp)
    sw a0 68(sp)

    #set m1 args
    lw a0 40(sp)
    lw t1 32(sp)
    lw a1 0(t1)
    lw t2 36(sp)
    lw a2 0(t2)

    #set relu(m0 * input) args
    lw a3 60(sp)
    lw t1 20(sp)
    lw a4 0(t1)
    lw t2 48(sp)
    lw a5 0(t2)

    #set d arg
    lw a6 68(sp)

    jal ra matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    # Load pointer to output filename

    #call write_matrix on scores, write into the output file
    lw a0 16(sp)
    lw a1 68(sp)
    lw t1 32(sp)
    lw a2 0(t1)
    lw t2 48(sp)
    lw a3 0(t2)

    jal ra write_matrix
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax on scores

    lw a0 68(sp)
    lw t1 32(sp)
    lw t1 0(t1)
    lw t2 48(sp)
    lw t2 0(t2)
    mul a1 t1 t2

    lw a1 64(sp)

    jal ra argmax

    #save argmax at 72(sp)
    sw a0 72(sp)

    # Print classification, print_int
    add a1 a0 x0
    jal ra print_int

    addi sp sp 76

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

eof_or_error:
    li a1 3
    jal exit2
