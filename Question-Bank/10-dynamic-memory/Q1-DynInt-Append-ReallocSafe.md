# Growable Integer Buffer

**Title:** Append One Integer to a Dynamically-Resizable Buffer  
**Level:** Easy  
**Concepts:** `malloc`/`realloc`/`free`, growth strategy, overflow checks, ownership, no-leak `realloc` pattern, pointer-to-pointer API

### Scenario

You’re collecting sensor samples as `int`. The buffer starts **empty** (no allocation), and each time a new sample arrives you **append** it. The API must allocate on first use, **grow capacity** as needed (e.g., **double** when full), guard against **integer overflow**, handle **allocation failure** without leaking, and update the caller’s `*buf`, `*count`, and `*capacity` consistently.

### Problem Statement

Implement a function to **append one integer** to a dynamically managed array. Allocate on first append, grow when full, and keep the original buffer intact on failure (no partial updates, no leaks).

### Requirements

*   Allowed types only: `int`, `long`, `double`, `char`, `bool`, `enum` (and their pointers).
*   Inputs:
    *   `int **buf` — pointer to the dynamic array pointer (may be `NULL` when empty).
    *   `int *count` — number of valid elements.
    *   `int *capacity` — total allocated slots (≥ 0).
    *   `int value` — value to append.
*   Behavior:
    *   If `*capacity == 0`, allocate a small initial capacity (e.g., **4**).
    *   When `*count == *capacity`, **grow** capacity (e.g., **double**), but check for **overflow** (new capacity must be ≥ `*count + 1` and reasonable for `int` sizes).
    *   Use the **no-leak `realloc` pattern**: assign `realloc` result to a **temporary** pointer; update `*buf` only after success.
    *   On success, store `value` at index `*count` and increment `*count`.
*   Error handling:
    *   Invalid pointers or negative `*capacity`/`*count` → return error without modifying anything.
    *   On allocation failure, do **not** modify any of `*buf`, `*count`, `*capacity` (and no leaks).
*   Return codes:
    *   `0` success
    *   `-1` invalid arguments
    *   `-2` allocation failure
    *   `-3` capacity overflow detected (growth would exceed safe integer limits)

### Function Details

*   **Name:** `dynint_append`
*   **Arguments:**
    *   `int **buf`
    *   `int *count`
    *   `int *capacity`
    *   `int value`
*   **Return Value:**  
    `int` — `0` on success; negative error codes as above.
*   **Description:**  
    Appends `value` to a growable buffer. Allocates on first use and grows geometrically. Uses a **temporary pointer** to hold `realloc`’s return before committing to avoid losing the original pointer on failure.

### Solution Approach

*   Validate pointers and invariants (`*count ≥ 0`, `*capacity ≥ 0`, and if `*capacity == 0` then `*buf` may be `NULL`).
*   Decide **target capacity**:
    *   If `*capacity == 0` → `new_cap = 4`
    *   Else `new_cap = (*capacity < INT_MAX/2) ? (*capacity * 2) : (INT_MAX/sizeof(int))` with checks.
*   Confirm `new_cap >= *count + 1` and `new_cap * sizeof(int)` won’t overflow `int` (use `long` for intermediate).
*   Allocate:
    *   If `*capacity == 0`: `tmp = malloc(new_cap * sizeof(int))`
    *   Else: `tmp = realloc(*buf, new_cap * sizeof(int))`
*   On success, commit: `*buf = tmp; *capacity = new_cap;` then write `(*buf)[*count] = value; (*count)++;`
*   On failure, return `-2`.

### Tasks to Perform

1.  Validate `buf`, `count`, `capacity` pointers and non-negative values.
2.  If `*count < *capacity`, append directly; else compute safe `new_cap`.
3.  Allocate/grow using `malloc`/`realloc` into a **temporary**.
4.  On success, commit pointer/capacity, store `value`, increment `*count`.
5.  On failure, return `-2` without modifying anything.

### Test Cases

| # | Inputs / Precondition                               | Expected Output                                  | Notes                     |
| - | --------------------------------------------------- | ------------------------------------------------ | ------------------------- |
| 1 | `*buf=NULL, *count=0, *capacity=0, value=10`        | `ret=0; new cap=4; buf[0]=10; count=1`           | First allocation          |
| 2 | After #1, append 20,30,40                           | `ret=0; count=4; capacity=4; buf={10,20,30,40}`  | Filled to capacity        |
| 3 | Append 50 when full                                 | `ret=0; capacity grows to 8; count=5; buf[4]=50` | Doubling growth           |
| 4 | `*count=-1` or `*capacity=-1`                       | `ret=-1`                                         | Invalid invariants        |
| 5 | Force overflow path (simulate `*capacity` near max) | `ret=-3`                                         | Detected unsafe growth    |
| 6 | Simulate allocation failure (conceptually)          | `ret=-2; no changes to buf/count/capacity`       | No leaks; state unchanged |

***