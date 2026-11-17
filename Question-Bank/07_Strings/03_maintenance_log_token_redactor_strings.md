# 18 - Maintenance Log Token Redactor - Difficult

## Question Details
- Concept: Strings, token boundaries, output sizing, and controlled copying
- Difficulty: Difficult
- Domain: Industrial cybersecurity
- Learning Objective: Remove exact sensitive tokens from a log line while preserving neighboring text and spacing rules.

## Scenario
Maintenance logs may contain temporary access tokens pasted into operator notes. Redact every exact occurrence of a configured token before the log is exported; substrings inside other words must remain untouched.

## Function Details
- Function Name: `redact_log_token`
- Function Signature: `int redact_log_token(const char input[], const char token[], char output[], size_t outputCapacity, int *removedCount);`
- A token is a maximal sequence of non-whitespace characters. Remove tokens exactly equal to `token`, and collapse runs of whitespace between retained tokens to one space.
- Return 1 on success and 0 for null pointers, empty token, or insufficient output capacity. On failure, leave output and count unchanged.
- Output must be null-terminated on success; `removedCount` is the number of removed tokens.

## Tasks to Implement
1. Identify token boundaries using whitespace characters.
2. Compare whole tokens, not arbitrary substrings.
3. Copy retained tokens and normalized separators while tracking capacity.
4. Commit the removal count only after successful output construction.

## Test Cases
| Test Case ID | Input; token | Expected Output; removedCount |
| --- | --- | --- |
| TC01 | `PMP-1 ACCESS-77 bearing-hot ACCESS-77`; `ACCESS-77` | `PMP-1 bearing-hot`; 2 |
| TC02 | `ACCESS-7 ACCESS-77 ACCESS-7`; `ACCESS-7` | `ACCESS-77`; 2 |
| TC03 | `motor  overload`; `overload` | `motor`; 1 |
| TC04 | `normal vibration`; `token` | `normal vibration`; 0 |
| TC05 | ` ACCESS-9   pump `; `ACCESS-9` | `pump`; 1 |
| TC06 | any input; empty token | failure; outputs unchanged |

## Expected Deliverables
- A complete implementation of `redact_log_token`.
- A short explanation of token boundaries and capacity checks.
- Test evidence for all six cases.
