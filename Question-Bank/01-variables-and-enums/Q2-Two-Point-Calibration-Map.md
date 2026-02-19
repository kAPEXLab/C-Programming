# Two‑Point Calibration Map (Overflow‑Safe, Rounding, Clamping)

**Level:** Difficult  
**Concepts:** Variables & Data Types  

### Scenario
A temperature sensor is calibrated at two points:  
- `(x1 → y1)`  
- `(x2 → y2)`

Given a new raw reading `x`, compute the calibrated output `y` using a linear map. The implementation must avoid overflow during slope calculation, support optional clamping to a physical range, and operate using only `int`, `long`, and `bool`.

### Problem Statement
Implement a function that performs integer linear interpolation (or extrapolation) between two calibration points, with optional result clamping and full argument validation.

### Requirements
- **Data types:** only `int`, `long`, `bool`.
- **Inputs:** `x`, `x1`, `y1`, `x2`, `y2`, optional clamping bounds `[y_min, y_max]`.
- If `x1 == x2` → return error (degenerate calibration).
- Compute `y = y1 + (x - x1) * (y2 - y1) / (x2 - x1)` with:
  - All intermediate products performed in `long` to avoid overflow.
  - Round‑to‑nearest: add/subtract half the divisor before division (positive case uses `+ den/2`, negative case uses `- den/2`).
- If `clamp == true`, clamp `y` to `[y_min, y_max]`.
- Validate all pointers and arguments; do **not** modify `*out_y` on error.

### Function Details
| Item | Description |
|------|-------------|
| **Name** | `calib_map_linear` |
| **Arguments** | `int x` – New raw reading.<br>`int x1, int y1, int x2, int y2` – Calibration points.<br>`bool clamp` – Enable clamping.<br>`int y_min, int y_max` – Valid only if `clamp` is `true`.<br>`int *out_y` – Output pointer for the mapped result. |
| **Return Value** | `int` – `0` on success; `-1` on invalid arguments (null pointer, degenerate calibration, bad range, etc.). |
| **Description** | Performs integer linear interpolation using `long` intermediates to prevent overflow. Rounds to nearest as described, adds the offset `y1`, and optionally clamps the result. Leaves `*out_y` unchanged on error. |

### Solution Approach
1. **Validate arguments** – check `out_y` is non‑NULL, `x2 != x1`, and if `clamp` is true ensure `y_min <= y_max`. Return `-1` on any failure.
2. **Calculate numerator and denominator** as `long` values: <br>`long num = (long)(x - x1) * (long)(y2 - y1);`<br>`long den = (long)(x2 - x1);`
3. **Round‑to‑nearest**: <br>`long adj = (num >= 0) ? (den / 2) : -(den / 2);`<br>`long term = (num + adj) / den;`
4. **Add offset**: `long y_long = (long)y1 + term;`
5. **Clamp if requested**: if `clamp` then `y_long = (y_long < y_min) ? y_min : (y_long > y_max) ? y_max : y_long;`
6. **Store result**: `*out_y = (int)y_long;` and return `0`.

### Tasks to Perform
- Perform full argument validation.
- Compute the linear map using `long` intermediates.
- Apply round‑to‑nearest logic.
- Add the `y1` offset.
- Optionally clamp the result to `[y_min, y_max]`.
- Write the final value to `*out_y` only on success.

### Test Cases

| # | Inputs & Pre‑condition | Expected Return | Expected `*out_y` | Notes |
|---|------------------------|-----------------|-------------------|-------|
| 1 | `x=75`, `x1=50,y1=0`, `x2=100,y2=100`, `clamp=false` | 0 | 50 | Midpoint maps to 50 |
| 2 | `x=100`, same calibration, `clamp=false` | 0 | 100 | Exact endpoint |
| 3 | `x=120`, same calibration, `clamp=true`, `y_min=0`, `y_max=100` | 0 | 100 | Clamped high |
| 4 | `x=40`, same calibration, `clamp=true`, `y_min=0`, `y_max=100` | 0 | 0 | Clamped low |
| 5 | `x=60`, `x1=100,y1=200`, `x2=200,y2=400`, `clamp=false` | 0 | 120 | Extrapolation (rounded) |
| 6 | `x=10`, `x1=10,y1=500`, `x2=10,y2=900`, any clamp | -1 | – | Degenerate: `x1 == x2` |

| 7 | `out_y = NULL`, any other valid args | -1 | – | Invalid pointer |
