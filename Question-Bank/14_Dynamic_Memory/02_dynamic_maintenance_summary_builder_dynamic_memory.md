# 29 - Dynamic Maintenance Summary Builder - Medium

## Question Details
- Concept: Dynamic memory allocation, sizing, and ownership
- Difficulty: Medium
- Domain: Industrial maintenance
- Learning Objective: Allocate a precisely sized summary from variable-length work-order fields.

## Scenario
A maintenance terminal combines a variable number of short work-order notes into one summary line. The final length is not known until all notes have been inspected.

## Function Details
- Function Name: `build_work_order_summary`
- Function Signature: `char *build_work_order_summary(const char *notes[], size_t count);`
- Join non-null notes with one space between them and a terminating null byte.
- Maximum note count is 100; maximum output length excluding the terminator is 4096 bytes.
- Return a dynamically allocated string on success or null for invalid input or allocation failure. The caller owns and must free the returned string.
- For count 0, return an allocated empty string.

## Tasks to Implement
1. Validate the note array and count.
2. Measure note lengths and calculate the exact allocation size, including separators and the null terminator.
3. Reject totals above the output limit before allocating.
4. Copy the notes into the allocated buffer and return ownership to the caller.

## Test Cases
| Test Case ID | Input notes | Expected Output |
| --- | --- | --- |
| TC01 | `{"Pump-4", "bearing inspection", "replace seal"}` | `Pump-4 bearing inspection replace seal` |
| TC02 | `{"Line-2", "sensor mismatch"}` | `Line-2 sensor mismatch` |
| TC03 | `{}`, count=0 | allocated empty string |
| TC04 | any list containing a null note | null |
| TC05 | notes whose joined size exceeds 4096 bytes | null |

## Expected Deliverables
- A complete implementation of `build_work_order_summary`.
- A short explanation of exact sizing and caller ownership.
- Test evidence for all five cases, including `free` calls.
