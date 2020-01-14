.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    # if a2 != a4, exit
    bne a2 a4 mismatched_dimensions

    # Prologue
    # row counter
    add t2 x0 x0

    # store 4 for easy multiply
    addi t4 x0 4


outer_loop_start:
  bge t2 a1 outer_loop_end

  # column counter
  add t3 x0 x0

inner_loop_start:
  bge t3 a5 inner_loop_end

  #save any variables that need to be saved
  addi sp sp -44
  sw ra 0(sp)
  sw a0 4(sp)
  sw a1 8(sp)
  sw a2 12(sp)
  sw a3 16(sp)
  sw a4 20(sp)
  sw a5 24(sp)
  sw a6 28(sp)
  sw t2 32(sp)
  sw t3 36(sp)
  sw t4 40(sp)

  #set a0 - start of v0
  add a0 a0 x0

  #set a1 - start of v1
  #a3 + 4 * column
  mul t5 t3 t4
  add a1 a3 t5

  #set a2 - length of vectors
  #a2 or a4
  add a2 a2 x0

  #set a3 - stride of the row-wise matrix
  addi a3 x0 1

  #set a4 - stride of the column wise matrix
  add a4 a5 x0

  #call Dot
  jal ra dot

  #save answer to position
  sw a0 0(a6)

  #reload variables
  lw ra 0(sp)
  lw a0 4(sp)
  lw a1 8(sp)
  lw a2 12(sp)
  lw a3 16(sp)
  lw a4 20(sp)
  lw a5 24(sp)
  lw a6 28(sp)
  lw t2 32(sp)
  lw t3 36(sp)
  lw t4 40(sp)
  addi sp sp 44

  #increment column
  addi t3 t3 1

  #increment a6
  addi a6 a6 4

  j inner_loop_start
inner_loop_end:
  # increment row
  addi t2 t2 1

  #increment a0
  mul t5 t4 a2
  add a0 a0 t5

  j outer_loop_start

outer_loop_end:
    # Epilogue
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
