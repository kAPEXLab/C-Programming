# 06 - Automotive Fleet Trip Report - Difficult

## Question Details
- Concept: Arrays of structures, pointers, functions, validation, aggregation, and tie-breaking
- Difficulty: Difficult
- Domain: Automotive systems
- Scenario: A fleet service analyzes trip records to report distance, fuel usage, average fleet efficiency, and the most efficient vehicle.
- Learning Objective: Validate structured records, aggregate valid entries, and return multiple outputs through a structure pointer.

## Scenario
Each trip record contains a vehicle ID, starting odometer reading, ending odometer reading, and fuel consumed. Invalid records must be counted and excluded from all calculations, while valid records still contribute to the report.

## Function Details
- Define `TripRecord` with `vehicleId`, `startKm`, `endKm`, and `fuelLitres` fields.
- Define `TripReport` with `validRecords`, `rejectedRecords`, `totalDistanceKm`, `totalFuelLitres`, `averageKmPerLitre`, and `bestVehicleId` fields.
- Function Name: `analyze_trip_records`
- Function Signature: `int analyze_trip_records(const TripRecord records[], int count, TripReport *report);`
- Valid count is 0 through 100. A record is valid when `vehicleId > 0`, `startKm >= 0`, `endKm > startKm`, and `fuelLitres > 0`.
- Distance is `endKm - startKm`. Fleet average efficiency is total valid distance divided by total valid fuel.
- Best vehicle is the valid record with the greatest individual distance/fuel ratio. If ratios tie, choose the smaller vehicle ID.
- Return 1 when at least one record is valid, otherwise return 0. If no valid records exist, all numeric report fields must be 0. The caller supplies a non-null report pointer; records is non-null when count > 0.

## Tasks to Implement
1. Define both structures and implement the function.
2. Validate every record independently, counting invalid records without discarding valid records.
3. Aggregate only valid distances and fuel amounts.
4. Calculate the fleet ratio and choose the best vehicle using the specified tie-break.
5. Handle an empty list and a list containing no valid records.
6. Verify all 10 cases.

## Test Cases
| Test Case ID | Input records: {ID,start,end,fuel} | Expected Output: return; valid,rejected; distance,fuel,avg km/L,best ID |
| --- | --- | --- |
| TC01 | {{101,100,200,10},{102,0,120,12}} | 1; 2,0; 220,22,10.00,101 |
| TC02 | {{3,0,50,5},{7,10,70,12}} | 1; 2,0; 110,17,6.47,3 |
| TC03 | {{5,20,80,10}} | 1; 1,0; 60,10,6.00,5 |
| TC04 | {{0,0,50,5},{2,10,10,2},{3,0,20,0}} | 0; 0,3; 0,0,0.00,0 |
| TC05 | {}, count=0 | 0; 0,0; 0,0,0.00,0 |
| TC06 | {{9,0,100,10},{4,10,90,8}} | 1; 2,0; 180,18,10.00,4 |
| TC07 | {{1,0,40,4},{2,-1,50,5},{3,10,50,4}} | 1; 2,1; 80,8,10.00,1 |
| TC08 | {{55,0,300,15},{56,0,200,5}} | 1; 2,0; 500,20,25.00,56 |
| TC09 | {{8,50,75,2},{9,0,100,20},{10,0,0,1}} | 1; 2,1; 125,22,5.68,8 |
| TC10 | {{6,0,1,0.5},{2,100,160,6},{7,0,20,-1}} | 1; 2,1; 61,6.5,9.38,2 |

## Suggested Validation Rules
- Use floating-point calculations for efficiency and display ratios to two decimal places.
- Keep valid and rejected record counts consistent with the input count.
- Ensure ties are resolved by the smaller vehicle ID.

## Expected Deliverables
- Definitions for `TripRecord` and `TripReport`.
- A complete implementation of `analyze_trip_records`.
- A short explanation of record validation, aggregation, and tie-breaking.
- Test evidence for all 10 cases.
