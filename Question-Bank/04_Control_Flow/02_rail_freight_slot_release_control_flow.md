# 08 - Rail Freight Slot Release - Medium

## Question Details
- Concept: Decision making, string categories, and prioritized conditions
- Difficulty: Medium
- Domain: Industrial rail logistics
- Learning Objective: Apply ordered dispatch rules to classify freight handling and slot availability.

## Scenario
A rail terminal assigns freight wagons to handling areas. Hazardous material needs controlled handling, refrigerated cargo needs a cold-chain area, and standard freight uses the general area. An inspection hold always prevents release; a free dock determines whether the wagon can be placed immediately.

## Function Details
- Function Name: `evaluate_freight_slot`
- Function Signature: `void evaluate_freight_slot(const char materialClass[], int docksAvailable, int inspectionHold, char handlingClass[], char releaseStatus[], char dockStatus[]);`
- Valid material classes are `HAZMAT`, `COLD`, and `STANDARD`; `inspectionHold` must be 0 or 1 and `docksAvailable` non-negative.
- Return `INVALID` in all output buffers for invalid input. Otherwise choose `CONTROLLED`, `COLD_CHAIN`, or `GENERAL`; hold status takes precedence over dock availability.
- If not held, release is `RELEASE`; dock status is `AVAILABLE` when docks are available, otherwise `QUEUE`.

## Tasks to Implement
1. Validate the freight class, dock count, and binary hold flag.
2. Select the handling class with ordered conditions.
3. Apply inspection hold before reporting dock availability.

## Test Cases
| Test Case ID | Input: class, docksAvailable, inspectionHold | Expected: handling, release, dock |
| --- | --- | --- |
| TC01 | HAZMAT, 2, 0 | CONTROLLED, RELEASE, AVAILABLE |
| TC02 | COLD, 0, 0 | COLD_CHAIN, RELEASE, QUEUE |
| TC03 | STANDARD, 4, 1 | GENERAL, HOLD, NOT_ALLOCATED |
| TC04 | STANDARD, 1, 0 | GENERAL, RELEASE, AVAILABLE |
| TC05 | UNKNOWN, 2, 0 | INVALID, INVALID, INVALID |
| TC06 | HAZMAT, -1, 0 | INVALID, INVALID, INVALID |

## Expected Deliverables
- A complete implementation of `evaluate_freight_slot`.
- A short explanation of the safety-hold precedence.
- Test evidence for all six cases.
