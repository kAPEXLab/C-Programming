# 10 - Vibration Operating Band - Easy

## Question Details
- Concept: Decision making with ordered conditions
- Difficulty: Easy
- Domain: Rotating equipment monitoring
- Learning Objective: Classify a sensor value using mutually exclusive threshold bands.

## Scenario
A pump's vibration monitor converts a measured velocity into an operator action. Readings in the normal band continue operation, elevated readings request inspection, and high readings require a controlled stop.

## Function Details
- Function Name: `classify_vibration`
- Function Signature: `char classify_vibration(double vibrationMmS);`
- Return `N` for 0 through 2.8 mm/s, `W` for values above 2.8 through 4.5 mm/s, and `S` above 4.5 mm/s.
- Return `I` for a negative reading or a reading above 100 mm/s, which indicates an invalid sensor value.

## Tasks to Implement
1. Validate the input range before classifying it.
2. Apply the bands in an order that handles each boundary exactly once.
3. Return the specified one-character action code.

## Test Cases
| Test Case ID | Input: vibrationMmS | Expected Output |
| --- | --- | --- |
| TC01 | 0.0 | N |
| TC02 | 2.8 | N |
| TC03 | 2.81 | W |
| TC04 | 3.6 | W |
| TC05 | 4.5 | W |
| TC06 | 4.51 | S |
| TC07 | 8.2 | S |
| TC08 | -0.1 | I |
| TC09 | 100.1 | I |
| TC10 | 1.4 | N |

## Expected Deliverables
- A complete implementation of `classify_vibration`.
- A short explanation of the decision order and boundary handling.
- Test evidence for all ten cases.
