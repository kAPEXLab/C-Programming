# 05 - Enum Alarm Priority Dispatcher - Medium

## Question Details
- Concept: Enums, typedefs, switch logic, and structured dispatch
- Difficulty: Medium
- Domain: Industrial safety
- Scenario: A plant monitoring system translates alarm codes into priority actions and dispatches the correct response.
- Learning Objective: Use enum values to model alarm severity and produce deterministic control actions.

## Scenario
Different alarm types require different actions and urgency. A central dispatcher maps each alarm type to a priority rank and a response text or state.

## Function Details
- Define an enum for alarm types such as `LOW_PRESSURE`, `HIGH_TEMP`, `MOTOR_FAULT`, `POWER_LOSS`, `SAFETY_SHUTDOWN`.
- Define a second enum for priority levels such as `INFO`, `WARNING`, `CRITICAL`, `EMERGENCY`.
- Function Name: `get_alarm_priority`
- Function Signature: `int get_alarm_priority(AlarmType type, AlarmPriority *priority);`
- The priority mapping is: `LOW_PRESSURE` = WARNING, `HIGH_TEMP` = CRITICAL, `MOTOR_FAULT` = EMERGENCY, `POWER_LOSS` = EMERGENCY, `SAFETY_SHUTDOWN` = EMERGENCY.
- Return 1 when the alarm is recognized, otherwise 0.
- The output pointer is non-null.

## Tasks to Implement
1. Define the enums and map each alarm to an action priority.
2. Use a switch-based dispatcher rather than raw integer comparisons.
3. Return the matching priority and indicate recognized alarms.
4. Handle unknown alarm codes safely.
5. Verify all 10 cases for correct priority assignment.

## Test Cases
| Test Case ID | Input alarm type | Expected Output: return; priority |
| --- | --- | --- |
| TC01 | LOW_PRESSURE | 1; WARNING |
| TC02 | HIGH_TEMP | 1; CRITICAL |
| TC03 | MOTOR_FAULT | 1; EMERGENCY |
| TC04 | POWER_LOSS | 1; EMERGENCY |
| TC05 | SAFETY_SHUTDOWN | 1; EMERGENCY |
| TC06 | unknown value | 0; undefined |
| TC07 | LOW_PRESSURE again | 1; WARNING |
| TC08 | HIGH_TEMP again | 1; CRITICAL |
| TC09 | POWER_LOSS again | 1; EMERGENCY |
| TC10 | SAFETY_SHUTDOWN again | 1; EMERGENCY |

## Expected Deliverables
- Definitions for the enums and priority mapping.
- A complete dispatcher implementation for `get_alarm_priority`.
- A short explanation of why enums improve code clarity in safety systems.
- Test evidence for all 10 cases.
