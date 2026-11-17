# 57 - Thermal Run-Up Detector - Medium

## Question Details
- Concept: Arrays, loops, adjacent-sample comparison, and output parameters
- Difficulty: Medium
- Domain: Embedded systems
- Scenario: A controller detects a rapid temperature rise in an industrial sensor stream before an absolute over-temperature limit is reached.
- Learning Objective: Compare adjacent array samples and report the first limit crossing and largest rise.

## Scenario
A thermal protection task receives 2..10 ordered samples in Celsius. It must identify the first adjacent increase that meets a configured rise limit and report the largest rise between consecutive samples.

## Function Details
- Function Name: `detect_thermal_runup`
- Function Signature: `int detect_thermal_runup(const double samplesC[], int count, double riseLimitC, int *firstAlarmIndex, double *largestRiseC);`
- A valid count is 2 through 10. Samples must be in -40..150 C and `riseLimitC` must be positive.
- Set `firstAlarmIndex` to the index of the later sample in the first adjacent pair whose rise is at least the limit, or -1 if no pair reaches it.
- Set `largestRiseC` to the largest `samplesC[i] - samplesC[i-1]`, including negative results if every sample falls.
- Return 1 on valid input and 0 for invalid input or null outputs. Do not modify outputs on failure.

## Tasks to Implement
1. Validate the count, thresholds, and every sample.
2. Compare each sample with its immediate predecessor.
3. Track the maximum rise and preserve the first threshold crossing index.
4. Write outputs only after the input is validated.

## Test Cases
| Test Case ID | Input: samplesC, riseLimitC | Expected: return, firstAlarmIndex, largestRiseC |
| --- | --- | --- |
| TC01 | {20,21,22}; 2.0 | 1, -1, 1.0 |
| TC02 | {20,23,24}; 2.0 | 1, 1, 3.0 |
| TC03 | {40,35,32}; 2.0 | 1, -1, -3.0 |
| TC04 | {-40,-38,0}; 30.0 | 1, 2, 38.0 |
| TC05 | {30,31,34,36}; 3.0 | 1, 2, 3.0 |
| TC06 | {10,15}; 5.0 | 1, 1, 5.0 |
| TC07 | {20,22}; 2.0 | 1, 1, 2.0 |
| TC08 | {20,20}; 0.1 | 1, -1, 0.0 |
| TC09 | {20}, count=1 | 0; outputs unchanged |
| TC10 | {22,151}, count=2 | 0; outputs unchanged |

## Expected Deliverables
- A complete implementation of `detect_thermal_runup`.
- A short explanation of adjacent-sample analysis and limit crossing.
- Test evidence for all ten cases.
