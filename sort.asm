.data
A:  .space 200       # Array A with 50 integers, each of size 4 bytes
N:  .word 0          # N for dimension
I:  .word 0          # I for index array element
J:  .word 0          # J for index array element
HELP:  .word 0       # HELP for permutation
PMAX:  .word 0       # PMAX indicates the pos. of the element maximum on the right of A[I]
prompt1:  .asciiz " Give the size of array (max.50) : "
prompt2:  .asciiz "Element "
prompt3:  .asciiz " : "
given_array:  .asciiz "Given array :\n"
sorted_array:  .asciiz "Sorted array :\n"

    .text
    .globl main
main:
    # Data entry
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, prompt1     # Load the address of the prompt1 string into register $a0
    syscall             # Print the prompt1 string
    li $v0, 5           # Load the read integer syscall code into register $v0
    syscall             # Read integer N
    sw $v0, N           # Store N in memory
    li $t0, 0           # Initialize J to 0
input_loop:
    beq $t0, $v0, array_display  # If J == N, jump to array_display
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, prompt2     # Load the address of the prompt2 string into register $a0
    syscall             # Print the prompt2 string
    move $a0, $t0       # Move J to register $a0
    li $v0, 1           # Load the print integer syscall code into register $v0
    syscall             # Print J
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, prompt3     # Load the address of the prompt3 string into register $a0
    syscall             # Print the prompt3 string
    li $v0, 5           # Load the read integer syscall code into register $v0
    syscall             # Read integer A[J]
    sll $t1, $t0, 2     # Calculate the offset for A[J]
    sw $v0, A($t1)      # Store A[J] in memory
    addi $t0, $t0, 1    # Increment J by 1
    j input_loop        # Jump back to input_loop

array_display:
    # Array display
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, given_array # Load the address of the given_array string into register $a0
    syscall             # Print the given_array string
    li $t0, 0           # Initialize J to 0
display_loop:
    bge $t0, $v0, array_sorting  # If J >= N, jump to array_sorting
    sll $t1, $t0, 2     # Calculate the offset for A[J]
    lw $a0, A($t1)      # Load A[J] into register $a0
    li $v0, 1           # Load the print integer syscall code into register $v0
    syscall             # Print A[J]
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, " "         # Load the address of the space string into register $a0
    syscall             # Print a space
    addi $t0, $t0, 1    # Increment J by 1
    j display_loop      # Jump back to display_loop

array_sorting:
    # Array sorting
    li $t0, 0           # Initialize I to 0
outer_loop:
    bge $t0, $v0, print_sorted_array  # If I >= N, jump to print_sorted_array
    li $t2, 0           # Initialize PMAX to 0
    add $t3, $t0, 1     # Initialize J to I + 1
inner_loop:
    bge $t3, $v0, swap_elements  # If J >= N, jump to swap_elements
    sll $t4, $t3, 2     # Calculate the offset for A[J]
    lw $t5, A($t4)      # Load A[J] into register $t5
    sll $t6, $t2, 2     # Calculate the offset for A[PMAX]
    lw $t7, A($t6)      # Load A[PMAX] into register $t7
    ble $t5, $t7, else_branch  # If A[J] <= A[PMAX], jump to else_branch
    move $t2, $t3       # Move J to PMAX
else_branch:
    addi $t3, $t3, 1    # Increment J by 1
    j inner_loop        # Jump back to inner_loop

swap_elements:
    sll $t8, $t0, 2     # Calculate the offset for A[I]
    lw $t9, A($t8)      # Load A[I] into register $t9
    sll $t10, $t2, 2    # Calculate the offset for A[PMAX]
    lw $t11, A($t10)    # Load A[PMAX] into register $t11
    sw $t9, A($t10)     # Store A[I] in A[PMAX]
    sw $t11, A($t8)     # Store A[PMAX] in A[I]
    addi $t0, $t0, 1    # Increment I by 1
    j outer_loop        # Jump back to outer_loop

print_sorted_array:
    # Editing results
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, sorted_array # Load the address of the sorted_array string into register $a0
    syscall             # Print the sorted_array string
    li $t0, 0           # Initialize J to 0
print_loop:
    bge $t0, $v0, exit_program  # If J >= N, jump to exit_program
    sll $t1, $t0, 2     # Calculate the offset for A[J]
    lw $a0, A($t1)      # Load A[J] into register $a0
    li $v0, 1           # Load the print integer syscall code into register $v0
    syscall             # Print A[J]
    li $v0, 4           # Load the print string syscall code into register $v0
    la $a0, " "         # Load the address of the space string into register $a0
    syscall             # Print a space
    addi $t0, $t0, 1    # Increment J by 1
    j print_loop        # Jump back to print_loop

exit_program:
    li $v0, 10          # Load the exit syscall code into register $v0
    syscall             # Exit the program
