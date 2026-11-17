# 31 - Pressure Batch File Summary - Easy

## Question Details
- Concept: Opening, reading, and closing a text file
- Difficulty: Easy
- Domain: Production quality control
- Learning Objective: Read a compact batch file and calculate a sensor summary.

## Scenario
A line-side quality tool reads a pressure batch export. The first line contains a positive batch ID and a sample count; the following values contain one pressure reading per line. The tool reports the batch ID and mean pressure.

## Function Details
- Function Name: `summarize_pressure_file`
- Function Signature: `int summarize_pressure_file(const char fileName[], int *batchId, double *averageKPa);`
- The file format is `batchId sampleCount` on the first line followed by exactly `sampleCount` pressure values.
- Sample count must be 1..100 and each pressure must be 0..1000 kPa inclusive.
- Return 1 on a complete valid read and 0 for an invalid pointer, open failure, malformed data, or out-of-range value.
- Do not modify either output unless the entire file is valid.

## Tasks to Implement
1. Open the named file and verify that it is available.
2. Read and validate the header and every sample.
3. Calculate the average only after all samples are valid.
4. Close the file on every path and commit outputs only on success.

## Test Cases
| Test Case ID | File contents | Expected Output |
| --- | --- | --- |
| TC01 | `501 3` then `98.0`, `100.0`, `102.0` | return=1, batchId=501, average=100.00 |
| TC02 | `502 1` then `0.0` | return=1, batchId=502, average=0.00 |
| TC03 | `503 2` then `120.0`, `130.0` | return=1, batchId=503, average=125.00 |
| TC04 | `0 2` then `120.0`, `130.0` | return=0, outputs unchanged |
| TC05 | `505 0` | return=0, outputs unchanged |
| TC06 | `506 2` then `120.0` only | return=0, outputs unchanged |
| TC07 | `507 1` then `1000.1` | return=0, outputs unchanged |
| TC08 | file does not exist | return=0, outputs unchanged |

## Expected Deliverables
- A complete implementation of `summarize_pressure_file`.
- Correct file cleanup and unchanged outputs on failure.
- Test evidence for all eight cases.
