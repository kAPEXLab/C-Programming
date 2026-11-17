# 03 - Variables and Data Types - Difficult

## Question Details
- Concept: Variables and Data Types
- Difficulty: Difficult
- Scenario: A finance engine computes a loan EMI for a manufacturing equipment purchase using principal, annual interest rate, and loan duration.
- Learning Objective: Represent a capital equipment loan using floating-point financial inputs and output parameters.

## Scenario
A finance engine computes a loan EMI for a manufacturing equipment purchase using principal, annual interest rate, and loan duration.

## Function Details
- Function Name: calculate_loan_emi
- Function Signature: void calculate_loan_emi(double principal, double annualRate, int years, double *emi, double *totalAmount, double *interestAmount);
- Parameters:
  - double principal: loan principal amount
  - double annualRate: annual interest rate in percent
  - int years: loan duration in years
  - double *emi: pointer to EMI output
  - double *totalAmount: pointer to total payable amount
  - double *interestAmount: pointer to total interest amount
- Return Type: void
- The annual rate is a percentage and the payment term is in whole years. Convert to monthly rate and payment count before applying the standard EMI formula.
- Principal must be positive, annual rate non-negative, years positive, and all output pointers non-null.
- Keep full precision while calculating total paid and interest; round only when displaying results.

## Tasks to Implement
1. Calculate the monthly payment using floating-point arithmetic.
2. Derive total paid and interest from the monthly payment and payment count.
3. Handle zero interest as a separate case.

## Test Cases
| Test Case ID | Input | Expected Output |
| --- | --- | --- |
| TC01 | principal=500000, rate=8.5%, years=5 | EMI=10258.27, Total=615495.94, Interest=115495.94 |
| TC02 | principal=1200000, rate=7.2%, years=3 | EMI=37162.35, Total=1337844.48, Interest=137844.48 |
| TC03 | principal=250000, rate=9.0%, years=2 | EMI=11421.19, Total=274108.45, Interest=24108.45 |
| TC04 | principal=1000000, rate=0.0%, years=1 | EMI=83333.33, Total=1000000.00, Interest=0.00 |
| TC05 | principal=750000, rate=11.5%, years=7 | EMI=13039.85, Total=1095347.03, Interest=345347.03 |

## Expected Deliverables
- A complete implementation of `calculate_loan_emi`.
- A short explanation of monthly rate conversion and the zero-rate case.
- Test evidence for all five equipment-financing cases.
