# Find the Minimum Value in a 1D Integer Array

**Title:** Minimum Element Finder (1D Array)  
**Level:** Easy  
**Concepts:** 1D array traversal, iteration, boundary checks, simple comparison logic, input validation

***

### Scenario

An embedded device periodically collects a batch of sensor readings (integers). Before further processing, you must determine the **minimum value** in the collected samples. The array length may vary, and the function must handle cases like empty input safely.

***

### Problem Statement

Implement a function that scans a 1D integer array and returns the **minimum** value found. The function must perform input validation, handle arrays of any valid length, and return an error if the array pointer is invalid or the size is negative.

***

### Requirements

*   Use a **simple linear scan** through the array.
*   Inputs:
    *   `a[]` — integer array
    *   `n` — number of elements (may be 0 or more)
*   Outputs:
    *   `*out_min` — the smallest integer in the array
*   Error handling:
    *   If `a == NULL`, `out_min == NULL`, or `n <= 0`, return `-1`
    *   On error: **do not modify** `*out_min`
*   Must use only the allowed types (`int`, `long`, `double`, `char`, `bool`, `enum`).

***

### Function Details

*   **Name:** `find_min_in_array`
*   **Arguments:**
    *   `const int *a`
    *   `int n`
    *   `int *out_min`
*   **Return Value:**
    *   `int` — `0` on success, `-1` on error.
*   **Description:**  
    The function must iterate from index `0` to `n-1`, track the smallest value encountered, and return it through `*out_min`.

***

### Solution Approach

*   Validate inputs (`a != NULL`, `out_min != NULL`, `n > 0`).
*   Initialize local `min_value = a[0]`.
*   Iterate using a simple loop:
    *   For each `a[i]`, compare with `min_value`.
    *   If smaller, update `min_value`.
*   Store the result into `*out_min`.
*   Return success (`0`).

***

### Tasks to Perform

1.  Validate inputs:
    *   If `out_min == NULL` or `a == NULL` → return `-1`.
    *   If `n <= 0` → return `-1`.
2.  Initialize `min_value = a[0]`.
3.  Loop from `i = 1` to `n-1`:
    *   If `a[i] < min_value`, then update.
4.  Write final result into `*out_min`.
5.  Return `0`.

***

### Test Cases

| # | Inputs / Precondition  | Expected Output       | Notes                  |
| - | ---------------------- | --------------------- | ---------------------- |
| 1 | `a=[5,2,8,1,9], n=5`   | `ret=0, *out_min=1`   | Normal case            |
| 2 | `a=[10], n=1`          | `ret=0, *out_min=10`  | Single element         |
| 3 | `a=[-5,-2,-9,-1], n=4` | `ret=0, *out_min=-9`  | Negative numbers       |
| 4 | `a=[100,100,100], n=3` | `ret=0, *out_min=100` | Identical values       |
| 5 | `n=0`                  | `ret=-1`              | Invalid size           |
| 6 | `a=NULL`               | `ret=-1`              | Invalid pointer        |
| 7 | `out_min=NULL`         | `ret=-1`              | Invalid output pointer |

***