# Map Operating Mode (enum) to CPU Frequency  

**Level:** Easy  
**Concepts:** Variables & Data Types  

---  

### Scenario  
An embedded controller runs at different CPU frequencies depending on an operating mode. In power‑save mode, frequencies should be reduced by half.  

---  

### Problem Statement  
Implement a function that maps an operating mode (enumerated) to its corresponding CPU frequency in MHz, optionally applying a power‑save reduction. Invalid enum values must be reported as an error.  

---  

### Requirements  

- Define the enumeration- `Mode { MODE_SLEEP, MODE_IDLE, MODE_RUN, MODE_BOOST }`  

- Base frequencies (example design):  

  * `MODE_SLEEP` → 0 MHz  
  * `MODE_IDLE`  → 24 MHz  
  * `MODE_RUN`   → 48 MHz  
  * `MODE_BOOST` → 96 MHz  

- If `power_save == true`, return **half** the base frequency (integer division).  
- For invalid enum values, return **‑1**.  
- `MODE_SLEEP` must always return 0 MHz, even when `power_save` is true.  

---  

### Function Details  

**Name:** `mode_to_cpu_mhz`  

**Arguments:**  

- `enum Mode mode` – operating mode to be mapped.  
- `bool power_save` – flag indicating whether to halve the base frequency.  

**Return Value:**  

- `int` – CPU frequency in MHz; `-1` for an invalid mode.  

**Description:**  
Validate that `mode` is one of the defined enumeration values. Retrieve the corresponding base frequency, apply the power‑save reduction when requested (except for `MODE_SLEEP`), and return the result. If the mode is not recognized, return `-1`.  

---  

### Solution Approach  

1. **Validate** the `mode` value; if it is outside the range of the defined enum, return `-1`.  
2. **Map** the enum to its base frequency using a `switch` (or lookup table).  
3. If `mode == MODE_SLEEP`, set frequency to `0`.  
4. Otherwise, if `power_save` is `true`, divide the base frequency by `2` using integer division.  
5. Return the final frequency.  

---  

### Tasks to Perform  

1. Write the `enum Mode` definition.  
2. Implement `mode_to_cpu_mhz` following the solution steps.  
3. Verify that the function works for all valid modes, respects the power‑save flag, and correctly handles invalid enum values.  
4. Create unit tests covering the cases listed below.  

---  

### Test Cases

| # | Inputs / Pre‑condition                                                   | Expected Output | Notes                              |
|---|---------------------------------------------------------------------------|-----------------|------------------------------------|
| 1 | `mode = MODE_SLEEP`, `power_save = false`                                 | `0`             | Sleep clock off                   |
| 2 | `mode = MODE_IDLE`, `power_save = false`                                  | `24`            | Base frequency                    |
| 3 | `mode = MODE_RUN`, `power_save = true`                                    | `24`            | 48 / 2 = 24 (power‑save)           |
| 4 | `mode = MODE_BOOST`, `power_save = true`                                  | `48`            | 96 / 2 = 48 (power‑save)           |
| 5 | `mode = (enum Mode)99`, `power_save = false`                              | `-1`            | Invalid enum                      |

| 6 | `mode = MODE_SLEEP`, `power_save = true`                                  | `0`             | Remains zero even with power‑save |
