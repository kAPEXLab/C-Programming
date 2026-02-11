# Find Subsequence in a Byte Buffer Using Pointer Ranges

**Title:** First Occurrence of a Needle in a Buffer Slice (Pointer Range Scan)  
**Level:** Easy  
**Concepts:** Pointer ranges `[begin, end)`, pointer arithmetic (`p + k`, `end - p`), bounds checks, `const` correctness, output via pointer

### Scenario

You receive a raw **byte buffer** and a smaller **needle** sequence. You must search for the **first occurrence** of `needle` within a **slice** of the buffer delimited by pointers `[buf, buf + n)`. You are **not** allowed to read beyond the end pointer. No standard library calls—only **pointer arithmetic**.

### Problem Statement

Implement a function that returns a pointer to the **first byte** of the first occurrence of `needle` in the buffer slice, or `NULL` if not found. Also return the **offset** (0-based) from `buf` to the match (if found), via an output pointer.

### Requirements

*   Inputs:
    *   `const char *buf` — start of buffer slice
    *   `int n` — number of bytes in the slice (`n ≥ 0`)
    *   `const char *needle` — sequence to find
    *   `int m` — length of `needle` (`m > 0`)
*   Outputs:
    *   `char **out_ptr` — set to address of first match within `[buf, buf+n)`, or `NULL` if none
    *   `int *out_offset` — set to `match_ptr - buf` if found; otherwise `-1`
*   Use **only pointer arithmetic** and comparisons:
    *   Let `const char *p = buf; const char *end = buf + n;`
    *   For each candidate `p`, ensure you **never** read past `end`: only test `p` while `p + m <= end`.
*   Validation:
    *   If any pointer is `NULL`, or if `n < 0` or `m <= 0`, return `-1` and do **not** modify outputs.
*   Time: O((n − m + 1) \* m) naive scan; Space: O(1).
*   Do not modify input buffers.

### Function Details

*   **Name:** `find_subsequence_in_slice`
*   **Arguments:**
    *   `const char *buf`
    *   `int n`
    *   `const char *needle`
    *   `int m`
    *   `char **out_ptr`
    *   `int *out_offset`
*   **Return Value:**  
    `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    Scan `[buf, buf+n)` with pointer `p`. For each `p`, compare `needle[0..m-1]` against `p[0..m-1]` **only if** `p + m <= end`. On first match, set `*out_ptr = (char*)p; *out_offset = (int)(p - buf)` and return `0`. If not found, set `*out_ptr = NULL; *out_offset = -1;` and return `0`.

### Solution Approach

*   Validate pointers and lengths.
*   Compute `end = buf + n`.
*   For `p = buf; p + m <= end; p++`:
    *   Compare with a nested pointer `q = p` and `r = needle` advancing both while `*q == *r`.
    *   On full match, write outputs and return.
*   After loop, write `NULL`/`-1` outputs and return.

### Tasks to Perform

1.  Validate: `buf`, `needle`, `out_ptr`, `out_offset` non-`NULL`; `n ≥ 0`; `m > 0`.
2.  Set `const char *end = buf + n;`
3.  Loop: `for (const char *p = buf; p + m <= end; ++p)`:
    *   `const char *q = p; const char *r = needle;`
    *   While `r < needle + m` and `*q == *r`, advance `q`, `r`.
    *   If `r == needle + m` → found.
4.  On found: `*out_ptr = (char*)p; *out_offset = (int)(p - buf); return 0;`
5.  If not found: `*out_ptr = NULL; *out_offset = -1; return 0;`

### Test Cases

| # | Inputs / Precondition                  | Expected Output                          | Notes                           |
| - | -------------------------------------- | ---------------------------------------- | ------------------------------- |
| 1 | `buf="ABCDEF", n=6, needle="CDE", m=3` | `ret=0, *out_ptr=&buf[2], *out_offset=2` | Middle match                    |
| 2 | `buf="AAAAA", n=5, needle="AAA", m=3`  | `ret=0, *out_ptr=&buf[0], *out_offset=0` | Overlapping allowed; take first |
| 3 | `buf="ABCDE", n=5, needle="DEF", m=3`  | `ret=0, *out_ptr=NULL, *out_offset=-1`   | Not present                     |
| 4 | `buf="XYZ", n=3, needle="XYZ", m=3`    | `ret=0, *out_ptr=&buf[0], *out_offset=0` | Full-slice match                |
| 5 | `buf="HI", n=2, needle="HIK", m=3`     | `ret=0, *out_ptr=NULL, *out_offset=-1`   | `m > n` → no match              |
| 6 | `buf=NULL` or `needle=NULL`            | `ret=-1`                                 | Invalid pointers                |
| 7 | `n=-1` or `m<=0`                       | `ret=-1`                                 | Invalid lengths                 |

***