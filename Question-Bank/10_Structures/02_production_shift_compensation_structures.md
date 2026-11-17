# 29 - Production Shift Compensation - Medium

## Question Details
- Concept: Structures, member access, arithmetic, and validation
- Difficulty: Medium
- Domain: Manufacturing operations
- Learning Objective: Pass a shift record to a function and calculate compensation from its fields.

## Scenario
A plant payroll service calculates compensation for a production technician. A shift record contains regular hours, overtime hours, hourly rate, and whether the shift qualifies for a fixed night allowance.

## Function Details
- Define `struct ShiftRecord` with `regularHours`, `overtimeHours`, `hourlyRate`, and `nightShift` members.
- Function Name: `calculate_shift_compensation`
- Function Signature: `double calculate_shift_compensation(const struct ShiftRecord *shift);`
- Calculate regular pay plus overtime pay at 1.5 times the hourly rate. Add a 35.00 allowance when `nightShift` is 1.
- Valid hours are non-negative with a combined maximum of 24; rate is 0..500; `nightShift` is 0 or 1. Return -1.0 for invalid input or a null pointer.

## Tasks to Implement
1. Define the shift record structure.
2. Validate every member before calculating pay.
3. Apply the overtime multiplier and optional allowance.

## Test Cases
| Test Case ID | Input: regularHours, overtimeHours, hourlyRate, nightShift | Expected Pay |
| --- | --- | --- |
| TC01 | 8, 0, 25.00, 0 | 200.00 |
| TC02 | 8, 2, 25.00, 0 | 275.00 |
| TC03 | 8, 2, 25.00, 1 | 310.00 |
| TC04 | 0, 0, 40.00, 1 | 35.00 |
| TC05 | 10, 4, 30.00, 0 | 480.00 |
| TC06 | 12, 12, 20.00, 1 | 635.00 |
| TC07 | -1, 0, 20.00, 0 | -1.00 |
| TC08 | 20, 5, 20.00, 0 | -1.00 |
| TC09 | 8, 0, 501.00, 0 | -1.00 |
| TC10 | null pointer | -1.00 |

## Expected Deliverables
- A complete implementation of `calculate_shift_compensation`.
- A short explanation of structure member access and the pay formula.
- Test evidence for all ten cases.
