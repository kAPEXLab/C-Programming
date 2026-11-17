# 12 - Multi-Sensor Equipment Alarm - Difficult

## Question Details
- Concept: Decision making, validation, and prioritized multi-condition rules
- Difficulty: Difficult
- Domain: Rotating equipment protection
- Learning Objective: Combine independent sensor conditions while preserving an explicit safety precedence.

## Scenario
A pump protection controller uses bearing temperature, vibration, and an emergency-stop input to select an operator action. Invalid sensor values must be rejected before any action is selected.

## Function Details
- Function Name: `classify_pump_condition`
- Function Signature: `char classify_pump_condition(double bearingTempC, double vibrationMmS, int emergencyStop);`
- Bearing temperature must be in -40..150 C and vibration in 0..100 mm/s, inclusive. Use comparisons that also reject NaN values.
- Return `I` for an out-of-range sensor value or a non-binary emergency-stop input.
- Otherwise return `S` when emergency stop is active, temperature is at least 110 C, or vibration is at least 8.0 mm/s; return `W` when temperature is at least 90 C or vibration is at least 5.0 mm/s; otherwise return `N`.
- Apply stop conditions before warning conditions.

## Tasks to Implement
1. Validate both sensor ranges and the emergency-stop flag.
2. Apply stop-level rules before warning-level rules.
3. Return one status code for every valid or invalid combination.

## Test Cases
| Test Case ID | Input: bearingTempC, vibrationMmS, emergencyStop | Expected Code |
| --- | --- | --- |
| TC01 | 75, 2.0, 0 | N |
| TC02 | 95, 2.0, 0 | W |
| TC03 | 85, 5.0, 0 | W |
| TC04 | 90, 8.0, 0 | S |
| TC05 | 80, 2.0, 1 | S |
| TC06 | 110, 0.0, 0 | S |
| TC07 | 90, 4.9, 0 | W |
| TC08 | 90, 8.0, 1 | S |
| TC09 | 151, 2.0, 0 | I |
| TC10 | 80, 2.0, 2 | I |

## Expected Deliverables
- A complete implementation of `classify_pump_condition`.
- A short explanation of validation and alarm precedence.
- Test evidence for all ten cases.
