# 42 - Resizable Machine Event Log - Difficult

## Question Details
- Concept: Dynamic allocation, `realloc`, and pointer-to-pointer updates
- Difficulty: Difficult
- Domain: Industrial equipment monitoring
- Learning Objective: Grow an event array safely while retaining the caller's existing data on failure.

## Scenario
A machine monitor receives events at an unpredictable rate. Append each validated event to a dynamically allocated log so the diagnostics task can review the complete sequence after a shift.

## Function Details
- Define `struct MachineEvent` with a non-negative `timestamp` and an `eventCode` from 1 through 999.
- Function Name: `append_machine_event`
- Function Signature: `int append_machine_event(struct MachineEvent **events, size_t *count, const struct MachineEvent *newEvent);`
- The current array contains `*count` entries; it may be null only when count is zero. Maximum count is 10000.
- Use `realloc` to add one entry. Return 1 and update the pointer and count on success.
- Return 0 for invalid pointers, invalid event values, count at the limit, or allocation failure. On failure, leave the original allocation and count unchanged.
- The caller owns and must free the resulting array.

## Tasks to Implement
1. Validate all pointer arguments and event fields before allocation.
2. Store the `realloc` result in a temporary pointer.
3. Update the caller's pointer and count only after allocation succeeds.
4. Preserve existing entries and document caller cleanup.

## Test Cases
| Test Case ID | Initial count; new event | Expected Output |
| --- | --- | --- |
| TC01 | 0; {100,12} | success, count=1 |
| TC02 | 1; {200,13} | success, count=2, prior entry preserved |
| TC03 | 2; {300,14} | success, count=3 |
| TC04 | 0; null event pointer | failure, count unchanged |
| TC05 | 0; null events output pointer | failure |
| TC06 | 0; null count pointer | failure |
| TC07 | 0; {100,0} | failure, count unchanged |
| TC08 | 0; {-1,12} | failure, count unchanged |
| TC09 | 10000; valid event | failure, allocation unchanged |

## Expected Deliverables
- A complete implementation of `append_machine_event`.
- A short explanation of safe `realloc` usage and ownership.
- Test evidence for all nine cases, including cleanup.
