# 04 - Factory Consumables Order Total - Easy

## Question Details
- Concept: Arithmetic operators and expression evaluation
- Difficulty: Easy
- Domain: Factory procurement
- Learning Objective: Calculate a discounted and taxed purchase total using a defined order of operations.

## Scenario
A maintenance store orders consumables such as gloves and cleaning solvent for a production line. The purchasing tool applies a supplier discount to the subtotal, then calculates tax on the discounted amount.

## Function Details
- Function Name: `calculate_supply_order_total`
- Function Signature: `double calculate_supply_order_total(int quantity, double unitPrice, double discountPercent, double taxPercent);`
- Calculate subtotal, subtract the percentage discount, then add tax on the discounted subtotal.
- Quantity and rates are non-negative; discount and tax rates are at most 100 percent.

## Tasks to Implement
1. Calculate subtotal using multiplication.
2. Apply discount before tax as specified.
3. Return the final amount without rounding intermediate values.

## Test Cases
| Test Case ID | Input | Expected Output |
| --- | --- | --- |
| TC01 | qty=3, price=120, discount=10%, tax=5% | Subtotal=360.00, Discount=36.00, Tax=16.20, Total=340.20 |
| TC02 | qty=2, price=250, discount=0%, tax=5% | Subtotal=500.00, Discount=0.00, Tax=25.00, Total=525.00 |
| TC03 | qty=1, price=999, discount=15%, tax=18% | Subtotal=999.00, Discount=149.85, Tax=152.85, Total=1002.00 |
| TC04 | qty=5, price=80, discount=20%, tax=5% | Subtotal=400.00, Discount=80.00, Tax=16.00, Total=336.00 |
| TC05 | qty=0, price=150, discount=0%, tax=0% | Subtotal=0.00, Discount=0.00, Tax=0.00, Total=0.00 |

## Expected Deliverables
- A complete implementation of `calculate_supply_order_total`.
- A short explanation of the calculation order.
- Test evidence for all five cases.
