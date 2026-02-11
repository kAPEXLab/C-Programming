# Title: Two-Point Calibration Map (Overflow‑Safe, Rounding, Clamping)

### Level: Difficult  

### Concepts: Variables & Data Types  

---  

## Scenario  
A temperature sensor is calibrated at two points: (x₁ → y₁) and (x₂ → y₂).  
Given a new raw reading **x**, compute the calibrated output **y** using a linear map.  
The implementation must avoid overflow during slope calculation, support optional clamping to a physical range, and use only integer arithmetic.

---  

## Problem Statement  
Implement an integer‑only linear interpolation function that maps a raw sensor value to a calibrated output while handling rounding, overflow safety, optional clamping, and full argument validation.

---  

## Requirements  

- Use only `int`, `long`, and `bool`.  
- Inputs: `x`, `x1`, `y1`, `x2`, `y2`, optional clamping bounds `[y_min, y_max]`.  
- If `x1 == x2`, the calibration is degenerate → return an error.  
- Compute `y = y1 + (x - x1) * (y2 - y1) / (x2 - x1)` with all intermediate products performed in `long` to avoid overflow.  
- Apply **round‑to‑nearest** (add/subtract half the divisor before division).  
- When `clamp == true`, clamp the final `y` to the range `[y_min, y_max]`.  
- Validate pointers and all arguments; on error do **not** modify `*out_y`.  

---  

## Function Details  

**Name:** `calib_map_linear`  

**Arguments:**  
- `int x` – New raw reading.  
- `int x1, int y1, int x2, int y2` – Calibration points.  
- `bool clamp` – Enable clamping.  
- `int y_min, int y_max` – Valid only when `clamp` is `true`.  
- `int *out_y` – Output pointer for the mapped result.  

**Return Value:**  
- `int` – `0` on success; `-1` on invalid arguments (null pointer, degenerate calibration, bad clamping range, etc.).  

**Description:**  
The function performs integer linear interpolation with overflow‑safe `long` intermediates, rounds the result to the nearest integer, optionally clamps it, and stores the outcome through `out_y`. If any validation fails, the function returns `-1` and leaves `*out_y` unchanged.

---  

## Solution Approach  

1. **Validate arguments** – check for `NULL` `out_y`, ensure `x1 != x2`, verify clamping bounds when `clamp` is true, etc.  
2. **Compute numerator and denominator** using `long`:  

   ```
   long num = (long)(x - x1) * (long)(y2 - y1);
   long den = (long)(x2 - x1);
   ```  

3. **Round to nearest**:  

   - If `num >= 0`, `long term = (num + den/2) / den;`  
   - Else, `long term = (num - den/2) / den;`  

4. **Add offset**: `long y_long = (long)y1 + term;`  

5. **Clamp (if requested)**: limit `y_long` to `[y_min, y_max]`.  

6. **Store result**: `*out_y = (int) y_long;` and return `0`.  

---  

## Tasks to Perform  

1. Implement `calib_map_linear` following the solution steps above.  
2. Ensure all arithmetic uses only `int`, `long`, and `bool`.  
3. Provide thorough unit tests covering normal mapping, rounding, clamping, extrapolation, degenerate calibration, and invalid pointer cases.  

---  

## Test Cases (≥5)  

| # | Inputs / Pre‑condition                                                                                              | Expected Output                               | Notes |
|---|----------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|-------|
| 1 | `x=75`, `(x1=50,y1=0)`, `(x2=100,y2=100)`, `clamp=false`                                                            | `ret=0`, `*out=50`                            | Midpoint maps to 50 |
| 2 | `x=100`, `(50→0, 100→100)`, `clamp=false`                                                                            | `ret=0`, `*out=100`                           | Exact endpoint |
| 3 | `x=120`, `(50→0, 100→100)`, `clamp=true`, `y_min=0`, `y_max=100`                                                     | `ret=0`, `*out=100`                           | Clamped high |
| 4 | `x=40`, `(50→0, 100→100)`, `clamp=true`, `y_min=0`, `y_max=100`                                                      | `ret=0`, `*out=0`                             | Clamped low |
| 5 | `x=60`, `(x1=100,y1=200)`, `(x2=200,y2=400)`, `clamp=false`                                                          | `ret=0`, `*out=120`                           | Extrapolation (200 + (-40*200)/100 = 120) |
| 6 | `x=10`, `(x1=10,y1=500)`, `(x2=10,y2=900)`                                                                            | `ret=-1`                                      | Degenerate calibration (`x1==x2`) |
| 7 | `out_y = NULL`, any valid numeric arguments                                                                          | `ret=-1`                                      | Invalid pointer |

---