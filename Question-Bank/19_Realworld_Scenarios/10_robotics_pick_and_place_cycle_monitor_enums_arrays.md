# 10 - Robotics Pick-and-Place Cycle Monitor - Difficult

## Question Details
- Concept: Enumerations, arrays, loops, structures, pointers, and finite-state logic
- Difficulty: Difficult
- Domain: Robotics and industrial automation
- Scenario: A robot-cell monitor checks event sequences, counts completed pick-and-place cycles, and records faults and protocol errors.
- Learning Objective: Process an event array with a state machine and return multiple counters through an output structure.

## Scenario
A robot cell emits event codes as it handles a part. A valid cycle is `PART_DETECTED`, `GRIP_CLOSED`, `ITEM_PICKED`, `ITEM_PLACED`, then `GRIP_OPENED`. After the final event, the cell returns to the idle state and can begin another cycle.

## Function Details
- Define event values `PART_DETECTED=1`, `GRIP_CLOSED=2`, `ITEM_PICKED=3`, `ITEM_PLACED=4`, `GRIP_OPENED=5`, and `FAULT=6`.
- Define `CycleReport` with `completedCycles`, `sequenceErrors`, `faultEvents`, and `incompleteCycles` fields.
- Function Name: `analyze_robot_events`
- Function Signature: `int analyze_robot_events(const int events[], int count, CycleReport *report);`
- Valid count is 0 through 100. The event array is non-null when count > 0; the report pointer is non-null.
- Events 1 through 5 must appear in the exact cycle order above. An unexpected valid event increments `sequenceErrors`, resets the cycle to idle, and is discarded (it is not reinterpreted as the start of a new cycle).
- A `FAULT` increments `faultEvents` and resets the current cycle to idle without incrementing `sequenceErrors`.
- At end of input, increment `incompleteCycles` once if the state is partway through a cycle.
- If count is outside its valid range or an event code is outside 1..6, return 0 and zero every report field. Otherwise return 1, including for an empty event list.

## Tasks to Implement
1. Define the event values and `CycleReport` structure.
2. Implement the cycle state machine and process events in order.
3. Apply the exact reset and discard rules for unexpected events and faults.
4. Count an unfinished cycle at most once after processing the full list.
5. Validate complete cycles, partial cycles, faults, errors, and invalid input.

## Test Cases
| Test Case ID | Input event sequence | Expected Output: return; completed, errors, faults, incomplete |
| --- | --- | --- |
| TC01 | `{}` count=0 | 1; 0,0,0,0 |
| TC02 | `{1,2,3,4,5}` | 1; 1,0,0,0 |
| TC03 | `{1,2,3,4,5,1,2,3,4,5}` | 1; 2,0,0,0 |
| TC04 | `{1,2,3,4}` | 1; 0,0,0,1 |
| TC05 | `{1,3}` | 1; 0,1,0,0 |
| TC06 | `{6}` | 1; 0,0,1,0 |
| TC07 | `{1,6}` | 1; 0,0,1,0 |
| TC08 | `{1,2,3,4,5,6}` | 1; 1,0,1,0 |
| TC09 | `{2,1,2,3,4,5}` | 1; 1,1,0,0 |
| TC10 | `{1,2,3,4,7}` | 0; 0,0,0,0 |

## Expected Deliverables
- Definitions for event values and `CycleReport`.
- A complete implementation of `analyze_robot_events`.
- A short explanation of state transitions and recovery behavior.
- Test evidence for all 10 cases.
