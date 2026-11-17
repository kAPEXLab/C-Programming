# 17 - Production Batch Completion Callback - Medium

## Question Details
- Concept: Function-pointer typedefs and callbacks with structured data
- Difficulty: Medium
- Domain: Manufacturing execution
- Learning Objective: Notify a caller through a callback when a validated production batch is ready for downstream processing.

## Scenario
A production cell closes a batch report when the line completes a run. One deployment may persist the report, another may send it to a supervisor display; the batch validator should not be coupled to either action.

## Function Details
- Define `struct BatchReport` with `batchId`, `acceptedUnits`, and `rejectedUnits` fields.
- Define `BatchCompleteCallback` as a function pointer accepting `const struct BatchReport *`.
- Function Name: `notify_batch_complete`
- Function Signature: `int notify_batch_complete(const struct BatchReport *report, BatchCompleteCallback callback);`
- A valid report has a positive batch ID, non-negative counts, and at least one unit processed.
- Invoke the callback exactly once for a valid report and non-null callback; return 1. Return 0 otherwise.

## Tasks to Implement
1. Define the report structure and callback signature.
2. Validate the report before invoking anything.
3. Invoke the callback once with the original report pointer.
4. Reject a null report or callback safely.

## Test Cases
| Test Case ID | Input: batchId, accepted, rejected, callback | Expected Output |
| --- | --- | --- |
| TC01 | 501, 120, 2, valid | 1; callback once |
| TC02 | 502, 0, 8, valid | 1; callback once |
| TC03 | 503, 50, 0, valid | 1; callback once |
| TC04 | 0, 12, 0, valid | 0; no callback |
| TC05 | 504, -1, 2, valid | 0; no callback |
| TC06 | 505, 10, -1, valid | 0; no callback |
| TC07 | 506, 1, 1, null | 0; no callback |
| TC08 | null report, valid callback | 0; no callback |

## Expected Deliverables
- Definitions for the report structure and callback type.
- A working implementation of `notify_batch_complete`.
- A short explanation of decoupling batch processing from downstream actions.
- Test evidence for all eight cases.
