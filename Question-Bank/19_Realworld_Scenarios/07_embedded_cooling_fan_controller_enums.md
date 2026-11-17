# 61 - Embedded Cooling Fan Controller - Difficult

## Question Details
- Concept: Structures, pointers, enumerated status values, validation, and state-dependent logic
- Difficulty: Difficult
- Domain: Embedded systems
- Scenario: An engine controller manages a cooling fan using temperature hysteresis and a fail-safe response to sensor faults.
- Learning Objective: Use prior state as input, update control state, and distinguish normal, fault, and invalid conditions.

## Scenario
A controller receives a temperature reading and the fan's previous on/off state. Hysteresis prevents rapid switching when temperature fluctuates around a single threshold.

## Function Details
- Define `SensorReading` with `temperatureC` and `sensorFault` fields.
- Define `FanResult` with `fanOn` and `status` fields. Status values: `NORMAL`, `SENSOR_FAULT`, `INVALID_INPUT`.
- Function Name: `update_cooling_fan`
- Function Signature: `FanResult update_cooling_fan(const SensorReading *reading, int previousFanOn);`
- `sensorFault` and `previousFanOn` must each be 0 or 1. Valid temperature range is -40..125 C inclusive.
- If any input is invalid, return `fanOn=0`, `status=INVALID_INPUT`.
- If inputs are valid and `sensorFault=1`, return `fanOn=0`, `status=SENSOR_FAULT` regardless of temperature.
- Otherwise, turn the fan on at temperatures >=30 C, turn it off at temperatures <=25 C, and retain `previousFanOn` between those thresholds. Return `status=NORMAL`.

## Tasks to Implement
1. Define the structures and status values.
2. Validate the reading fields and previous state.
3. Apply the sensor-fault fail-safe and the two hysteresis thresholds in the specified order.
4. Return both the new fan state and status in `FanResult`.
5. Verify all 10 cases, including retained states and invalid readings.

## Test Cases
| Test Case ID | Input: temperature C, sensorFault, previousFanOn | Expected Output: fanOn, status |
| --- | --- | --- |
| TC01 | 20,0,0 | 0, NORMAL |
| TC02 | 30,0,0 | 1, NORMAL |
| TC03 | 25,0,1 | 0, NORMAL |
| TC04 | 27,0,0 | 0, NORMAL |
| TC05 | 27,0,1 | 1, NORMAL |
| TC06 | 125,0,0 | 1, NORMAL |
| TC07 | -40,0,1 | 0, NORMAL |
| TC08 | 80,1,1 | 0, SENSOR_FAULT |
| TC09 | 126,0,0 | 0, INVALID_INPUT |
| TC10 | 28,0,2 | 0, INVALID_INPUT |

## Expected Deliverables
- Definitions for both structures and status values.
- A complete implementation of `update_cooling_fan`.
- A short explanation of hysteresis and fail-safe behavior.
- Test evidence for all 10 cases.
