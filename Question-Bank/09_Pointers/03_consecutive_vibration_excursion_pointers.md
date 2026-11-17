# 24 - Consecutive Vibration Excursion - Difficult

## Question Details
- Concept: Pointers, pointer traversal, and output parameters
- Difficulty: Difficult
- Domain: Predictive maintenance
- Learning Objective: Traverse sensor samples through a pointer and report the longest consecutive excursion.

## Scenario
A vibration monitor receives a time-ordered sample buffer and reports the longest consecutive sequence above a maintenance threshold. The service report also needs the one-based starting sample of that longest sequence.

## Function Details
- Function Name: `find_longest_vibration_excursion`
- Function Signature: `int find_longest_vibration_excursion(const double *samples, int count, double thresholdMmS, int *startSample, int *runLength);`
- A sample is above threshold only when `samples[i] > thresholdMmS`.
- Return 1 for valid input and 0 for count outside 1..100, a null pointer, or a negative threshold. On failure, leave output parameters unchanged.
- If no sample is above threshold, write `startSample=0` and `runLength=0`. Ties use the earliest run.

## Tasks to Implement
1. Traverse the sample buffer with a pointer rather than array indexing.
2. Track the current run and the longest run seen so far.
3. Preserve the earliest run when two runs have equal length.
4. Write outputs only after validating the inputs.

## Test Cases
| Test Case ID | Samples; thresholdMmS | Expected: return, startSample, runLength |
| --- | --- | --- |
| TC01 | {8,5,10,3,9}; 7 | 1, 1, 1 |
| TC02 | {20,18,22,17,19}; 16 | 1, 1, 5 |
| TC03 | {1,2,3,4,5}; 5 | 1, 0, 0 |
| TC04 | {4,9,10,2,11,12,3}; 8 | 1, 2, 2 |
| TC05 | {6,7,6,8,7}; 6 | 1, 4, 2 |
| TC06 | {5,5,5}; 5 | 1, 0, 0 |
| TC07 | {8,9}; 7 | 1, 1, 2 |
| TC08 | {1,2}; -1 | 0, unchanged, unchanged |
| TC09 | null samples, count=2 | 0, unchanged, unchanged |
| TC10 | any samples, count=0 | 0, unchanged, unchanged |

## Expected Deliverables
- A complete implementation of `find_longest_vibration_excursion`.
- A short explanation of pointer traversal and run tie-breaking.
- Test evidence for all ten cases.
