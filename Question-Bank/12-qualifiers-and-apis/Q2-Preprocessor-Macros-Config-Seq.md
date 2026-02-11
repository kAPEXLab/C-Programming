# Safe Register Macros (`#define`) + Config Function Using Them

**Title:** Implement and Use Safe Bit Macros for a Configuration Sequence  
**Level:** Difficult  
**Concepts:** Preprocessor macros, `do { … } while(0)` pattern, side‑effect safety guidance, compile‑time guards, conditional compilation, API design that consumes macros

### Scenario

You must configure a device by manipulating **bitfields** in **three volatile registers**:

*   `CTRL` (control), `STAT` (status), `CFG` (configuration).
*   The sequence is:
    1.  **Set** `CTRL.EN` (bit 0).
    2.  **Poll** `STAT.RDY` (bit 7) until it becomes `1`, with a **max attempts** limit.
    3.  **Write** a 3‑bit field `CFG.MODE` (bits `[5:3]`) with a requested `mode` in `0..7`.
    4.  **Clear** `STAT.INT` (bit 6) using **W1C** (write 1 to bit 6 only).
*   You must implement **macros** to:
    *   Get/set/clear bits safely for **volatile int** registers,
    *   Prepare/extract a **field** `[hi:lo]`,
    *   Provide an **assert-like** compile-time guard when `MODE_MAX < 7` (build-time policy),
    *   Optional logging enabled by `#define ENABLE_CFG_LOG 1`.

Then implement a function `device_configure` that **uses** these macros to perform the sequence robustly, with timeouts and return codes.

### Problem Statement

Write a set of macros and a function that together perform a safe register configuration, avoiding common macro pitfalls (accidental multiple evaluation, lack of scoping, missing parentheses). The macros must be **parenthesized**, use `do { … } while (0)` for statement-like forms, and document that **arguments should be free of side effects** (since pure C macros cannot guarantee single evaluation without extensions).

### Requirements

*   Allowed C types only; registers are `volatile int*`.
*   Define the following macros (names fixed; implementers fill bodies):
    *   **Bit/Mask helpers**
        *   `BIT(b)` → `(1 << (b))`
        *   `BMASK(hi, lo)` → mask covering bits `[hi..lo]` (assume `hi >= lo` and both in `0..30`)
    *   **Register operations** *(statement-like; need `do{...}while(0)`)*
        *   `SET_BITS(reg_ptr, mask)` → `*reg_ptr |= mask;`
        *   `CLR_BITS(reg_ptr, mask)` → `*reg_ptr &= ~(mask);`
        *   `W1C_BITS(reg_ptr, mask)` → `*reg_ptr = (mask);` *(write-1-to-clear)*
    *   **Field helpers**
        *   `FIELD_PREP(hi, lo, val)` → put `val` into position `[hi..lo]` (value masked to field width)
        *   `FIELD_GET(hi, lo, word)` → extract field `[hi..lo]` from `word`
    *   **Compile-time guard** (no extensions): use an `enum` trick so that if a condition fails, a **negative array size** occurs:
        *   `ENUM_ASSERT(name, cond)` → `enum { name = 1/(int)(!!(cond)) };`
            *   *Usage example:* `ENUM_ASSERT(MODE_RANGE_OK, (MODE_MAX >= 7));`
*   Optional logging macro:
    *   If `ENABLE_CFG_LOG` is defined and non-zero, expand `CFG_LOG(msg)` to a call `cfg_log(msg)`; else expand to empty. `cfg_log` is **provided by caller**.
*   **Function to implement (uses macros):**
    *   **Name:** `device_configure`
    *   **Args:**
        *   `volatile int *CTRL, *STAT, *CFG`
        *   `int mode` (requested `0..7`)
        *   `int max_attempts` (≥ 0)
    *   **Return code enum (`typedef`)**:
        *   `DC_OK = 0`, `DC_BAD_ARG = -1`, `DC_TIMEOUT = -2`
    *   **Behavior:**
        1.  Validate pointers, `mode` range, and `max_attempts ≥ 0`.
        2.  `SET_BITS(CTRL, BIT(0));` (enable)
        3.  Poll `STAT` until `STAT & BIT(7)` is set or attempts exhausted.
        4.  If ready, write `CFG` field `[5:3]` with `mode`:
            *   Read `tmp = *CFG;`
            *   Clear the field: `tmp &= ~BMASK(5,3);`
            *   OR-in `FIELD_PREP(5,3, mode)`
            *   Write `*CFG = tmp;`
        5.  `W1C_BITS(STAT, BIT(6));` to clear interrupt.
        6.  Return `DC_OK`; on timeout return `DC_TIMEOUT`; on invalid args `DC_BAD_ARG`.

### Function Details

*   **Name:** `device_configure`
*   **Arguments:**
    *   `volatile int *CTRL`
    *   `volatile int *STAT`
    *   `volatile int *CFG`
    *   `int mode`
    *   `int max_attempts`
*   **Return Value:**
    *   `int` — one of `DC_OK`, `DC_BAD_ARG`, `DC_TIMEOUT`.
*   **Description:**  
    Demonstrates **macro design** (parentheses, statement-like forms, compile-time guards, conditional logging) and safe **usage** with `volatile` registers and explicit read‑modify‑write for a bitfield.

### Solution Approach

*   **Macro design guidance:**
    *   **Always** parenthesize parameters and the whole macro value: e.g., `#define BIT(b) (1 << (b))`.
    *   For statement-like macros, wrap body in `do { ... } while (0)` to ensure they behave like a single statement in any context.
    *   For value macros that combine expressions (e.g., `FIELD_PREP`), document that arguments **must be side-effect free**.
    *   Provide a compile-time guard (`ENUM_ASSERT`) to enforce build-time invariants without non-standard extensions.
    *   Use `#if defined(ENABLE_CFG_LOG) && (ENABLE_CFG_LOG)` to conditionally compile logging.
*   **Function flow:**
    *   Validate inputs; return `DC_BAD_ARG` on failure.
    *   Enable, then busy-wait with a counter (`attempts++`) until ready bit set or `attempts == max_attempts`.
    *   Program the field using `FIELD_PREP` and `BMASK`.
    *   Clear the interrupt using `W1C_BITS`.
    *   Return `DC_OK` on success; `DC_TIMEOUT` if ready bit never set.

### Tasks to Perform

1.  Define helper macros: `BIT`, `BMASK`, `FIELD_PREP`, `FIELD_GET` with full parentheses.
2.  Define statement-like macros: `SET_BITS`, `CLR_BITS`, `W1C_BITS` with `do{...}while(0)`.
3.  Define `ENUM_ASSERT(name, cond)` as specified; use it to assert `MODE_MAX >= 7` (you define `#define MODE_MAX 7` or higher).
4.  Define `CFG_LOG(msg)` with conditional compilation around `ENABLE_CFG_LOG`.
5.  `typedef enum { DC_OK=0, DC_BAD_ARG=-1, DC_TIMEOUT=-2 } DC_Ret;`
6.  Implement `device_configure` per the behavior steps.
7.  Document in comments that macro arguments should avoid side effects (e.g., no `*p++` inside).

### Test Cases

| # | Inputs / Precondition                                                                                | Expected Output                                                | Notes                           |
| - | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | ------------------------------- |
| 1 | `CTRL=0, STAT=0, CFG=0; mode=3; max_attempts=0`                                                      | `ret=DC_TIMEOUT; CTRL bit0 set; STAT unchanged; CFG unchanged` | No attempts → immediate timeout |
| 2 | Ready immediately: `STAT` already has bit7 set                                                       | `ret=DC_OK; CFG[5:3]=3; STAT W1C bit6 written`                 | Field programmed, INT cleared   |
| 3 | Ready after 3 polls: `STAT` transitions to set on 3rd read                                           | `ret=DC_OK`                                                    | Poll loop works with limit      |
| 4 | `mode=8` or negative                                                                                 | `ret=DC_BAD_ARG`                                               | Out-of-range mode               |
| 5 | `CTRL=NULL` or `STAT=NULL` or `CFG=NULL`                                                             | `ret=DC_BAD_ARG`                                               | Invalid pointers                |
| 6 | Field preservation: preset other `CFG` bits; after configure only `[5:3]` changed                    | `ret=DC_OK`                                                    | RMW correctness                 |
| 7 | With `#define ENABLE_CFG_LOG 1`, verify `cfg_log("...")` is called along steps (manually/in harness) | `ret=DC_OK`                                                    | Conditional macro compiled in   |

***