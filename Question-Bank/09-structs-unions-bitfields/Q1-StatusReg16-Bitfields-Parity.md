# Compose a 16‑bit Status Register with Bit‑Fields and Even Parity

**Title:** Pack Device Status into a 16‑bit Register (Bit‑Fields + Parity)  
**Level:** Easy  
**Concepts:** Struct with bit‑fields, packing/validation, parity computation, range checks, input validation

### Scenario

An embedded peripheral exposes a **16‑bit status register**. Some bits are individual flags, others encode small integers. The top bit enforces **even parity** over the lower 15 bits to detect single‑bit errors. You need to **build** a correct register value from inputs and validate argument ranges.

### Problem Statement

Design and specify a function that **packs** discrete status inputs into a **16‑bit integer** as per the layout below and **computes even parity** for bit 15. The function must **validate** inputs and return an error if any field is out of range.

**Register layout (bit 15 is MSB, bit 0 is LSB):**

    [15] PAR   [14:12] RETRIES   [11:10] MODE   [9] READY   [8] BUSY   [7] FAULT   [6:1] RSV   [0] RSV

*   `PAR` — parity bit (even parity over bits 0..14).
*   `RETRIES` — 3‑bit value (0..7).
*   `MODE` — 2‑bit value from enum (0..3).
*   `READY`, `BUSY`, `FAULT` — single‑bit flags (`0`/`1`).
*   `RSV` — reserved, must be `0`.

### Requirements

*   Use a **bit‑field struct** for clarity (members’ widths must sum to 16).
*   Do not rely on implementation‑defined struct layout to produce the final integer; **explicitly pack** with shifts and masks to ensure portability.
*   Inputs:
    *   `mode` in `{0,1,2,3}` (use an `enum`).
    *   `retries` in `[0..7]`.
    *   `ready`, `busy`, `fault` in `{false,true}`.
*   Outputs:
    *   `*out_reg16` — the complete 16‑bit status value in an `int` (lower 16 bits significant).
*   Parity: compute **even parity** of bits 0..14 and place the result into bit 15 so the **total number of 1s** in bits 0..15 is **even**.
*   Validation: on any invalid input or null output pointer, return error without modifying output.

### Function Details

*   **Name:** `build_status_reg16`
*   **Arguments:**
    *   `enum Mode mode`  // `MODE0=0, MODE1=1, MODE2=2, MODE3=3`
    *   `int retries`     // 0..7
    *   `bool ready`
    *   `bool busy`
    *   `bool fault`
    *   `int *out_reg16`
*   **Return Value:**  
    `int` — `0` on success; `-1` on invalid input (no output written).
*   **Description:**  
    Compose bits as:
        reg = 0;
        reg |= (retries & 0x7) << 12;
        reg |= (mode & 0x3) << 10;
        reg |= (ready ? 1 : 0) << 9;
        reg |= (busy  ? 1 : 0) << 8;
        reg |= (fault ? 1 : 0) << 7;
        // reserved bits remain 0
        // compute even parity over bits 0..14, place into bit 15
    The **bit‑field struct** (with `int` widths) documents the layout, but final packing must use shifts to avoid implementation‑defined layout and padding issues.

### Solution Approach

*   Validate `out_reg16 != NULL`, `0 ≤ retries ≤ 7`, `mode ∈ {0,1,2,3}`.
*   Build the 15 lower bits via shifts and ORs.
*   Compute even parity for bits 0..14 (e.g., xor‑fold then mask `& 1`), set bit 15 accordingly.
*   Write result to `*out_reg16`.

### Tasks to Perform

1.  Define `enum Mode { MODE0=0, MODE1=1, MODE2=2, MODE3=3 };`.
2.  (For documentation) Define a `struct StatusBits` with `int` bit‑fields whose widths sum to 16, matching the map.
3.  Implement packing using **shifts/masks**, not by casting the struct.
4.  Compute **even parity** over bits 0..14 and set bit 15.
5.  Validate ranges and pointer; return `-1` on invalid input (no write).
6.  On success, store the 16‑bit value into `*out_reg16` and return `0`.

### Test Cases

| # | Inputs / Precondition                                         | Expected Output                                                                           | Notes                                        |
| - | ------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------- |
| 1 | `mode=MODE0, retries=0, ready=false, busy=false, fault=false` | `ret=0, reg16 has only parity bit possibly set`                                           | Parity depends on zeros: even parity → PAR=0 |
| 2 | `mode=MODE3, retries=7, ready=true, busy=true, fault=true`    | `ret=0, reg16 bits [14:12]=111, [11:10]=11, [9]=1, [8]=1, [7]=1, PAR set for even parity` | Dense case                                   |
| 3 | `mode=MODE1, retries=5, ready=true, busy=false, fault=false`  | `ret=0, correct fields packed, PAR adjusted`                                              | Mixed flags                                  |
| 4 | `retries=-1`                                                  | `ret=-1`                                                                                  | Invalid range                                |
| 5 | `mode=(enum Mode)4`                                           | `ret=-1`                                                                                  | Invalid enum                                 |
| 6 | `out_reg16=NULL`                                              | `ret=-1`                                                                                  | Invalid pointer                              |

***