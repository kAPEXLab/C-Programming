# 35 - Spare-Part Catalogue Lookup - Medium

## Question Details
- Concept: Recursion, array indexing, and binary search
- Difficulty: Medium
- Domain: Maintenance stores
- Learning Objective: Recursively locate a part code in a sorted inventory export and return its position.

## Scenario
A maintenance planner loads the sorted part IDs for a store room into a compact array. Work-order preparation uses the located index to retrieve the corresponding stock record from a parallel table.

## Function Details
- Function Name: `find_spare_part_index`
- Function Signature: `int find_spare_part_index(const int partIds[], int count, int targetId);`
- IDs are sorted in ascending order and contain no duplicates. Return the matching zero-based index, or -1 when the ID is absent.
- Use recursion to narrow the search interval; do not use loops.
- The array is valid when count is positive; count zero represents an empty store list.

## Tasks to Implement
1. Define the empty-interval base case.
2. Calculate the midpoint without adding the full left and right indices directly.
3. Recurse only into the half that may contain the target.
4. Return the original array index when found.

## Test Cases
| Test Case ID | Sorted part IDs; targetId | Expected Index |
| --- | --- | --- |
| TC01 | {104205,104310,208115,311020,470022}; 208115 | 2 |
| TC02 | {104205,104310,208115,311020,470022}; 470022 | 4 |
| TC03 | {104205,104310,208115,311020,470022}; 105000 | -1 |
| TC04 | {104205,104310,208115,311020,470022}; 104205 | 0 |
| TC05 | {104205,104310,208115,311020,470022}; 300000 | -1 |
| TC06 | {}, count=0; 104205 | -1 |

## Expected Deliverables
- A complete implementation of `find_spare_part_index`.
- A short explanation of the recursive search interval.
- Test evidence for all six cases.
