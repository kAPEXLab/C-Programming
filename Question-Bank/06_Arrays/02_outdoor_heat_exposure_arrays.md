# 14 - Outdoor Work Heat-Exposure Counter - Medium

## Question Details
- Concept: Fixed-size arrays, loops, and consecutive-condition tracking
- Difficulty: Medium
- Domain: Worker safety operations
- Learning Objective: Count hot-shift readings and find the longest consecutive heat-exposure run.

## Scenario
A safety station records one outdoor temperature at the start of each of seven work shifts. The safety manager needs the number of shifts above the heat-action threshold and the longest consecutive run of such shifts to schedule additional cooling breaks.

## Function Details
- Function Name: `analyze_heat_exposure`
- Function Signature: `void analyze_heat_exposure(const double shiftTempsC[7], double actionThresholdC, int *hotShiftCount, int *longestHotRun);`
- A shift is hot when its temperature is greater than or equal to `actionThresholdC`.
- The threshold and all output pointers are valid.

## Tasks to Implement
1. Traverse all seven shift readings.
2. Count hot shifts and track consecutive hot readings.
3. Reset the current run when a reading is below the threshold.
4. Report the total count and longest run.

## Test Cases
| Test Case ID | Shift temperatures; threshold | Expected: hotShiftCount, longestHotRun |
| --- | --- | --- |
| TC01 | {32,34,31,29,27,30,33}; 30 | 5, 3 |
| TC02 | {18,17,16,15,14,17,18}; 30 | 0, 0 |
| TC03 | {28,28,28,28,28,28,28}; 28 | 7, 7 |
| TC04 | {42,40,41,39,38,37,44}; 40 | 4, 3 |
| TC05 | {10,12,11,13,15,14,9}; 12 | 4, 3 |

## Expected Deliverables
- A complete implementation of `analyze_heat_exposure`.
- A short explanation of consecutive-run tracking.
- Test evidence for all five cases.
