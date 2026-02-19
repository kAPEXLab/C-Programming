## Detect Stable Sensor Readings Using `do-while`

**Title:** Stability Detection with Minimum Consecutive Samples (Using `do-while`)  
**Level:** Difficult  
**Concepts:** `do-while` loop (at least one iteration), loop termination conditions, absolute difference, counters, bounds checking, input validation

***

### Scenario

A sensor produces integer readings at fixed intervals. You want to detect when the signal becomes **stable**, defined as having at least **K consecutive samples** whose absolute difference from the current **reference** value is within a given **delta**. The reference value is the **first sample processed in this call**. The function must attempt detection even if there is only one sample available—hence you must use a **`do-while` loop** to ensure **at least one** iteration.

***

### Problem Statement

Implement a function that scans `samples[start..n)` and determines whether there exists a run of **K consecutive** values such that for each sample `s`, `abs(s - ref) ≤ delta`, where `ref = samples[start]`. The scan must process samples using a **`do-while` loop** and stop when:

*   Stability is detected (K consecutive within `delta`),
*   Input is exhausted (`index == n`),
*   Or an optional **limit** on examined samples (`max_to_check`) is reached.

Report whether stability was found, how many samples were examined, and the end index of the stable window (if found).

***

### Requirements

*   **Allowed C types only:** `int`, `long`, `double`, `char`, `bool`, and `enum` (and their pointers/arrays).
*   Inputs:
    *   `const int *samples` — input array
    *   `int n` — number of elements in `samples` (≥ 0)
    *   `int start` — starting index (0 ≤ `start` < `n` when `n > 0`)
    *   `int delta` — inclusive tolerance for stability (≥ 0)
    *   `int k_consecutive` — required consecutive count for stability (≥ 1)
    *   `int max_to_check` — maximum number of samples to examine (≥ 1)
*   Outputs:
    *   `bool *out_stable` — `true` if stability detected, else `false`
    *   `int *out_examined` — number of samples examined in this call (≥ 1 if inputs valid)
    *   `int *out_end_index` — index of the **last** sample in the first detected stable window; undefined if not stable (caller uses only when `out_stable==true`)
*   Behavior:
    *   Use a **`do-while`** loop so the first sample at `start` is **always** processed.
    *   Set `ref = samples[start]` before entering the loop.
    *   Maintain a `streak` counter. For each sample `x`:
        *   If `abs(x - ref) ≤ delta`: increment `streak`.
        *   Else: reset `streak = 0`.
    *   Declare stability as soon as `streak == k_consecutive`; record the current index as `*out_end_index`.
    *   Stop when stability is found, or when `i == n`, or when `examined == max_to_check`.
    *   On **invalid inputs**, return `-1` and **do not modify** any outputs.
    *   Time O(m) where `m = min(n - start, max_to_check)`; space O(1).

***

### Function Details

*   **Name:** `detect_stability_do_while`
*   **Arguments:**
    *   `const int *samples`
    *   `int n`
    *   `int start`
    *   `int delta`
    *   `int k_consecutive`
    *   `int max_to_check`
    *   `bool *out_stable`
    *   `int *out_examined`
    *   `int *out_end_index`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    The function checks for a stable window relative to the **first** sample (`ref = samples[start]`) using a **`do-while`** loop:
    ```c
    // Pseudocode shape (not full code)
    ref = samples[start];
    i = start;
    examined = 0;
    streak = 0;
    do {
        x = samples[i];
        if (abs(x - ref) <= delta) streak++; else streak = 0;
        examined++;
        if (streak == k_consecutive) { *out_stable = true; *out_end_index = i; break; }
        i++;
    } while (i < n && examined < max_to_check);
    *out_examined = examined;
    if (streak < k_consecutive) *out_stable = false;
    ```
    The `do-while` guarantees at least one processed sample, which is important when `start == n-1` or `max_to_check == 1`.

***

### Solution Approach

*   **Validate**:
    *   `samples`, `out_stable`, `out_examined`, `out_end_index` are not `NULL`.
    *   `n ≥ 0`, `max_to_check ≥ 1`, `delta ≥ 0`, `k_consecutive ≥ 1`.
    *   If `n == 0`, `start` must be `0` is invalid; in general ensure `0 ≤ start < n`.
*   **Initialize** local variables: `int i = start; int examined = 0; int streak = 0; int ref = samples[start];`
*   Use a **`do-while`** loop:
    *   Load `x = samples[i]`.
    *   Update `streak` based on `abs(x - ref) ≤ delta`.
    *   Increment `examined`.
    *   If `streak == k_consecutive`, set outputs and finish.
    *   Increment `i`.
*   Loop condition: `while (i < n && examined < max_to_check);`
*   On exit without stability: set `*out_stable = false`, `*out_examined = examined`. Do not write `*out_end_index` (or write a sentinel like `-1` if you prefer in your implementation spec).

***

### Tasks to Perform

1.  **Input validation**:
    *   Check pointers (`samples`, `out_stable`, `out_examined`, `out_end_index`) are non-NULL.
    *   Check numeric ranges: `n ≥ 0`, `delta ≥ 0`, `k_consecutive ≥ 1`, `max_to_check ≥ 1`.
    *   Check `0 ≤ start < n` (and ensure `n > 0`).
    *   On any failure: return `-1` without modifying outputs.
2.  **Initialize state**:
    *   `int i = start;`
    *   `int ref = samples[start];`
    *   `int streak = 0;`
    *   `int examined = 0;`
3.  **Process using `do-while`**:
    *   Read `int x = samples[i];`
    *   If `x` within `[ref - delta, ref + delta]` → `streak++`; else `streak = 0;`
    *   `examined++;`
    *   If `streak == k_consecutive`:
        *   `*out_stable = true; *out_end_index = i;`
        *   `*out_examined = examined; return 0;`
    *   `i++;`
    *   **Continue** while `i < n && examined < max_to_check`.
4.  **No stability found**:
    *   `*out_stable = false;`
    *   `*out_examined = examined;`
    *   (Leave `*out_end_index` for caller to ignore or write `-1` in your implementation spec.)
    *   `return 0;`

***

### Test Cases

| #  | Inputs / Precondition                                                       | Expected Output                                           | Notes                                                                       |
| -- | --------------------------------------------------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------------------- |
| 1  | `samples=[100,101,100,99,150], n=5, start=0, delta=2, k=3, max_to_check=5`  | `ret=0, out_stable=true, out_examined=3, out_end_index=2` | 100,101,100 are within ±2 → streak 3 at index 2                             |
| 2  | `samples=[100,120,100,101,102], n=5, start=0, delta=1, k=3, max_to_check=5` | `ret=0, out_stable=false, out_examined=5`                 | 120 breaks streak; never reaches 3                                          |
| 3  | `samples=[200], n=1, start=0, delta=0, k=1, max_to_check=10`                | `ret=0, out_stable=true, out_examined=1, out_end_index=0` | Single sample; `do-while` ensures at least one iteration                    |
| 4  | `samples=[50, 49, 51, 48, 52], n=5, start=1, delta=2, k=2, max_to_check=2`  | `ret=0, out_stable=true, out_examined=2, out_end_index=2` | Start at 49 (ref=49): 49 and 51 within ±2; quota stops exactly at detection |
| 5  | `samples=[10, 30, 10, 30, 10], n=5, start=0, delta=0, k=2, max_to_check=5`  | `ret=0, out_stable=false, out_examined=5`                 | Alternating values prevent 2-in-a-row                                       |
| 6  | `samples=[5,6,7,8], n=4, start=3, delta=0, k=2, max_to_check=3`             | `ret=0, out_stable=false, out_examined=1`                 | Start at last element; `do-while` processes once then stops (end of array)  |
| 7  | `samples=[100,101,100,103], n=4, start=0, delta=1, k=3, max_to_check=3`     | `ret=0, out_stable=true, out_examined=3, out_end_index=2` | Detected before hitting max\_to\_check                                      |
| 8  | `samples=NULL` or `out_stable=NULL`                                         | `ret=-1`                                                  | Invalid pointer                                                             |
| 9  | `n=0` with `start=0`                                                        | `ret=-1`                                                  | Empty array invalid with given `start`                                      |
| 10 | `start=5` with `n=4`                                                        | `ret=-1`                                                  | Start out of range                                                          |
| 11 | `delta=-1` or `k_consecutive<1` or `max_to_check<1`                         | `ret=-1`                                                  | Invalid parameters                                                          |


***
