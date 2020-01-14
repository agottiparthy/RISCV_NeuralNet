.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
  # Prologue
  add t1 x0 x0

loop_start:
  bge t1 a1 loop_end
  lw t2 0(a0)
  bgt t2 x0 loop_continue
  sw x0 0(a0)

loop_continue:
  addi a0 a0 4
  addi t1 t1 1
  j loop_start

loop_end:
  # Epilogue
	ret
