# 25 - Sensor Reading Record - Easy

## Question Details
- Concept: Structures and member access
- Difficulty: Easy
- Domain: Industrial instrumentation
- Learning Objective: Group related values from one sensor sample in a structure.

## Scenario
A controller receives a pressure reading together with its channel number and sample sequence. Validate one complete sample before it is sent to the process-control task.

## Function Details
- Define `struct SensorReading` with `channel`, `pressureKPa`, and `sequence` members.
- Function Name: `validate_sensor_reading`
- Function Signature: `int validate_sensor_reading(const struct SensorReading *reading);`
- A valid channel is 0..15, pressure is 0..1000 kPa inclusive, and sequence is non-negative.
- Return 1 when all fields are valid; return 0 for a null pointer or invalid field.

## Tasks to Implement
1. Define the structure with the specified member types.
2. Read each member through the structure pointer.
3. Validate all three fields and return one status.

## Test Cases
| Test Case ID | Input: channel, pressureKPa, sequence | Expected Output |
| --- | --- | --- |
| TC01 | 0, 0.0, 0 | 1 |
| TC02 | 3, 420.5, 18 | 1 |
| TC03 | 15, 1000.0, 200 | 1 |
| TC04 | 16, 200.0, 1 | 0 |
| TC05 | 2, 1000.1, 5 | 0 |
| TC06 | 4, 90.0, -1 | 0 |
| TC07 | 8, 999.9, 42 | 1 |
| TC08 | 0, -0.1, 9 | 0 |
| TC09 | null pointer | 0 |
| TC10 | 7, 250.0, 0 | 1 |

## Expected Deliverables
- A complete implementation of `validate_sensor_reading`.
- A short explanation of why the three fields belong in one record.
- Test evidence for all ten cases.
