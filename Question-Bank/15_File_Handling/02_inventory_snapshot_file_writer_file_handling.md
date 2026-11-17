# 44 - Inventory Snapshot File Writer - Medium

## Question Details
- Concept: File streams, formatted output, and error checking
- Difficulty: Medium
- Domain: Maintenance stores
- Learning Objective: Append a validated stock record to an already-open backup stream.

## Scenario
At shift close, the maintenance-store service appends each spare-part balance to a snapshot file that is archived with the production log. Each successful call writes one complete CSV record.

## Function Details
- Include `<stdio.h>` and use the caller-provided stream.
- Function Name: `append_inventory_snapshot`
- Function Signature: `int append_inventory_snapshot(FILE *output, const char itemCode[], int quantity, double unitPrice);`
- Write one line in the format `itemCode,quantity,unitPrice` with unit price to two decimal places.
- Return 1 when the complete formatted write succeeds; return 0 for a null stream, empty/null item code, negative quantity/price, or write error.
- The caller opens and closes the file; this function must not close the stream.

## Tasks to Implement
1. Validate the stream and record values.
2. Use `fprintf` to append the CSV record and newline.
3. Check the write result and report success or failure.
4. Leave stream ownership with the caller.

## Test Cases
| Test Case ID | Input record | Expected bytes appended |
| --- | --- | --- |
| TC01 | A100, 25, 120.00 | `A100,25,120.00\n` |
| TC02 | B200, 40, 80.50 | `B200,40,80.50\n` |
| TC03 | C300, 18, 250.00 | `C300,18,250.00\n` |
| TC04 | D400, 0, 60.00 | `D400,0,60.00\n` |
| TC05 | E500, 72, 35.25 | `E500,72,35.25\n` |
| TC06 | null stream | return 0 |
| TC07 | empty item code | return 0 |
| TC08 | negative quantity | return 0 |

## Expected Deliverables
- A complete implementation of `append_inventory_snapshot`.
- A short explanation of stream ownership and formatted writing.
- Test evidence for all eight cases.
