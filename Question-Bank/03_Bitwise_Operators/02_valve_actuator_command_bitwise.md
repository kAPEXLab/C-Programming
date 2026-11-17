# 02 - Valve Actuator Command - Medium

## Question Details
- Concept: Bitwise packing and command decoding
- Difficulty: Medium
- Domain: Process control
- Scenario: A valve controller receives a packed command byte for open, close, hold, and emergency-stop requests.
- Learning Objective: Encode multiple actuator commands into one bitfield and decode them accurately.

## Scenario
An industrial valve uses a single command byte where each bit represents a separate actuator action. The system must decode the byte without reading separate control lines.

## Function Details
- Define masks for `OPEN`, `CLOSE`, `HOLD`, and `EMERGENCY_STOP`.
- Function Name: `decode_valve_command`
- Function Signature: `int decode_valve_command(unsigned char command, int *open, int *close, int *hold, int *emergencyStop);`
- Bits: bit 0 open, bit 1 close, bit 2 hold, bit 3 emergency stop.
- Return 1 if all output pointers are valid, otherwise return 0.
- Set each output to 1 only when the relevant bit is active.

## Tasks to Implement
1. Define the bit masks.
2. Use bitwise AND to check each action.
3. Write the decoded flags into the output variables.
4. Ensure reserved bits do not trigger actions.
5. Validate different real command values.

## Test Cases
| Test Case ID | Input command | Expected Output: return; open; close; hold; emergencyStop |
| --- | --- | --- |
| TC01 | 0x01 | 1; 1; 0; 0; 0 |
| TC02 | 0x02 | 1; 0; 1; 0; 0 |
| TC03 | 0x04 | 1; 0; 0; 1; 0 |
| TC04 | 0x08 | 1; 0; 0; 0; 1 |
| TC05 | 0x05 | 1; 1; 0; 1; 0 |
| TC06 | 0x06 | 1; 0; 1; 1; 0 |
| TC07 | 0x0F | 1; 1; 1; 1; 1 |
| TC08 | 0x10 | 1; 0; 0; 0; 0 |
| TC09 | 0x00 | 1; 0; 0; 0; 0 |
| TC10 | 0xFF | 1; 1; 1; 1; 1 |

## Expected Deliverables
- A complete implementation of `decode_valve_command`.
- A short explanation of bit masking and flag interpretation.
- Test evidence for all 10 cases.
