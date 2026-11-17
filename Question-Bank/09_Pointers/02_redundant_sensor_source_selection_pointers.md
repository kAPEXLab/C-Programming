# 23 - Redundant Sensor Source Selection - Medium

## Question Details
- Concept: Pointers, pointer-to-pointer output, and validation
- Difficulty: Medium
- Domain: Redundant process instrumentation
- Learning Objective: Return the address of the sensor source selected by a failover decision.

## Scenario
A pressure controller normally reads its primary transmitter and switches to a backup transmitter when the primary is unhealthy. The selection function must return the chosen reading's address, not copy its value.

## Function Details
- Function Name: `select_sensor_source`
- Function Signature: `int select_sensor_source(const int *primary, const int *backup, int primaryHealthy, const int **selected);`
- `primaryHealthy` must be 0 or 1. Select the primary when healthy; otherwise select the backup.
- Return 1 when a source is selected. If the selected source or output pointer is null, or `primaryHealthy` is invalid, return 0 and set `*selected` to null when the output pointer is valid.

## Tasks to Implement
1. Validate the output pointer and health flag.
2. Choose the correct input pointer based on primary health.
3. Return the selected address through the pointer-to-pointer parameter.
4. Handle a missing backup source without dereferencing it.

## Test Cases
| Test Case ID | Primary value, backup value, primaryHealthy | Expected: return, selected value |
| --- | --- | --- |
| TC01 | 120, 118, 1 | 1, 120 |
| TC02 | 120, 118, 0 | 1, 118 |
| TC03 | null, 118, 0 | 1, 118 |
| TC04 | 120, null, 1 | 1, 120 |
| TC05 | 120, 118, 2 | 0, null |

## Expected Deliverables
- A complete implementation of `select_sensor_source`.
- A short explanation of pointer-to-pointer output and failover selection.
- Test evidence for all five cases, including missing sources.
