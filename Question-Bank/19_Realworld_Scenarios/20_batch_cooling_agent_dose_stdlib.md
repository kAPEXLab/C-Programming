# 20 - Batch Cooling-Agent Dose - Hard

## Question Details
- Concept: Standard library math functions, floating-point validation, and rounding
- Difficulty: Hard
- Domain: Process engineering
- Learning Objective: Apply standard math functions to convert a process recipe into a safe whole-unit dose.

## Scenario
A batch-mixing station calculates the cooling-agent dose from batch volume, recipe concentration, and the stock solution strength. The dosing pump accepts whole milliliters, so the calculated amount must be rounded up to avoid under-dosing.

## Function Details
- Include `<math.h>` and use `ceil` for whole-milliliter dosing.
- Function Name: `calculate_cooling_agent_dose`
- Function Signature: `int calculate_cooling_agent_dose(double batchLiters, double targetGramsPer100L, double stockGramsPerMl, unsigned int *doseMl);`
- Calculate `ceil(batchLiters * targetGramsPer100L / 100.0 / stockGramsPerMl)`.
- Require finite values, positive batch volume and stock strength, and a non-negative target concentration. Return 1 and write the dose on success; otherwise return 0 without modifying the output.
- The calculated dose must not exceed 100000 ml.

## Tasks to Implement
1. Validate the output pointer and all floating-point inputs, including non-finite values.
2. Apply the dose equation with floating-point arithmetic.
3. Round upward with `ceil` and enforce the pump capacity limit.
4. Leave the caller's output unchanged when validation fails.

## Test Cases
| Test Case ID | Input: batchLiters, targetGramsPer100L, stockGramsPerMl | Expected: return, doseMl |
| --- | --- | --- |
| TC01 | 100, 2.0, 1.0 | 1, 2 |
| TC02 | 250, 2.4, 1.2 | 1, 5 |
| TC03 | 1000, 0.5, 2.5 | 1, 2 |
| TC04 | 10, 1.0, 1.5 | 1, 1 |
| TC05 | 25, 0.0, 1.0 | 1, 0 |
| TC06 | 100, 2.0, 0.0 | 0, unchanged |
| TC07 | -1, 2.0, 1.0 | 0, unchanged |
| TC08 | 100000, 100.0, 0.1 | 0, unchanged |

## Expected Deliverables
- A complete implementation of `calculate_cooling_agent_dose`.
- A short explanation of `ceil` and floating-point validation.
- Test evidence for all eight cases.
