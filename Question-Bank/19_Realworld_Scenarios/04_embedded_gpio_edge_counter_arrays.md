# 58 - Embedded GPIO Edge Counter - Medium

## Question Details
- Concept: Arrays, loops, validation, and returning a structure
- Difficulty: Medium
- Domain: Embedded systems
- Scenario: A digital input monitor counts rising edges in a sampled sensor signal.
- Learning Objective: Detect transitions across adjacent array values and report invalid samples explicitly.

## Scenario
A controller samples a digital input as a sequence of 0 and 1 values. The signal is assumed to be 0 immediately before the first sample. Count each rising edge, which is a transition from 0 to 1.

## Function Details
- Define `EdgeCountResult` with `valid`, `sampleCount`, and `risingEdges` fields.
- Function Name: `count_rising_edges`
- Function Signature: `EdgeCountResult count_rising_edges(const int samples[], int count);`
- Valid count is 0 through 32 inclusive. Every sample must be exactly 0 or 1.
- A falling edge is not counted. Repeated 1 values count as one high signal, not multiple edges.
- If count or a sample is invalid, return `valid=0`, `sampleCount=0`, and `risingEdges=0`.
- For count=0, return a valid result with zero samples and zero rising edges.

## Tasks to Implement
1. Validate the count and sample values.
2. Traverse the sequence once, keeping track of the previous signal value.
3. Count only transitions from 0 to 1, using the specified initial value.
4. Return a result structure with the required fields.
5. Test empty, constant, alternating, and invalid sequences.

## Test Cases
| Test Case ID | Input: samples, count | Expected Output: valid, sampleCount, risingEdges |
| --- | --- | --- |
| TC01 | {0,1,1,0,1}, 5 | 1, 5, 2 |
| TC02 | {1}, 1 | 1, 1, 1 |
| TC03 | {0,0,0,0}, 4 | 1, 4, 0 |
| TC04 | {1,1,1}, 3 | 1, 3, 1 |
| TC05 | {0,1,0,1,0,1}, 6 | 1, 6, 3 |
| TC06 | {1,0,0,1,1,0}, 6 | 1, 6, 2 |
| TC07 | {}, 0 | 1, 0, 0 |
| TC08 | {0,2,1}, 3 | 0, 0, 0 |
| TC09 | {0,1}, -1 | 0, 0, 0 |
| TC10 | {0}, 33 | 0, 0, 0 |

## Expected Deliverables
- A complete implementation of `count_rising_edges`.
- A short explanation of transition detection and the initial signal state.
- Test evidence for all 10 cases.
