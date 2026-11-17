# 67 - Fault Bit Counter and Production Inhibit - Hard

## Question Details
- Concept: Bitwise masking, bit counting, and mask validation
- Difficulty: Hard
- Domain: Manufacturing automation
- Scenario: A machine controller counts active fault flags and decides whether a safety-critical fault should inhibit production.
- Learning Objective: Process selected bits independently and distinguish all active faults from critical inhibit faults.

## Scenario
A production line exposes a 32-bit fault word. A maintenance tool receives a mask for the faults relevant to the current machine and a second mask identifying which of those faults require production to stop.

## Function Details
- Function Name: `analyze_fault_bits`
- Function Signature: `int analyze_fault_bits(uint32_t faultWord, uint32_t monitoredMask, uint32_t inhibitMask, int *activeCount, int *productionInhibited);`
- Count the set bits in `faultWord & monitoredMask` and set `productionInhibited` when any bit in `faultWord & inhibitMask` is active.
- `inhibitMask` must be a subset of `monitoredMask`. Return 1 on valid inputs and 0 for null outputs or an invalid mask relationship.

## Tasks to Implement
1. Intersect the fault word with the monitored mask.
2. Count active bits using a loop and bit shifts or masks.
3. Separately test the inhibit mask.
4. Validate output pointers and the mask-subset rule.

## Test Cases
| Test Case ID | Input: faultWord, monitoredMask, inhibitMask | Expected: return; activeCount; productionInhibited |
| --- | --- | --- |
| TC01 | 0x00, 0x7F, 0x03 | 1; 0; 0 |
| TC02 | 0x05, 0x7F, 0x03 | 1; 2; 1 |
| TC03 | 0x08, 0x7F, 0x03 | 1; 1; 0 |
| TC04 | 0x70, 0x7F, 0x40 | 1; 3; 1 |
| TC05 | 0xFF, 0x7F, 0x03 | 1; 7; 1 |
| TC06 | 0x20, 0x7F, 0x03 | 1; 1; 0 |
| TC07 | 0x0A, 0x0F, 0x08 | 1; 2; 1 |
| TC08 | 0x00, 0x00, 0x00 | 1; 0; 0 |
| TC09 | 0x04, 0x07, 0x08 | 0; unchanged; unchanged |
| TC10 | any, valid masks, null output | 0; no write |

## Expected Deliverables
- A complete implementation of `analyze_fault_bits`.
- A short explanation of bit counting and production-inhibit masking.
- Test evidence for all ten cases.
