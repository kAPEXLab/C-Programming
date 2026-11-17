# 22 - Equipment Import Duty Calculation - Easy

## Question Details
- Concept: Reusable functions and floating-point arithmetic
- Difficulty: Easy
- Domain: Industrial procurement
- Learning Objective: Encapsulate an import-duty calculation for equipment components.

## Scenario
A procurement tool estimates the import duty on a shipment of replacement drive components. The function returns the duty amount; the caller is responsible for adding it to the invoice.

## Function Details
- Function Name: `calculate_import_duty`
- Function Signature: `double calculate_import_duty(double declaredValue, double dutyRatePercent);`
- Return `declaredValue * dutyRatePercent / 100.0`.
- Inputs are non-negative and the rate is at most 100 percent.

## Tasks to Implement
1. Implement the reusable duty calculation.
2. Preserve fractional amounts by using floating-point arithmetic.
3. Keep the duty result separate from the declared value.

## Test Cases
| Test Case ID | Input: declaredValue, dutyRatePercent | Expected Duty |
| --- | --- | --- |
| TC01 | 5000, 18 | 900.00 |
| TC02 | 1200, 5 | 60.00 |
| TC03 | 250, 12 | 30.00 |
| TC04 | 10000, 28 | 2800.00 |
| TC05 | 0, 18 | 0.00 |

## Expected Deliverables
- A complete implementation of `calculate_import_duty`.
- A brief explanation of the formula and return value.
- Test evidence for all five cases.
