# 11 - Production Cell Availability Pattern - Medium

## Question Details
- Concept: Loops, character sequences, and consecutive-state tracking
- Difficulty: Medium
- Domain: Manufacturing operations
- Learning Objective: Count operating and down periods and detect a sustained equipment outage.

## Scenario
A line monitor records five consecutive production periods as `R` (running) or `D` (down). The shift report needs both totals and an alert when the cell is down for at least three consecutive periods.

## Function Details
- Function Name: `evaluate_cell_availability`
- Function Signature: `int evaluate_cell_availability(int periods, const char states[], int *runningCount, int *downCount, int *outageAlert);`
- `periods` is 1..96 and each state is `R` or `D`.
- Set `outageAlert` to 1 if any run of at least three consecutive `D` states occurs, otherwise 0.
- Return 1 on valid input and 0 for invalid count, state, or null pointers. Do not modify outputs on failure.

## Tasks to Implement
1. Traverse the state sequence once.
2. Count running and down periods.
3. Track the current consecutive down run and set the alert at length three.
4. Reject unknown state characters without changing outputs.

## Test Cases
| Test Case ID | Input states | Expected: return, runningCount, downCount, outageAlert |
| --- | --- | --- |
| TC01 | `RRDRR` | 1, 4, 1, 0 |
| TC02 | `RRRRR` | 1, 5, 0, 0 |
| TC03 | `DDDRR` | 1, 2, 3, 1 |
| TC04 | `RDDDD` | 1, 1, 4, 1 |
| TC05 | `RDRDR` | 1, 3, 2, 0 |
| TC06 | `DRXRR` | 0, unchanged, unchanged, unchanged |

## Expected Deliverables
- A complete implementation of `evaluate_cell_availability`.
- A short explanation of loop-based run tracking.
- Test evidence for all six cases.
