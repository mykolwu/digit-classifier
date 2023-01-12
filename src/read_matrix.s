.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    
    addi sp sp -32
    
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)
    
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s6 x0
    
    li a1 0
    jal fopen
    mv s0 a0 # descriptor
    li t0 -1
    beq s0 t0 fopen_error
    
    mv a1 s1
    li a2 4
    jal fread
    li t0 -1
    beq a0 t0 fread_error
    
    mv a0 s0
    mv a1 s2
    li a2 4
    jal fread
    li t0 -1
    beq a0 t0 fread_error
   
    lw t1 0(s1)
    lw t2 0(s2)
    mul t3 t1 t2
    mv s3 t3
    slli a0 t3 2    
    jal malloc
    beq a0 x0 malloc_error
    
    mv s4 a0
    slli t3 s3 2
    mv s3 t3

    mv a0 s0
    mv a1 s4
    mv a2 s1
    jal fread
    li t0 -1
    beq a0 t0 fread_error
    
    # Epilogue 
    mv a0 s0
    jal fclose 
    li t0 -1
    beq a0 t0 fclose_error
    
    mv a0 s4
    
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    
    addi sp sp 32
    
    jr ra
    
malloc_error:
    li a0 26
    j exit
fopen_error:
    li a0 27
    j exit
fclose_error:
    li a0 28
    j exit
fread_error:
    li a0 29
    j exit
