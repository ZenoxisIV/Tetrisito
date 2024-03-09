# CS 21 LAB1 -- S2 AY 2022-2023
# Ivan Cassidy A. Cadiang -- 21/05/2023
# macros.asm -- an asm file full of macros for cs21project1c.asm

# ------- UNIVERSAL -------
.macro do_syscall(%n)
li $v0, %n
syscall
.end_macro

.macro exit
do_syscall(10)
.end_macro

.macro get_int_user_input(%store_reg)
do_syscall(5)
move %store_reg, $v0
.end_macro

.macro print_str(%label)
la $a0, %label
do_syscall(4)
.end_macro

.macro read_str(%label, %len)
la $a0, %label
li $a1, %len
do_syscall(8)
.end_macro

.macro allocate_bytes(%label, %n)
%label: .space %n
.end_macro
# -------------------------------

# ------------ ARRAYS -----------
.macro replace_elem_in_grid_with_X(%base_addr, %label)
mul $t4, $t8, 6 # multiply row index by 6 to access desired row 
addu $t4, $t4, $t2 # access desired col
addu $t4, $t4, %base_addr # target_index_grid = base_addr + offset
lbu $t5, %label # get 'X' character
sb $t5, 0($t4) # mark frozen blocks as 'X'
.end_macro

.macro get_memory_address(%n, %m, %addr, %step)
mul $t3, %n, %step
addu $t3, $t3, %m
addu $t3, %addr, $t3
.end_macro

.macro access_2d_array(%n, %m, %addr, %store_reg, %step)
get_memory_address(%n, %m, %addr, %step)
lbu %store_reg, 0($t3)
.end_macro

.macro access_1d_array(%n, %addr, %store_reg)
addu $t3, %addr, %n
lbu %store_reg 0($t3)
.end_macro

.macro store_in_2d_array(%n, %m, %addr, %val, %step)
get_memory_address(%n, %m, %addr, %step)
sb %val, 0($t3)
.end_macro

.macro store_in_1d_array(%n, %addr, %val)
addu $t3, %addr, %n
sb %val, 0($t3)
.end_macro
# -------------------------------
