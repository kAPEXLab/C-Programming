# 33 - Production Log Severity Scanner - Difficult

## Question Details
- Concept: File reading, parsing, aggregation, and error handling
- Difficulty: Difficult
- Domain: Production incident response
- Learning Objective: Scan a complete event file and report its highest-severity valid event.

## Scenario
An incident tool reviews a production log before maintenance begins. Each line uses `eventId|level|source`; the report must show the highest severity found, the source of its first occurrence, and the number of valid events read.

## Function Details
- Function Name: `scan_production_log`
- Function Signature: `int scan_production_log(const char fileName[], char severity[16], char source[32], int *eventCount);`
- Severity order is `INFO < WARNING < ERROR < CRITICAL`.
- Ignore malformed lines and lines with unknown severities. Keep the first source encountered when severities tie.
- Return 1 when at least one valid record was read and 0 for open/read failure, no valid records, or invalid output pointers.
- Do not modify outputs unless at least one valid record was processed. Close the file on every path.

## Tasks to Implement
1. Open the file and read it line by line with a bounded buffer.
2. Parse the three pipe-delimited fields and validate the severity token.
3. Count valid records and retain the first source at the highest severity.
4. Close the file and commit outputs only after successful processing.

## Test Cases
| Test Case ID | File contents | Expected Output |
| --- | --- | --- |
| TC01 | `E101|CRITICAL|DB_CONN` then `E102|ERROR|NETWORK` | success; CRITICAL, DB_CONN, 2 |
| TC02 | `E102|ERROR|NETWORK` then `E103|WARNING|MEMORY` | success; ERROR, NETWORK, 2 |
| TC03 | `E103|WARNING|MEMORY` | success; WARNING, MEMORY, 1 |
| TC04 | `E104|CRITICAL|CPU` then `E105|CRITICAL|DRIVE` | success; CRITICAL, CPU, 2 |
| TC05 | malformed line only | failure; outputs unchanged |
| TC06 | file does not exist | failure; outputs unchanged |

## Expected Deliverables
- A complete implementation of `scan_production_log`.
- A short explanation of severity ranking and file cleanup.
- Test evidence for all six cases.
