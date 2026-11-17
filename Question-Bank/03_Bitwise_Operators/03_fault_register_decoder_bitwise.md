# 03 - Fault Register Decoder - Hard

## Question Details
- Concept: Bitwise decoding and fault prioritization
- Difficulty: Hard
- Domain: Manufacturing automation
- Scenario: A machine reports its fault status in a 32-bit register containing several independent faults.
- Learning Objective: Decode several flags and select the highest-priority fault using bit masks.

## Scenario
A production machine exposes one packed register. The controller must decide whether the machine is healthy, then identify the most important active fault among several possible conditions.

## Function Details
- Define priority bits: `E_STOP`, `OVER_TEMP`, `LOW_PRESSURE`, `DRIVE_FAIL`, `ENCODER_FAIL`, `OVERLOAD`, `MOTOR_STALL`.
- Function Name: `decode_fault_register`
- Function Signature: `int decode_fault_register(unsigned int faultWord, int *faultPresent, int *priorityCode);`
- Priority order is fixed as: emergency stop, over-temperature, low pressure, drive fail, encoder fail, overload, motor stall.
- Return 1 if the register was processed successfully; return 0 if the output pointers are null.
- `faultPresent` is 1 if any relevant bit is set; otherwise 0.
- `priorityCode` is the highest-priority bit index, or -1 if no fault is active.

## Tasks to Implement
1. Define the bit position constants.
2. Check each bit with a mask and priority order.
3. Return the dominant fault for simultaneous errors.
4. Handle invalid output pointers safely.
5. Validate the function for multiple simultaneous faults.

## Test Cases
| Test Case ID | Input faultWord | Expected Output: return; faultPresent; priorityCode |
| --- | --- | --- |
| TC01 | 0x00000000 | 1; 0; -1 |
| TC02 | 0x00000001 | 1; 1; 0 |
| TC03 | 0x00000002 | 1; 1; 1 |
| TC04 | 0x00000040 | 1; 1; 6 |
| TC05 | 0x00000005 | 1; 1; 0 |
| TC06 | 0x00000012 | 1; 1; 1 |
| TC07 | 0x0000007F | 1; 1; 0 |
| TC08 | 0x00000020 | 1; 1; 5 |
| TC09 | 0x00000010 | 1; 1; 4 |
| TC10 | 0x00000008 | 1; 1; 3 |

## Expected Deliverables
- A complete implementation of `decode_fault_register`.
- A short explanation of fault mask priority logic.
- Test evidence for all 10 cases.
