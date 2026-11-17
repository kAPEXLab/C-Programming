# 02 - Spare-Parts Stock Position - Medium

## Question Details
- Concept: Integer variables and arithmetic expressions
- Difficulty: Medium
- Domain: Maintenance stores
- Learning Objective: Track stock quantities from distinct operational inputs without mixing units.

## Scenario
A maintenance store reconciles a spare-parts bin at shift change. The stock position is the opening quantity plus receipts minus issued parts; issuing more parts than are available is an invalid transaction.

## Function Details
- Function Name: `calculate_available_stock`
- Function Signature: `int calculate_available_stock(int openingStock, int received, int issued);`
- Return `openingStock + received - issued` when all quantities are non-negative and the result is not negative.
- Return -1 for invalid quantities or an attempted issue beyond available stock.

## Tasks to Implement
1. Store each quantity as an integer.
2. Calculate the available stock using the specified arithmetic.
3. Reject negative quantities and stock underflow.

## Test Cases
| Test Case ID | Input: openingStock, received, issued | Expected Output |
| --- | --- | --- |
| TC01 | 40, 12, 9 | 43 |
| TC02 | 0, 20, 7 | 13 |
| TC03 | 15, 0, 15 | 0 |
| TC04 | 8, 3, 12 | -1 |
| TC05 | -1, 4, 0 | -1 |

## Expected Deliverables
- A complete implementation of `calculate_available_stock`.
- Test evidence for all five cases, including stock underflow.
