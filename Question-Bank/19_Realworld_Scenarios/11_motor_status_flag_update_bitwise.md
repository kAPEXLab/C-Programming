# 65 - Motor Status Flag Update - Hard

## Question Details
- Concept: Bit masks, flag setting and clearing, reserved-bit preservation, and validation
- Difficulty: Hard
- Domain: Variable-speed motor drive
- Scenario: A maintenance command updates selected status flags in a drive register without disturbing hardware-reserved bits.
- Learning Objective: Use bitwise masks to make targeted register updates while preserving unrelated state.

## Scenario
A motor drive exposes an 8-bit status register. Bits 0 through 5 are writable status flags for running, fault, overload, maintenance due, communication loss, and ready. Bits 6 and 7 are reserved by the drive firmware and must remain unchanged. A maintenance service receives separate masks for flags to set and clear.

## Function Details
- Function Name: `update_motor_status`
- Function Signature: `int update_motor_status(unsigned char currentStatus, unsigned char setFlags, unsigned char clearFlags, unsigned char *updatedStatus);`
- Bits 0 through 5 are writable; bits 6 and 7 of the update masks are invalid.
- A flag cannot be requested in both `setFlags` and `clearFlags` in the same update.
- Return 1 and write the updated byte when the request is valid; otherwise return 0 without modifying the output.
- Preserve the current values of all reserved bits.

## Tasks to Implement
1. Define the writable-status mask.
2. Validate the output pointer, requested masks, and conflicting requests.
3. Set and clear only the requested status bits.
4. Preserve all unrelated and reserved bits.
5. Test normal updates, reserved-bit cases, and invalid requests.

## Test Cases
| Test Case ID | Input: current, set, clear | Expected Output: return; updated |
| --- | --- | --- |
| TC01 | 0x00, 0x01, 0x00 | 1; 0x01 |
| TC02 | 0x03, 0x00, 0x02 | 1; 0x01 |
| TC03 | 0x80, 0x04, 0x00 | 1; 0x84 |
| TC04 | 0x40, 0x00, 0x01 | 1; 0x40 |
| TC05 | 0x0F, 0x10, 0x02 | 1; 0x1D |
| TC06 | 0x00, 0x40, 0x00 | 0; unchanged |
| TC07 | 0x00, 0x00, 0x80 | 0; unchanged |
| TC08 | 0x02, 0x02, 0x02 | 0; unchanged |
| TC09 | 0xC0, 0x20, 0x00 | 1; 0xE0 |
| TC10 | any, valid masks, null output | 0; no write |

## Expected Deliverables
- A complete implementation of `update_motor_status`.
- A short explanation of mask validation and reserved-bit preservation.
- Test evidence for all 10 cases.
