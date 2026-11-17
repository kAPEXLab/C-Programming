# 09 - Automation Conveyor Safety Interlock - Difficult

## Question Details
- Concept: Structures, pointers, enumerations, validation, and prioritized decision logic
- Difficulty: Difficult
- Domain: Industrial automation
- Scenario: A conveyor controller decides whether a motor may run based on operator request and safety interlocks.
- Learning Objective: Validate structured inputs and implement a clearly ordered safety decision using a structured return value.

## Scenario
A packaging line controller receives a start request and three interlock signals. Safety conditions must take precedence over a start request, and the report must state the reason the motor is running or stopped.

## Function Details
- Define `ConveyorInputs` with `startRequested`, `guardClosed`, `emergencyStop`, and `overload` integer fields.
- Define reason values `RUNNING`, `IDLE`, `STOP_EMERGENCY`, `STOP_GUARD_OPEN`, `STOP_OVERLOAD`, and `INVALID_INPUT`.
- Define `ConveyorResult` with `motorOn` and `reason` fields.
- Function Name: `evaluate_conveyor`
- Function Signature: `ConveyorResult evaluate_conveyor(const ConveyorInputs *inputs);`
- Every input field must be either 0 or 1. If any field is invalid, return motor off with reason `INVALID_INPUT`.
- Apply this priority after validation: emergency stop, open guard, overload, start request, idle.
- If the emergency stop is active, reason is `STOP_EMERGENCY`; if the guard is open, `STOP_GUARD_OPEN`; if overloaded, `STOP_OVERLOAD`; otherwise a start request runs the motor with reason `RUNNING`; otherwise reason is `IDLE`.

## Tasks to Implement
1. Define the input and result structures and reason values.
2. Validate every binary input before making a decision.
3. Apply the specified priority even when multiple stop conditions are active.
4. Return motor state and decision reason together.
5. Verify all 10 cases, especially simultaneous interlocks.

## Test Cases
| Test Case ID | Input: start, guard closed, emergency stop, overload | Expected Output: motorOn, reason |
| --- | --- | --- |
| TC01 | 1,1,0,0 | 1, RUNNING |
| TC02 | 0,1,0,0 | 0, IDLE |
| TC03 | 1,0,0,0 | 0, STOP_GUARD_OPEN |
| TC04 | 1,1,1,0 | 0, STOP_EMERGENCY |
| TC05 | 1,1,0,1 | 0, STOP_OVERLOAD |
| TC06 | 1,0,1,1 | 0, STOP_EMERGENCY |
| TC07 | 1,0,0,1 | 0, STOP_GUARD_OPEN |
| TC08 | 0,1,0,1 | 0, STOP_OVERLOAD |
| TC09 | 2,1,0,0 | 0, INVALID_INPUT |
| TC10 | 1,1,0,-1 | 0, INVALID_INPUT |

## Expected Deliverables
- Definitions for all structures and reason values.
- A complete implementation of `evaluate_conveyor`.
- A short explanation of validation and interlock precedence.
- Test evidence for all 10 cases.
