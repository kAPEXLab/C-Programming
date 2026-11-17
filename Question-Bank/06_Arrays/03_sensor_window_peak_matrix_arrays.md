# 18 - Arrays - Difficult

## Question Details
- Concept: Arrays
- Difficulty: Difficult
- Scenario: An industrial sensor hub parses a 3x3 vibration matrix for row and column trends and reports maximum stress signal values.
- Learning Objective: Traverse a two-dimensional sensor window and derive row, column, and global peak values.

## Scenario
An industrial sensor hub parses a 3x3 vibration matrix for row and column trends and reports maximum stress signal values.

## Function Details
- Function Name: analyze_matrix
- Function Signature: void analyze_matrix(const int matrix[3][3], int rowMax[3], int colMax[3], int *globalMax);
- Parameters:
  - const int matrix[3][3]: matrix values
  - int rowMax[3]: row-wise maxima
  - int colMax[3]: column-wise maxima
  - int *globalMax: global maximum
- Return Type: void

## Tasks to Implement
1. Find each row's maximum using nested loops.
2. Find each column's maximum in a separate traversal.
3. Track the global maximum across the complete 3x3 window.

## Test Cases
| Test Case ID | Input | Expected Output |
| --- | --- | --- |
| TC01 | matrix=[[12,8,15],[10,7,9],[5,14,11]] | Row Max={15,10,14}, Col Max={12,14,15}, Max=15 |
| TC02 | matrix=[[1,2,3],[4,5,6],[7,8,9]] | Row Max={3,6,9}, Col Max={7,8,9}, Max=9 |
| TC03 | matrix=[[6,5,4],[9,8,7],[3,2,1]] | Row Max={6,9,3}, Col Max={9,8,7}, Max=9 |
| TC04 | matrix=[[0,0,0],[0,5,0],[0,0,0]] | Row Max={0,5,0}, Col Max={0,5,0}, Max=5 |
| TC05 | matrix=[[10,20,30],[15,25,35],[11,21,31]] | Row Max={30,35,31}, Col Max={15,25,31}, Max=35 |

## Expected Deliverables
- A complete implementation of `analyze_matrix`.
- A short explanation of row-major and column-wise traversal.
- Test evidence for all five sensor windows.
