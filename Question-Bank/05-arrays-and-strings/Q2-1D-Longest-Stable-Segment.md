# Longest “Stable” Segment in a 1D Integer Array

**Title:** Longest Stable Segment with Step, Span, Average & Length Constraints  
**Level:** Difficult  
**Concepts:** 1D array, sliding window, two‑pointer thinking, min/max maintenance, average computation, multi‑constraint satisfaction, tie‑breaking rules, input validation  
*(Use only built-in C types: `int`, `long`, `double`, `char`, `bool`, `enum` and their pointers/arrays.)*

***

## Scenario

You’re analyzing a stream of integer sensor readings captured into a 1D array. A segment of readings is considered **stable** if it satisfies **all** of the following:

1.  **Step constraint:** Every pair of **adjacent** samples within the segment differs by at most `step_max`.
2.  **Span constraint:** The **range** (max − min) within the segment is at most `span_max`.
3.  **Average constraint:** The **mean** of the segment lies within the inclusive range `[avg_min, avg_max]`.
4.  **Length constraint:** The segment length is in `[min_len, max_len]` (if `max_len == 0`, treat as “no upper bound”).

Among all stable segments, you must pick the **longest** one. If multiple candidates share the same maximum length, choose the one with the **higher average**; if still tied, choose the one with the **earliest start index**.

***

## Problem Statement

Given an integer array `a` of length `n`, find a **contiguous** segment `[L..R]` that satisfies all the constraints above. Return its start index, end index, length, and average. If no valid segment exists, return a specific error code without modifying outputs.

***

## Requirements

*   **Inputs:**
    *   `a` — integer array
    *   `n` — number of elements (≥ 0)
    *   `step_max` — maximum allowed absolute difference between adjacent elements within the segment (≥ 0)
    *   `span_max` — maximum allowed `(max − min)` within the segment (≥ 0)
    *   `avg_min`, `avg_max` — inclusive average bounds (`avg_min ≤ avg_max`)
    *   `min_len` — minimum segment length (≥ 1)
    *   `max_len` — maximum segment length (≥ `min_len`), or `0` to indicate “no upper bound”
*   **Outputs (on success):**
    *   `*out_start = L`
    *   `*out_end = R`
    *   `*out_len = R - L + 1`
    *   `*out_avg = average of a[L..R]` (as `double`)
*   **Return codes:**
    *   `0` — success
    *   `-1` — invalid input (do **not** modify outputs)
    *   `-2` — no segment satisfies constraints (do **not** modify outputs)
*   **Constraints to enforce on a candidate segment `[L..R]`:**
    *   For all `i` in `[L+1..R]`: `|a[i] - a[i-1]| ≤ step_max`
    *   Let `vmin = min(a[L..R])`, `vmax = max(a[L..R])`: require `vmax - vmin ≤ span_max`
    *   Let `mean = sum(a[L..R]) / (R - L + 1)`: require `avg_min ≤ mean ≤ avg_max`
    *   `min_len ≤ (R - L + 1) ≤ (max_len or ∞ if max_len==0)`
*   **Tie‑breakers (in order):**
    1.  **Longer length**
    2.  **Higher average** (strictly larger `mean`)
    3.  **Smaller `L`** (earlier start)

***

## Function Details

*   **Name:** `find_longest_stable_segment`
*   **Arguments:**
    *   `const int *a`
    *   `int n`
    *   `int step_max`
    *   `int span_max`
    *   `double avg_min`
    *   `double avg_max`
    *   `int min_len`
    *   `int max_len`   // `0` means “no upper bound”
    *   `int *out_start`
    *   `int *out_end`
    *   `int *out_len`
    *   `double *out_avg`
*   **Return Value:**  
    `int` — `0` on success; `-1` on invalid input; `-2` if no valid segment exists.
*   **Description:**  
    Search a contiguous segment `[L..R]` in `a` that satisfies **step**, **span**, **average**, and **length** constraints, applying defined tie‑breakers to select a unique best segment. On success, write all outputs and return `0`. On error or no solution, **do not** modify any outputs.

***

## Solution Approach

*   **Validation first** (fail fast):
    *   Pointers `a`, `out_start`, `out_end`, `out_len`, `out_avg` must be non‑`NULL`.
    *   `n ≥ 0`, `step_max ≥ 0`, `span_max ≥ 0`, `min_len ≥ 1`, `avg_min ≤ avg_max`, and if `max_len > 0` then `max_len ≥ min_len`.
    *   If `n == 0`, immediately return `-2` (no data to form a segment).
*   **Brute-force (baseline, O(n²), simple to implement):**
    *   For each `L` from `0` to `n-1`:
        *   Initialize `sum = 0`, `vmin = a[L]`, `vmax = a[L]`, `ok_step = true`.
        *   For `R = L .. n-1`:
            *   Check adjacent step: if `R > L` and `|a[R] - a[R-1]| > step_max`, **break** (no further `R` for this `L` will satisfy step constraint).
            *   Update `sum += a[R]`, `vmin`, `vmax`.
            *   If `max_len > 0` and `(R - L + 1) > max_len`, break (exceeds upper bound).
            *   If `(R - L + 1) ≥ min_len` and `(vmax - vmin) ≤ span_max`:
                *   Compute `mean = ((double)sum) / (R - L + 1)`.
                *   If `avg_min ≤ mean ≤ avg_max`, evaluate against current **best** using tie‑breakers.
*   **Optimized hint (O(n)–O(n log n) via sliding window):**
    *   Maintain window `[L..R]`, `sum`, **two deques** for window **min** and **max**, and a `last_bad_step` index where `|a[i]-a[i-1]| > step_max`. Ensure `L > last_bad_step`.
    *   On each `R` extension: push to deques; while `span` or `length` constraint violated (or `L ≤ last_bad_step`), pop from left (advance `L`) and adjust `sum`.
    *   Whenever the window meets **span**, **step**, and **length** constraints, compute mean and evaluate against best.  
        *(Average bounds are not monotonic, so you may need to test candidates rather than always shrinking to fix mean.)*
*   **Numerical notes:**
    *   Use `long` for `sum` to avoid overflow when `n` and values are large; cast to `double` only for average.
    *   All comparisons are inclusive where specified.

***

## Tasks to Perform

1.  **Validate inputs:**
    *   Check all pointers are non‑`NULL`.
    *   Check numeric ranges: `n ≥ 0`, `step_max ≥ 0`, `span_max ≥ 0`, `avg_min ≤ avg_max`, `min_len ≥ 1`, and `(max_len == 0 || max_len ≥ min_len)`.
    *   If invalid → `return -1`.
    *   If `n == 0` → `return -2`.
2.  **Initialize best trackers:**
    *   `int best_L = -1, best_R = -1; int best_len = 0; double best_avg = 0.0;`
3.  **Outer loop over start `L` (baseline approach):**
    *   Set `long sum = 0; int vmin = a[L]; int vmax = a[L];`
    *   For `R` from `L` to `n-1`:
        *   If `R > L` and `|a[R] - a[R-1]| > step_max`, **break**.
        *   Update `sum`, `vmin`, `vmax`.
        *   If `max_len > 0` and `(R - L + 1) > max_len`, **break**.
        *   If `(R - L + 1) ≥ min_len` and `(vmax - vmin) ≤ span_max`:
            *   `double mean = (double)sum / (double)(R - L + 1);`
            *   If `avg_min ≤ mean ≤ avg_max`, compare with current best using tie‑breakers.
4.  **Finalize:**
    *   If `best_len == 0`, return `-2`.
    *   Else write outputs:  
        `*out_start = best_L; *out_end = best_R; *out_len = best_len; *out_avg = best_avg; return 0;`
5.  **(Optional advanced)** Re-implement with sliding window + deques for min/max to achieve near O(n).

***

## Test Cases

| # | Inputs / Precondition                                                                                  | Expected Output                           | Notes                                                                                                                                                                                                                                                                                          |
| - | ------------------------------------------------------------------------------------------------------ | ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | `a=[10,12,13,13,15,20], n=6, step_max=3, span_max=6, avg_min=11.0, avg_max=15.0, min_len=3, max_len=0` | `ret=0, start=0, end=4, len=5, avg=12.6`  | Entire `[0..4]` valid: steps ≤3, span=15−10=5≤6, mean≈12.6 within range                                                                                                                                                                                                                        |
| 2 | `a=[5,5,5,5], n=4, step_max=0, span_max=0, avg_min=5.0, avg_max=5.0, min_len=2, max_len=0`             | `ret=0, start=0, end=3, len=4, avg=5.0`   | All equal; longest is whole array                                                                                                                                                                                                                                                              |
| 3 | `a=[1,20,2,21,3,22], n=6, step_max=3, span_max=5, avg_min=0.0, avg_max=100.0, min_len=2, max_len=0`    | `ret=0, start=2, end=4, len=3, avg=~8.67` | Step constraint breaks at big jumps; best is `[2..4]: 2,21,3` invalid (span=19) → Actually `[2..3]` invalid (step 19); hence **valid** longest is `[0..1]` (len=2, avg=10.5) or `[4..5]` (len=2, avg=12.5). **Tie-breaker picks `[4..5]`** (higher average): `start=4, end=5, len=2, avg=12.5` |
| 4 | `a=[3,4,7,8,9], n=5, step_max=4, span_max=3, avg_min=5.0, avg_max=7.0, min_len=2, max_len=3`           | `ret=0, start=1, end=3, len=3, avg=~6.33` | `[1..3]={4,7,8}` span=4>3 invalid; best is `[2..3]={7,8}`, len=2, avg=7.5 (within) and `[3..4]={8,9}`, avg=8.5 (out of range). So choose `[2..3]`                                                                                                                                              |
| 5 | `a=[100], n=1, step_max=0, span_max=0, avg_min=200.0, avg_max=300.0, min_len=1, max_len=0`             | `ret=-2`                                  | Single sample average 100 not in \[200,300]                                                                                                                                                                                                                                                    |
| 6 | `a=[-2,-1,-1,0,1], n=5, step_max=2, span_max=3, avg_min=-1.5, avg_max=0.5, min_len=3, max_len=0`       | `ret=0, start=0, end=3, len=4, avg=-1.0`  | Steps OK, span=0−(−2)=2, mean in range; `[0..4]` span=3 also valid, avg=-0.6 (still within), **longer wins** → `start=0, end=4, len=5, avg=-0.6` (choose longest)                                                                                                                              |
| 7 | `a=[], n=0, step_max=1, span_max=1, avg_min=0.0, avg_max=1.0, min_len=1, max_len=0`                    | `ret=-2`                                  | No data                                                                                                                                                                                                                                                                                        |
| 8 | `a=NULL` (any other valid params)                                                                      | `ret=-1`                                  | Invalid pointer                                                                                                                                                                                                                                                                                |
| 9 | `min_len=0` or `avg_min>avg_max` or `max_len>0 && max_len<min_len`                                     | `ret=-1`                                  | Invalid parameters                                                                                                                                                                                                                                                                             |

