.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================

dot:
    
    li t0 1 # t0 is our error condition (len < 1)
    
    blt a2 t0 improper1 # exit if not enough elems
    
    blt a3 t0 improper2 # stride 0 is under
    blt a4 t0 improper2 # stride 1 is under
    
    add t1 x0 x0 # t1 for iteration thru array 0
    
    addi a7 x0 4 # constant 4 as register
    
    mul a5 a3 a7 # bytes to jump for array 0
    mul a6 a4 a7 # bytes to jump for array 1
    
    li t3 0 # running sum
   
loop_start:

    lw t4 0(a0) # current element of array 0
    lw t6 0(a1) # current element of array 1
    
    mul t2 t4 t6 # t2 is current product to be added
    add t3 t3 t2 # t3 is running sum
    
    j loop_continue
    
loop_continue:

    addi t1 t1 1 # inc by step size for array 0 
    add a0 a0 a5
    add a1 a1 a6
    beq t1 a2 loop_end
    j loop_start

loop_end:
    # Epilogue
    add a0 t3 x0
    jr ra
    
improper1:
    li a0 36
    j exit
    
improper2:
    li a0 37
    j exit
    