# 36 - Shutdown Sequence Callback - Hard

## Question Details
- Concept: Function-pointer arrays and callback chaining
- Difficulty: Hard
- Domain: Plant safety interlocks
- Scenario: A critical fault triggers several safety callbacks in order.
- Learning Objective: Use callback arrays to build a modular emergency-safety response sequence.

## Scenario
During a critical machine error, the controller must trigger a fixed sequence of safety actions such as logging, isolating power, and stopping motors. Different plants may register different action handlers, but the sequence remains the same.

## Function Details
- Define a callback type `ShutdownHandler` with a `void` return type and an integer fault code parameter.
- Function Name: `run_shutdown_chain`
- Function Signature: `void run_shutdown_chain(ShutdownHandler handlers[], int count, int faultCode);`
- For each valid handler in the array, call it with the given fault code.
- If `handlers` is null or `count <= 0`, do nothing.
- Handle the sequence in order and do not stop early unless explicitly required.

## Tasks to Implement
1. Define the callback signature.
2. Iterate through the handler array in order.
3. Invoke each callback with the fault code.
4. Handle null or invalid arrays safely.
5. Verify the sequence for valid and invalid inputs.

## Test Cases
| Test Case ID | Input: handlers, count, faultCode | Expected Output |
| --- | --- | --- |
| TC01 | 3 valid handlers, 3, 101 | all 3 invoked |
| TC02 | 1 valid handler, 1, 202 | handler invoked once |
| TC03 | empty list, 0, 303 | no handlers invoked |
| TC04 | null handlers, 0, 404 | no handlers invoked |
| TC05 | 5 valid handlers, 5, 505 | all 5 invoked |
| TC06 | valid handlers, -1, 606 | no handlers invoked |
| TC07 | 2 valid handlers, 2, 700 | both invoked |
| TC08 | null handlers, 3, 801 | no handlers invoked |
| TC09 | 4 valid handlers, 4, 900 | all 4 invoked |
| TC10 | 10 valid handlers, 10, 1000 | all 10 invoked |

## Expected Deliverables
- A complete implementation of `run_shutdown_chain`.
- A short explanation of callback arrays and ordered emergency handling.
- Test evidence for all 10 cases.
