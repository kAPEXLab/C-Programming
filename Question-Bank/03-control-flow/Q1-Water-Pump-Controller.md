# Water Pump Controller with Safety & Hysteresis
 
**Level:** Easy  
**Concepts:** `if/else` chains, condition ordering, guard conditions, hysteresis, clamping, boolean logic

***

### Scenario

A domestic water tank uses a pump to maintain water level. The controller decides whether to **start** or **stop** the pump based on the **tank level percentage** and **safety flags**. To avoid frequent toggling, the system applies **hysteresis** (different thresholds for ON and OFF). Manual overrides must take precedence, and any safety fault must **force stop** the pump.

***

### Problem Statement

Implement a function that computes the **next pump command** (start/stop) using **if/else** logic, considering safety, manual overrides, current tank level, and pump’s current state. The function should enforce hysteresis and produce a deterministic result.

***

### Requirements

*   Allowed C types only: `int`, `long`, `double`, `char`, `bool`, and `enum` (and their pointers/arrays).
*   Inputs:
    *   `level_pct` — current tank level in percent (0–100, but function should handle out-of-range gracefully via clamping).
    *   `pump_running` — current pump state (`true` if currently ON).
    *   `manual_on` — user requests pump **ON** (momentary).
    *   `manual_off` — user requests pump **OFF** (momentary).
    *   `leak` — leak detected (`true` forces pump OFF).
    *   `overcurrent` — electrical fault (`true` forces pump OFF).
*   Hysteresis policy:
    *   **Turn ON** when `level_pct <= 25`.
    *   **Turn OFF** when `level_pct >= 80`.
    *   If between 26–79%, **keep current state** unless overridden or faulted.
*   Priority (highest to lowest):
    1.  **Safety**: if `leak` or `overcurrent` → **force STOP**.
    2.  **Manual OFF**: if `manual_off` → **STOP**.
    3.  **Manual ON**: if `manual_on` and **no safety fault** → **START**.
    4.  **Hysteresis**: apply thresholds to decide **START/STOP**.
    5.  Otherwise, **hold** the current state.
*   Output:
    *   `*out_cmd = 1` to **START** pump, `*out_cmd = 0` to **STOP** pump.
*   Validation:
    *   `out_cmd` must be non-null; return error and **do not modify** it if invalid.
    *   Clamp `level_pct` into `[0, 100]` before logic.

***

### Function Details

*   **Name:** `decide_pump_command`
*   **Arguments:**
    *   `int level_pct`
    *   `bool pump_running`
    *   `bool manual_on`
    *   `bool manual_off`
    *   `bool leak`
    *   `bool overcurrent`
    *   `int *out_cmd`  // 0=STOP, 1=START
*   **Return Value:**
    *   `int` — `0` on success; `-1` if `out_cmd == NULL`.
*   **Description:**  
    The function enforces **if/else** evaluation in a clear priority order:
    1.  Check safety; 2) Manual OFF; 3) Manual ON; 4) Hysteresis; 5) Hold state.  
        `level_pct` is clamped to `[0,100]`. Hysteresis avoids chatter by using different ON/OFF thresholds.

***

### Solution Approach

*   Validate `out_cmd != NULL`; return `-1` otherwise.
*   Clamp `level_pct` to `[0, 100]`.
*   Apply **strict priority** using a linear `if/else` chain:
    *   If `leak || overcurrent` → `STOP`.
    *   Else if `manual_off` → `STOP`.
    *   Else if `manual_on` → `START`.
    *   Else if `level_pct <= 25` → `START`.
    *   Else if `level_pct >= 80` → `STOP`.
    *   Else → hold current state: `START` if `pump_running`, otherwise `STOP`.
*   Write the final command to `*out_cmd` and return `0`.

***

### Tasks to Perform

1.  If `out_cmd == NULL`, return `-1` immediately (do not write output).
2.  Clamp input:
    *   If `level_pct < 0` set to `0`; if `level_pct > 100` set to `100`.
3.  Apply priority-driven `if/else` logic:
    *   Safety first: if `leak || overcurrent` → `*out_cmd = 0; return 0;`
    *   Manual OFF next: if `manual_off` → `*out_cmd = 0; return 0;`
    *   Manual ON next: if `manual_on` → `*out_cmd = 1; return 0;`
    *   Hysteresis:
        *   if `level_pct <= 25` → `*out_cmd = 1; return 0;`
        *   else if `level_pct >= 80` → `*out_cmd = 0; return 0;`
    *   Else hold: `*out_cmd = pump_running ? 1 : 0; return 0;`
4.  Ensure only one path writes output and returns.

***

### Test Cases

| #  | Inputs / Precondition                                                                                 | Expected Output     | Notes                                      |
| -- | ----------------------------------------------------------------------------------------------------- | ------------------- | ------------------------------------------ |
| 1  | `level_pct=15, pump_running=false, manual_on=false, manual_off=false, leak=false, overcurrent=false`  | `ret=0, *out_cmd=1` | Below ON threshold → START                 |
| 2  | `level_pct=85, pump_running=true, manual_on=false, manual_off=false, leak=false, overcurrent=false`   | `ret=0, *out_cmd=0` | Above OFF threshold → STOP                 |
| 3  | `level_pct=50, pump_running=true, manual_on=false, manual_off=false, leak=false, overcurrent=false`   | `ret=0, *out_cmd=1` | Mid-band → hold current (running)          |
| 4  | `level_pct=50, pump_running=false, manual_on=false, manual_off=false, leak=false, overcurrent=false`  | `ret=0, *out_cmd=0` | Mid-band → hold current (stopped)          |
| 5  | `level_pct=40, pump_running=false, manual_on=true, manual_off=false, leak=false, overcurrent=false`   | `ret=0, *out_cmd=1` | Manual ON overrides mid-band               |
| 6  | `level_pct=10, pump_running=true, manual_on=false, manual_off=true, leak=false, overcurrent=false`    | `ret=0, *out_cmd=0` | Manual OFF overrides low level             |
| 7  | `level_pct=70, pump_running=true, manual_on=false, manual_off=false, leak=true, overcurrent=false`    | `ret=0, *out_cmd=0` | Safety fault forces STOP                   |
| 8  | `level_pct=120, pump_running=false, manual_on=false, manual_off=false, leak=false, overcurrent=false` | `ret=0, *out_cmd=0` | Level clamped to 100 → STOP via hysteresis |
| 9  | `level_pct=-5, pump_running=false, manual_on=false, manual_off=false, leak=false, overcurrent=false`  | `ret=0, *out_cmd=1` | Level clamped to 0 → START via hysteresis  |
| 10 | `out_cmd=NULL`                                                                                        | `ret=-1`            | Invalid pointer (no output written)        |
