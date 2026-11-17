# 73 - Equipment Downtime Duration - Medium

## Question Details
- Concept: Standard library time types and `difftime`
- Difficulty: Medium
- Domain: Production maintenance
- Learning Objective: Use standard time-library facilities to calculate a validated equipment downtime interval.

## Scenario
A maintenance historian stores stop and restart timestamps as `time_t` values. It reports downtime in whole minutes and rejects reversed, excessively long, or non-minute-aligned intervals so bad timestamps do not distort availability reports.

## Function Details
- Include `<time.h>` and use `time_t` timestamps.
- Function Name: `calculate_downtime_minutes`
- Function Signature: `int calculate_downtime_minutes(time_t stoppedAt, time_t restartedAt, long *minutes);`
- Use `difftime` to compute elapsed seconds.
- Accept intervals from zero through seven days only when elapsed seconds are an exact multiple of 60.
- Return 1 and write minutes on success; return 0 for invalid intervals or a null output pointer. Do not modify the output on failure.

## Tasks to Implement
1. Calculate the interval with `difftime` rather than subtracting timestamps directly.
2. Validate direction, maximum duration, and whole-minute alignment.
3. Convert seconds to minutes and write the result only after validation.

## Test Cases
| Test Case ID | Input: stoppedAt, restartedAt | Expected Output: return; minutes |
| --- | --- | --- |
| TC01 | 1000, 2800 | 1; 30 |
| TC02 | 10000, 11800 | 1; 30 |
| TC03 | 0, 0 | 1; 0 |
| TC04 | 0, 86400 | 1; 1440 |
| TC05 | 100, 50 | 0; unchanged |
| TC06 | 0, 59 | 0; unchanged |
| TC07 | 100, 604900 | 1; 10080 |
| TC08 | 50, 50 | 1; 0 |

## Expected Deliverables
- A complete implementation of `calculate_downtime_minutes`.
- A short explanation of `time_t` and `difftime`.
- Test evidence for all eight cases.
