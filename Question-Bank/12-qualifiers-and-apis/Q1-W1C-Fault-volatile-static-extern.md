# W1C Fault Flag Handler with `volatile`, `const`, `static`, `extern`, and `typedef`

**Title:** Handle a Write‑1‑to‑Clear Fault Bit in a Memory‑Mapped Register  
**Level:** Easy  
**Concepts:** `volatile` (MMIO), `const` pointer parameters, `static` internal state, `extern` timebase, `typedef` for API clarity, simple API design

### Scenario

A device exposes a **status register** at a memory-mapped address. **Bit `fault_bit`** indicates a **fault** and is **W1C (write one to clear)**. You must implement a small API that:

*   **Reads** the volatile status register,
*   **Optionally clears** the fault bit using the W1C rule,
*   **Counts** how many times the fault was seen (across calls),
*   **Rate-limits** the clear operation to at most **once every `cooldown_ms`** using a global tick `extern long g_ms_tick`,
*   Returns a **code** describing what happened.

### Problem Statement

Design a function that inspects a **volatile** status register and, if the specified **fault bit is set**, may clear it according to a cooldown. The function should maintain an internal **static** counter of seen faults and expose it to the caller via an output pointer. Use `typedef` to define a small enum for return codes. `extern long g_ms_tick` provides milliseconds since boot.

### Requirements

*   Allowed types only.
*   Inputs:
    *   `volatile int *reg` — MMIO status register (readable/writable).
    *   `int fault_bit` — bit index `0..30` (bit `31` reserved).
    *   `bool allow_clear` — if `true`, perform W1C clear (subject to cooldown).
    *   `long cooldown_ms` — minimum gap between two clears (≥ 0).
*   **Global (provided by caller/environment):**
    *   `extern long g_ms_tick;` — monotonically non-decreasing time.
*   Outputs:
    *   `int *out_seen_count` — cumulative times a fault has been observed.
*   Return code (`typedef enum`):
    *   `RC_NOFAULT = 0` — bit not set
    *   `RC_SEEN_ONLY = 1` — bit was set, not cleared (cooldown/allow\_clear=false)
    *   `RC_CLEARED = 2` — bit was set and successfully cleared
    *   `RC_BAD_ARG = -1` — invalid inputs (no output writes)
*   Behavior:
    *   Read `*reg` **once**.
    *   If `fault_bit` out of range, or pointers null, return `RC_BAD_ARG`.
    *   If fault bit is set, increment **static** `seen_count` and attempt clear only if:
        *   `allow_clear == true` and
        *   `g_ms_tick - last_clear_ms ≥ cooldown_ms`.  
            Clearing uses **W1C**: write back a value with **only** `fault_bit` set to `1` (other bits must be `0` in the write).
    *   Update a **static** `last_clear_ms` for cooldown tracking.
    *   Always write the current `seen_count` to `*out_seen_count` on success.

### Function Details

*   **Name:** `handle_w1c_fault`
*   **Arguments:**
    *   `volatile int *reg`
    *   `int fault_bit`
    *   `bool allow_clear`
    *   `long cooldown_ms`
    *   `int *out_seen_count`
*   **Return Value:**
    *   `int` — One of `RC_*` values described above.
*   **Description:**  
    Uses `volatile` for MMIO safety; `const` is **not** appropriate for `reg` because we may write. Keeps internal state (`seen_count`, `last_clear_ms`) as `static` so state persists across calls. Uses an `extern long g_ms_tick` (declared elsewhere) for simple rate limiting.

### Solution Approach

*   Validate pointers and ranges.
*   Compute `mask = (1 << fault_bit)` using `int`.
*   Read `val = *reg;` and check `(val & mask)`.
*   If not set → `RC_NOFAULT`.
*   If set:
    *   Increment `static int seen_count`.
    *   If `allow_clear` and cooldown satisfied, **write** `*reg = mask;` (W1C) and set `last_clear_ms = g_ms_tick`; return `RC_CLEARED`.
    *   Else return `RC_SEEN_ONLY`.
*   On success write `*out_seen_count = seen_count`.

### Tasks to Perform

1.  Define `typedef enum { RC_NOFAULT=0, RC_SEEN_ONLY=1, RC_CLEARED=2, RC_BAD_ARG=-1 } RetCode;`.
2.  Declare `extern long g_ms_tick;` in your module (defined elsewhere).
3.  Implement `handle_w1c_fault` with **static** `int seen_count` and **static** `long last_clear_ms`.
4.  Validate args: `reg != NULL`, `out_seen_count != NULL`, `0 ≤ fault_bit ≤ 30`, `cooldown_ms ≥ 0`.
5.  Perform logic per “Solution Approach”.
6.  Return appropriate `RetCode`.

### Test Cases

| # | Inputs / Precondition                                                  | Expected Output                            | Notes                 |
| - | ---------------------------------------------------------------------- | ------------------------------------------ | --------------------- |
| 1 | `*reg=0x00, fault_bit=3, allow_clear=true, cooldown_ms=0, g_ms_tick=0` | `ret=RC_NOFAULT, seen=0`                   | No fault              |
| 2 | `*reg=0x08 (bit3), allow_clear=false`                                  | `ret=RC_SEEN_ONLY, seen=1, *reg unchanged` | Clear not allowed     |
| 3 | `*reg=0x08, allow_clear=true, cooldown_ms=0, g_ms_tick=100`            | `ret=RC_CLEARED, seen=2, write *reg=0x08`  | W1C write clears bit3 |
| 4 | Fault again immediately with `cooldown_ms=50, g_ms_tick=120`           | `ret=RC_SEEN_ONLY, seen=3`                 | Cooldown blocks clear |
| 5 | Later `g_ms_tick=180` (≥ 50ms gap), bit set                            | `ret=RC_CLEARED, seen=4`                   | Cooldown satisfied    |
| 6 | `reg=NULL` or `out_seen_count=NULL` or `fault_bit=31`                  | `ret=RC_BAD_ARG`                           | Invalid args          |

***