# 38 - Machined-Part Dimension Macro - Medium

## Question Details
- Concept: Function-like macros and safe argument parenthesizing
- Difficulty: Medium
- Domain: Precision machining
- Learning Objective: Define a reusable conversion macro that behaves correctly inside larger expressions.

## Scenario
A machining station receives drawing dimensions in millimeters, while one legacy fixture controller uses inches. Convert the dimension using a macro and demonstrate why both the parameter and full expression must be parenthesized.

## Function Details
- Define `MM_TO_INCHES(mm)` as `((mm) / 25.4)`.
- Function Name: `fixture_dimension_inches`
- Function Signature: `double fixture_dimension_inches(double drawingMm);`
- Return the macro result. The macro must evaluate the argument exactly once.

## Tasks to Implement
1. Define the conversion macro with parentheses around its parameter and whole expression.
2. Use it in the wrapper function.
3. Test the macro inside an expression such as `MM_TO_INCHES(a + b)`.
4. Explain the result if the macro were defined without parentheses.

## Test Cases
| Test Case ID | Drawing dimension mm | Expected inches |
| --- | --- | --- |
| TC01 | 25.4 | 1.0 |
| TC02 | 50.8 | 2.0 |
| TC03 | `MM_TO_INCHES(25.4 + 25.4)` | 2.0 |
| TC04 | 0.0 | 0.0 |
| TC05 | 12.7 | 0.5 |

## Expected Deliverables
- A complete implementation of `MM_TO_INCHES` and `fixture_dimension_inches`.
- A short explanation of macro parenthesizing and single evaluation.
- Test evidence for all five cases.
