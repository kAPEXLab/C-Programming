# 02 - Sensor Configuration Union - Medium

## Question Details
- Concept: typedef, union, and hardware configuration packing
- Difficulty: Medium
- Domain: Industrial instrumentation
- Scenario: A sensor stores its channel ID and calibration offset in a compact hardware layout.
- Learning Objective: Use a union to represent the same memory in multiple convenient ways.

## Scenario
A sensor module must store several values in a compact record for transmission to the controller. The same data must be readable either as raw bytes or as named fields.

## Function Details
- Define `SensorConfig` using `typedef`.
- Use a union to allow the memory to be read both as raw bits and as named fields.
- Function Name: `apply_sensor_config`
- Function Signature: `int apply_sensor_config(SensorConfig *config, unsigned char channel, unsigned char gainCode, short offset);`
- Valid `channel` is 0..15, `gainCode` is 0..7, and `offset` is -1000..1000.
- Return 1 on valid input; return 0 on invalid input.
- The pointer must be non-null.

## Tasks to Implement
1. Define the typedef and union layout.
2. Store values in a way that supports both raw and field access.
3. Validate each field before saving.
4. Return success or failure appropriately.
5. Test valid and invalid calibration values.

## Test Cases
| Test Case ID | Input: channel, gainCode, offset | Expected Output: return |
| --- | --- | --- |
| TC01 | 1, 2, 50 | 1 |
| TC02 | 15, 7, 1000 | 1 |
| TC03 | 0, 0, 0 | 1 |
| TC04 | 8, 3, 250 | 1 |
| TC05 | 16, 1, 10 | 0 |
| TC06 | 5, 8, 100 | 0 |
| TC07 | 3, 2, -1000 | 1 |
| TC08 | 2, 4, -1001 | 0 |
| TC09 | 15, 7, 1001 | 0 |
| TC10 | 10, 6, -500 | 1 |

## Expected Deliverables
- Definitions for the typedef and union layout.
- A complete implementation of `apply_sensor_config`.
- A short explanation of memory-efficient configuration encoding.
- Test evidence for all 10 cases.
