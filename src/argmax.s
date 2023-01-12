.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:

    # a0 pointer to first index, a1 length
    
    li t0 1 # t0 is our error condition (len < 1)
    add t1 x0 x0 # t1 for iteration
    li t3 0 # index of current max
    lw t4 0(a0) # current max so far
    blt a1 t0 improper 

loop_start:
    
    lw t2 0(a0) # t2 = element of array
    blt t4 t2 set_max
    
    j loop_continue
    
loop_continue:
    addi t1 t1 1
    addi a0 a0 4
    beq t1 a1 loop_end
    j loop_start

loop_end:
    # Epilogue
    add a0 t3 x0
    jr ra
    
set_max:
    add t4 t2 x0
    add t3 t1 x0
    j loop_continue
    
improper:
    li a0 36 
    j exit
    
    

