# 18 - Robot-Cell Mode Transition Callback - Hard

## Question Details
- Concept: Function pointers, callback signatures, and state-transition validation
- Difficulty: Hard
- Domain: Plant safety interlocks
- Scenario: A robot-cell controller notifies a registered handler when the cell moves between operating modes.
- Learning Objective: Invoke a callback only for an allowed state transition and pass both state values.

## Scenario
A robot cell has IDLE, RUN, PAUSED, and FAULT modes. The safety monitor checks a requested transition before notifying the rest of the system, so dashboards and trace logs can respond without being hard-coded into the state logic.

## Function Details
- Define `ModeChangeCallback` as a function pointer accepting previous and next mode integers.
- Function Name: `report_mode_transition`
- Function Signature: `int report_mode_transition(int previousMode, int nextMode, ModeChangeCallback callback);`
- Valid modes are 0=IDLE, 1=RUN, 2=PAUSED, and 3=FAULT.
- Allowed transitions are IDLE->RUN, RUN->PAUSED, PAUSED->RUN, RUN->FAULT, PAUSED->FAULT, and FAULT->IDLE.
- Return 1 for an allowed transition; invoke the callback once only when the mode changes and callback is non-null. Return 0 for an invalid mode or disallowed transition.

## Tasks to Implement
1. Define the callback signature.
2. Validate both mode values and the transition table.
3. Invoke the callback with both states after validation.
4. Do not invoke the callback for an invalid transition.

## Test Cases
| Test Case ID | Input: previousMode, nextMode, callback | Expected Output: return; callback |
| --- | --- | --- |
| TC01 | IDLE, RUN, valid | 1; once |
| TC02 | RUN, PAUSED, valid | 1; once |
| TC03 | PAUSED, RUN, valid | 1; once |
| TC04 | RUN, FAULT, valid | 1; once |
| TC05 | PAUSED, FAULT, valid | 1; once |
| TC06 | FAULT, IDLE, valid | 1; once |
| TC07 | RUN, IDLE, valid | 0; none |
| TC08 | IDLE, FAULT, valid | 0; none |
| TC09 | IDLE, IDLE, valid | 0; none |
| TC10 | mode 4, RUN, valid | 0; none |

## Expected Deliverables
- A complete implementation of `report_mode_transition`.
- A short explanation of transition validation and callback invocation.
- Test evidence for all ten cases.
