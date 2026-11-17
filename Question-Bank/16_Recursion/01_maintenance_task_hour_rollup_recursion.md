# 46 - Maintenance Task-Hour Roll-Up - Easy

## Question Details
- Concept: Recursion, base cases, and array traversal
- Difficulty: Easy
- Domain: Maintenance planning
- Learning Objective: Use a recursive function to aggregate a finite list of work estimates.

## Scenario
A planner estimates the labor hours for a short maintenance package. The estimates are stored in an array, and the package total must be calculated with a recursive function so each call handles one remaining task.

## Function Details
- Function Name: `sum_maintenance_hours`
- Function Signature: `double sum_maintenance_hours(const double taskHours[], int count);`
- Return 0.0 when `count` is zero.
- Return -1.0 when `count` is negative or any included estimate is negative.
- For a positive count, add the current estimate to the recursive result for the remaining items.

## Tasks to Implement
1. Define the base case for an empty task list.
2. Validate the current estimate.
3. Recurse on the remaining portion and add the current estimate.

## Test Cases
| Test Case ID | Input: taskHours, count | Expected Total Hours |
| --- | --- | --- |
| TC01 | `{}`, 0 | 0.0 |
| TC02 | `{2.0}`, 1 | 2.0 |
| TC03 | `{1.5, 2.0, 0.5}`, 3 | 4.0 |
| TC04 | `{8.0, 4.0, 3.5, 1.0}`, 4 | 16.5 |
| TC05 | `{2.0, -1.0, 4.0}`, 3 | -1.0 |
| TC06 | `{1.0, 2.0}`, -1 | -1.0 |

## Expected Deliverables
- A complete implementation of `sum_maintenance_hours`.
- A short explanation of the base case and recursive step.
- Test evidence for all six cases.
