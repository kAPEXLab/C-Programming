# 05 - Peak-Load Energy Cost - Medium

## Question Details
- Concept: Arithmetic, comparison, and logical operators
- Difficulty: Medium
- Domain: Plant energy operations
- Learning Objective: Combine a base energy charge with a conditional peak-load surcharge.

## Scenario
A factory energy dashboard estimates the charge for a production run. A surcharge applies only when the run overlaps the utility's peak-load window; off-peak runs use the base tariff.

## Function Details
- Function Name: `calculate_peak_energy_cost`
- Function Signature: `double calculate_peak_energy_cost(double energyKWh, double tariffPerKWh, double surchargePercent, int isPeak);`
- Calculate base cost as energy multiplied by tariff. Apply the surcharge only when `isPeak` is 1.
- Return -1.0 for negative energy or tariff, a negative surcharge, or an `isPeak` value other than 0 or 1.

## Tasks to Implement
1. Calculate the base charge.
2. Use a condition to decide whether the peak surcharge applies.
3. Validate the binary peak flag and non-negative numeric inputs.

## Test Cases
| Test Case ID | Input: energyKWh, tariffPerKWh, surchargePercent, isPeak | Expected Cost |
| --- | --- | --- |
| TC01 | 100, 0.12, 25, 1 | 15.00 |
| TC02 | 100, 0.12, 25, 0 | 12.00 |
| TC03 | 250.5, 0.20, 10, 1 | 55.11 |
| TC04 | 0, 0.15, 20, 0 | 0.00 |
| TC05 | 50, 0.30, 0, 1 | 15.00 |
| TC06 | 10, 0.10, 25, 2 | -1.00 |

## Expected Deliverables
- A complete implementation of `calculate_peak_energy_cost`.
- A short explanation of the conditional surcharge.
- Test evidence for all six cases.
