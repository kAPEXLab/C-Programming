# 62 - Robotics Grid Robot Command Processor - Difficult

## Question Details
- Concept: Arrays, structures, pointers, enumerations, loops, and state updates
- Difficulty: Difficult
- Domain: Robotics
- Scenario: A mobile robot processes a sequence of movement and turn commands while reporting its final grid position and heading.
- Learning Objective: Pass an array of commands and update a structure through a pointer while handling malformed sequences safely.

## Scenario
The robot starts at a supplied integer coordinate and heading. It executes commands in order until the sequence ends or an invalid command is encountered.

## Function Details
- Define heading values `NORTH`, `EAST`, `SOUTH`, and `WEST` in that clockwise order.
- Define `RobotState` with integer `x`, integer `y`, heading, and `commandsExecuted` fields.
- Function Name: `execute_robot_commands`
- Function Signature: `int execute_robot_commands(const char commands[], int count, RobotState *state);`
- Valid count is 0 through 50. Valid commands are `F` (one cell forward), `B` (one cell backward), `L` (turn left 90 degrees), and `R` (turn right 90 degrees).
- For movement, north increases y, east increases x, south decreases y, and west decreases x. Backward movement is opposite the current heading. Turning does not move the robot.
- Return 1 when all commands are valid; return 0 when an invalid command or count is encountered. Stop at the first invalid command and retain the state after all earlier valid commands. `commandsExecuted` counts only executed commands.
- The caller provides a non-null state pointer. The command array is non-null when count > 0. No grid boundary restrictions apply.

## Tasks to Implement
1. Define the heading values and `RobotState` structure.
2. Implement the command loop, movement rules, and heading rotation.
3. Update the caller's state through its pointer.
4. Stop safely on invalid input and preserve the already-executed state.
5. Verify all 10 cases.

## Test Cases
| Test Case ID | Initial state: x,y,heading | Commands | Expected: return; final x,y,heading; executed |
| --- | --- | --- | --- |
| TC01 | 0,0,NORTH | `F` | 1; 0,1,NORTH; 1 |
| TC02 | 2,3,EAST | `F,R,F` | 1; 3,2,SOUTH; 3 |
| TC03 | 0,0,NORTH | `L,F` | 1; -1,0,WEST; 2 |
| TC04 | 5,5,SOUTH | `B` | 1; 5,6,SOUTH; 1 |
| TC05 | 1,-1,WEST | `F,R,F` | 1; 0,0,NORTH; 3 |
| TC06 | 0,0,NORTH | `R,R,R,R` | 1; 0,0,NORTH; 4 |
| TC07 | 4,4,EAST | `F,X,F` | 0; 5,4,EAST; 1 |
| TC08 | -2,7,SOUTH | empty, count=0 | 1; -2,7,SOUTH; 0 |
| TC09 | 0,0,NORTH | `L,B,R,F` | 1; 1,1,NORTH; 4 |
| TC10 | 3,3,NORTH | `F,B,L,R` | 1; 3,3,NORTH; 4 |

## Expected Deliverables
- Definitions for the heading values and state structure.
- A complete implementation of `execute_robot_commands`.
- A short explanation of direction mapping, turns, and invalid-command handling.
- Test evidence for all 10 cases.
