# 02 - Event Log Parser - Medium

## Question Details
- Concept: Standard library string parsing and validation
- Difficulty: Medium
- Domain: Industrial monitoring
- Scenario: A plant logs events as comma-separated strings and needs to parse them into structured values.
- Learning Objective: Use standard library string functions such as `strtok` and numeric conversion helpers.

## Scenario
A supervisor application receives event lines like `101,20,42`. Each line must be parsed into a timestamp, event code, and machine ID. Invalid entries should be rejected.

## Function Details
- Define `EventRecord` with `timestamp`, `eventCode`, and `machineId` fields.
- Function Name: `parse_event_line`
- Function Signature: `int parse_event_line(const char *line, EventRecord *record);`
- Input line is non-null and at most 63 characters. Copy it into a mutable local buffer before calling `strtok`; do not modify the caller's string.
- Valid timestamp is positive, event code is one of 10, 20, 30, 40, 50, and machine ID is 1..999.
- Require exactly three comma-separated fields and reject trailing characters in numeric fields.
- Return 1 when parsing succeeds; return 0 for a null output pointer or invalid/malformed input. Do not modify the record on failure.

## Tasks to Implement
1. Copy the input into a bounded mutable buffer and tokenize the copy.
2. Convert token values with checked standard-library conversion functions.
3. Validate exact field count and each field range.
4. Commit the parsed record only after full validation.

## Test Cases
| Test Case ID | Input line | Expected Output: return |
| --- | --- | --- |
| TC01 | "101,20,42" | 1 |
| TC02 | "200,10,15" | 1 |
| TC03 | "0,20,12" | 0 |
| TC04 | "150,99,30" | 0 |
| TC05 | "300,30,1000" | 0 |
| TC06 | "400,40,1" | 1 |
| TC07 | "-10,20,44" | 0 |
| TC08 | "500,50,999" | 1 |
| TC09 | "abc,20,10" | 0 |
| TC10 | "600,10,7" | 1 |
| TC11 | "601,10,7,extra" | 0 |

## Expected Deliverables
- A complete implementation of `parse_event_line`.
- A short explanation of parsing and validation using the standard library.
- Test evidence for all 10 cases.
