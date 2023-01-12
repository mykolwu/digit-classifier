.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # prologue
    addi sp sp -76
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
    sw s11 44(sp)
    sw ra 48(sp)
    
    # check for correct # arguments
    li t0 5
    bne a0 t0 argerror
    
    mv s0 a0
    mv s1 a1
    mv s2 a2
    
    # Read pretrained m0
    lw a0, 4(s1)
    addi a1 sp 52     # number of rows of m0
    addi a2 sp 56     # number of cols of m0
    jal read_matrix
    mv s3 a0           # start of m0

    # Read pretrained m1
    lw a0 8(s1)
    addi a1 sp 60     # number of rows of m1
    addi a2 sp 64     # number of cols of m1
    jal read_matrix
    mv s4 a0           # start of m1

    # Read input matrix
    lw a0 12(s1)
    addi a1 sp 68     # number of rows of input mat
    addi a2 sp 72     # number of cols of input mat
    jal read_matrix
    mv s5 a0           # start of input mat


    # Compute h = matmul(m0, input)
    
    # setting proper arguments to matmul
    
#     lw a1 52(sp) # rows of m0
#     lw a2 56(sp) # cols of m0
#     mv a3 s5 # start of input
#     lw a4 68(sp) # rows of input
#     lw a5 72(sp) # cols of input
    
    # -----
    
    li t0 1
    lw t1 52(sp) # rows of m0
    lw t2 72(sp) # cols of input
    mul t0 t1 t2
    slli t0 t0 2
    mv a0 t0
    
    jal malloc
        
    li t3 0
    beq a0 t3 mallocerror
    
    mv s9 a0 # storing malloc pointer INTEGER ARRAY of h
    
    # setting proper arguments to matmul
    mv a0 s3 # start of m0
    lw a1 52(sp) # rows of m0
    lw a2 56(sp) # cols of m0
    mv a3 s5 # start of input
    lw a4 68(sp) # rows of input
    lw a5 72(sp) # cols of input
    mv a6 s9 # pointer to memory to store
      
    jal matmul
     
    # Compute h = relu(h)
    
    li t0 1
    lw t1 52(sp) # rows of m0
    lw t2 72(sp) # cols of input
    mul t0 t1 t2
    
    mv a0 s9 # integer array
    mv a1 t0 # num of elements
    jal relu

    # Compute o = matmul(m1, h)
    # setting proper arguments to matmul
    
#     lw a1 60(sp) # rows of m1
#     lw a2 64(sp) # cols of m1
#     mv a3 s9 # start of h
#     lw a4 52(sp) # rows of h
#     lw a5 72(sp) # cols of h
    
    # -----
    
    li t0 1
    lw t1 60(sp)
    lw t2 72(sp)
    mul t0 t1 t2
    mv s6 t0 # number of elements
    slli t0 t0 2
    mv a0 t0
    
    jal malloc
        
    li t3 0
    beq a0 t3 mallocerror
    
    mv s11 a0 # storing malloc pointer INTEGER ARRAY
    
    mv a0 s4 # start of m1
    lw a1 60(sp) # rows of m1
    lw a2 64(sp) # cols of m1
    mv a3 s9 # start of h
    lw a4 52(sp) # rows of h
    lw a5 72(sp) # cols of h
    mv a6 s11 # pointer to memory to store
      
    jal matmul
    
    # Write output matrix o
    # set up arguments for write_matrix
    
    lw a0, 16(s1)
    mv a1 s11
    lw a2 60(sp) # rows of m1
    lw a3 72(sp) # cols of h
    jal write_matrix

    # Compute and return argmax(o)
    # set up arguments for argmax
    mv a0 s11
    mv a1 s6
    jal argmax
    mv s10 a0 # result of argmax

    # If enabled, print argmax(o) and newline
    bne s2 x0 no_print
    jal print_int
    
    li a0 '\n'
    jal print_char
    
no_print:
     
    mv a0 s3
    jal free
    mv a0 s4
    jal free
    mv a0 s5
    jal free
    
    mv a0 s9
    jal free
    mv a0 s11
    jal free
    
    mv a0 s10
    
    # epilogue
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
    lw s11 44(sp)
    lw ra 48(sp)
    addi sp sp 76
    jr ra

mallocerror:
    li a0 26
    j exit
argerror:
    li a0 31
    j exit
