# CS 21 LAB1 -- S2 AY 2022-2023
# Ivan Cassidy A. Cadiang -- 21/05/2023
# cs21project1c.asm --  a MIPS program that FULLY implements Tetrisito - a modified Tetris solver (with line clearing)

# Notes for the Programmer/Reader:
# (1) Most of the loops are inverted or reversed (i.e., to prevent too much dependence on j instructions). 
#     	The guard condition should be usually at the end of the loop.
# (2) Most conditions are negated to simulate properly the intended functionality.
# (3) This MIPS program is in reference with the Python code mp1c.py given alongside this Machine Problem.
# (4) The MIPS code is further optimized and does not follow some steps as the Python code dictates.
# (5) Line clearing bonus section is enabled/implemented.
# (6) Good luck and have fun! :)

.include "macros.asm"
.eqv numPieces $t9

.text
# =============== MAIN =============== #
main: li $t0, 0x10040000 # load heap memory address to $t0; this is to manually track memory allocation so that we can 'free' the heap later
sw $t0, 0($gp) # store the base address of the heap globally
sw $t0, 4($gp) # store the last allocated heap address (initial setup)
li $t0, 0 # sbrk_override_flag = False
sw $t0, 8($gp) # store sbrk_override_flag globally
la $t0, start_grid # get start_grid starting address
la $t2, final_grid # get final_grid starting address
li $t8, 0 # i = 0
li $t1, 6 # MAX_COLS_FOR_GRID = 6
addiu $t0, $t0, 24 # skip 4 empty rows for falling piece
addiu $t7, $t2, 24 # skip 4 empty rows for falling piece

loop_for_start_grid: read_str(line_grid, 7) # line = input()
la $t3, line_grid # get line base address
li $t2, 0 # counter = 0

start_loop_for_line: lbu $t4, hashtag # load '#' character
addu $t5, $t3, $t2 # target_index_on_row_array = line_base_addr + counter
lbu $t5, 0($t5) # load value of target index
bne $t5, $t4, start_increment_line_counter # check if target_index_value == '#'
replace_elem_in_grid_with_X($t0, bigX) # start_grid replacement X

start_increment_line_counter: addiu $t2, $t2, 1 # counter++
bne $t2, $t1, start_loop_for_line # character for character in line; while (counter != 6)
addiu $t8, $t8, 1 # i++
bne $t8, $t1, loop_for_start_grid # for _ in range(6)
# *************************************
li $t8, 0 # i = 0
loop_for_final_grid: read_str(line_grid, 7) # line = input()
la $t3, line_grid # get line base address
li $t2, 0 # counter = 0

final_loop_for_line: lbu $t4, hashtag # load '#' character
addu $t5, $t3, $t2 # target_index_on_row_array = line_base_addr + counter
lbu $t5, 0($t5) # load value of target index
bne $t5, $t4, final_increment_line_counter # check if target_index_value == '#'
replace_elem_in_grid_with_X($t7, bigX) # final_grid replacement X

final_increment_line_counter: addiu $t2, $t2, 1 # counter++
bne $t2, $t1, final_loop_for_line # character for character in line; while (counter != 6)
addiu $t8, $t8, 1 # i++
bne $t8, $t1, loop_for_final_grid # for _ in range(6)
# *************************************
li $t8, 0 # i = 0
get_int_user_input(numPieces) # numPieces = int(input())
sw numPieces, 12($gp) # numPieces (global)
la $t4, chosen

loop_for_chosen: addu $t3, $t4, $t8 # target_index_on_chosen_array = chosen_base_addr + counter
sb $0, 0($t3) # False
addiu $t8, $t8, 1 # i++
bne $t8, numPieces, loop_for_chosen # False for _ in range(numPieces)
# *************************************
li $t8, 0 # i = 0
li $t7, 0 # j = 0
li $t1, 4 # MAX_COLS_FOR_PIECE = 4
la $t4, pieceAscii
li $t0, 0 # track consumed bytes of converted pieces

loop_for_pieceAscii_grid: read_str(line_piece, 5) # line = input()
la $t3, line_piece # get line base address
li $t2, 0 # counter = 0
li $t5, 1 # temp = 1
bgt $t5, $t7, skip_offset # manage offset of base address of pieceAscii for the succeeding iterations (<=1)
addiu $t4, $t4, 5 # offset by 5 base address of pieceAscii (null terminator included)

skip_offset: addiu $t7, $t7, 1 # j++

pieceAscii_loop_for_line: addu $t5, $t3, $t2 # target_index_on_row_array = line_base_addr + counter
lbu $t5, 0($t5) # load value of target index
addu $t6, $t4, $t2 # target_index_on_pieceAscii_array = pieceAscii_base_addr + counter
sb $t5, 0($t6) # store character of line in pieceAscii
addiu $t2, $t2, 1 # counter++
bne $t2, $t1, pieceAscii_loop_for_line # # character for character in line; while (counter != 4)
bne $t7, $t1, loop_for_pieceAscii_grid # for _ in range(4)

prepare_for_convertion: la $t5, pieceAscii
move $a0, $t5 # pieceAscii (passing to function)
jal convert_piece_to_pairs # convert_piece_to_pairs(pieceAscii)
move $t5, $v0 # piecePairs = convert_piece_to_pairs(pieceAscii)
move $t3, $v1 # index tracker

append_to_converted_pieces: la $t6, converted_pieces
addu $t6, $t6, $t0 # adjust base address of converted_pieces
lbu $t4, 0($t5) # load i from temp
sb $t4, 0($t6) # store i to converted_pieces
lbu $t4, 1($t5) # load j from temp
sb $t4, 1($t6) # store j to converted_pieces
addiu $t0, $t0, 2 # consumed bytes = consumed bytes + 2
addiu $t5, $t5, 2 # adjust base address of piecePairs
bne $t5, $t3, append_to_converted_pieces
li $t7, 0 # j = 0
la $t4, pieceAscii # reset offset base address of pieceAscii
addiu $t8, $t8, 1 # i++
bne $t8, numPieces, loop_for_pieceAscii_grid # for _ in range(numPieces)
# *************************************
la $a0, start_grid
la $a1, chosen
la $a2, converted_pieces
jal backtrack # backtrack(start_grid, chosen, converted_pieces)
move $t0, $v0 # answer = backtrack(start_grid, chosen, converted_pieces)
beq $t0, $0, answer_no
print_str(yes) # print("YES")
j terminate

answer_no: print_str(no) # print("NO")

terminate: exit() # syscall code 10

# =============== FUNCTIONS =============== #
convert_piece_to_pairs: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
sw $s1, 20($sp)
sw $s2, 16($sp)
# ------- END ------- #

li $t5, 4 # temp = 4
li $t6, 0 # i = 0
li $s2, 0 # j = 0
li $s0, 0 # pieceCoords_index_counter = 0

convert_piece_loop: access_2d_array($t6, $s2, $a0, $s1, 5) # pieceGrid[i][j]
lbu $t3, hashtag # load '#' character
bne $s1, $t3, skip_append_coords # if pieceGrid[i][j] == '#'
la $t3, pieceCoords
addu $t3, $t3, $s0 # adjust base address of pieceCoords
sb $t6, 0($t3) # i
sb $s2, 1($t3) # j
addiu $s0, $s0, 2 # offset += 2

skip_append_coords: addiu $s2, $s2, 1 # j++
bne $s2, $t5, convert_piece_loop # for j in range(4)
addiu $t6, $t6, 1 # i++
li $s2, 0
bne $t6, $t5, convert_piece_loop # for i in range(4)
la $s1, pieceCoords
addu $s0, $s1, $s0 # signal end of array
move $v0, $s1 # return pieceCoords
move $v1, $s0 # return pieceCoords array index termination

convert_piece_done: # ------- POSTAMBLE ------- #
lw $s2, 16($sp)
lw $s1, 20($sp)
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

backtrack: # ------- PREAMBLE ------- #
subu $sp, $sp, 36
sw $ra, 32($sp)
sw $s0, 28($sp)
sw $s1, 24($sp)
sw $s2, 20($sp)
sw $s3, 16($sp)
sw $s4, 12($sp)
sw $s5, 8($sp)
sw $s6, 4($sp)
sw $s7, 0($sp)
# ------- END ------- #

lw numPieces, 12($gp) # get numPieces from global
jal is_equal_grids # is_equal_grids(currGrid, final_grid)
move $s2, $v0
li $s1, 0 # result = False
li $t2, 1 # True
beq $s2, $t2, backtrack_return_True # if is_equal_grids(currGrid, final_grid)
li $s2, 0 # i = 0

backtrack_outer_loop: beq $s2, numPieces, backtrack_return_result # for i in range(len(chosen))
move $s0, $a0 # save contents of $a0 (currGrid) in preparation for possible recursion or to make space
move $s5, $a1 # save contents of $a1 (chosen) to make space
access_1d_array($s2, $s5, $s4) # chosen[i]
li $t2, 1 # True
beq $s4, $t2, backtrack_increment_i # if not chosen[i]:
move $a0, $s2 # pass value of i to get_max_x_of_piece
jal get_max_x_of_piece # get_max_x_of_piece(pieces, i)
move $s3, $v0 # max_x_of_piece = get_max_x_of_piece(pieces, i)
jal deepcopy_chosen # deepcopy(chosen)
move $s6, $v0 # chosenCopy = deepcopy(chosen)
move $a0, $s0 # move currGrid back to $a0
li $a3, 0 # offset
li $t0, 6
subu $s3, $t0, $s3 # range(6 - max_x_of_piece)

backtrack_inner_loop: beq $a3, $s3, backtrack_increment_i # for offset in range(6 - max_x_of_piece)
move $a1, $s2 # copy contents of i to $a1 to get pieces[i] for drop_piece_in_grid
jal drop_piece_in_grid # drop_piece_in_grid(currGrid, i, pieces, offset)
move $a0, $v0 # nextGrid
move $t0, $v1 # success
move $a1, $s6 # store chosenCopy to $a1
beq $t0, $0, backtrack_increment_offset # if success
li $t2, 1 # True
store_in_1d_array($s2, $a1, $t2) # chosenCopy[i] = True
move $s7, $a3 # save the value of offset temporarily
jal backtrack # backtrack(nextGrid, chosenCopy, pieces)
move $s1, $v0 # result = backtrack(nextGrid, chosenCopy, pieces)
move $a3, $s7 # store back the value of offset back to $a3
beq $s1, $0, backtrack_increment_offset # if result
j backtrack_return_True

backtrack_increment_i: move $a1, $s5 # move chosen back to $a1
addiu $s2, $s2, 1
j backtrack_outer_loop

backtrack_increment_offset: move $a0, $s0 # move currGrid back to $a0
jal free # free(nextGrid); if nextGrid is currGrid, no deallocation will happen
addiu $a3, $a3, 1 # offset++
j backtrack_inner_loop

backtrack_return_True: li $v0, 1 # return True
j backtrack_done

backtrack_return_result: move $v0, $s1 # return result

backtrack_done: # ------- POSTAMBLE ------- #
lw $s7, 0($sp)
lw $s6, 4($sp)
lw $s5, 8($sp)
lw $s4, 12($sp)
lw $s3, 16($sp)
lw $s2, 20($sp)
lw $s1, 24($sp)
lw $s0, 28($sp)
lw $ra, 32($sp)
addu $sp, $sp, 36
# ------- END ------- #
jr $ra

is_equal_grids: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
# ------- END ------- #

li $s0, 1 # result = True
li $t2, 4 # i = 4; skip first 4 rows since they are only for dropping pieces
li $t6, 0 # j = 0
li $t4, 10 # range(6 + 4)
li $t5, 6 # range(6)
la $t7, final_grid # get final_grid starting address

is_equal_grids_loop: access_2d_array($t2, $t6, $a0, $t0, 6)
access_2d_array($t2, $t6, $t7, $t1, 6)
beq $t0, $t1, is_equal_grids_skip_set_to_false # gridOne[i][j] == gridTwo[i][j]
li $s0, 0 # result = False;
j is_equal_grids_return # exit the loop since one element is not equal; thus, the grids are not equal.

is_equal_grids_skip_set_to_false: addiu $t6, $t6, 1 # j++
bne $t6, $t5, is_equal_grids_loop # for j in range(6)
li $t6, 0 # j = 0
addiu $t2, $t2, 1 # i++
bne $t2, $t4, is_equal_grids_loop # for i in range(6 + 4)

is_equal_grids_return: move $v0, $s0 # return result

is_equal_grids_done: # ------- POSTAMBLE ------- #
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

get_max_x_of_piece: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
# ------- END ------- #

li $t4, -1 # max_x = -1
li $t5, 1 # index = 1
mul $t7, $a0, 8 # offset by i * 8
addu $t5, $t5, $t7 # index = index + offset
addiu $t6, $t5, 8 # max index for a piece

get_max_x_of_piece_loop: beq $t5, $t6, get_max_x_of_piece_return # for block in piece
access_1d_array($t5, $a2, $t7) # block[1]
blt $t4, $t7, get_max_x_of_piece_change_max_val # max(max_x, block[1])
j get_max_x_of_piece_increment_index

get_max_x_of_piece_change_max_val: move $t4, $t7 # max_x = max(max_x, block[1])

get_max_x_of_piece_increment_index: addiu $t5, $t5, 2 # index = index + 2
j get_max_x_of_piece_loop

get_max_x_of_piece_return: move $v0, $t4 # return max_x

get_max_x_of_piece_done: # ------- POSTAMBLE ------- #
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

drop_piece_in_grid: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
sw $s1, 20($sp)
sw $s2, 16($sp)
sw $s3, 12($sp)
sw $s4, 8($sp)
# ------- END ------- #

move $s4, $a1 # store i temporarily in $s4 to prepare for malloc()
jal deepcopy_grid # deepcopy(grid)
move $a1, $s4 # bring back i to $a1
move $s0, $v0 # gridCopy = deepcopy(grid)
mul $t1, $a1, 8 # for each piece[i], we have exactly 4 '#'s. Thus, 4 * 2 = 8 coords and counter = i * 8
addiu $t2, $t1, 8 # range for end of loop (array end)
move $t4, $a2 # temp = base address of pieces
move $t7, $s0 # temp = base address of gridCopy
lbu $s1, hashtag # load '#' character
lbu $s2, bigX # load 'X' character
lbu $s3, dot # load '.' character

drop_piece_in_grid_block_piece_loop: beq $t1, $t2, drop_piece_in_grid_while_True_loop # for block in piece
addu $t4, $t4, $t1 # block[0]
lbu $t5, 0($t4) # load value of block[0]
addiu $t4, $t4, 1 # block[1]
lbu $t6, 0($t4) # load value of block[1]
addu $t6, $t6, $a3 # col = block[1] + yOffset
store_in_2d_array($t5, $t6, $t7, $s1, 6) # gridCopy[block[0]][block[1] + yOffset] = '#'; put piece in grid
move $t4, $a2 # reset base address of pieces
move $t7, $s0 # reset base address of gridCopy
addiu $t1, $t1, 2 # counter += 2
j drop_piece_in_grid_block_piece_loop

drop_piece_in_grid_while_True_loop: li $t1, 0 # i = 0; while True; only active blocks are '#'; frozen blocks are 'X'
li $t2, 0 # j = 0
li $t4, 10 # range(4 + 6)
li $t5, 6 # range(6)
li $t7, 0 # flag_one = False
li $t8, 0 # flag_two = False

drop_piece_in_grid_outer_loop: beq $t1, $t4, drop_piece_in_grid_canStillGoDown # for i in range(4 + 6)

drop_piece_in_grid_inner_loop: beq $t2, $t5, drop_piece_in_grid_increment_i # for j in range(6)
access_2d_array($t1, $t2, $s0, $t3, 6) # access gridCopy[i][j]
beq $t3, $s1, flag_one_True # if gridCopy[i][j] == '#'
j drop_piece_in_grid_increment_j # first condition failed; hence, we can safely increment j
check_other_conditions: addiu $t6, $t1, 1 # i + 1
beq $t6, $t4, flag_two_True # i + 1 == 10
access_2d_array($t6, $t2, $s0, $t3, 6) # access gridCopy[i + 1][j]
beq $t3, $s2, flag_two_True # if gridCopy[i + 1][j] == 'X'
j drop_piece_in_grid_increment_j # all conditions failed (False and False); we can safely increment j

flag_one_True: li $t7, 1 # flag_one = True
j check_other_conditions

flag_two_True: li $t8, 1 # flag_two = True
j break_all_loops # canStillGoDown = False; we can safely break from the while loop since we have (True and True) since next branch would fail regardless

drop_piece_in_grid_increment_i: addiu $t1, $t1, 1 # i++
li $t2, 0 # j = 0
j drop_piece_in_grid_outer_loop

drop_piece_in_grid_increment_j: addiu $t2, $t2, 1 # j++
j drop_piece_in_grid_inner_loop

drop_piece_in_grid_canStillGoDown: li $t0, -1 # if canStillGoDown; range(8, -1, -1); move cells of piece down, starting from bottom cells
li $t1, 8 # i = 8
li $t2, 0 # j = 0
li $t4, 6 # range(6)

drop_piece_in_grid_canStillGoDown_outer_loop: beq $t1, $t0, drop_piece_in_grid_while_True_loop # for i in range(8, -1, -1)

drop_piece_in_grid_canStillGoDown_inner_loop: beq $t2, $t4, drop_piece_in_grid_canStillGoDown_decrement_i # for j in range(6)
access_2d_array($t1, $t2, $s0, $t3, 6) # access gridCopy[i][j]
bne $t3, $s1, drop_piece_in_grid_canStillGoDown_increment_j # if gridCopy[i][j] == '#'; move cells down one space
addiu $t5, $t1, 1 # i + 1
store_in_2d_array($t5, $t2, $s0, $s1, 6) # gridCopy[i + 1][j] = '#'
store_in_2d_array($t1, $t2, $s0, $s3, 6) # gridCopy[i][j] = '.'
j drop_piece_in_grid_canStillGoDown_increment_j

drop_piece_in_grid_canStillGoDown_decrement_i: subiu $t1, $t1, 1 # i--
li $t2, 0 # j = 0
j drop_piece_in_grid_canStillGoDown_outer_loop

drop_piece_in_grid_canStillGoDown_increment_j: addiu $t2, $t2, 1 # j++
j drop_piece_in_grid_canStillGoDown_inner_loop

break_all_loops: li $t0, 100 # maxY = 100
li $t1, 0 # i = 0
li $t2, 0 # j = 0
li $t4, 10 # range(10)
li $t5, 6 # range(6)

drop_piece_in_grid_maxY_outer_loop: beq $t1, $t4, check_piece_protrudes # for i in range(4 + 6)

drop_piece_in_grid_maxY_inner_loop: beq $t2, $t5, drop_piece_in_grid_maxY_increment_i # for j in range(6)
access_2d_array($t1, $t2, $s0, $t3, 6) # access gridCopy[i][j]
bne $t3, $s1, drop_piece_in_grid_maxY_increment_j # if gridCopy[i][j] == '#'
ble $t0, $t1, drop_piece_in_grid_maxY_increment_j # compares if maxY <= i; if false, then we update maxY
move $t0, $t1 # maxY = min(maxY, i)
j drop_piece_in_grid_maxY_increment_j

drop_piece_in_grid_maxY_increment_i: addiu $t1, $t1, 1 # i++
li $t2, 0 # j = 0
j drop_piece_in_grid_maxY_outer_loop

drop_piece_in_grid_maxY_increment_j: addiu $t2, $t2, 1 # j++
j drop_piece_in_grid_maxY_inner_loop

check_piece_protrudes: li $t1, 3 # $t1 = 3
bgt $t0, $t1, piece_protrudes_else # if maxY <= 3; piece protrudes from top of 6x6 grid
jal free # free(gridCopy)
move $v0, $a0 # return grid
li $v1, 0 # return False
j drop_piece_in_grid_done

piece_protrudes_else: move $a0, $s0 # move to $a1 contents of gridCopy
jal check_line_clear # check_line_clear(gridCopy)
move $a0, $v0 # gridCopy = check_line_clear(gridCopy)
jal freeze_blocks # freeze_blocks(gridCopy)
li $v1, 1 # return freeze_blocks(gridCopy), true; (note: contents of $v0 is the return value of freeze_blocks)

drop_piece_in_grid_done: # ------- POSTAMBLE ------- #
lw $s4, 8($sp)
lw $s3, 12($sp)
lw $s2, 16($sp)
lw $s1, 20($sp)
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

freeze_blocks: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
sw $s1, 20($sp)
# ------- END ------- #

lbu $s0, hashtag # load '#' character
lbu $s1, bigX # load 'X' character
li $t0, 0 # i = 0
li $t1, 0 # j = 0
li $t2, 10 # range(4 + 6)
li $t4, 6 # range(6)

freeze_blocks_loop: access_2d_array($t0, $t1, $a0, $t3, 6) # access grid[i][j]
bne $t3, $s0, freeze_blocks_skip # if grid[i][j] == '#'
store_in_2d_array($t0, $t1, $a0, $s1, 6) # grid[i][j] = 'X'
freeze_blocks_skip: addiu $t1, $t1, 1 # j++
bne $t1, $t4, freeze_blocks_loop # for j in range(6)
addiu $t0, $t0, 1 # i++
li $t1, 0 # j = 0
bne $t0, $t2, freeze_blocks_loop # for i in range(4 + 6)
move $v0, $a0 # return grid

freeze_blocks_done: # ------- POSTAMBLE ------- #
lw $s1, 20($sp)
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

check_line_clear: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
sw $s1, 20($sp)
# ------- END ------- #

li $t0, 9 # i = 9
li $t1, 3 # guard = 3
li $t2, 0 # j = 0
li $t4, 6 # range(6)
li $t5, 2 # guard_inner_j = 2
li $t6, 0 # k = 0
li $t8, 10 # 10
lbu $s1, dot # load '.' character
check_line_clear_while_loop: beq $t0, $t1, check_line_clear_return # while i != 3

check_line_clear_outer_j_loop: beq $t2, $t4, if_line_clear # for j in range(6)
access_2d_array($t0, $t2, $a0, $s0, 6) # access grid[i][j]
bne $s0, $s1, check_line_clear_increment_outer_j # if grid[i][j] == '.'
subiu $t0, $t0, 1 # i--
li $t2, 0 # j = 0; reset j for next while loop iteration
j check_line_clear_while_loop

check_line_clear_increment_outer_j: addiu $t2, $t2, 1 # j++
j check_line_clear_outer_j_loop

if_line_clear: subiu $t2, $t0, 1 # j = i - 1

if_line_clear_inner_j_loop: beq $t2, $t5, if_i_not_ten # for j in range(i - 1, 2, -1)

if_line_clear_k_loop: beq $t6, $t4, if_line_clear_decrement_inner_j # for k in range(6)
access_2d_array($t2, $t6, $a0, $s0, 6) # access grid[j][k]
addiu $t7, $t2, 1 # j + 1
store_in_2d_array($t7, $t6, $a0, $s0, 6) # grid[j + 1][k] = grid[j][k]; move each row below
j if_line_clear_increment_k

if_line_clear_decrement_inner_j: subiu $t2, $t2, 1 # j--
li $t6, 0 # k = 0
j if_line_clear_inner_j_loop

if_line_clear_increment_k: addiu $t6, $t6, 1 # k++
j if_line_clear_k_loop

if_i_not_ten: li $t2, 0 # j = 0; reset j for next while loop iteration
addiu $t7, $t0, 1 # i + 1
beq $t7, $t8, check_line_clear_while_loop # if i + 1 != 10
addiu $t0, $t0, 1 # i++
j check_line_clear_while_loop

check_line_clear_return: move $v0, $a0 # return grid

check_line_clear_done: # ------- POSTAMBLE ------- #
lw $s1, 20($sp)
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- 
jr $ra

# =============== AUXILIARY FUNCTIONS =============== #
deepcopy_chosen: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
# ------- END ------- #

lw numPieces, 12($gp) # get numPieces from global
move $t6, $a1 # store base address of chosen temporarily
li $a1, 6 # allocate bytes for chosen (max number of Pieces possible)
jal malloc # malloc(sizeof(chosen))
move $t1, $v0
move $a1, $t6 # bring back chosen to $a1
li $t2, 0 # i = 0

deepcopy_chosen_loop: access_1d_array($t2, $a1, $t3) # $t3 = chosen[i]; assume all arrays are 1D at this point (contiguous memory)
addu $t4, $t1, $t2 # offset for copy; base address + offset
sb $t3, 0($t4) # store chosen[i] to copy[i]
addiu $t2, $t2, 1 # i++
bne $t2, numPieces, deepcopy_chosen_loop # for i in range(numPieces)
move $v0, $t1 # return base address of copy

deepcopy_chosen_done: # ------- POSTAMBLE ------- #
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

deepcopy_grid: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
# ------- END ------- #

li $a1, 60 # 10 x 6 grid = 60 characters; len(grid)
move $t8, $a0 # save contents of $a0 to temp
jal malloc # malloc(sizeof(grid))
move $t1, $v0
move $a0, $t8 # move grid back to $a0
li $t2, 0 # i = 0

deepcopy_grid_loop: access_1d_array($t2, $a0, $t3) # $t3 = grid[i]; assume all arrays are 1D at this point (contiguous memory)
addu $t4, $t1, $t2 # offset for copy; base address + offset
sb $t3, 0($t4) # store grid[i] to copy[i]
addiu $t2, $t2, 1 # i++
bne $t2, $a1, deepcopy_grid_loop # for i in range(len(grid))
move $v0, $t1 # return base address of copy

deepcopy_grid_done: # ------- POSTAMBLE ------- #
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

malloc: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
sw $s1, 20($sp)
# ------- END ------- #

lw $s1, 4($gp) # get address of available heap
move $s0, $s1 # update base address of current heap 
addu $s1, $s1, $a1 # allocate n number of bytes
li $t1, 0x103FFFFC # max allowed heap address by sbrk
bgt $s1, $t1, override_sbrk # if current allocation is more than the maximum allowed heap, override to use more than sbrk allows.
sw $s0, 0($gp) # update base address of current heap
sw $s1, 4($gp) # store the new allocated memory globally
move $v0, $s0 # return the base address of the new allocated heap
j malloc_done

override_sbrk: lw $s0, 8($gp) # check sbrk_override_flag
beq $s0, 0, malloc_flag_true # if False, sbrk_override_flag = True
j malloc_skip

malloc_flag_true: li $s0, 1 # sbrk_override_flag = True
sw $s0, 8($gp) # store new value of sbrk_override_flag globally
li $s1, 0x7FC00000 # new initial address allocation; (note: 0x10400000 to 0x7FBFFFFC is restricted in MARS)
sw $s1, 0($gp) # update base address of current heap
sw $s1, 4($gp) # store the new allocated memory globally

malloc_skip: lw $s1, 4($gp) # get address of available heap
move $s0, $s1 # update base address of current heap 
addu $s1, $s1, $a1 # allocate n number of bytes
sw $s0, 0($gp) # update base address of current heap
sw $s1, 4($gp) # store the new allocated memory globally
move $v0, $s0 # return the base address of the new allocated heap

malloc_done: # ------- POSTAMBLE ------- #
lw $s1, 20($sp)
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

free: # ------- PREAMBLE ------- #
subu $sp, $sp, 32
sw $ra, 28($sp)
sw $s0, 24($sp)
# ------- END ------- #

lw $s0, 0($gp) # get the base address of current heap
sw $s0, 4($gp) # free allocated heap

free_done: # ------- POSTAMBLE ------- #
lw $s0, 24($sp)
lw $ra, 28($sp)
addu $sp, $sp, 32
# ------- END ------- #
jr $ra

.data
# grids will be 10 rows by 6 columns, so we can put the piece at the top before letting it fall
start_grid: .byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'

final_grid: .byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'
.byte '.', '.', '.', '.', '.', '.'

allocate_bytes(line_grid, 7)
allocate_bytes(line_piece, 5)
allocate_bytes(chosen, 5) # 5 pieces; 1 byte for bool (0 or 1); tracks which piece has been used
allocate_bytes(converted_pieces, 40) # exactly 4 hashtags per piece; 5 pieces; 2 pos; 4*5*2
allocate_bytes(pieceAscii, 20) # 4x4 grid + 4 null terminators; (4*4)+4
allocate_bytes(pieceCoords, 8) # exactly 4 hashtags per piece; 2 pos; 4*2

newline: .asciiz "\n"
yes: .asciiz "YES"
no: .asciiz "NO"
hashtag: .byte  '#'
bigX: .byte 'X'
dot: .byte '.'
