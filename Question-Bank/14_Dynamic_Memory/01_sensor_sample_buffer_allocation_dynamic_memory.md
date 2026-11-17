# 40 - Sensor Sample Buffer Allocation - Easy

## Question Details
- Concept: Dynamic memory allocation and pointer-to-pointer output
- Difficulty: Easy
- Domain: Embedded data acquisition
- Learning Objective: Allocate a runtime-sized sample buffer and report ownership to the caller.

## Scenario
A data-acquisition task learns the number of pressure samples required only after reading the device configuration. Allocate exactly enough storage for the requested sample count and let the caller own and release the buffer.

## Function Details
- Function Name: `allocate_sensor_buffer`
- Function Signature: `int allocate_sensor_buffer(size_t sampleCount, double **samples);`
- Valid count is 0..4096. Return 1 on success and 0 for a null output pointer, count above the limit, or allocation failure.
- Set `*samples` to null before attempting allocation. For count 0, return success with a null buffer.
- The caller is responsible for freeing a successfully allocated buffer.

## Tasks to Implement
1. Include the standard declaration needed for `size_t`, `malloc`, and `free`.
2. Validate the output pointer and requested count.
3. Allocate storage for `sampleCount` doubles and assign it through `samples`.
4. Ensure every failure leaves the output pointer null.

## Test Cases
| Test Case ID | Input | Expected Output |
| --- | --- | --- |
| TC01 | count=0, valid output pointer | return=1, buffer=null |
| TC02 | count=1, valid output pointer | return=1, one slot allocated |
| TC03 | count=64, valid output pointer | return=1, 64 slots allocated |
| TC04 | count=4096, valid output pointer | return=1, allocation attempted |
| TC05 | count=4097, valid output pointer | return=0, buffer=null |
| TC06 | count=8, null output pointer | return=0 |
| TC07 | count=0, null output pointer | return=0 |

## Expected Deliverables
- A complete implementation of `allocate_sensor_buffer`.
- A short explanation of allocation ownership and cleanup.
- Test evidence that allocated buffers are freed by the caller.
