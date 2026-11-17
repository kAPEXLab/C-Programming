# 15 - Lubrication Service Interval Counter - Difficult

## Question Details
- Concept: Loops, repeated accumulation, and input validation
- Difficulty: Difficult
- Domain: Predictive maintenance
- Learning Objective: Use a loop to count recurring service points and calculate the remaining operating time.

## Scenario
A pump requires lubrication every configured number of operating hours. Given the total runtime accumulated by a machine and its service interval, calculate how many lubrication events are due and how many hours have elapsed since the most recent event.

## Function Details
- Return the two results through output parameters.
- Function Name: `calculate_lubrication_schedule`
- Function Signature: `int calculate_lubrication_schedule(int operatingHours, int intervalHours, int *servicesDue, int *hoursSinceLastService);`
- Both inputs must be non-negative and `intervalHours` must be greater than zero. Return 0 for invalid input or null output pointers.
- On valid input, write both results and return 1.
- Count each complete service interval using a loop; do not use division or modulo to calculate the two result fields.

## Tasks to Implement
1. Validate the output pointers and input values.
2. Repeatedly subtract one service interval until less than one interval remains.
3. Write the number of due services and remaining hours through the output pointers.

## Test Cases
| Test Case ID | Input: operatingHours, intervalHours | Expected: return, servicesDue, hoursSinceLastService |
| --- | --- | --- |
| TC01 | 0, 8 | 1, 0, 0 |
| TC02 | 7, 8 | 1, 0, 7 |
| TC03 | 8, 8 | 1, 1, 0 |
| TC04 | 19, 8 | 1, 2, 3 |
| TC05 | 168, 24 | 1, 7, 0 |
| TC06 | 170, 24 | 1, 7, 2 |
| TC07 | 1000, 100 | 1, 10, 0 |
| TC08 | 1015, 100 | 1, 10, 15 |
| TC09 | -1, 8 | 0, unchanged, unchanged |
| TC10 | 10, 0 | 0, unchanged, unchanged |

## Expected Deliverables
- A complete implementation of `calculate_lubrication_schedule`.
- A brief explanation of the loop invariant and invalid-input handling.
- Test evidence for all ten cases.
