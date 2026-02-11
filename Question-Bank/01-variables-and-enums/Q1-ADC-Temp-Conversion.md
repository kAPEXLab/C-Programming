# Title: Convert ADC Reading to Battery Percentage

**Level:** Easy

**Concepts:** Variables & Data Types

### Scenario
A handheld tester reads battery voltage via an ADC. You need to compute a percentage (0–100%) from the raw ADC count. The ADC’s full‑scale count can vary by hardware version.

### Problem Statement
Write a function that converts a raw ADC reading to a battery‑percentage using integer arithmetic only.

### Requirements
- **Inputs:** `adc` (current count), `adc_max` (maximum valid count).  
- Use integer arithmetic; avoid floating point.  
- Use overflow‑safe intermediate (`long`) for multiply.  
- Perform round‑to‑nearest during percentage calculation.  
- Clamp result to `[0, 100]`.  
- Treat invalid inputs as errors (`adc_max <= 0` or `adc < 0` or `adc > adc_max`).

### Function Details
- **Name:** `adc_to_percent`  
- **Arguments:**  
  - `int adc` — Raw ADC count.  
  - `int adc_max` — Maximum ADC count for the hardware (e.g., 1023, 4095).  
  - `int *out_percent` — Output pointer for the result (0–100).  
- **Return Value:** `int` — `0` on success; `-1` on invalid inputs or null pointer.  
- **Description:** Compute `percent = round((adc * 100) / adc_max)` using `long` for the product. Clamp to `[0, 100]`. Return an error if inputs are invalid or `out_percent` is `NULL`.

### Solution Approach
*(Use integer arithmetic with a `long` intermediate, add `adc_max/2` for rounding, then clamp the result.)*

### Tasks to Perform
- Validate input arguments.  
- Perform the integer calculation with proper rounding.  
- Clamp the result to the range 0‑100.  
- Store the result via `out_percent`.  

### Test Cases
| # | `adc` | `adc_max` | Expected Return | Expected `*out_percent` | Notes |
|---|-------|-----------|-----------------|--------------------------|-------|
| 1 | 0     | 4095      | 0               | 0                        | Lower bound |
| 2 | 4095  | 4095      | 0               | 100                      | Upper bound |
| 3 | 2048  | 4095      | 0               | 50                       | Mid‑scale (rounded) |
| 4 | 1023  | 1023      | 0               | 100                      | Edge when `adc = adc_max` |
| 5 | 1100  | 1023      | -1              | —                        | Invalid: `adc > adc_max` |
| 6 | 500   | 0         | -1              | —                        | Invalid: division by zero |
| 7 | 205   | 4095      | 0               | 5                        | Rounding check |