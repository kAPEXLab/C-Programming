# 25 - Sensor Zero-Offset Correction - Easy

## Question Details
- Concept: Pointers and in-place updates
- Difficulty: Easy
- Domain: Instrument commissioning
- Learning Objective: Modify a caller-owned sensor value through a pointer.

## Scenario
A technician enters a zero-offset correction after comparing a pressure transmitter with a certified reference. Apply the correction directly to the stored raw reading so the acquisition task sees the adjusted value.

## Function Details
- Function Name: `apply_zero_offset`
- Function Signature: `int apply_zero_offset(int *rawCount, int offsetCounts);`
- Add `offsetCounts` to `*rawCount` and return 1. Return 0 without writing when `rawCount` is null.

## Tasks to Implement
1. Validate the pointer before dereferencing it.
2. Update the caller's reading through the pointer.
3. Confirm that a null pointer causes no write.

## Test Cases
| Test Case ID | Input: rawCount, offsetCounts | Expected Output: return, updated rawCount |
| --- | --- | --- |
| TC01 | 120, -3 | 1, 117 |
| TC02 | 0, 0 | 1, 0 |
| TC03 | 4095, 5 | 1, 4100 |
| TC04 | -20, 2 | 1, -18 |
| TC05 | 75, 10; null pointer | 0, unchanged |

## Expected Deliverables
- A complete implementation of `apply_zero_offset`.
- A short explanation of pointer-based in-place updates.
- Test evidence for all five cases.
