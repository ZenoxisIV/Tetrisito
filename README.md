## About the Project
This [CS 21](https://dcs.upd.edu.ph/academics/undergraduate-program/) project is a MIPS program that uses exhaustive search to find a solution from a given starting Tetris grid to a goal Tetris grid.

## Modes
Two modes are provided:
- **Normal**: In this mode, tetrominoes do not rotate and only move downwards. There is no line clearing mechanism; tetrominoes will just keep stacking indefinitely. The game ends when the stack reaches the top of the playing field or it fails to find a solution.
- **Line Clearing**: Similar to Normal Mode, tetrominoes do not rotate and only move downwards. However, in this mode, a line clearing mechanism is enabled. When a horizontal line is completely filled with blocks, it is cleared from the playing field, and all blocks above it fall down by one row. The game ends when the stack reaches the top of the playing field or it fails to find a solution.

## How to Play
1. **Set Up the Grids**
    - Open a text editor.
    - Define a starting 6x5 Tetris grid using `#` for blocks and `.` for empty tiles.
    - Similarly, define a goal 6x5 Tetris grid.

2. **Select Pieces**
    - Choose a number from 1-5, indicating the number of pieces to be dropped to achieve the goal grid.
    - Define a 4x4 grid with the pieces (tetrominoes) you want to drop, using `#` and `.` for blocks and empty tiles, respectively.
    - Ensure the number of grids (pieces) matches the number you declared.

3. **Solve the Puzzle**
    - Input the starting grid, goal grid, and the pieces. You may refer to *Sample Test Cases* directory for visualization.
    - The solver will analyze the grids and attempt a sequence of moves to transform the starting grid into the goal grid using the provided pieces.

## Execution
To run the program for sample test cases, follow these steps:

1. **Navigation**
   - Open your file explorer and navigate to the *Sample Test Cases* directory.

2. **Open a Terminal**
   - Open a terminal window inside the directory.

3. **Run the Program**
   - Execute the following command:
     ```
     runtime java -jar Mars4_5.jar p ../"<Mode>"/cs21project1c.asm < "<Type>"/<number>.in
     ```
     Replace `<Mode>` with either *Normal* or *Line Clearing*, `<Type>` with *No Line Clears* or *With Line Clears*, and `<number>` with the sample test case you want to run. Lastly, including `runtime` is optional. It simply tracks the execution time of the program.

     *Note*: You may replace `"<Type>"/<number>.in` with a test case you defined yourself!

4. **Output**
   - The program will attempt to find a solution and output either `YES` or `NO`.

5. **Time to Finish**
   - For some edge-case inputs, the search might take **more than 60 seconds**, depending on your hardware specs and computing power.

## Documentation
Refer to the documentation provided for more implementation details.
