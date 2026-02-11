# Safe Bounded Copy from Read-Only String (with Optional Case Transform)

**Title:** Safe String Copy Using `const char*` (Optional Lowercase Transform)  
**Level:** Easy  
**Concepts:** Function parameters by value, `const` pointer to input, output via pointer, buffer capacity/terminator handling, input validation

### Scenario

Your device receives text labels from firmware as **read-only** strings. You must **copy** a label into a caller-provided buffer, ensuring **no writes** to the source string, **null-termination**, and **no overflow**. Optionally, the caller can request **lowercasing** of ASCII letters during the copy.

### Problem Statement

Implement a function that copies from `src` (read-only) to `dst` with a capacity `dst_capacity`. The function must:

*   Copy at most **`dst_capacity - 1`** characters,
*   Always **null-terminate** `dst` when `dst_capacity > 0`,
*   Optionally **lowercase** ASCII `A–Z` to `a–z` in the copied data if `to_lower == true`,
*   Report how many characters were **actually copied** (excluding the terminator) and whether truncation occurred.

### Requirements

*   **Inputs:**
    *   `const char *src` — **must not** be modified.
    *   `char *dst` — writable destination buffer.
    *   `int dst_capacity` — capacity in bytes (`dst_capacity >= 0`).
    *   `bool to_lower` — by-value flag; the function must not depend on modifying it.
*   **Outputs:**
    *   `int *out_copied` — number of bytes copied (0 if `dst_capacity == 0`).
    *   `bool *out_truncated` — `true` if source did not fully fit.
*   **Rules:**
    *   If any pointer is `NULL` or `dst_capacity < 0`, return error **without modifying** outputs.
    *   If `dst_capacity == 0`, do not write to `dst`, but still validate other inputs and compute results accordingly (`*out_copied=0`, truncation depends on `src` length > 0).
    *   Treat `src` as a C-string ending at the first `'\0'`.
    *   Implement ASCII lowercasing **without** `<ctype.h>`: if `'A' <= ch <= 'Z'`, then `ch = ch + ('a' - 'A')`.

### Function Details

*   **Name:** `safe_copy_label`
*   **Arguments:**
    *   `const char *src`
    *   `char *dst`
    *   `int dst_capacity`
    *   `bool to_lower`
    *   `int *out_copied`
    *   `bool *out_truncated`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    Perform a bounded copy from **read-only** `src` to writable `dst`. The `src` parameter is a **const pointer** to ensure the function does not (and cannot) modify source data. `to_lower` is passed **by value**; changes inside the function must not affect the caller’s flag.

### Solution Approach

*   Validate all pointers; check `dst_capacity >= 0`.
*   Compute the length to copy: `limit = max(0, dst_capacity - 1)`.
*   Iterate over `src` until `'\0'` or `i == limit`: copy char to `dst` (lowercase if requested).
*   If `dst_capacity > 0`, write terminator `'\0'` at the end.
*   Set `*out_copied = number_of_chars_written` and `*out_truncated = (src_has_more_chars)`.
*   Return `0`.

### Tasks to Perform

1.  Validate: `src`, `dst`, `out_copied`, `out_truncated` are not `NULL`; `dst_capacity >= 0`.
2.  Determine `limit = (dst_capacity > 0) ? (dst_capacity - 1) : 0`.
3.  Copy up to `limit` chars; if `to_lower==true`, fold ASCII `A–Z` to `a–z`.
4.  If `dst_capacity > 0`, null-terminate `dst`.
5.  Set outputs (`*out_copied`, `*out_truncated`) and return `0`.
6.  On invalid input, return `-1` and **do not** modify outputs.

### Test Cases

| # | Inputs / Precondition                         | Expected Output                                 | Notes                                 |
| - | --------------------------------------------- | ----------------------------------------------- | ------------------------------------- |
| 1 | `src="Hello", dst_cap=10, to_lower=false`     | `ret=0, copied=5, truncated=false, dst="Hello"` | Normal copy                           |
| 2 | `src="Hello", dst_cap=6, to_lower=true`       | `ret=0, copied=5, truncated=false, dst="hello"` | Exact fit (5 + NUL)                   |
| 3 | `src="FirmwareV1", dst_cap=5, to_lower=false` | `ret=0, copied=4, truncated=true, dst="Firm"`   | Truncation                            |
| 4 | `src="", dst_cap=3, to_lower=true`            | `ret=0, copied=0, truncated=false, dst=""`      | Empty source                          |
| 5 | `src="ABC", dst_cap=0`                        | `ret=0, copied=0, truncated=true`               | No space to write; compute truncation |
| 6 | `src=NULL` or `dst=NULL`                      | `ret=-1`                                        | Invalid pointers                      |
| 7 | `dst_cap=-1`                                  | `ret=-1`                                        | Invalid capacity                      |

***