# 37 - Sensor Calibration Tolerance Check - Easy

## Question Details
- Concept: Standard library math functions and floating-point validation
- Difficulty: Easy
- Domain: Instrument commissioning
- Learning Objective: Use `fabs` and `isfinite` to compare a measured calibration value with its reference.

## Scenario
A technician checks whether a pressure transmitter's measured output is close enough to the certified reference before returning it to service. Non-finite readings and negative tolerances must be rejected.

## Function Details
- Include `<math.h>`.
- Function Name: `is_within_calibration_tolerance`
- Function Signature: `int is_within_calibration_tolerance(double referenceKPa, double measuredKPa, double toleranceKPa);`
- Return 1 when all inputs are finite, tolerance is non-negative, and `fabs(measuredKPa - referenceKPa) <= toleranceKPa`; otherwise return 0.

## Tasks to Implement
1. Reject non-finite inputs with `isfinite`.
2. Use `fabs` to calculate the absolute calibration error.
3. Include the tolerance boundary in the accepted range.

## Test Cases
| Test Case ID | Input: referenceKPa, measuredKPa, toleranceKPa | Expected Output |
| --- | --- | --- |
| TC01 | 100.0, 100.0, 0.0 | 1 |
| TC02 | 100.0, 100.05, 0.05 | 1 |
| TC03 | 100.0, 100.06, 0.05 | 0 |
| TC04 | 200.0, 199.5, 0.5 | 1 |
| TC05 | 200.0, 199.49, 0.5 | 0 |
| TC06 | 0.0, 0.0, -0.1 | 0 |
| TC07 | NAN, 1.0, 1.0 | 0 |
| TC08 | 1.0, INFINITY, 1.0 | 0 |

## Expected Deliverables
- A complete implementation of `is_within_calibration_tolerance`.
- A brief explanation of `fabs` and non-finite input checks.
- Test evidence for all eight cases.
