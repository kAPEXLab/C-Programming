# 10 - Shift Energy Meter Roll-Up - Easy

## Question Details
- Concept: Loops and running totals
- Difficulty: Easy
- Domain: Plant energy monitoring
- Learning Objective: Accumulate interval energy readings and calculate average consumption per interval.

## Scenario
A plant energy gateway receives a variable number of interval-consumption readings for a shift. Calculate total energy used and average energy per interval.

## Function Details
- Function Name: `calculate_shift_energy`
- Function Signature: `int calculate_shift_energy(int intervalCount, const double intervalKWh[], double *totalKWh, double *averageKWh);`
- Valid count is 1..96 and each interval value is non-negative. Return 1 on success and 0 for invalid inputs or null output pointers.
- Write total and average only when the inputs are valid.

## Tasks to Implement
1. Use a loop to accumulate each interval value once.
2. Divide the total by the interval count to calculate the mean.
3. Reject invalid count, negative readings, or null output pointers without writing outputs.

## Test Cases
| Test Case ID | Input: intervalKWh, intervalCount | Expected Output: return, totalKWh, averageKWh |
| --- | --- | --- |
| TC01 | {10,20,30,40,50} | 1, 150, 30.00 |
| TC02 | {5,10,15,20} | 1, 50, 12.50 |
| TC03 | {7,8,9} | 1, 24, 8.00 |
| TC04 | {99} | 1, 99, 99.00 |
| TC05 | {2,2,2,2,2,2} | 1, 12, 2.00 |
| TC06 | {}, count=0 | 0, unchanged, unchanged |
| TC07 | {10,-1,20} | 0, unchanged, unchanged |

## Expected Deliverables
- A complete implementation of `calculate_shift_energy`.
- A brief explanation of the loop and accumulation logic.
- Test evidence for all seven cases.
