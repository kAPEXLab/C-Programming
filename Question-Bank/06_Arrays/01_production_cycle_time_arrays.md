# 13 - Production Cycle-Time Batch Check - Easy

## Question Details
- Concept: Fixed-size arrays, accumulation, and min/max tracking
- Difficulty: Easy
- Domain: Manufacturing process monitoring
- Learning Objective: Traverse a fixed batch and count cycles that meet a takt-time target.

## Scenario
A packaging line records the duration of five consecutive machine cycles. The shift lead needs to know how many met the takt-time target, how many were late, and the longest observed cycle.

## Function Details
- Function Name: `summarize_cycle_times`
- Function Signature: `void summarize_cycle_times(const int cycleSeconds[5], int targetSeconds, int *onTarget, int *late, int *longestSeconds);`
- A cycle is on target when its duration is less than or equal to `targetSeconds`; otherwise it is late.
- `targetSeconds` is positive and all output pointers are valid.

## Tasks to Implement
1. Visit each of the five cycle durations exactly once.
2. Count durations that meet and exceed the target.
3. Track the longest cycle and write the three results through the output pointers.

## Test Cases
| Test Case ID | Cycle durations; targetSeconds | Expected: onTarget, late, longestSeconds |
| --- | --- | --- |
| TC01 | {55,58,60,57,59}; 60 | 5, 0, 60 |
| TC02 | {55,61,60,64,59}; 60 | 3, 2, 64 |
| TC03 | {40,40,40,40,40}; 40 | 5, 0, 40 |
| TC04 | {61,62,58,63,59}; 60 | 2, 3, 63 |
| TC05 | {75,70,68,72,74}; 70 | 2, 3, 75 |

## Expected Deliverables
- A complete implementation of `summarize_cycle_times`.
- A short explanation of array traversal and takt-time classification.
- Test evidence for all five cases.
