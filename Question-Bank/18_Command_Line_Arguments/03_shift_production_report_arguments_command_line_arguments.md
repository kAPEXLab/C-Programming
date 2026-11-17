# 42 - Shift Production Report Arguments - Difficult

## Question Details
- Concept: Command-line arguments, numeric parsing, and validation
- Difficulty: Difficult
- Domain: Manufacturing operations
- Learning Objective: Parse a complete report command safely before updating output options.

## Scenario
A shift supervisor runs a report utility for a production line and shift. The program accepts a line identifier, a shift period, and a maximum number of records; malformed commands must be rejected before report generation.

## Function Details
- Define `struct ShiftReportOptions` with `lineId`, `period`, and `limit` members.
- Function Name: `parse_shift_report_args`
- Function Signature: `int parse_shift_report_args(int argc, char *argv[], struct ShiftReportOptions *options);`
- Accept exactly `shift-report --line L2 --period night --limit 50` with line ID `L1`, `L2`, or `L3`, period `day` or `night`, and limit 1..500.
- Parse the limit with a checked conversion such as `strtol`; reject trailing characters and overflow.
- Return 1 on success and 0 on invalid arguments. Do not modify `options` unless the complete command is valid.

## Tasks to Implement
1. Validate `argc`, `argv`, and the output pointer before indexing arguments.
2. Require the exact option names and order.
3. Validate line and period values.
4. Parse the limit completely and enforce its range.
5. Commit all option fields only after every check succeeds.

## Test Cases
| Test Case ID | Arguments after program name | Expected Output |
| --- | --- | --- |
| TC01 | `--line L2 --period night --limit 50` | success |
| TC02 | `--line L1 --period day --limit 1` | success |
| TC03 | `--line L3 --period night --limit 500` | success |
| TC04 | `--line L9 --period day --limit 50` | failure |
| TC05 | `--line L2 --period evening --limit 50` | failure |
| TC06 | `--line L2 --period day --limit 0` | failure |
| TC07 | `--line L2 --period day --limit 501` | failure |
| TC08 | `--line L2 --period day --limit 10x` | failure |
| TC09 | missing `--period` option | failure |
| TC10 | extra argument after valid options | failure |

## Expected Deliverables
- A complete implementation of `parse_shift_report_args`.
- Correct no-partial-update behavior for invalid commands.
- Test evidence for all ten cases.
