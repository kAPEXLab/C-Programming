# 16 - Equipment Tag Validator - Easy

## Question Details
- Concept: C strings, character inspection, and terminating null characters
- Difficulty: Easy
- Domain: Industrial asset tracking
- Learning Objective: Validate a fixed-format equipment identifier using indexed string access.

## Scenario
A maintenance terminal accepts asset tags in the format `PMP-####`: three uppercase letters identifying a pump family, a hyphen, and four decimal digits. Reject malformed tags before they are attached to a work order.

## Function Details
- Function Name: `is_valid_equipment_tag`
- Function Signature: `int is_valid_equipment_tag(const char tag[]);`
- Return 1 only when the string is exactly eight characters and matches the stated format; return 0 for a null pointer or any mismatch.
- Use character comparisons and string indexing; do not use library parsing functions.

## Tasks to Implement
1. Check the required prefix and separator positions.
2. Check that each of the final four characters is a decimal digit.
3. Confirm the string ends immediately after the final digit.
4. Return the validation result.

## Test Cases
| Test Case ID | Input tag | Expected Output |
| --- | --- | --- |
| TC01 | `PMP-1042` | 1 |
| TC02 | `MTR-0007` | 1 |
| TC03 | `PMP-12A4` | 0 |
| TC04 | `PMP10422` | 0 |
| TC05 | `pmP-1042` | 0 |
| TC06 | `PMP-104` | 0 |
| TC07 | `PMP-10420` | 0 |
| TC08 | `ABC-9999` | 1 |
| TC09 | `P1P-1042` | 0 |
| TC10 | null pointer | 0 |

## Expected Deliverables
- A complete implementation of `is_valid_equipment_tag`.
- A brief explanation of string termination and positional validation.
- Test evidence for all ten cases.
