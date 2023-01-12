.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
	matmul:

    # Error checks
    
    li t0 1 # t0 is our error condition (len < 1)
    
    blt a1 t0 error
    blt a2 t0 error
    blt a4 t0 error
    blt a5 t0 error
    bne a2 a4 error
    
    # Prologue
    
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw ra 44(sp)

    add s0 a0 x0 # pointer to A
    add s1 a1 x0 # rows of A
    add s2 a2 x0 # cols of A
    add s3 a3 x0 # pointer to B
    add s4 a4 x0 # rows of B
    add s5 a5 x0 # cols of B
    add s6 a6 x0 # pointer to C
    add s7 x0 x0 # s7: current row
    add s8 x0 x0 # s8: current col
    add s9 x0 x0 # s9: counter to end of length of matrix A [deprecated]
    add s10 x0 x0 # index of C [deprecated]

outer_loop_start:

    bge s7 s1 outer_loop_end # stop multiplying if no more rows
    add s8 x0 x0 #reset current col
    
inner_loop_start:

    bge s8 s5 inner_loop_end # stop multiplying if no more cols
    
    # fill a0-4 with correct arguments for dot
    add a0 s0 x0
    add a1 s3 x0
    add a2 s2 x0
    addi a3 x0 1
    add a4 s5 x0
    
    jal dot # call dot product
    
    sw a0 0(s6) # store result to C
    addi s6 s6 4 # move pointer to B
    addi s3 s3 4 # move pointer to C
    addi s8 s8 1 # increment current col
    
    j inner_loop_start # multiply next column in same row
    
inner_loop_end:

    #increment A
    add t0 s2 x0 # t0 = how much to increment A pointer
    slli t0 t0 2 # adjust for int length (4 bytes)
    add s0 s0 t0 # move pointer to A
    
    #increment B
    
    add t0 s5 x0 # t0 = how much to increment B pointer
    slli t0 t0 2 # adjust for int length (4 bytes)
    sub t0 x0 t0 # make negative
    add s3 s3 t0 # move pointer to B
    
    #increment C
    addi s7 s7 1
    
    j outer_loop_start # multiply next row 
    
outer_loop_end:

    # Epilogue
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw ra 44(sp)
    addi sp sp 48
    
    jr ra
    
error:

    li a0 38
    j exit