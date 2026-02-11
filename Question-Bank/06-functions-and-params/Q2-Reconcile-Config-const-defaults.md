# Reconcile Writable Config with Read-Only Defaults (Tolerances, Dry-Run)

**Title:** Array Reconciliation Using `const int*` Defaults and By-Value Controls  
**Level:** Difficult  
**Concepts:** `const` pointer for read-only input, writable pointer for in-place updates, by-value parameters (tolerance, flags), output via pointers, aliasing safety, input validation

### Scenario

Your device stores **default configuration** values in a **read-only** table (flash/ROM). At runtime, a **writable** configuration array may drift from defaults. You must **reconcile** the writable array against defaults as follows:

*   If `abs(current[i] - defaults[i]) > tolerance`, the element is **out-of-spec**.
*   If `dry_run == false`, **overwrite** `current[i]` with `defaults[i]`.
*   If `dry_run == true`, **do not modify** `current`, but still **report** how many elements would be updated and the **first index** that would change.

The **defaults** table must never be modified; it is provided as a **`const int*`**. Control inputs (`tolerance`, `dry_run`) are **by value**.

### Problem Statement

Implement a function that compares two same-length arrays, counts **out-of-spec** entries, optionally **updates** the writable array to match defaults (depending on `dry_run`), and reports how many entries were actually updated (or would be updated), plus the **first mismatch index** (or `-1` if none). Guard against invalid inputs and **aliasing** (if `defaults` and `current` point to the same buffer, treat as an error).

### Requirements

*   **Inputs:**
    *   `const int *defaults` — read-only table; **must not** be modified.
    *   `int *current` — writable config array.
    *   `int n` — array length (`n >= 0`).
    *   `int tolerance` — inclusive tolerance (≥ 0).
    *   `bool dry_run` — by-value control flag.
*   **Outputs:**
    *   `int *out_mismatches` — count of indices with `abs(diff) > tolerance`.
    *   `int *out_updates` — number of elements **updated** (or **would update** if `dry_run==true`).
    *   `int *out_first_index` — smallest index that is out-of-spec, or `-1` if none.
*   **Rules:**
    *   If any pointer is `NULL`, `n < 0`, or `tolerance < 0`, return error **without modifying** outputs.
    *   If `n == 0`, succeed with all outputs as `0` and `-1` (no work).
    *   If `defaults == current` (same address), **return error**: cannot read-only compare and write in-place safely.
    *   Time: O(n), Space: O(1).

### Function Details

*   **Name:** `reconcile_config_with_defaults`
*   **Arguments:**
    *   `const int *defaults`
    *   `int *current`
    *   `int n`
    *   `int tolerance`
    *   `bool dry_run`
    *   `int *out_mismatches`
    *   `int *out_updates`
    *   `int *out_first_index`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input; `-2` on aliasing (`defaults == current`).
*   **Description:**  
    Scan arrays and compute `diff = current[i] - defaults[i]`. If `diff > tolerance` or `diff < -tolerance`, mark as mismatch. Count mismatches and record the first mismatch index. If `dry_run==false`, set `current[i] = defaults[i]` and increment updates; if `dry_run==true`, leave `current` untouched but still increment updates for each out-of-spec slot. Use `const int*` for `defaults` to prevent accidental writes. `tolerance` and `dry_run` are **by value**; any changes inside the function must not affect caller variables.

### Solution Approach

*   Validate inputs: pointers not `NULL`, `n >= 0`, `tolerance >= 0`.
*   If `n == 0`: write `*out_mismatches = 0; *out_updates = 0; *out_first_index = -1; return 0;`.
*   If `defaults == current`: return `-2` (cannot safely reconcile).
*   Initialize locals: `mismatches = 0; updates = 0; first = -1;`.
*   Loop `i = 0..n-1`:
    *   Compute `diff = current[i] - defaults[i]`.
    *   If `diff > tolerance || diff < -tolerance`:
        *   `mismatches++`; if `first < 0`, set `first = i`.
        *   If `!dry_run`, do `current[i] = defaults[i];` and `updates++`; else `updates++` only.
*   Set outputs and return `0`.

### Tasks to Perform

1.  Validate: `defaults`, `current`, `out_mismatches`, `out_updates`, `out_first_index` are not `NULL`; `n >= 0`; `tolerance >= 0`.
2.  Check aliasing: if `defaults == current`, return `-2`.
3.  Handle `n == 0`: set outputs to `0, 0, -1` and return `0`.
4.  Iterate through arrays; detect out-of-spec entries with inclusive `tolerance`.
5.  If `dry_run==false`, update `current[i]` to default; otherwise leave it unchanged.
6.  Track `mismatches`, `updates`, and the earliest index requiring change.
7.  Write outputs and return `0`.

### Test Cases

| # | Inputs / Precondition                                                | Expected Output                                                         | Notes                                |
| - | -------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------ |
| 1 | `defaults=[10,20,30], current=[10,22,27], n=3, tol=2, dry_run=false` | `ret=0, mismatches=1 (index1), updates=1, first=1, current=[10,20,27]`  | Only 22→20 updated                   |
| 2 | Same as #1 but `dry_run=true`                                        | `ret=0, mismatches=1, updates=1, first=1, current unchanged [10,22,27]` | Dry run reports but does not modify  |
| 3 | `defaults=[0,0,0], current=[5,-1,0], n=3, tol=0, dry_run=false`      | `ret=0, mismatches=2, updates=2, first=0, current=[0,0,0]`              | Tolerance zero: exact match required |
| 4 | `defaults=[1,2,3], current=[1,2,3], n=3, tol=5, dry_run=true`        | `ret=0, mismatches=0, updates=0, first=-1, current=[1,2,3]`             | Already within tolerance             |
| 5 | `defaults=[100], current=[120], n=1, tol=25, dry_run=false`          | `ret=0, mismatches=0, updates=0, first=-1, current=[120]`               | 20 ≤ 25 → in-spec                    |
| 6 | `defaults=[7,8], current=[7,8], n=2, tol=0, dry_run=false, n=0`      | `ret=0, mismatches=0, updates=0, first=-1`                              | Trivial empty work (when `n==0`)     |
| 7 | `defaults == current` (same pointer), any other valid params         | `ret=-2`                                                                | Aliasing not allowed                 |
| 8 | `defaults=NULL` or `current=NULL` or any out pointer `NULL`          | `ret=-1`                                                                | Invalid pointers                     |
| 9 | `tolerance=-1` or `n<0`                                              | `ret=-1`                                                                | Invalid parameters                   |

***