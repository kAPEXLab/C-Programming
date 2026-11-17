# 55 - Automotive Tire Pressure Monitor - Medium

## Question Details
- Concept: Structures, arrays, functions, validation, and returning a structure
- Difficulty: Medium
- Domain: Automotive systems
- Scenario: A vehicle inspection tool evaluates the four tire-pressure readings and summarizes tires that need attention.
- Learning Objective: Pass an array to a function, validate each reading, and return a structured summary.

## Scenario
Implement a tire-pressure evaluation module. The supplied array always contains four readings in kilopascals (kPa), ordered front-left, front-right, rear-left, and rear-right.

## Function Details
- Define `TireReport` with `valid`, `lowCount`, `highCount`, `minimumKPa`, and `maximumKPa` fields.
- Function Name: `evaluate_tire_pressures`
- Function Signature: `TireReport evaluate_tire_pressures(const double pressuresKPa[4]);`
- A reading is valid when it is between 0 and 500 inclusive.
- Readings below 220 kPa are low; readings above 250 kPa are high. Values exactly 220 or 250 are acceptable.
- If any reading is outside the valid range, return `valid=0` and set all count and pressure summary fields to 0.
- Otherwise return `valid=1`, counts, and the minimum and maximum readings.

## Tasks to Implement
1. Define the required structure and implement the function.
2. Evaluate all four readings and apply the exact inclusive/exclusive boundaries.
3. Return a zeroed invalid report if any reading is out of range.
4. Do not write a `main` function unless needed to demonstrate your tests.
5. Verify the function against every test case.

## Test Cases
| Test Case ID | Input: pressures in kPa | Expected Output: valid, low, high, min, max |
| --- | --- | --- |
| TC01 | {230,230,230,230} | 1, 0, 0, 230, 230 |
| TC02 | {210,230,240,250} | 1, 1, 0, 210, 250 |
| TC03 | {220,250,220,250} | 1, 0, 0, 220, 250 |
| TC04 | {251,260,230,240} | 1, 0, 2, 230, 260 |
| TC05 | {200,210,260,270} | 1, 2, 2, 200, 270 |
| TC06 | {0,220,250,500} | 1, 1, 1, 0, 500 |
| TC07 | {219,221,249,251} | 1, 1, 1, 219, 251 |
| TC08 | {-1,230,230,230} | 0, 0, 0, 0, 0 |
| TC09 | {230,501,230,230} | 0, 0, 0, 0, 0 |
| TC10 | {230,230,230,500.1} | 0, 0, 0, 0, 0 |

## Expected Deliverables
- A complete implementation of the specified function.
- A short explanation of the validation and classification rules.
- Test evidence for all 10 cases.
