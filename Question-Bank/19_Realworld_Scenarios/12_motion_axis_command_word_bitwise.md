# 12 - Motion Axis Command Word - Medium

## Question Details
- Concept: Bitwise shifts, masks, and command-word encoding
- Difficulty: Medium
- Domain: Robotics motion control
- Learning Objective: Pack bounded fields into a fixed-width command word without overlapping bits.

## Scenario
A robot-axis controller sends speed, direction, and motion mode to a drive in one 16-bit control word. The drive reserves the upper three bits, so those bits must remain clear in every valid encoded command.

## Function Details
- Function Name: `encode_axis_command`
- Function Signature: `uint16_t encode_axis_command(unsigned int speedPermille, int reverse, unsigned int mode);`
- Bits 0..9 contain speed (0..1000), bit 10 contains direction (0=forward, 1=reverse), and bits 11..12 contain mode (0..3).
- Bits 13..15 must be zero. Return `0xFFFF` for invalid input.

## Tasks to Implement
1. Validate the three input fields before encoding.
2. Shift each field into its documented bit positions.
3. Combine the fields with bitwise OR and leave reserved bits clear.
4. Return the invalid sentinel for out-of-range values.

## Test Cases
| Test Case ID | Input: speedPermille, reverse, mode | Expected 16-bit word |
| --- | --- | --- |
| TC01 | 0, 0, 0 | 0x0000 |
| TC02 | 500, 0, 1 | 0x09F4 |
| TC03 | 1000, 1, 2 | 0x17E8 |
| TC04 | 1000, 0, 3 | 0x1BE8 |
| TC05 | 1, 1, 0 | 0x0401 |
| TC06 | 1001, 0, 0 | 0xFFFF |
| TC07 | 500, 2, 1 | 0xFFFF |
| TC08 | 500, 0, 4 | 0xFFFF |

## Expected Deliverables
- A complete implementation of `encode_axis_command`.
- A brief explanation of shifts, masks, and the reserved-bit requirement.
- Test evidence for all eight cases.
