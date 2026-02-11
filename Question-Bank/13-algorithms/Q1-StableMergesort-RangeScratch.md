# Stable Sort with External Scratch Buffer (Memory-Bounded Mergesort)

**Title:** Stable Ascending Sort Using Caller-Provided Scratch (Range-Aware)  
**Level:** Difficult  
**Concepts:** Stable mergesort, external buffer, range-based sort `[L..R]`, overflow-safe mid, O(n log n), memory constraints, input validation

### Scenario

You must sort a large **integer array** on an embedded target where **extra RAM is limited**. The application requires a **stable** ascending sort (preserve the original order of equal elements). To control memory usage, the caller provides a **scratch buffer** (reuse across calls) and optionally asks to sort only a **subrange** `[left..right]`, leaving other elements untouched.

### Problem Statement

Implement a **stable mergesort** over `a[left..right]` (inclusive) using a **caller-provided `scratch` buffer**. If `left==0` and `right==n-1`, the whole array is sorted. The function must verify that `scratch_capacity` is **at least `right-left+1`**. Use a **top‑down** merge, **prefer left on equality** for stability, and compute mid as `left + (right - left)/2` to avoid overflow. You may switch to **insertion sort** for tiny runs (e.g., length ≤ 16) to reduce recursion overhead.

### Requirements

*   Stable ascending sort; **prefer left element on equality**.
*   Sort **only** `[left..right]`; other indices remain unchanged.
*   Time **O(m log m)** and space **O(m)** where `m = right-left+1`.
*   Inputs validated strictly:
    *   `a`, `scratch`, `out_sorted_count` non-NULL; `n ≥ 0`.
    *   `0 ≤ left ≤ right < n` when `n > 0`; if `n == 0` then `left==right==-1` is allowed as a “no-op” case (or caller passes `m=0` semantics).
    *   `scratch_capacity ≥ (right-left+1)` (when range non-empty).
*   Do **not** allocate dynamically; use caller’s `scratch`.
*   On any invalid input, return error and **do not** modify outputs.

### Function Details

*   **Name:** `stable_sort_range_with_scratch`
*   **Arguments:**
    *   `int *a`
    *   `int n`
    *   `int left`
    *   `int right`
    *   `int *scratch`           // caller-provided buffer
    *   `int scratch_capacity`   // capacity in elements
    *   `int *out_sorted_count`  // set to number of elements sorted (right-left+1 or 0)
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    Performs a **stable mergesort** over `[left..right]`: recursively sorts two halves, then **merges** into `scratch` and copies back to `a[left..right]`. For stability, when elements are equal, **take from the left half first**. Optionally, for small segments (`len ≤ 16`), use **insertion sort** into the same range (still stable if you only swap when strictly less).

### Solution Approach

*   **Validate** inputs and compute `m = (right >= left) ? (right - left + 1) : 0`.
*   If `m == 0`, set `*out_sorted_count = 0` and return `0`.
*   Ensure `scratch_capacity ≥ m`.
*   **Recursive top-down mergesort**:
    *   `mid = left + (right - left)/2`.
    *   Sort `[left..mid]` and `[mid+1..right]`.
    *   **Merge** into `scratch[0..m-1]`: use two pointers; on equality, pick **left** first for stability.
    *   Copy `scratch[0..m-1]` back into `a[left..right]`.
*   **Optimization (optional)**: if `m ≤ 16`, run insertion sort on `[left..right]` (only swap when `a[j] < a[j-1]` to remain stable relative to equal keys).
*   Set `*out_sorted_count = m`.

### Tasks to Perform

1.  Validate pointers (`a`, `scratch`, `out_sorted_count`) and numeric ranges (`n ≥ 0`, indices in bounds).
2.  If `n == 0`: set `*out_sorted_count = 0`; return `0`.
3.  Check `0 ≤ left ≤ right < n`; compute `m = right-left+1`.
4.  Ensure `scratch_capacity ≥ m`; otherwise return `-1`.
5.  Implement stable mergesort with overflow-safe `mid`.
6.  Merge into `scratch` using **left-on-equal** for stability; copy back.
7.  Optionally use insertion sort when `m ≤ 16`.
8.  Set `*out_sorted_count = m`; return `0`.

### Test Cases

| # | Inputs / Precondition                                    | Expected Output                            | Notes                                    |
| - | -------------------------------------------------------- | ------------------------------------------ | ---------------------------------------- |
| 1 | `a=[5,3,3,2,9], n=5, left=0, right=4, scratch_cap=5`     | `ret=0, out_sorted_count=5, a=[2,3,3,5,9]` | Whole-array stable sort                  |
| 2 | `a=[4,1,4,2,4], n=5, left=1, right=3, scratch_cap=3`     | `ret=0, out_sorted_count=3, a=[4,1,2,4,4]` | Sort subrange `[1..3]` only              |
| 3 | Stability: `a=[(3a),(3b),(3c)]` represented as `[3,3,3]` | `ret=0, order preserved among equals`      | Left-on-equal merge keeps original order |
| 4 | Already sorted: `a=[1,2,3,4], left=0, right=3`           | `ret=0, a unchanged`                       | No change                                |
| 5 | Reverse: `a=[4,3,2,1], left=0, right=3, scratch_cap=4`   | `ret=0, a=[1,2,3,4]`                       | Worst-case comparisons                   |
| 6 | `scratch_cap=2` but `m=4`                                | `ret=-1`                                   | Scratch too small                        |
| 7 | `a=NULL` or `scratch=NULL` or `out_sorted_count=NULL`    | `ret=-1`                                   | Invalid pointers                         |
| 8 | `n=0` (empty), any `left/right` ignored per your policy  | `ret=0, out_sorted_count=0`                | No-op                                    |
| 9 | `left=2, right=1` or `right>=n`                          | `ret=-1`                                   | Index range invalid                      |

***