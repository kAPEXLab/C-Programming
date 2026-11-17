# 02 - Vibration Sample Predicate Callback - Medium

## Question Details
- Concept: Function pointers used as predicate callbacks
- Difficulty: Medium
- Domain: Predictive maintenance
- Learning Objective: Apply a caller-supplied rule to each sensor sample without hard-coding the acceptance policy.

## Scenario
A maintenance tool receives a short window of vibration readings. Different machine models define acceptable readings differently, so the caller supplies a predicate function. Count how many samples that predicate accepts.

## Function Details
- Define `VibrationPredicate` as a function pointer taking one `double` and returning 1 when accepted, otherwise 0.
- Function Name: `count_accepted_vibration_samples`
- Function Signature: `int count_accepted_vibration_samples(const double samples[], int count, VibrationPredicate acceptSample, int *acceptedCount);`
- Valid count is 0..100. Return 1 after processing and write the accepted count; return 0 for invalid count, null predicate, or null output pointer.
- Do not modify the output count on failure. For count 0, return success with an accepted count of 0.

## Tasks to Implement
1. Define the predicate callback type.
2. Call the predicate once for each sample.
3. Count accepted values and write the result only after processing.
4. Handle empty input and invalid callback arguments.

## Test Cases
| Test Case ID | Samples; predicate rule | Expected: return, acceptedCount |
| --- | --- | --- |
| TC01 | {1.0,2.0,3.0}; sample <= 2.5 | 1, 2 |
| TC02 | {4.0,5.0,6.0}; sample >= 5.0 | 1, 2 |
| TC03 | {-1.0,0.0,1.0}; sample >= 0.0 | 1, 2 |
| TC04 | {2.1,2.2,2.3}; sample < 3.0 | 1, 3 |
| TC05 | {}; valid predicate | 1, 0 |
| TC06 | {1.0,2.0}; null predicate | 0, unchanged |
| TC07 | {1.0,2.0}; null output pointer | 0 |
| TC08 | any; count=-1 | 0, unchanged |

## Expected Deliverables
- A working implementation of `count_accepted_vibration_samples`.
- A short explanation of predicate callbacks and policy decoupling.
- Test evidence for all eight cases.
