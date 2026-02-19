# Parse Records from a Byte Stream Until Delimiter or Limits

**Title:** Stream Parser with Delimiter, Field Length Limit, and Timeout (While Loop)  
**Level:** Difficult  
**Concepts:** `while` loop, loop invariants, `break`/`continue`, sentinel/termination conditions, counters, input validation, defensive programming

***

### Scenario

You receive bytes from a UART-like interface in chunks and must parse **records** delimited by a specific **terminator character** (e.g., `'\n'`). Each record is a sequence of printable bytes (not including the delimiter). You must accumulate bytes into an output buffer until you see the delimiter, **or** you hit a **maximum field length**, **or** a **timeout** (measured in number of bytes scanned without seeing a delimiter). The function must process **one record per call** using a `while` loop and report the parsing outcome.

***

### Problem Statement

Implement a function that scans a byte array `in[]` of length `n` from a given starting index and extracts **one record** into `out[]`, stopping when:

1.  The **delimiter** is found (successful parse),
2.  The **record length** would exceed `out_capacity`,
3.  The **scan** surpasses `max_scan_without_delim` bytes without encountering the delimiter,
4.  The input is **exhausted** (`index == n`).

Return a status via an enum and update the caller-visible index to the **next unread position**. The logic must be implemented using a `while` loop (no `for`), with `break`/`continue` as needed.

***

### Requirements

*   **Allowed types only:** `int`, `long`, `double`, `char`, `bool`, and `enum` (with pointers/arrays).
*   Inputs:
    *   `const char *in` — input byte array
    *   `int n` — number of available bytes in `in`
    *   `int *index` — in/out current scanning position (0 ≤ \*index ≤ n)
    *   `char delimiter` — record terminator (e.g., `'\n'`)
    *   `char *out` — destination buffer for one record (no delimiter copied)
    *   `int out_capacity` — capacity of `out` (≥ 1)
    *   `int max_scan_without_delim` — maximum number of bytes to scan before declaring timeout (≥ 0)
*   Behavior:
    *   Use a **`while` loop** that continues as long as `*index < n` and scanned bytes ≤ `max_scan_without_delim`.
    *   On each byte:
        *   If it equals `delimiter`: **stop successfully** (do not store delimiter), advance index past delimiter, write `*out_len` and status.
        *   Else if `out_len == out_capacity`: **stop with overflow status** (do not consume further input; index stays where it is for the overflowing byte).
        *   Else if the byte is **non-printable** (below space `' '` except `'\t'` and `'\r'`) or above `~` (0x7E), **skip** it using `continue` (do not count toward output, but does count toward scan/timeout).
        *   Else: store byte to `out[out_len++]`, increment `*index`, and continue.
    *   If bytes scanned exceeds `max_scan_without_delim` **before** a delimiter appears, stop with **timeout** status (index remains where it stopped scanning).
    *   If `*index == n` without seeing delimiter:
        *   If `out_len > 0`, status is **PARTIAL\_NO\_DELIM**.
        *   Otherwise, status is **NEED\_MORE\_DATA**.
*   Error handling:
    *   If any pointer is `NULL`, or if `n < 0`, `out_capacity <= 0`, `max_scan_without_delim < 0`, or `*index` out of `[0, n]`, return error `-1` without modifying outputs.

***

### Function Details

*   **Name:** `parse_record_while`
*   **Arguments:**
    *   `const char *in`
    *   `int n`
    *   `int *index`
    *   `char delimiter`
    *   `char *out`
    *   `int out_capacity`
    *   `int max_scan_without_delim`
    *   `int *out_len`          // number of bytes written to out (0..out\_capacity)
    *   `enum ParseStatus *out_status`
*   **Return Value:**
    *   `int` — `0` on success (status provided), `-1` on invalid input (no outputs modified).
*   **Description:**  
    Parse one delimited record from `in[*index..n)` using a **single `while` loop** with explicit checks and `break`/`continue`. Track a local `scanned` counter for timeout. Update `*index` only as you consume bytes; on delimiter success, advance past the delimiter.

**Suggested enum for status (for your implementation):**

```c
enum ParseStatus {
    PARSE_OK = 0,            // Delimiter found, record in out[0..out_len-1]
    PARSE_OVERFLOW = 1,      // Output capacity exceeded before delimiter
    PARSE_TIMEOUT = 2,       // Scanned too many bytes without finding delimiter
    PARSE_NEED_MORE = 3,     // Reached end with zero bytes collected
    PARSE_PARTIAL_NO_DELIM = 4 // Reached end with some bytes collected
};
```

***

### Solution Approach

*   Validate pointers and ranges; bail with `-1` if invalid.
*   Initialize locals: `int out_count = 0; int scanned = 0; int i = *index;`
*   **While loop condition:** `while (i < n && scanned <= max_scan_without_delim)`.
*   Fetch `char c = in[i];` then:
    *   If `c == delimiter`: set `*index = i + 1;` set `*out_len = out_count;` set `*out_status = PARSE_OK;` return `0`.
    *   If output full (`out_count == out_capacity`): set `*out_len = out_count; *out_status = PARSE_OVERFLOW;` **do not** advance `*index` (leave at `i`); return `0`.
    *   If `c` is non-printable (e.g., `< ' '` except `'\t'` and `'\r'`) or `c > '~'`: increment `i` and `scanned`; `continue;`
    *   Otherwise: `out[out_count++] = c; i++; scanned++;`
*   After loop:
    *   If `scanned > max_scan_without_delim`: set `*out_len = out_count; *out_status = PARSE_TIMEOUT; *index = i; return 0;`
    *   Else if `i == n`:
        *   If `out_count == 0`: `*out_status = PARSE_NEED_MORE;`
        *   Else: `*out_status = PARSE_PARTIAL_NO_DELIM;`
        *   `*out_len = out_count; *index = i; return 0;`

***

### Tasks to Perform

1.  **Validate inputs:**
    *   `in != NULL`, `index != NULL`, `out != NULL`, `out_len != NULL`, `out_status != NULL`
    *   `n >= 0`, `0 <= *index && *index <= n`
    *   `out_capacity > 0`, `max_scan_without_delim >= 0`
    *   On failure → return `-1` (no outputs modified)
2.  **Initialize locals:**
    *   `int out_count = 0;`
    *   `int scanned = 0;`
    *   `int i = *index;`
3.  **While loop:**
    *   Condition: `i < n && scanned <= max_scan_without_delim`
    *   Body:
        *   `char c = in[i];`
        *   If `c == delimiter`: success path (advance `i` by 1 for delimiter, update outputs, return).
        *   Else if `out_count == out_capacity`: overflow status (no `i` advance), update outputs, return.
        *   Else if `c` non-printable: `i++; scanned++; continue;`
        *   Else: `out[out_count++] = c; i++; scanned++;`
4.  **Post-loop handling:**
    *   If `scanned > max_scan_without_delim`: timeout status, `*index = i`, return.
    *   Else (end reached): choose `PARSE_NEED_MORE` or `PARSE_PARTIAL_NO_DELIM`, set `*out_len`, set `*index = i`, return.
5.  Ensure only one path writes the outputs and returns once.

***

### Test Cases

| # | Inputs / Precondition                                                  | Expected Output                                                            | Notes                                                           |
| - | ---------------------------------------------------------------------- | -------------------------------------------------------------------------- | --------------------------------------------------------------- |
| 1 | `in="ABC\nXYZ", n=7, *index=0, delim='\n', out_cap=8, max_scan=100`    | `ret=0, status=PARSE_OK, out="ABC", out_len=3, *index=4`                   | Delimiter found; index advanced past `\n`                       |
| 2 | `in="ABCD", n=4, *index=0, delim='\n', out_cap=3, max_scan=100`        | `ret=0, status=PARSE_OVERFLOW, out="ABC", out_len=3, *index=0`             | Overflow before delimiter; index not consumed past failing byte |
| 3 | `in="A\tB\rC\n", n=6, *index=0, delim='\n', out_cap=8, max_scan=100`   | `ret=0, status=PARSE_OK, out="A\tB\rC", out_len=5, *index=6`               | Tab/CR allowed as printable here                                |
| 4 | `in="\x01A\x7F\n", n=4, *index=0, delim='\n', out_cap=8, max_scan=100` | `ret=0, status=PARSE_OK, out="A", out_len=1, *index=4`                     | Skips 0x01 and 0x7F via `continue`                              |
| 5 | `in="ABCDEFGHI", n=9, *index=0, delim='\n', out_cap=8, max_scan=5`     | `ret=0, status=PARSE_TIMEOUT, out="ABCDE", out_len=5, *index=5`            | Timeout after 5 scanned without delimiter                       |
| 6 | `in="", n=0, *index=0, delim='\n', out_cap=8, max_scan=10`             | `ret=0, status=PARSE_NEED_MORE, out_len=0, *index=0`                       | No data available                                               |
| 7 | `in="PARTIAL", n=7, *index=0, delim='\n', out_cap=8, max_scan=100`     | `ret=0, status=PARSE_PARTIAL_NO_DELIM, out="PARTIAL", out_len=7, *index=7` | Reached end with partial record                                 |
| 8 | `index=NULL` or `out=NULL` or `out_status=NULL`                        | `ret=-1`                                                                   | Invalid pointers                                                |
| 9 | `n=-1` or `out_capacity<=0` or `max_scan<0` or `*index>n`              | `ret=-1`                                                                   | Invalid parameters                                              |


***
