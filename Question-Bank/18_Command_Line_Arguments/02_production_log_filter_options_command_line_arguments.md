# 41 - Production Log Filter Options - Medium

## Question Details
- Concept: Command-line arguments, flags, and structured option output
- Difficulty: Medium
- Domain: Industrial monitoring
- Learning Objective: Parse option/value pairs from `argc` and `argv` into a validated filter configuration.

## Scenario
An operator launches a log viewer for a specific machine and severity. The command accepts `--severity` and `--source` options in either order; malformed or duplicate options must be rejected.

## Function Details
- Define `struct LogFilterOptions` with `severity[16]` and `source[32]` members.
- Function Name: `parse_log_filter_args`
- Function Signature: `int parse_log_filter_args(int argc, char *argv[], struct LogFilterOptions *options);`
- Accept exactly two option/value pairs: severity is `WARNING`, `ERROR`, or `CRITICAL`; source is a non-empty identifier of at most 31 characters.
- Require both options exactly once, allow either pair order, and reject unknown or extra arguments.
- Return 1 on success. Return 0 on invalid input and leave `options` unchanged.

## Tasks to Implement
1. Validate `argc`, `argv`, and the output pointer before indexing.
2. Parse both option/value pairs regardless of order.
3. Reject duplicates, missing values, invalid severity, or an overlong source.
4. Copy values into the structure only after the whole command is valid.

## Test Cases
| Test Case ID | Arguments after program name | Expected Output |
| --- | --- | --- |
| TC01 | `--severity ERROR --source PUMP-4` | success |
| TC02 | `--source LINE-2 --severity WARNING` | success |
| TC03 | `--severity CRITICAL --source CELL-7` | success |
| TC04 | `--severity INFO --source PUMP-4` | failure |
| TC05 | `--severity ERROR` | failure |
| TC06 | `--severity ERROR --severity WARNING --source PUMP-4` | failure |
| TC07 | `--severity ERROR --source` | failure |
| TC08 | `--severity ERROR --source PUMP-4 extra` | failure |
| TC09 | null argument vector | failure |

## Expected Deliverables
- A complete implementation of `parse_log_filter_args`.
- Correct no-partial-update behavior for invalid commands.
- Test evidence for all nine cases.
