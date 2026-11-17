# 56 - Automotive Vehicle Health Diagnostics - Medium

## Question Details
- Concept: Structures, pointers, functions, conditional logic, and output parameters
- Difficulty: Medium
- Domain: Automotive systems
- Scenario: An onboard diagnostic check evaluates coolant temperature, oil pressure, and battery voltage.
- Learning Objective: Pass a structure by pointer and populate a report structure through an output parameter.

## Scenario
A service tool receives three sensor readings and reports whether the vehicle is ready, needs inspection, or should be stopped for service.

## Function Details
- Define `VehicleReadings` with `coolantC`, `oilPressureKPa`, and `batteryV` fields.
- Define `DiagnosticReport` with `valid`, `coolantWarning`, `oilWarning`, `batteryWarning`, `warningCount`, and `status` fields.
- Function Name: `evaluate_vehicle_health`
- Function Signature: `int evaluate_vehicle_health(const VehicleReadings *readings, DiagnosticReport *report);`
- Valid input ranges: coolant -40..150 C, oil pressure 0..1000 kPa, battery 0..20 V, inclusive.
- A warning is coolant above 110 C, oil pressure below 150 kPa, or battery voltage below 11.5 V.
- Status is `OK` for zero warnings, `CHECK` for one warning, and `STOP` for two or three warnings.
- Return 1 for valid input and 0 otherwise. On invalid input, set `valid=0`, all warning flags/count to 0, and status to `INVALID`.

## Tasks to Implement
1. Declare the required structures and status values.
2. Implement the function using the readings pointer and report output pointer.
3. Validate all ranges before applying warning thresholds.
4. Count each triggered warning once and select the overall status.
5. Test normal, threshold, multiple-warning, and invalid readings.

## Test Cases
| Test Case ID | Input: coolant C, oil kPa, battery V | Expected Output: return; valid; warnings C/O/B; count; status |
| --- | --- | --- |
| TC01 | 90, 250, 12.4 | 1; 1; 0/0/0; 0; OK |
| TC02 | 111, 250, 12.4 | 1; 1; 1/0/0; 1; CHECK |
| TC03 | 110, 149, 12.0 | 1; 1; 0/1/0; 1; CHECK |
| TC04 | 100, 200, 11.4 | 1; 1; 0/0/1; 1; CHECK |
| TC05 | 120, 100, 10.5 | 1; 1; 1/1/1; 3; STOP |
| TC06 | 115, 140, 12.0 | 1; 1; 1/1/0; 2; STOP |
| TC07 | -40, 0, 0 | 1; 1; 0/1/1; 2; STOP |
| TC08 | 150, 1000, 20 | 1; 1; 1/0/0; 1; CHECK |
| TC09 | -41, 200, 12.0 | 0; 0; 0/0/0; 0; INVALID |
| TC10 | 90, 1001, 12.0 | 0; 0; 0/0/0; 0; INVALID |

## Expected Deliverables
- Definitions for both structures and the status values.
- A working implementation of `evaluate_vehicle_health`.
- A short explanation of pass-by-pointer and status selection.
- Test evidence for all 10 cases.
