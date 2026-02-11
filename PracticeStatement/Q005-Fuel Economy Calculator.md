# Title: Fuel Economy Calculator (precedence & integer division pitfalls) — Easy  

## Level: Easy  

## Concepts: Precedence, Integer vs Floating‑Point Division, Type Conversion  

---  

## Scenario  
You log trip distance in meters and fuel consumed in milliliters on an embedded logger. You must compute fuel economy in km/L as a double, being careful with integer vs floating‑point division and operator precedence.

---  

## Problem Statement  
Implement a function that converts the raw sensor values (distance in meters, fuel in milliliters) to fuel economy expressed in kilometres per litre (km/L). The calculation must be performed using floating‑point arithmetic; any accidental integer division must be avoided.

---  

## Requirements  

* Use `double` for the result; inputs are `int`.  
* Compute  

  ```c
  km    = distance_meters / 1000.0;          // metres → kilometres
  liters= fuel_milliliters / 1000.0;         // millilitres → litres
  kmpl  = km / liters;
  ```  

* Ensure at least one operand of each division is a `double` (e.g., `1000.0` or an explicit cast) and parenthesise sub‑expressions to make the evaluation order explicit:  

  ```c
  *out_kmpl = (distance_meters / 1000.0) / (fuel_milliliters / 1000.0);
  ```  

* Validate inputs:  

  * `distance_meters >= 0`  
  * `fuel_milliliters > 0`  
  * `out_kmpl` is non‑NULL  

* Return an error for invalid inputs; **do not modify** `*out_kmpl` on error.

---  

## Function Details  

**Name:** `compute_kmpl`  

**Arguments:**  

| Argument | Type | Description |
|----------|------|-------------|
| `distance_meters` | `int` | Trip distance in metres (must be ≥ 0). |
| `fuel_milliliters`| `int` | Fuel consumed in millilitres (must be > 0). |
| `out_kmpl`        | `double *` | Pointer where the computed km/L will be stored. |

**Return Value:** `int` — `0` on success; `-1` on invalid input or null pointer.  

**Description:**  
The function validates the parameters, performs the floating‑point conversion and division as described above, stores the result in `*out_kmpl`, and returns `0`. If any validation fails, it returns `-1` and leaves `*out_kmpl` unchanged.

---  

## Solution Approach  

1. **Validate pointers** – if `out_kmpl == NULL` → return `-1`.  
2. **Validate numeric ranges** – if `distance_meters < 0` or `fuel_milliliters <= 0` → return `-1`.  
3. **Perform floating‑point calculation** using `1000.0` (a `double`) to force the operands into floating‑point context and parenthesise the sub‑expressions to guarantee the intended order.  
4. **Store the result** in `*out_kmpl` and return `0`.  

---  

## Tasks to Perform  

1. Declare the function prototype:  

   ```c
   int compute_kmpl(int distance_meters, int fuel_milliliters, double *out_kmpl);
   ```  

2. Implement the validation and calculation steps as outlined in the Solution Approach.  
3. Write unit tests covering all required test cases (see below).  
4. Verify that no integer division occurs by inspecting the generated assembly or by confirming the results with known floating‑point values.  

---  

## Test Cases

| # | Inputs / Pre‑condition                              | Expected Output                              | Notes |
|---|-----------------------------------------------------|----------------------------------------------|-------|
| 1 | `distance_meters = 0`, `fuel_milliliters = 500`, `out_kmpl` valid | `ret = 0`, `*out_kmpl = 0.0`                 | Zero distance ⇒ 0 km/L |
| 2 | `distance_meters = 50000`, `fuel_milliliters = 2500` | `ret = 0`, `*out_kmpl = 20.0`                | 50 km / 2.5 L |
| 3 | `distance_meters = 12345`, `fuel_milliliters = 678` | `ret = 0`, `*out_kmpl ≈ 18.21`               | Checks FP precedence/precision |
| 4 | `distance_meters = 1000`, `fuel_milliliters = 0`   | `ret = -1`                                   | Invalid: divide‑by‑zero would occur |
| 5 | `distance_meters = -10`, `fuel_milliliters = 100`  | `ret = -1`                                   | Invalid negative distance |
| 6 | `distance_meters = 1000`, `fuel_milliliters = 1000`, `out_kmpl = NULL` | `ret = -1`                                   | Null output pointer |
| 7 | `distance_meters = 999`, `fuel_milliliters = 1000` | `ret = 0`, `*out_kmpl ≈ 0.999`               | Sub‑km distance; FP correctness |
