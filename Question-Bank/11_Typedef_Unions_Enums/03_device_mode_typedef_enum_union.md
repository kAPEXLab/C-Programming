# 03 - Device Mode Config - Hard

## Question Details
- Concept: typedef, enum, and union used together in a device-control model
- Difficulty: Hard
- Domain: Plant control
- Scenario: A device needs a compact configuration block storing mode, alarm type, and raw parameter value.
- Learning Objective: Combine typedef, enums, and union types to model a control register clearly and efficiently.

## Scenario
A control device stores its current mode, the last alarm code, and a numeric calibration value in a single structure-like memory block. The application must read and write this block in both named-field and raw-register styles.

## Function Details
- Define enums for `MODE_IDLE`, `MODE_RUN`, `MODE_STOP`, and `MODE_FAULT`.
- Define a union for a raw register and a named value representation.
- Function Name: `set_device_mode`
- Function Signature: `int set_device_mode(DeviceConfig *config, DeviceMode mode, int alarmCode, int rawValue);`
- Valid modes are the declared enum values.
- Alarm code must be 0 to 255; raw value must be in the range -32768..32767.
- Return 1 when all values are valid and saved; return 0 if the config pointer is null or the values are out of range.

## Tasks to Implement
1. Define the typedef, enum, and union types.
2. Validate the mode, alarm code, and raw value before writing.
3. Reuse the same memory for both symbolic and raw interpretation.
4. Test both valid and invalid control combinations.
5. Explain why this representation suits embedded device configuration.

## Test Cases
| Test Case ID | Input: mode, alarmCode, rawValue | Expected Output: return |
| --- | --- | --- |
| TC01 | MODE_IDLE, 0, 0 | 1 |
| TC02 | MODE_RUN, 12, 25 | 1 |
| TC03 | MODE_STOP, 255, -100 | 1 |
| TC04 | MODE_FAULT, 10, 32767 | 1 |
| TC05 | MODE_RUN, 300, 0 | 0 |
| TC06 | MODE_STOP, 50, -32769 | 0 |
| TC07 | MODE_FAULT, 0, 32768 | 0 |
| TC08 | MODE_RUN, 2, 500 | 1 |
| TC09 | MODE_IDLE, 0, -32768 | 1 |
| TC10 | MODE_STOP, 99, -1 | 1 |

## Expected Deliverables
- Definitions for the enum, typedef, and union.
- A complete implementation of `set_device_mode`.
- A short explanation of symbolic and raw hardware representation.
- Test evidence for all 10 cases.
