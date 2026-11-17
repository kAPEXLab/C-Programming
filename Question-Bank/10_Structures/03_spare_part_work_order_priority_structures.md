# 27 - Spare-Part Work Order Priority - Difficult

## Question Details
- Concept: Structures, pointers, and prioritized decision logic
- Difficulty: Difficult
- Domain: Industrial maintenance
- Learning Objective: Use a structure to keep work-order data together and classify a job from multiple fields.

## Scenario
A maintenance planner receives a work order for a production asset. The response priority depends on whether the issue is safety-critical, whether the line is stopped, and whether the required spare part is available.

## Function Details
- Define `struct WorkOrder` with `workOrderId`, `safetyCritical`, `lineStopped`, and `partAvailable` members.
- Function Name: `classify_work_order`
- Function Signature: `char classify_work_order(const struct WorkOrder *order);`
- Return `I` for a null pointer, negative ID, or non-binary flag.
- Otherwise return `E` for a safety-critical order, `H` when the line is stopped and the part is available, `P` when the line is stopped but the part is unavailable, and `R` for all other valid orders.
- Apply the rules in the stated priority order.

## Tasks to Implement
1. Define the work-order structure.
2. Validate the pointer, identifier, and binary fields.
3. Apply the priority rules from highest to lowest.

## Test Cases
| Test Case ID | Input: ID, safetyCritical, lineStopped, partAvailable | Expected Code |
| --- | --- | --- |
| TC01 | 101, 1, 1, 1 | E |
| TC02 | 102, 0, 1, 1 | H |
| TC03 | 103, 0, 1, 0 | P |
| TC04 | 104, 0, 0, 1 | R |
| TC05 | 105, 1, 0, 0 | E |
| TC06 | 106, 0, 0, 0 | R |
| TC07 | 107, 0, 1, 1 | H |
| TC08 | -1, 0, 0, 1 | I |
| TC09 | 109, 2, 1, 1 | I |
| TC10 | null pointer | I |

## Expected Deliverables
- A complete implementation of `classify_work_order`.
- A short explanation of validation and decision precedence.
- Test evidence for all ten cases.
