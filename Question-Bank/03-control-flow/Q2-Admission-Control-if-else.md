## Admission Control with Rate Limits, Min‑Gap, Cooldown and Maintenance

**Level:** Difficult  
**Concepts:** `if/else` chains, priority ordering of guards, boundary handling, integer comparisons, state carried via pointers, deterministic side effects

***

### Scenario

You are building a lightweight **admission controller** for a device interface that receives incoming **requests** (e.g., keypad or UART-triggered operations). The system must **accept** or **reject** each request based on:

*   A **fixed time window** rate limit (max N accepts per window),
*   A **minimum gap** between consecutive accepts,
*   A **cooldown period** that activates after a rate-limit breach,
*   A **maintenance mode** that blocks normal traffic unless an **emergency override** is set.

All logic must be expressed using **`if/else`** only (no `switch`), and state must be maintained across calls using pointer arguments.

***

### Problem Statement

Implement a function that, given the current timestamp and controller state, decides whether to **ACCEPT** or **REJECT** the request. The function must:

1.  Enforce **priority** among checks (maintenance → cooldown → min-gap → window limit).
2.  Update state **only** when inputs are valid.
3.  Return a **decision** (`0=REJECT`, `1=ACCEPT`) and a **reason** (enum) via output parameters.

***

### Requirements

*   **Allowed C types only:** `int`, `long`, `double`, `char`, `bool`, and `enum` (including pointers/arrays of these).
*   **Inputs:**
    *   `now_ms` — current time in milliseconds (monotonic, `now_ms >= 0`).
    *   `*window_start_ms` — start time of the **current** fixed window (ms, non-negative).
    *   `window_ms` — size of the window (ms, **must be > 0**).
    *   `max_in_window` — maximum accepts per window (**must be ≥ 1**).
    *   `min_gap_ms` — minimum time between **accepts** (ms, **≥ 0**).
    *   `cooldown_ms` — duration of cooldown after a rate-limit breach (ms, **≥ 0**).
    *   `*last_accept_ms` — timestamp of last **accepted** request, or `-1` if none.
    *   `*cooldown_until_ms` — if `now_ms < *cooldown_until_ms`, system is in cooldown; else not. Initialize to `0` for “no cooldown”.
    *   `*count_in_window` — number of **accepted** requests in the current window (≥ 0).
    *   `maintenance_mode` — if `true`, normal traffic must be blocked.
    *   `emergency_override` — if `true`, bypass maintenance block and proceed with other checks.
    *   `*out_decision` — `0=REJECT`, `1=ACCEPT`.
    *   `*out_reason` — reason enum (see below).
*   **Priority of checks (highest → lowest):**
    1.  **Maintenance:**
        *   If `maintenance_mode == true` and `emergency_override == false` → **REJECT** (`REASON_MAINTENANCE`).
    2.  **Cooldown:**
        *   If `now_ms < *cooldown_until_ms` → **REJECT** (`REASON_COOLDOWN`).
    3.  **Minimum gap from last ACCEPT:**
        *   If `*last_accept_ms >= 0` **and** `now_ms - *last_accept_ms < min_gap_ms` → **REJECT** (`REASON_MIN_GAP`).
    4.  **Windowed rate limit:**
        *   If `now_ms >= *window_start_ms + window_ms`, **roll** to a new window:  
            `*window_start_ms = now_ms; *count_in_window = 0;`
        *   If `*count_in_window >= max_in_window` → **REJECT** (`REASON_WINDOW_LIMIT`) **and set** `*cooldown_until_ms = now_ms + cooldown_ms` (one-shot cooldown).
    5.  **Otherwise ACCEPT:**
        *   Set `*last_accept_ms = now_ms; ++(*count_in_window); *out_decision = 1; *out_reason = REASON_ACCEPTED`.
*   **Validation:**
    *   All pointer arguments must be non-null.
    *   `window_ms > 0`, `max_in_window ≥ 1`, `min_gap_ms ≥ 0`, `cooldown_ms ≥ 0`, `now_ms ≥ 0`.
    *   `*window_start_ms ≥ 0`, `*count_in_window ≥ 0`.
    *   `now_ms` should be **monotonic** (assume non-decreasing; if obviously inconsistent, return error).
    *   On **invalid input**, return error and **do not modify** any outputs.
*   **Return codes:**
    *   `0` on success (decision provided).
    *   `-1` on invalid arguments (no outputs modified).

***

### Function Details

*   **Name:** `decide_admission`
*   **Arguments:**
    *   `long now_ms`
    *   `long *window_start_ms`
    *   `int window_ms`
    *   `int max_in_window`
    *   `long min_gap_ms`
    *   `long cooldown_ms`
    *   `long *last_accept_ms`
    *   `long *cooldown_until_ms`
    *   `int *count_in_window`
    *   `bool maintenance_mode`
    *   `bool emergency_override`
    *   `int *out_decision`      // 0=REJECT, 1=ACCEPT
    *   `enum AdmissionReason *out_reason`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    Implements a **deterministic** `if/else` chain that:
    *   Applies **maintenance guard** first (unless overridden).
    *   Enforces **cooldown** window.
    *   Respects **minimum inter-accept gap**.
    *   Maintains a **fixed-size window** for counting accepts; rolling the window when expired.
    *   Triggers **cooldown** on rate-limit breach.
    *   Updates state **only** after input validation; does not modify outputs on error.  
        The function never uses `switch`; all branching is via `if/else`.

***

### Solution Approach

*   **Validate** all pointers and numeric parameters first; check non-negative times and proper bounds.
*   **Normalize window**: if the window has expired (`now_ms ≥ *window_start_ms + window_ms`), start a **new window** and reset the counter.
*   Apply guards in the exact **priority order** specified using a single `if/else-if/...` ladder so only **one** reason determines the outcome.
*   On **REJECT** for window limit, set `*cooldown_until_ms = now_ms + cooldown_ms` (bounded by long range assumptions).
*   On **ACCEPT**, update `*last_accept_ms` and increment `*count_in_window`.
*   Always write **both** outputs (`*out_decision`, `*out_reason`) on success; never write them on error.

***

### Tasks to Perform

1.  **Validate inputs:**
    *   Check all pointers: `window_start_ms`, `last_accept_ms`, `cooldown_until_ms`, `count_in_window`, `out_decision`, `out_reason` are **not NULL**.
    *   Check numeric constraints:  
        `now_ms ≥ 0`, `*window_start_ms ≥ 0`, `window_ms > 0`, `max_in_window ≥ 1`, `min_gap_ms ≥ 0`, `cooldown_ms ≥ 0`, `*count_in_window ≥ 0`.  
        If any invalid → **return `-1`**.
2.  **Maintenance guard:**
    *   If `maintenance_mode && !emergency_override` → set decision to **REJECT** with `REASON_MAINTENANCE`.
3.  **Cooldown guard:**
    *   Else if `now_ms < *cooldown_until_ms` → **REJECT** with `REASON_COOLDOWN`.
4.  **Minimum gap guard:**
    *   Else if `*last_accept_ms >= 0` and `(now_ms - *last_accept_ms) < min_gap_ms` → **REJECT** with `REASON_MIN_GAP`.
5.  **Window handling:**
    *   If `now_ms >= *window_start_ms + window_ms` → roll window:  
        `*window_start_ms = now_ms; *count_in_window = 0;`
    *   If `*count_in_window >= max_in_window` → **REJECT** with `REASON_WINDOW_LIMIT` and set `*cooldown_until_ms = now_ms + cooldown_ms`.
6.  **Accept path:**
    *   Otherwise **ACCEPT**:  
        `*last_accept_ms = now_ms; (*count_in_window)++;`  
        decision = `1`, reason = `REASON_ACCEPTED`.
7.  **Write outputs & return:**
    *   On success, write `*out_decision` and `*out_reason`; **return `0`**.
    *   On any invalid input (Step 1), **do not modify outputs**; **return `-1`**.

***

### Test Cases

| #  | Inputs / Precondition                                                                                                                                     | Expected Output                                                                                                               | Notes                                              |
| -- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| 1  | `now=1000, window_start=1000, window_ms=10000, max=3, min_gap=500, cooldown=3000, last_accept=-1, cooldown_until=0, count=0, maint=false, override=false` | `ret=0, decision=1, reason=REASON_ACCEPTED; updates: last_accept=1000, count=1`                                               | First request in new window                        |
| 2  | Same as #1 but `now=1200 (200ms later)`                                                                                                                   | `ret=0, decision=0, reason=REASON_MIN_GAP; no state increments`                                                               | Violates `min_gap=500`                             |
| 3  | After #1, `now=1700 (700ms later)`                                                                                                                        | `ret=0, decision=1, reason=REASON_ACCEPTED; count=2, last_accept=1700`                                                        | Satisfies min-gap                                  |
| 4  | After #3, `now=2300 (600ms later)`                                                                                                                        | `ret=0, decision=1, reason=REASON_ACCEPTED; count=3, last_accept=2300`                                                        | Hits window quota (=3)                             |
| 5  | After #4, `now=2400`                                                                                                                                      | `ret=0, decision=0, reason=REASON_WINDOW_LIMIT; cooldown_until=2400+3000=5400`                                                | Exceeds window quota; cooldown starts              |
| 6  | During cooldown `now=5300 (<5400)`                                                                                                                        | `ret=0, decision=0, reason=REASON_COOLDOWN`                                                                                   | Cooldown active                                    |
| 7  | Cooldown ends `now=5400 (==5400)`                                                                                                                         | `ret=0, decision=0 or 1 depending on min-gap/window` → Here: window still 1000–10999 with `count=3`, so `REASON_WINDOW_LIMIT` | At boundary: not in cooldown, but still at quota   |
| 8  | New window rolls `now=11000 (>=1000+10000)`                                                                                                               | `ret=0, decision=1, reason=REASON_ACCEPTED; window_start=11000, count=1, last_accept=11000`                                   | Window reset, accept allowed                       |
| 9  | Maintenance block `maint=true, override=false, now=12000`                                                                                                 | `ret=0, decision=0, reason=REASON_MAINTENANCE`                                                                                | Maintenance has highest priority                   |
| 10 | Emergency override `maint=true, override=true, now=12550`                                                                                                 | Proceed to next guards; if `now - last_accept < min_gap` then `REASON_MIN_GAP`, else accept                                   | Override bypasses maintenance but not other guards |
| 11 | Invalid args: `window_ms=0` or any NULL pointer                                                                                                           | `ret=-1`                                                                                                                      | No outputs modified                                |

**Enum suggestion for reasons (for your implementation):**  
`enum AdmissionReason { REASON_ACCEPTED=0, REASON_MAINTENANCE=1, REASON_COOLDOWN=2, REASON_MIN_GAP=3, REASON_WINDOW_LIMIT=4 };`

***