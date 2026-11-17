# 03 - Part Priority Scheduler - Hard

## Question Details
- Concept: Standard library sorting, comparison functions, and data organization
- Difficulty: Hard
- Domain: Manufacturing assembly
- Scenario: A plant scheduler must sort part jobs by priority and then locate a specific part by ID.
- Learning Objective: Use `qsort` and comparator functions to organize production tasks.

## Scenario
The factory stores jobs in an array of structures. It sorts jobs by priority descending, then by part ID ascending for ties. Since the resulting array is not sorted by part ID alone, locate the requested ID with a linear scan after sorting.

## Function Details
- Define `PartJob` with `partId`, `priority`, and `dueHour` fields.
- Function Name: `sort_and_find_job`
- Function Signature: `int sort_and_find_job(PartJob jobs[], int count, int targetId, PartJob *result);`
- Sort by priority descending; for same priority, sort by partId ascending.
- Return 1 when a matching job is found; otherwise return 0.
- The result pointer is valid when the job is found.
- Use comparator logic and standard-array sorting.
- Search linearly by ID after sorting; binary search is not valid for this priority ordering.

## Tasks to Implement
1. Define the job structure and comparator.
2. Sort the array with `qsort`.
3. Search for the target job by scanning the priority-ordered array.
4. Return the matching record or not-found status.
5. Validate multiple scheduling cases.

## Test Cases
| Test Case ID | Input jobs / targetId | Expected Output: sorted part IDs; return; found |
| --- | --- | --- |
| TC01 | [{101,2,10},{132,1,8},{117,3,12}], 117 | {117,101,132}; 1; found |
| TC02 | [{101,2,10},{132,1,8},{117,3,12}], 132 | {117,101,132}; 1; found |
| TC03 | [{101,2,10},{132,1,8},{117,3,12}], 999 | {117,101,132}; 0; not found |
| TC04 | [{5,2,1},{4,2,2},{2,1,5}], 4 | {4,5,2}; 1; found |
| TC05 | [{15,5,2},{11,5,1},{22,1,3}], 22 | {11,15,22}; 1; found |
| TC06 | [{7,1,1},{9,1,2},{8,1,3}], 8 | {7,8,9}; 1; found |
| TC07 | [{3,3,1},{2,3,2},{1,3,3}], 2 | {1,2,3}; 1; found |
| TC08 | [{12,2,6},{13,2,5},{14,4,1}], 13 | {14,12,13}; 1; found |
| TC09 | [], 0, 5 | {}; 0; not found |
| TC10 | [{80,4,9},{40,4,2},{60,4,3}], 50 | {40,60,80}; 0; not found |

## Expected Deliverables
- A complete implementation of `sort_and_find_job`.
- A short explanation of comparator-based sorting and lookup.
- Test evidence for all 10 cases.
