# 01 - Motor Status Mask - Easy

## Question Details
- Concept: Bitwise operators, masks, and flag extraction
- Difficulty: Easy
- Domain: Industrial automation
- Scenario: A motor drive reports its current health using a packed status byte.
- Learning Objective: Use bit masks to read specific flags from a single integer value.

## Scenario
A motor controller stores several on/off conditions in one byte. The application must extract whether the motor is running, overloaded, and faulted from the same register.

## Function Details
- Define bit masks for `RUNNING`, `FAULT`, and `OVERLOAD`.
- Function Name: `read_motor_status`
- Function Signature: `int read_motor_status(unsigned char statusByte, int *running, int *fault, int *overload);`
- Bits: bit 0 = running, bit 1 = fault, bit 2 = overload.
- Return 1 if outputs are valid; return 0 if any pointer is null.
- Set each output to 1 only when the corresponding bit is set.

## Tasks to Implement
1. Define the bit masks using bitwise constants.
2. Extract each flag with bitwise AND.
3. Write the result into the output variables.
4. Handle null pointers safely.
5. Verify the function against several sample bytes.

## Test Cases
| Test Case ID | Input statusByte | Expected Output: return; running; fault; overload |
| --- | --- | --- |
| TC01 | 0x00 | 1; 0; 0; 0 |
| TC02 | 0x01 | 1; 1; 0; 0 |
| TC03 | 0x02 | 1; 0; 1; 0 |
| TC04 | 0x04 | 1; 0; 0; 1 |
| TC05 | 0x05 | 1; 1; 0; 1 |
| TC06 | 0x06 | 1; 0; 1; 1 |
| TC07 | 0x07 | 1; 1; 1; 1 |
| TC08 | 0x10 | 1; 0; 0; 0 |
| TC09 | 0xFF | 1; 1; 1; 1 |
| TC10 | 0x80 | 1; 0; 0; 0 |

## Expected Deliverables
- A complete implementation of `read_motor_status`.
- A short explanation of bit masking and flag extraction.
- Test evidence for all 10 cases.
