# 01 - Motor Input Power Estimate - Easy

## Question Details
- Concept: Variables, numeric data types, and arithmetic expressions
- Difficulty: Easy
- Domain: Industrial instrumentation
- Learning Objective: Choose numeric types for electrical measurements and calculate input power.

## Scenario
A commissioning tool estimates the real input power of a motor drive from line voltage, current, and power factor. Keep the measurements as floating-point values so fractional amperes and power factors are not truncated.

## Function Details
- Function Name: `estimate_input_power`
- Function Signature: `double estimate_input_power(double voltageV, double currentA, double powerFactor);`
- Calculate and return `voltageV * currentA * powerFactor` in watts.
- Inputs are guaranteed to be finite, non-negative, and `powerFactor` is at most 1.0.

## Tasks to Implement
1. Use floating-point variables for the three measured quantities.
2. Multiply the values without converting them to integers.
3. Return the estimated power in watts.

## Test Cases
| Test Case ID | Input: voltageV, currentA, powerFactor | Expected Output: watts |
| --- | --- | --- |
| TC01 | 400.0, 10.0, 0.8 | 3200.00 |
| TC02 | 230.0, 5.5, 1.0 | 1265.00 |
| TC03 | 480.0, 12.5, 0.92 | 5520.00 |
| TC04 | 0.0, 8.0, 0.9 | 0.00 |
| TC05 | 24.0, 2.25, 0.75 | 40.50 |

## Expected Deliverables
- A complete implementation of `estimate_input_power`.
- A brief note explaining the floating-point data types and power calculation.
- Test evidence for all five cases.
