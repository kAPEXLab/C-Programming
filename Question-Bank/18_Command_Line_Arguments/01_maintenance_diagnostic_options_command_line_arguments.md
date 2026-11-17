# 52 - Maintenance Diagnostic Options - Easy

## Question Details
- Concept: Command-line arguments and argument-count validation
- Difficulty: Easy
- Domain: Plant maintenance tooling
- Learning Objective: Read and validate positional command-line arguments for a real maintenance utility.

## Scenario
A technician runs a diagnostic utility with an asset tag and a requested report type. The utility must accept exactly two arguments after the program name and reject incomplete invocations instead of silently printing arbitrary tokens.

## Function Details
- Function Name: `validate_diagnostic_args`
- Function Signature: `int validate_diagnostic_args(int argc, char *argv[]);`
- Accept exactly `maintdiag <asset-tag> <health|faults>` where the asset tag is non-empty and the report type is either `health` or `faults`.
- Return 1 for a valid invocation and 0 for invalid count, null argument vector, or invalid argument values.

## Tasks to Implement
1. Validate `argc` and `argv` before accessing entries.
2. Check that the asset-tag argument is non-empty.
3. Accept only the two documented report types.
4. Return a status without printing or modifying the argument strings.

## Test Cases
| Test Case ID | Command arguments (`argv[1...]`) | Expected Output |
| --- | --- | --- |
| TC01 | `PMP-1042 health` | 1 |
| TC02 | `MTR-0091 faults` | 1 |
| TC03 | `PMP-1042 temperature` | 0 |
| TC04 | `PMP-1042` | 0 |
| TC05 | empty asset tag, `health` | 0 |
| TC06 | no arguments | 0 |
| TC07 | `PMP-1042 faults extra` | 0 |
| TC08 | null argument vector | 0 |

## Expected Deliverables
- A complete implementation of `validate_diagnostic_args`.
- A short explanation of how `argc` bounds safe `argv` access.
- Test evidence for all eight cases.
