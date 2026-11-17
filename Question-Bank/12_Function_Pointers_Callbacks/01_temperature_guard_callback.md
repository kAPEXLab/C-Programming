# 01 - Temperature Guard Callback - Easy

## Question Details
- Concept: Function pointers and simple callback invocation
- Difficulty: Easy
- Domain: Thermal protection
- Scenario: A heater controller invokes a callback when a warning threshold is crossed.
- Learning Objective: Use a function pointer to trigger behavior without hardcoding the action.

## Scenario
A temperature monitor checks if the heater exceeds a limit. Instead of directly printing or halting, it calls a registered callback function when the threshold is crossed.

## Function Details
- Define a callback type `TemperatureHandler` as a function pointer.
- Function Name: `check_temperature_guard`
- Function Signature: `int check_temperature_guard(double currentTemp, double limit, TemperatureHandler callback);`
- If `currentTemp >= limit`, call the callback once and return 1.
- Otherwise, return 0 without calling the callback.
- If the callback pointer is null, return 0.

## Tasks to Implement
1. Define the callback type.
2. Implement the threshold check.
3. Invoke the callback only when needed.
4. Handle null callback safely.
5. Validate the function on threshold and non-threshold values.

## Test Cases
| Test Case ID | Input: currentTemp, limit, callback | Expected Output: return |
| --- | --- | --- |
| TC01 | 45.0, 50.0, valid | 0 |
| TC02 | 50.0, 50.0, valid | 1 |
| TC03 | 60.0, 50.0, valid | 1 |
| TC04 | 30.0, 40.0, valid | 0 |
| TC05 | 40.0, 40.0, valid | 1 |
| TC06 | 20.0, 10.0, null | 0 |
| TC07 | 10.0, 10.0, valid | 1 |
| TC08 | 0.0, 0.0, valid | 1 |
| TC09 | -5.0, -1.0, valid | 0 |
| TC10 | 35.0, 35.0, valid | 1 |

## Expected Deliverables
- A complete implementation of `check_temperature_guard`.
- A brief explanation of callback-based event handling.
- Test evidence for all 10 cases.
