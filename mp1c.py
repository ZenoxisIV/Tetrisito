from copy import deepcopy

def check_line_clear(grid):
    i = 9
    while i != 3:
        line_clear = True      
        for j in range(6):
            if grid[i][j] == '.':
                line_clear = False
                i -= 1
                break
        if line_clear:
            for j in range(i - 1, 2, -1):
                for k in range(6):
                    grid[j + 1][k] = grid[j][k] # move each row below
            if i + 1 != 10:
                i += 1
    print_grid(grid)
    return grid

def is_equal_grids(gridOne, gridTwo):
    result = True
    for i in range(6 + 4):
        for j in range(6):
            result = result and (gridOne[i][j] == gridTwo[i][j])
    return result


def print_grid(grid):
    for row in grid:
        print(''.join(row))


def freeze_blocks(grid):
    for i in range(6 + 4):
        for j in range(6):
            if grid[i][j] == '#':
                grid[i][j] = 'X'
    return grid


def get_max_x_of_piece(piece):
    max_x = -1
    for block in piece:
        max_x = max(max_x, block[1])
    return max_x


def drop_piece_in_grid(grid, piece, yOffset):
    gridCopy = deepcopy(grid)
    maxY = 100
    for block in piece:
        gridCopy[block[0]][block[1] + yOffset] = '#'  # put piece in grid\

    #  only active blocks are '#'; frozen blocks are 'X'
    while True:
        canStillGoDown = True
        for i in range(4 + 6):
            for j in range(6):
                if gridCopy[i][j] == '#' and (i + 1 == 10 or gridCopy[i + 1][j] == 'X'):
                    canStillGoDown = False
        if canStillGoDown:
            for i in range(8, -1, -1):  # move cells of piece down, starting from bottom cells
                for j in range(6):
                    if gridCopy[i][j] == '#':  # move cells down one space
                        gridCopy[i + 1][j] = '#'
                        gridCopy[i][j] = '.'
        else:
            break
    
    for i in range(4 + 6):
        for j in range(6):
            if gridCopy[i][j] == '#':
                maxY = min(maxY, i)
    if maxY <= 3:  # piece protrudes from top of 6x6 grid
        return grid, False
    else:
        # BONUS SECTION (LINE CLEARING)
        gridCopy = check_line_clear(gridCopy)
        return freeze_blocks(gridCopy), True

def convert_piece_to_pairs(pieceGrid):  # get (row,col) coords of piece at top left of grid
    pieceCoords = []
    for i in range(4):
        for j in range(4):
            if pieceGrid[i][j] == '#':
                pieceCoords.append([i, j])
    return pieceCoords

def backtrack(currGrid, chosen, pieces):
    #print(chosen)
    #print_grid(currGrid)
    #print()
    result = False
    if is_equal_grids(currGrid, final_grid):
        return True
    for i in range(len(chosen)):
        if not chosen[i]:
            max_x_of_piece = get_max_x_of_piece(pieces[i])
            chosenCopy = deepcopy(chosen)  # copy of chosen
            for offset in range(6 - max_x_of_piece):
                nextGrid, success = drop_piece_in_grid(currGrid, pieces[i], offset)
                if success:
                    chosenCopy[i] = True
                    result = backtrack(nextGrid, chosenCopy, pieces)
                    if result:
                        return True
    return result

# initialize grids to have 4 empty rows

start_grid = [['.' for _ in range(6)] for _ in range(4)]
final_grid = [['.' for _ in range(6)] for _ in range(4)]
# grids will be 10 rows by 6 columns, so we can put the piece at the top,
# before letting it fall

for _ in range(6):
    line = input()
    row = [character for character in line]
    for j in range(len(row)):
        if row[j] == '#':
            row[j] = 'X'  # mark frozen blocks as 'X'
    start_grid.append(row)

for _ in range(6):
    line = input()
    row = [character for character in line]
    for j in range(len(row)):
        if row[j] == '#':
            row[j] = 'X'   # mark frozen blocks as 'X'
    final_grid.append(row)

numPieces = int(input())
chosen = [False for _ in range(numPieces)]  # tracks which piece has been used
converted_pieces = []
for _ in range(numPieces):
    pieceAscii = []
    for _ in range(4):
        line = input()
        row = [character for character in line]
        pieceAscii.append(row)
    piecePairs = convert_piece_to_pairs(pieceAscii)
    converted_pieces.append(piecePairs)

answer = backtrack(start_grid, chosen, converted_pieces)
if answer:
    print('YES')
else:
    print('NO')
