.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    
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
    mv s3 a3
    
    li a1 1
    jal fopen
    li t0 -1
    beq a0 t0 fopen_error
   
    mv s4 a0

    mul s5 s2 s3 # items
    #addi s5 s5 2
    
    #mv t1 s5
    #slli t1 t1 2
    #mv a0 t1
    #jal malloc
    
    addi sp sp -4
    sw s2 0(sp)
    
    mv a0 s4
    #lw a1 0(sp)
    mv a1 sp
    addi a2 x0 1
    addi a3 x0 4
    jal fwrite
    addi t0 x0 1
    bne a0 t0 fwrite_error
    
    lw s2 0(sp)
    addi sp sp 4
    
    
    addi sp sp -4
    sw s3 0(sp)

    mv a0 s4
    #lw a1 4(sp)
    mv a1 sp
    addi a2 x0 1
    addi a3 x0 4
    jal fwrite
    addi t0 x0 1
    bne a0 t0 fwrite_error
    
    lw s3 0(sp)
    addi sp sp 4
    
    
       
    mv a1 s1
    mv a0 s4
    mv a2 s5
    li a3 4
    
    jal fwrite
    bne a0 s5 fwrite_error
    
    mv a0 s4
    jal fclose 
    li t0 -1
    beq a0 t0 fclose_error
    
    # Epilogue 

    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    
    addi sp sp 32
    
    ret

fopen_error:
    li a0 27
    j exit
fwrite_error:
    li a0 30
    j exit
fclose_error:
    li a0 28
    j exit
