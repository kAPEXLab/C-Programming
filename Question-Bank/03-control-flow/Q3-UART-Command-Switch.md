# UART Command Interpreter (switch-case with Guards)

**Title:** Interpret Single-Character UART Commands via `switch` (with Mode & Lock Guards)  
**Level:** Medium (focus on `switch`)  
**Concepts:** `switch` statement, enumerations, default handling, guard checks inside cases, deterministic branching, no fall-through

***

### Scenario

Your embedded device receives **single-character commands** over UART to control its behavior. The device can be in **normal mode** or **maintenance mode**, and it can be **locked** for safety. Depending on the incoming command and these mode/lock flags, the device must select an **action** or **reject** the request. You will implement the decision logic using a **`switch`** on the command.

***

### Problem Statement

Implement a function that interprets a **single ASCII command** and returns an **action enum** using a `switch`. The function should validate the command, apply **guards** for `maintenance_mode` and `locked`, ensure **no fall-through** between cases, and handle unknown commands in the `default` case. The output action must only be written on success.

***

### Requirements

*   **Allowed C types:** `int`, `long`, `double`, `char`, `bool`, and `enum` (and pointers/arrays of these).
*   **Commands (`char cmd`)**:
    *   `'S'` → **START**
    *   `'T'` → **STOP**
    *   `'R'` → **RESET**
    *   `'D'` → **DIAGNOSTICS**
    *   `'U'` → **UPDATE**
    *   `'Q'` → **SHUTDOWN**
*   **Guards / Policies:**
    *   If `locked == true`, only **STOP** (`'T'`) and **RESET** (`'R'`) are allowed; all others must be rejected.
    *   If `maintenance_mode == false`, **DIAGNOSTICS** (`'D'`) and **UPDATE** (`'U'`) are **not permitted**.
    *   **SHUTDOWN** (`'Q'`) is allowed only when `locked == false`.
*   **Outputs & return codes:**
    *   On success: write `*out_action` and return `0`.
    *   On error/violation: return a negative code and **do not modify** `*out_action`.
        *   `-1` → invalid output pointer
        *   `-2` → invalid/unknown command (default case)
        *   `-3` → disallowed by guards (mode/lock)
*   **No fall-through:** each `case` must end in `return` or `break` (recommend `return` on each path).
*   Input is a **single character**; no need to process strings.

***

### Function Details

*   **Name:** `interpret_uart_command`
*   **Arguments:**
    *   `char cmd` — incoming ASCII command (`'S','T','R','D','U','Q'`, or other)
    *   `bool maintenance_mode` — true when device is in maintenance
    *   `bool locked` — true when safety lock is engaged
    *   `enum Action *out_action` — output action
*   **Return Value:**
    *   `int` — `0` on success; `-1` invalid pointer; `-2` invalid command; `-3` disallowed by guards.
*   **Description:**  
    Use `switch (cmd)` with cases `'S','T','R','D','U','Q'`. In each case, apply **guard checks** using `if` statements **inside** the case, return `-3` when a guard blocks the action, otherwise set `*out_action` to the mapped enum and return `0`. For any other character, return `-2`. Never modify `*out_action` on any error return path.

**Suggested enum (for your implementation):**

```c
enum Action {
    ACT_NONE = 0,
    ACT_START = 1,
    ACT_STOP = 2,
    ACT_RESET = 3,
    ACT_DIAG = 4,
    ACT_UPDATE = 5,
    ACT_SHUTDOWN = 6
};
```

***

### Solution Approach

*   Validate `out_action != NULL` first; return `-1` if invalid.
*   `switch (cmd)`:
    *   For `'S'`: if `locked` → `-3`; else set `ACT_START`.
    *   For `'T'`: allowed even when `locked`; set `ACT_STOP`.
    *   For `'R'`: allowed even when `locked`; set `ACT_RESET`.
    *   For `'D'`: if `!maintenance_mode` → `-3`; if `locked` → `-3`; else set `ACT_DIAG`.
    *   For `'U'`: if `!maintenance_mode` → `-3`; if `locked` → `-3`; else set `ACT_UPDATE`.
    *   For `'Q'`: if `locked` → `-3`; else set `ACT_SHUTDOWN`.
    *   `default`: return `-2`.
*   Ensure each case returns immediately to avoid fall-through.
*   Do not write to `*out_action` on any error path.

***

### Tasks to Perform

1.  **Validate pointer:** If `out_action == NULL`, return `-1`.
2.  **Switch on `cmd`:**
    *   **Case 'S' (START):** If `locked` return `-3`; else `*out_action = ACT_START; return 0;`
    *   **Case 'T' (STOP):** `*out_action = ACT_STOP; return 0;`
    *   **Case 'R' (RESET):** `*out_action = ACT_RESET; return 0;`
    *   **Case 'D' (DIAGNOSTICS):** If `!maintenance_mode` return `-3`; if `locked` return `-3`; else `*out_action = ACT_DIAG; return 0;`
    *   **Case 'U' (UPDATE):** If `!maintenance_mode` return `-3`; if `locked` return `-3`; else `*out_action = ACT_UPDATE; return 0;`
    *   **Case 'Q' (SHUTDOWN):** If `locked` return `-3`; else `*out_action = ACT_SHUTDOWN; return 0;`
    *   **Default:** return `-2` (invalid/unknown command).
3.  **No writes on error:** On any negative return, ensure `*out_action` remains untouched.

***

### Test Cases

| #  | Inputs / Precondition                           | Expected Output                   | Notes                                   |
| -- | ----------------------------------------------- | --------------------------------- | --------------------------------------- |
| 1  | `cmd='S', maintenance_mode=false, locked=false` | `ret=0, *out_action=ACT_START`    | Normal start                            |
| 2  | `cmd='S', maintenance_mode=false, locked=true`  | `ret=-3`                          | Start blocked by lock                   |
| 3  | `cmd='T', maintenance_mode=false, locked=true`  | `ret=0, *out_action=ACT_STOP`     | Stop allowed under lock                 |
| 4  | `cmd='R', maintenance_mode=false, locked=true`  | `ret=0, *out_action=ACT_RESET`    | Reset allowed under lock                |
| 5  | `cmd='D', maintenance_mode=false, locked=false` | `ret=-3`                          | Diagnostics blocked outside maintenance |
| 6  | `cmd='D', maintenance_mode=true, locked=false`  | `ret=0, *out_action=ACT_DIAG`     | Diagnostics allowed in maintenance      |
| 7  | `cmd='U', maintenance_mode=true, locked=true`   | `ret=-3`                          | Update blocked by lock                  |
| 8  | `cmd='Q', maintenance_mode=false, locked=false` | `ret=0, *out_action=ACT_SHUTDOWN` | Shutdown allowed when unlocked          |
| 9  | `cmd='Q', maintenance_mode=false, locked=true`  | `ret=-3`                          | Shutdown blocked by lock                |
| 10 | `cmd='X', maintenance_mode=false, locked=false` | `ret=-2`                          | Unknown command                         |
| 11 | `out_action=NULL`                               | `ret=-1`                          | Invalid pointer                         |

***
