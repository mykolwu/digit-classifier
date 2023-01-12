.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    
    # a0 pointer to first index, a1 length
    
    li t0 1 # t0 is our error condition (len < 1)
    add t1 x0 x0 # t1 for iteration
    blt a1 t0 improper 

loop_start:
    
    lw t2 0(a0) # t2 = element of array
    blt t2 x0 change
    j loop_continue
    
loop_continue:
    addi t1 t1 1
    addi a0 a0 4
    beq t1 a1 loop_end
    j loop_start
    
change:
    sw x0 0(a0) # set to 0
    j loop_continue

loop_end:
    # Epilogue
    jr ra

improper:
    li a0 36 
    j exit
