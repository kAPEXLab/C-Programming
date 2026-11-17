# 51 - Build-Time Sensor Sampling Profile - Difficult

## Question Details
- Concept: Preprocessor conditionals, object-like macros, and function-like macros
- Difficulty: Difficult
- Domain: Embedded machine monitoring
- Learning Objective: Configure sampling behavior at compile time for different production-line builds.

## Scenario
The same monitoring firmware is built for standard, high-speed, or low-power machine installations. The build profile determines how a requested sampling interval is scaled; incompatible profiles must fail at compile time rather than silently selecting one.

## Function Details
- Define `SAMPLE_INTERVAL_MS(requestedMs)` as a parenthesized function-like macro.
- When `HIGH_SPEED_LINE` is defined, use the requested interval unchanged.
- When `LOW_POWER_MODE` is defined, multiply the requested interval by 4.
- With neither macro defined, multiply the requested interval by 2.
- Emit a preprocessor error if both `HIGH_SPEED_LINE` and `LOW_POWER_MODE` are defined.
- Function Name: `configure_sample_interval`
- Function Signature: `int configure_sample_interval(int requestedMs);`
- Return -1 for a non-positive request or when the adjusted value would exceed `INT_MAX`; otherwise return the profile-adjusted interval.

## Tasks to Implement
1. Define the function-like scaling macro with safe parentheses.
2. Use `#if`, `#ifdef`, or `#error` to select and validate the build profile.
3. Implement `configure_sample_interval` using the macro.
4. Compile and test the standard, high-speed, and low-power profiles separately.

## Test Cases
| Test Case ID | Build flags | Input requestedMs | Expected Output |
| --- | --- | --- | --- |
| TC01 | none | 10 | 20 |
| TC02 | `-DHIGH_SPEED_LINE` | 10 | 10 |
| TC03 | `-DLOW_POWER_MODE` | 10 | 40 |
| TC04 | none | 1 | 2 |
| TC05 | `-DHIGH_SPEED_LINE` | 25 | 25 |
| TC06 | `-DLOW_POWER_MODE` | 25 | 100 |
| TC07 | any single profile | 0 | -1 |
| TC08 | any single profile | -5 | -1 |
| TC09 | `-DHIGH_SPEED_LINE -DLOW_POWER_MODE` | any | compilation must fail |
| TC10 | standard profile; `INT_MAX` | -1 |

## Expected Deliverables
- A complete implementation of `configure_sample_interval` and its macros.
- A short explanation of compile-time profile selection.
- Build/test evidence for all three valid profiles and the conflicting-profile compile failure.
