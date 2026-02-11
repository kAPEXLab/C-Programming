# Append Message into a Dynamic Log Buffer with Max Capacity (grow/compact)

**Title:** Append C-String Message into a Growing Log with Hard Cap and Compaction

**Level:** Difficult  
**Concepts:** `malloc`/`realloc` growth, maximum capacity, compaction vs. growth policy, NUL‑termination, pointer arithmetic, error isolation, consistent state

### Scenario

You maintain a **single dynamic char buffer** that stores a **log** of messages separated by a delimiter (e.g., `'\n'`). The buffer should **grow** to accommodate new messages but **must not exceed** a configured **max capacity** (bytes). When there’s not enough space, your API should try to **compact** (drop the **oldest** messages from the beginning) to make room; if still insufficient and you’re below max, it should **grow** (up to max). If the message can’t fit even after compaction and growth (or the message itself is larger than max), the append should **fail without partial writes**.

### Problem Statement

Implement a function that appends a **null‑terminated** message (without its trailing `'\0'`) plus a **delimiter** into a dynamic buffer, while:

*   Preserving existing log data order,
*   Ensuring the resulting buffer is **NUL‑terminated** for convenient printing,
*   Never exceeding `max_capacity`,
*   Performing **compaction** (remove oldest prefix) before growth,
*   Growing via `realloc` using a **temporary** pointer to avoid leaks,
*   Leaving the buffer **unchanged** if the operation fails.

### Requirements

*   Allowed types only: `int`, `long`, `double`, `char`, `bool`, `enum`, plus pointers.
*   Inputs:
    *   `char **buf` — pointer to dynamic buffer (may be `NULL` if empty).
    *   `int *used` — number of valid bytes currently used **excluding** final NUL (≥ 0).
    *   `int *capacity` — current allocation size in bytes (≥ 0).
    *   `int max_capacity` — hard cap in bytes (> 0).
    *   `const char *msg` — NUL‑terminated message to append.
    *   `char delim` — delimiter to append after the message.
*   Behavior:
    *   Compute `msg_len` by scanning `msg` until `'\0'`.
    *   Required additional bytes = `msg_len + 1` (for delimiter). Buffer must also have space for a **final NUL** (1 more byte not counted in `*used`).
    *   If `msg_len + 1 > max_capacity`, **fail** (message too large).
    *   **Compaction** step (if `*used > 0`): remove oldest prefix to free space **only if** needed (e.g., drop from the start until enough room exists or log becomes empty). This is done by shifting remaining bytes down with a manual copy (no `memmove` assumed), then updating `*used`.
    *   If still insufficient and `*capacity < max_capacity`, **grow** capacity (e.g., double up to `max_capacity`), guarding against overflow; use **temp `realloc`** and commit only on success.
    *   After enough space is available: write `msg` bytes, then `delim`, update `*used`, and ensure `(*buf)[*used] = '\0'`.
*   Error handling:
    *   Invalid pointers/values → `-1` (no changes).
    *   Couldn’t make room (even after compaction/growth) → `-2` (no changes).
*   Return codes:
    *   `0` success; `-1` invalid args; `-2` insufficient space (and message not appended).

### Function Details

*   **Name:** `logbuf_append`
*   **Arguments:**
    *   `char **buf`
    *   `int *used`         // bytes in use (excludes trailing NUL)
    *   `int *capacity`     // total allocated bytes
    *   `int max_capacity`  // hard upper bound
    *   `const char *msg`   // NUL-terminated
    *   `char delim`
*   **Return Value:**  
    `int` — `0` on success; `-1` invalid input; `-2` cannot fit (after compaction/growth).
*   **Description:**  
    Appends `msg` and `delim` to a dynamic log, ensuring there is always one trailing `'\0'`. Attempts compaction first by dropping oldest bytes; then tries to grow (not exceeding `max_capacity`). Uses a **temporary** result from `realloc` to avoid leaks. On failure, nothing changes.

### Solution Approach

*   **Validate**: pointers non‑NULL; `*used ≥ 0`, `*capacity ≥ 0`, `max_capacity > 0`; `*used ≤ *capacity`.
*   **Measure** `msg_len` by scanning `msg` until `'\0'`.
*   **Reject** if `msg_len + 1 > max_capacity` (too large).
*   **Ensure space**: needed total free = `(msg_len + 1) + 1` (data + delim + final NUL) minus current free `(capacity - used)`.
*   **Compact if needed**:
    *   Compute `need = msg_len + 1` (without the final NUL; NUL sits at `used`).
    *   If `*used > 0` and not enough room, drop a prefix:
        *   Decide minimal prefix length to drop so that `new_used + need ≤ max_capacity - 1` (keeping space for final NUL).
        *   Shift remaining bytes down with a manual copy loop; update `*used`.
*   **Grow if needed**:
    *   If still not enough and `*capacity < max_capacity`:
        *   New capacity = min(max\_capacity, max( (\*capacity==0? 8 : \*capacity \* 2), \*used + need + 1 )) with overflow checks using `long`.
        *   `tmp = realloc(*buf, new_capacity)`, commit on success.
*   **Append**: copy `msg` bytes, then `delim`, update `*used`, write trailing `'\0'`.
*   **Return** with `0` on success; `-2` if space couldn’t be made.

### Tasks to Perform

1.  Validate arguments and invariants (`*used ≤ *capacity`, `max_capacity > 0`).
2.  Measure `msg_len`.
3.  If `msg_len + 1 > max_capacity`, return `-2`.
4.  Calculate **required free** (include space for trailing `'\0'`).
5.  If insufficient:
    *   **Compact** by removing minimal prefix; update `*used`.
    *   If still insufficient, **grow** via `realloc` up to `max_capacity` using a temporary pointer; commit on success.
6.  If space is now sufficient:
    *   Copy `msg`, then `delim`; `*used += msg_len + 1`; set `(*buf)[*used] = '\0'`.
7.  On any failure to make room, return `-2` without modifying the buffer or metadata.

### Test Cases

| # | Inputs / Precondition                                              | Expected Output                                                               | Notes                            |
| - | ------------------------------------------------------------------ | ----------------------------------------------------------------------------- | -------------------------------- |
| 1 | `*buf=NULL,*used=0,*capacity=0,max=32; msg="A", delim='\n'`        | `ret=0; capacity grows (e.g., 8); used=2; buf="A\n\0"`                        | First append allocates           |
| 2 | Append `"BC"` then `"DEF"` under `max=32`                          | `ret=0; buf="A\nBC\nDEF\n\0"; used=8`                                         | Normal growth path               |
| 3 | Small capacity near full; append small msg; compaction frees space | `ret=0; oldest bytes dropped; buf ends with only newest messages; NUL at end` | Compaction exercised             |
| 4 | `msg` length = `max_capacity` (no delimiter space)                 | `ret=-2; unchanged`                                                           | Too large: needs delimiter + NUL |
| 5 | `msg=""` (empty)                                                   | `ret=0; only delimiter appended; used += 1`                                   | Handles empty messages           |
| 6 | `*used > *capacity` or negative values                             | `ret=-1`                                                                      | Invalid invariants               |
| 7 | Growth hits `max_capacity` and still can’t fit after compaction    | `ret=-2; unchanged`                                                           | Hard cap respected               |
| 8 | Simulated `realloc` failure (conceptual)                           | `ret=-2; unchanged; no leaks`                                                 | Commit-after-success pattern     |

***