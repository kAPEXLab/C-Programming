# Button Debounce with Event Callback

**Title:** Fire a User-Provided Callback on Stable Button Press (Debounce)  
**Level:** Easy  
**Concepts:** Function pointer as callback, by‑value parameters, const pointer to input buffer, input validation, simple debounce logic

***

### Scenario

You periodically sample a **digital button** and store each sample (`0` = not pressed, `1` = pressed) in a small buffer. You want to **debounce** the button by declaring it “pressed” only if the **last `k` samples are all `1`**. When a press is detected, you must invoke a **user‑provided callback** (function pointer) exactly **once** for this call.

***

### Problem Statement

Implement a function that examines the **last `k` samples** at the end of a `0/1` array. If all are `1`, it should call the provided **callback** once with an **event code** (e.g., `1` for “pressed”). Otherwise, it should not call the callback. The function must validate inputs and report via return code whether the callback was invoked.

***

### Requirements

*   **Allowed C types only:** `int`, `long`, `double`, `char`, `bool`, `enum` (plus their pointers/arrays and function pointers).
*   **Inputs:**
    *   `const int *samples` — array of `0/1` samples (read‑only).
    *   `int n` — number of samples (`n ≥ 0`).
    *   `int k` — debounce window size (`k ≥ 1`).
    *   `void (*on_press)(int event_code)` — user callback to invoke when a press is detected; pass `1` as `event_code`.
*   **Behavior:**
    *   If `n < k`, there are not enough samples to decide → do **not** call the callback; return success with “not invoked”.
    *   If the last `k` samples are all `1`, call `on_press(1)` exactly once.
    *   If any of the last `k` samples is `0`, do **not** call the callback.
*   **Outputs:**
    *   `bool *out_invoked` — set to `true` if the callback was called; otherwise `false`.
*   **Errors (no side effects on outputs):**
    *   Any NULL pointer (`samples`, `on_press`, `out_invoked`), or invalid sizes (`n < 0`, `k < 1`) → return `-1`.

***

### Function Details

*   **Name:** `debounce_and_fire`
*   **Arguments:**
    *   `const int *samples`
    *   `int n`
    *   `int k`
    *   `void (*on_press)(int event_code)`
    *   `bool *out_invoked`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    The function checks only the **last** `k` samples: indices `[n-k, …, n-1]`. If all are `1`, it invokes the callback once with `event_code = 1`, then sets `*out_invoked = true`. Otherwise, it sets `*out_invoked = false` and does not call the callback. This demonstrates **function pointer** usage and clean **callback invocation** after validation.

***

### Solution Approach

1.  **Validate inputs:** Pointers not `NULL`; `n ≥ 0`; `k ≥ 1`. If invalid, return `-1` without modifying `*out_invoked`.
2.  If `n < k`, set `*out_invoked = false` and return `0`.
3.  Initialize a local flag `all_one = true`.
4.  Loop `i` from `n - k` to `n - 1`:
    *   If `samples[i] != 1`, set `all_one = false` and break.
5.  If `all_one == true`, call `on_press(1)` exactly once and set `*out_invoked = true`; else set `*out_invoked = false`.
6.  Return `0`.

***

### Tasks to Perform

1.  Check `samples != NULL`, `on_press != NULL`, `out_invoked != NULL`, and `n >= 0`, `k >= 1`; on failure, return `-1`.
2.  If `n < k`, set `*out_invoked = false`; return `0`.
3.  Scan the last `k` samples for any `0`.
4.  If all are `1`, call `on_press(1)` and set `*out_invoked = true`; else set `*out_invoked = false`.
5.  Return `0`.

***

### Test Cases

| # | Inputs / Precondition                                   | Expected Output             | Notes                                  |
| - | ------------------------------------------------------- | --------------------------- | -------------------------------------- |
| 1 | `samples=[0,1,1,1], n=4, k=3`                           | `ret=0, *out_invoked=true`  | Last 3 are all 1 → callback fires once |
| 2 | `samples=[1,1,0,1], n=4, k=2`                           | `ret=0, *out_invoked=false` | Last 2 are `0,1` → not all 1           |
| 3 | `samples=[1,1], n=2, k=3`                               | `ret=0, *out_invoked=false` | Not enough samples (`n < k`)           |
| 4 | `samples=[1,1,1,1], n=4, k=4`                           | `ret=0, *out_invoked=true`  | Whole buffer checked; all 1            |
| 5 | `samples=[0,0,0], n=3, k=1`                             | `ret=0, *out_invoked=false` | Last sample is 0                       |
| 6 | `samples=NULL` or `on_press=NULL` or `out_invoked=NULL` | `ret=-1`                    | Invalid pointer                        |
| 7 | `n=-1` or `k<1`                                         | `ret=-1`                    | Invalid sizes                          |

***