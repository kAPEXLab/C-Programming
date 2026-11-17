# 31 - Sensor Alarm Enum - Easy

## Question Details
- Concept: Enum types and status mapping
- Difficulty: Easy
- Domain: Industrial instrumentation
- Scenario: A sensor controller translates raw alarm codes into readable operational states.
- Learning Objective: Use enums to represent device states clearly and safely.

## Scenario
A plant sensor reports alarm codes as integers. The code must be mapped to a named status so that the rest of the system can work with clear meanings rather than magic numbers.

## Function Details
- Define an enum for sensor states: `NORMAL`, `WARNING`, `CRITICAL`, `FAULT`.
- Function Name: `map_sensor_alarm`
- Function Signature: `int map_sensor_alarm(int code, SensorState *state);`
- Valid codes: 0 = NORMAL, 1 = WARNING, 2 = CRITICAL, 3 = FAULT.
- Return 1 for valid code; return 0 for unknown code.
- The output pointer is non-null.

## Tasks to Implement
1. Declare the enum values clearly.
2. Use a switch or if-chain to map the integer to the status.
3. Return the mapped state through the output pointer.
4. Handle invalid codes safely.
5. Validate all expected input values.

## Test Cases
| Test Case ID | Input code | Expected Output: return; state |
| --- | --- | --- |
| TC01 | 0 | 1; NORMAL |
| TC02 | 1 | 1; WARNING |
| TC03 | 2 | 1; CRITICAL |
| TC04 | 3 | 1; FAULT |
| TC05 | 5 | 0; invalid |
| TC06 | -1 | 0; invalid |
| TC07 | 0 | 1; NORMAL |
| TC08 | 2 | 1; CRITICAL |
| TC09 | 3 | 1; FAULT |
| TC10 | 4 | 0; invalid |

## Expected Deliverables
- A complete implementation of `map_sensor_alarm`.
- A short explanation of how enums make industrial status handling clearer.
- Test evidence for all 10 cases.
