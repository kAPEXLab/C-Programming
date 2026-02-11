# Count How Many Readings Exceed a Threshold (Using a Basic `for` Loop)

**Title:** Count Values Above Threshold  
**Level:** Easy  
**Concepts:** `for` loop, array traversal, boundary checks, counters, input validation

***

### Scenario

A small data-logger collects sensor samples (integers). Your task is to scan the array and count how many readings exceed a given **threshold**. Since the array length may vary, a clean and simple `for` loop must be used to iterate through all elements and compute the count.

***

### Problem Statement

Implement a function that counts how many elements in an integer array are **strictly greater** than a given threshold using a **basic `for` loop\`**. The function must validate inputs and return an error if any pointer is invalid or array size is negative.

***

### Requirements

*   Use only a **standard `for` loop\`** for iteration.
*   Inputs:
    *   `a[]` — integer array
    *   `n` — number of elements (may be 0 or more)
    *   `threshold` — reference value
*   Output:
    *   `*out_count` — number of elements strictly greater than `threshold`
*   Error handling:
    *   If `a == NULL` or `out_count == NULL` or `n < 0` → return error (`-1`)
    *   On error: **do not** modify `*out_count`

***

### Function Details

*   **Name:** `count_above_threshold`
*   **Arguments:**
    *   `const int *a`
    *   `int n`
    *   `int threshold`
    *   `int *out_count`
*   **Return Value:**
    *   `int` — `0` on success, `-1` on invalid input.
*   **Description:**  
    The function should loop from index `0` to `n-1` using a `for (i=0; i<n; i++)` pattern, compare each element with `threshold`, and increment a local counter.

***

### Solution Approach

*   Validate inputs.
*   Initialize a local variable `count = 0;`
*   Use a **classic for-loop**:
*   Store the result into `*out_count` and return success.

***

### Tasks to Perform

1.  Validate:
    *   `a != NULL`
    *   `out_count != NULL`
    *   `n >= 0`
2.  Initialize `count = 0`
3.  Iterate using a `for` loop and count values strictly greater than `threshold`
4.  Store the result in `*out_count`
5.  Return `0`
6.  On invalid input, return `-1` and do **not** write to output

***

### Test Cases

| # | Inputs / Precondition             | Expected Output       | Notes                     |
| - | --------------------------------- | --------------------- | ------------------------- |
| 1 | `a=[1,5,9], n=3, threshold=4`     | `ret=0, *out_count=2` | 5 & 9 are above threshold |
| 2 | `a=[10,10,10], n=3, threshold=10` | `ret=0, *out_count=0` | Strictly greater required |
| 3 | `a=[-1,-5,-3], n=3, threshold=-4` | `ret=0, *out_count=2` | -1 & -3 exceed threshold  |
| 4 | `a=[], n=0, threshold=5`          | `ret=0, *out_count=0` | Empty array               |
| 5 | `a=NULL`                          | `ret=-1`              | Invalid pointer           |
| 6 | `out_count=NULL`                  | `ret=-1`              | Invalid output pointer    |
| 7 | `n=-1`                            | `ret=-1`              | Invalid size              |

***