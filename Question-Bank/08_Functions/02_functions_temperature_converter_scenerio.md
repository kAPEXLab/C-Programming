# 23 - Functions - Medium

## Question Details
- Concept: Functions
- Difficulty: Medium
- Scenario: A process control dashboard converts temperatures between Celsius and Fahrenheit across equipment zones in an industrial environment.
- Learning Objective: Encapsulate temperature conversion rules in a reusable process-control function.

## Scenario
A process control dashboard converts temperatures between Celsius and Fahrenheit across equipment zones in an industrial environment.

## Function Details
- Function Name: convert_temperature
- Function Signature: double convert_temperature(double value, char fromUnit, char toUnit);
- Parameters:
  - double value: temperature value
  - char fromUnit: source unit
  - char toUnit: target unit
- Return Type: double
- Accept `C` and `F` as unit codes. Return -1.0 when the unit pair is unsupported; otherwise return the converted temperature.

## Tasks to Implement
1. Convert Celsius to Fahrenheit and Fahrenheit to Celsius using separate formulas.
2. Return the input unchanged when both unit codes are the same.
3. Return the invalid sentinel for unsupported units.

## Test Cases
| Test Case ID | Input | Expected Output |
| --- | --- | --- |
| TC01 | value=25, from=C, to=F | Result=77.00 F |
| TC02 | value=98.6, from=F, to=C | Result=37.00 C |
| TC03 | value=0, from=C, to=F | Result=32.00 F |
| TC04 | value=32, from=F, to=C | Result=0.00 C |
| TC05 | value=100, from=C, to=F | Result=212.00 F |
| TC06 | value=10, from=K, to=C | Result=-1.00 |

## Expected Deliverables
- A complete implementation of `convert_temperature`.
- A brief explanation of the conversion formulas and invalid-unit behavior.
- Test evidence for all six cases.
