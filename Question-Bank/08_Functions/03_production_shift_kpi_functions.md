# 21 - Production Shift KPI - Difficult

## Question Details
- Concept: Functions, arithmetic, and validation
- Difficulty: Difficult
- Domain: Manufacturing operations
- Learning Objective: Encapsulate a production-performance calculation in a reusable function.

## Scenario
A shift supervisor compares production runs using completed good units, rejected units, and downtime. The plant's agreed KPI awards two points per good unit and subtracts five points per rejected unit and one point per downtime minute.

## Function Details
- Function Name: `calculate_shift_kpi`
- Function Signature: `int calculate_shift_kpi(int goodUnits, int rejectedUnits, int downtimeMinutes);`
- Return `2 * goodUnits - 5 * rejectedUnits - downtimeMinutes`.
- Return -1 when any input is negative.

## Tasks to Implement
1. Implement the formula in the reusable function.
2. Validate counts and downtime before calculating.
3. Keep the returned KPI separate from any display or ranking policy.

## Test Cases
| Test Case ID | Input: goodUnits, rejectedUnits, downtimeMinutes | Expected KPI |
| --- | --- | --- |
| TC01 | 100, 2, 10 | 180 |
| TC02 | 0, 0, 0 | 0 |
| TC03 | 50, 5, 20 | 55 |
| TC04 | 1000, 0, 45 | 1955 |
| TC05 | 10, 4, 0 | 0 |

## Expected Deliverables
- A complete implementation of `calculate_shift_kpi`.
- A short explanation of the weighting and invalid-input rule.
- Test evidence for all five cases.
