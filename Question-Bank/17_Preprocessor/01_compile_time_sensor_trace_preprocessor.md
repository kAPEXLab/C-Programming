# 37 - Compile-Time Sensor Trace - Easy

## Question Details
- Concept: Object-like macros and conditional compilation
- Difficulty: Easy
- Domain: Embedded machine monitoring
- Learning Objective: Include or remove diagnostic output at compile time.

## Scenario
Production firmware must not print diagnostic text during normal operation, while service builds need a short trace line for each sensor event. Use a compile-time flag so the same function supports both builds.

## Function Details
- Include `<stdio.h>`.
- When `SENSOR_TRACE` is defined, `TRACE_SENSOR_EVENT(code)` prints `sensor:<code>` followed by a newline.
- When `SENSOR_TRACE` is not defined, `TRACE_SENSOR_EVENT(code)` expands to a no-op and must not evaluate `code`.
- Function Name: `trace_sensor_event`
- Function Signature: `void trace_sensor_event(const char eventCode[]);`
- The function invokes the macro once for a non-null event code.

## Tasks to Implement
1. Define `TRACE_SENSOR_EVENT` with `#ifdef SENSOR_TRACE` and `#else` branches.
2. Ensure the disabled macro does not evaluate its argument.
3. Call the macro from `trace_sensor_event`.
4. Build once with and once without the trace flag.

## Test Cases
| Test Case ID | Build flag; input | Expected Output |
| --- | --- | --- |
| TC01 | no flag; `OVERTEMP` | no output |
| TC02 | `-DSENSOR_TRACE`; `OVERTEMP` | `sensor:OVERTEMP` |
| TC03 | no flag; null event code | no output |
| TC04 | `-DSENSOR_TRACE`; `LINK_LOSS` | `sensor:LINK_LOSS` |

## Expected Deliverables
- A complete implementation of `TRACE_SENSOR_EVENT` and `trace_sensor_event`.
- A short explanation of conditional compilation.
- Build/test evidence with the flag enabled and disabled.
