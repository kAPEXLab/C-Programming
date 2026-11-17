# 59 - Automation Conveyor Item Sorter - Medium

## Question Details
- Concept: Arrays, loops, structures, functions, and validation
- Difficulty: Medium
- Domain: Industrial automation
- Scenario: A conveyor controller sorts a batch of items into light, standard, heavy, and invalid groups by weight.
- Learning Objective: Process a variable-length array and return several batch totals in a structure.

## Scenario
A packaging line sends item weights in kilograms to a sorting module. The module counts each category without stopping the whole batch when it sees a negative invalid weight.

## Function Details
- Define `SortSummary` with `lightCount`, `standardCount`, `heavyCount`, and `invalidCount` fields.
- Function Name: `sort_items_by_weight`
- Function Signature: `SortSummary sort_items_by_weight(const double weightsKg[], int count);`
- Valid count is 0 through 50 inclusive. For count=0, return all counts as 0.
- Negative weights are invalid and increment `invalidCount`.
- Valid weights from 0 through 1.00 kg inclusive are light; above 1.00 through 5.00 kg inclusive are standard; above 5.00 kg are heavy.
- If count is outside its valid range, return all counts as 0. The array is non-null whenever count is greater than 0.

## Tasks to Implement
1. Define the summary structure and implement the function.
2. Use a loop to classify each item using the exact boundaries.
3. Count invalid item weights separately and continue processing the batch.
4. Handle an empty batch and invalid count safely.
5. Verify the function using all test cases.

## Test Cases
| Test Case ID | Input: weights in kg, count | Expected Output: light, standard, heavy, invalid |
| --- | --- | --- |
| TC01 | {0.5,2.0,6.0}, 3 | 1, 1, 1, 0 |
| TC02 | {0,1.0,1.01,5.0,5.01}, 5 | 2, 2, 1, 0 |
| TC03 | {0.2,0.8,1.0}, 3 | 3, 0, 0, 0 |
| TC04 | {1.1,2.5,5.0}, 3 | 0, 3, 0, 0 |
| TC05 | {5.1,8.0,20.0}, 3 | 0, 0, 3, 0 |
| TC06 | {-1.0,0.5,6.0}, 3 | 1, 0, 1, 1 |
| TC07 | {-2.0,-0.1,1.0}, 3 | 1, 0, 0, 2 |
| TC08 | {}, 0 | 0, 0, 0, 0 |
| TC09 | {0.5}, -1 | 0, 0, 0, 0 |
| TC10 | {1.0,5.0,5.01,0.0}, 4 | 2, 1, 1, 0 |

## Expected Deliverables
- A complete implementation of `sort_items_by_weight`.
- A short explanation of the thresholds and invalid-item policy.
- Test evidence for all 10 cases.
