# 20 - Machine Alarm Label Builder - Medium

## Question Details
- Concept: C strings, bounded copying, and concatenation
- Difficulty: Medium
- Domain: Industrial maintenance
- Learning Objective: Parse a compact delimited record and validate its fields.

## Scenario
A machine gateway receives an asset tag and fault code as separate strings. Build a compact label for the operator panel in the format `assetTag:faultCode`, without exceeding the caller's output buffer.

## Function Details
- Function Name: `build_alarm_label`
- Function Signature: `int build_alarm_label(const char assetTag[], const char faultCode[], char output[], size_t outputCapacity);`
- Both input strings must be non-empty and contain no colon characters.
- Return 1 after writing a null-terminated `assetTag:faultCode` label. Return 0 for null pointers, invalid fields, or insufficient capacity.
- Leave output unchanged on failure.

## Tasks to Implement
1. Validate both input strings and reject reserved delimiter characters.
2. Calculate the exact required capacity, including colon and null terminator.
3. Copy the asset tag, colon, and fault code into the output buffer.
4. Leave the buffer unchanged when validation fails.

## Test Cases
| Test Case ID | Input: assetTag, faultCode, capacity | Expected Output |
| --- | --- | --- |
| TC01 | `PMP-1042`, `BEARING_TEMP`, 32 | success; `PMP-1042:BEARING_TEMP` |
| TC02 | `LINE-2`, `OVERLOAD`, 16 | success; `LINE-2:OVERLOAD` |
| TC03 | `LINE-2`, empty fault code, 32 | failure; output unchanged |
| TC04 | `LINE:2`, `TEMP`, 16 | failure; output unchanged |
| TC05 | `PUMP-1`, `BEARING`, 14 | failure; output unchanged |
| TC06 | null asset tag, `TEMP`, 16 | failure; output unchanged |

## Expected Deliverables
- A complete implementation of `build_alarm_label`.
- A short explanation of bounded concatenation and null termination.
- Test evidence for all six cases.
