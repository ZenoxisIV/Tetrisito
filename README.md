# Tetrisito

## About the Project
This MIPS program utilizes exhaustive search to find a solution from a given starting Tetris grid to a goal Tetris grid.

## Modes
Two modes are provided:
- **Normal**: In this mode, tetriminoes do not rotate and only move downwards. There is no line clearing mechanism; tetriminoes will just keep stacking indefinitely. The game ends when the stack reaches the top of the playfield or it fails to find a solution.
- **Line Clearing**: Similar to Normal Mode, tetriminoes do not rotate and only move downwards. However, in this mode, a line clearing mechanism is enabled. When a horizontal line is completely filled with blocks, it is cleared from the playing field, and all blocks above it fall down by one row. TThe game ends when the stack reaches the top of the playfield or it fails to find a solution.

## How to Play
1. **Set Up the Grids**
    - Open a text editor.
    - Define a starting 6x5 Tetris grid using `#` for blocks and `.` for empty tiles.
    - Similarly, define a goal 6x5 Tetris grid.

2. **Select Pieces**
    - Choose a number from 1-5, indicating the number of pieces to be dropped to achieve the goal grid.
    - Define a 4x4 grid with the pieces you want to drop, using `#` and `.`.
    - Ensure the number of grids (pieces) matches the number you declared.

3. **Solve the Puzzle**
    - Input the starting grid, goal grid, and the pieces. You may refer to *Sample Test Cases* directory for more details.
    - The solver will analyze the grids and attempt a sequence of moves to transform the starting grid into the goal grid using the provided pieces.

4. **Iterate and Improve**
    - Experiment with different starting configurations and goal grids.
    - Adjust the number and types of pieces to drop to increase the challenge.
    - Refine your strategy to solve Tetris puzzles efficiently.

5. **Enjoy and Share**
    - Have fun solving Tetris puzzles!
    - Share your favorite puzzles and solutions with friends.

## Execution
To run the program for sample test cases, follow these steps:

1. **Navigate to the Sample Test Cases Directory**
   - Open your file explorer and navigate to the directory containing the *Sample Test Cases* directory.

2. **Open a Terminal**
   - Open a terminal window inside the directory.

3. **Run the Program**
   - Execute the following command:
     ```
     java -jar Mars4_5.jar p ../"<Mode>"/cs21project1c.asm < "<Type>"/<number>.in
     ```
     Replace `<Mode>` with either *Normal* or *Line Clearing*, `<Type>` with *No Line Clears* or *With Line Clears*, and `<number>` with the sample test case you want to run.

     *Note*: You may replace `"<Type>"/<number>.in` with a test case you defined yourself!

4. **Output**
   - The program will attempt to find a solution and output either `YES` or `NO`.

5. **Time to Finish**
   - For some edge-case inputs, the search might take **more than 60 seconds**, depending on your hardware specs and computing power.

## Documentation
Refer to the documentation provided for more implementation details. 

Enjoy! 😉