# 06 - Shift Readiness Index - Difficult

## Question Details
- Concept: Arithmetic operators, weighted expressions, and conditional classification
- Difficulty: Difficult
- Domain: Occupational health and safety
- Learning Objective: Combine multiple shift-screening measurements into a readiness score and action band.

## Scenario
A plant's voluntary pre-shift safety program estimates readiness for physically demanding maintenance work. The company's approved model combines resting heart rate, prior rest, walking activity, and a self-reported stress score into one index. The function returns the numeric index; the caller assigns an action band.

## Function Details
- Function Name: `calculate_shift_readiness_score`
- Function Signature: `double calculate_shift_readiness_score(int heartRate, double restHours, int walkingSteps, int stressLevel);`
- Formula: `0.4 * (100 - heartRate) + 4.5 * restHours + 0.005 * walkingSteps - 0.35 * stressLevel`.
- Inputs are from the screening form: heart rate 30..200, rest hours 0..24, steps 0..100000, stress 0..100.
- A caller classifies scores >=85 as `READY`, scores >=60 as `REVIEW`, and lower scores as `REST`.

## Tasks to Implement
1. Evaluate the weighted expression without integer truncation.
2. Keep the score calculation separate from the caller's action-band selection.
3. Use the specified input ranges when validating screening data.

## Test Cases
| Test Case ID | Input: heartRate, restHours, walkingSteps, stressLevel | Expected Score; action band |
| --- | --- | --- |
| TC01 | 72, 7.5, 9500, 38 | 79.15; REVIEW |
| TC02 | 80, 6.0, 6000, 50 | 47.50; REST |
| TC03 | 65, 8.2, 12000, 25 | 102.15; READY |
| TC04 | 90, 9.0, 15000, 15 | 114.25; READY |
| TC05 | 55, 5.5, 3000, 70 | 33.25; REST |
| TC06 | 201, 8.0, 5000, 10 | invalid input |

## Expected Deliverables
- A complete implementation of `calculate_shift_readiness_score`.
- A short explanation of the weighted expression and action thresholds.
- Test evidence for all six cases.
