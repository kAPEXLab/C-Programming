# Tagged Union Telemetry Frame (Variant Payload with Summary)

**Title:** Process Variant Telemetry Using a Tagged Union (Sum/Length/Clamp)  
**Level:** Difficult  
**Concepts:** `struct` with **tag + union** (tagged union), safe variant handling via `switch` on enum, fixed‑size arrays in union members, validation, deterministic outputs

### Scenario

A device sends **telemetry frames** where the **payload type varies** per frame. To avoid dynamic allocation and keep a fixed footprint, each frame is a **tagged union**:

*   An **array** of integers,
*   A **scalar** `double`,
*   A **small text** message (C‑string) in a fixed‑length buffer.

You must write a function that **summarizes** any frame based on its tag:

*   For **INT\_ARRAY**: compute **sum** and **count**.
*   For **SCALAR**: **clamp** into `[min_allowed, max_allowed]` and report whether clamping happened.
*   For **TEXT**: compute **string length** (up to buffer size, stopping at `'\0'`), and report presence of **printable‑only** (ASCII 32..126).

### Problem Statement

Define a `struct` that contains a `tag` (`enum`) and a `union` with **three** payload shapes. Implement a function that, given a **const pointer** to a frame and some by‑value controls, fills a **summary struct** with results appropriate to the tag. The function must **validate** inputs and set outputs deterministically.

### Requirements

*   **Frame definition (suggested):**
    *   `enum FrameTag { FT_INT_ARRAY=0, FT_SCALAR=1, FT_TEXT=2 };`
    *   `struct Frame { enum FrameTag tag; union { struct { int data[8]; int count; } ints; double scalar; char text[32]; } payload; };`
        *   For `FT_INT_ARRAY`, use `payload.ints.count` in `[0..8]`.
        *   For `FT_TEXT`, treat `payload.text` as a C‑string up to 31 chars plus `'\0'`.
*   **Summary output (suggested):**
    *   `struct Summary { enum FrameTag tag; long sum; int count; double clamped_scalar; bool scalar_was_clamped; int text_len; bool text_all_printable; };`
*   **Function behavior per tag:**
    *   **INT\_ARRAY**: sum first `count` elements into a `long`; set `count`; ignore scalar/text fields.
    *   **SCALAR**: if `scalar < min_allowed` set to `min_allowed`; if `> max_allowed` set to `max_allowed`; report `scalar_was_clamped`.
    *   **TEXT**: compute length up to first `'\0'` or 31; test all characters are printable ASCII (32..126).
*   **Validation:**
    *   Pointers `frame`, `out_summary` must be non‑NULL.
    *   `frame->tag` must be a valid enum.
    *   For `FT_INT_ARRAY`, `0 ≤ count ≤ 8`.
    *   `min_allowed ≤ max_allowed`.
*   **No dynamic memory;** fixed sizes only.
*   **Time:** O(n) per case (n ≤ 8 for ints, n ≤ 31 for text).
*   **Space:** O(1).

### Function Details

*   **Name:** `summarize_frame`
*   **Arguments:**
    *   `const struct Frame *frame`
    *   `double min_allowed`
    *   `double max_allowed`
    *   `struct Summary *out_summary`
*   **Return Value:**  
    `int` — `0` on success; `-1` on invalid input (no output written).
*   **Description:**  
    Use a `switch (frame->tag)` to select the **active** union member and compute a tag‑appropriate summary. **Do not read** inactive union members. Validate ranges and inputs; on failure return `-1` without modifying `*out_summary`.

### Solution Approach

*   Validate `frame != NULL`, `out_summary != NULL`, `min_allowed ≤ max_allowed`.
*   Validate `frame->tag ∈ {FT_INT_ARRAY, FT_SCALAR, FT_TEXT}`.
*   Initialize all summary fields to safe defaults; set `summary.tag = frame->tag`.
*   **INT\_ARRAY**:
    *   Validate `0 ≤ count ≤ 8`.
    *   Accumulate `long sum` over `data[0..count-1]`; set `summary.sum=sum`, `summary.count=count`.
*   **SCALAR**:
    *   Let `x = frame->payload.scalar`; clamp into `[min_allowed, max_allowed]`; set `summary.clamped_scalar`, `summary.scalar_was_clamped`.
*   **TEXT**:
    *   Walk up to 31 characters or until `'\0'`; compute `len`.
    *   Check `32 ≤ ch ≤ 126` for each character to set `text_all_printable`.
    *   Set `summary.text_len=len` and `summary.text_all_printable`.
*   Write `*out_summary` and return `0`.

### Tasks to Perform

1.  Define `enum FrameTag` and the `struct Frame` with the union containing:
    *   `struct { int data[8]; int count; } ints;`
    *   `double scalar;`
    *   `char text[32];`
2.  Define `struct Summary` with fields listed above.
3.  Implement `summarize_frame`:
    *   Validate pointers and ranges (`min_allowed ≤ max_allowed`).
    *   Switch on `frame->tag` and process the matching union member.
    *   Fill only relevant summary fields; initialize others deterministically (e.g., zeros/false).
4.  Handle all error cases by returning `-1` without writing outputs.

### Test Cases

| #  | Inputs / Precondition                                            | Expected Output                                                         | Notes                                |
| -- | ---------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------ |
| 1  | `FT_INT_ARRAY, data=[1,2,3], count=3`                            | `ret=0, summary.tag=FT_INT_ARRAY, sum=6, count=3`                       | Simple sum                           |
| 2  | `FT_INT_ARRAY, data=[1000000]*8, count=8`                        | `ret=0, sum=8000000, count=8`                                           | Uses `long` to avoid overflow in sum |
| 3  | `FT_INT_ARRAY, count=9`                                          | `ret=-1`                                                                | Invalid count                        |
| 4  | `FT_SCALAR, scalar=42.0, min=0.0, max=100.0`                     | `ret=0, clamped_scalar=42.0, scalar_was_clamped=false`                  | In‑range                             |
| 5  | `FT_SCALAR, scalar=-10.0, min=0.0, max=5.0`                      | `ret=0, clamped_scalar=0.0, scalar_was_clamped=true`                    | Clamped low                          |
| 6  | `FT_SCALAR, scalar=7.5, min=8.0, max=5.0`                        | `ret=-1`                                                                | Invalid range (min>max)              |
| 7  | `FT_TEXT, text="HELLO", limits any`                              | `ret=0, text_len=5, text_all_printable=true`                            | Basic text                           |
| 8  | `FT_TEXT, text="Hi\x01" (non‑printable in first 31), limits any` | `ret=0, text_len=2 (stop at '\0' if present), text_all_printable=false` | Non‑printable present                |
| 9  | `frame=NULL` or `out_summary=NULL`                               | `ret=-1`                                                                | Invalid pointers                     |
| 10 | `tag=(enum FrameTag)99`                                          | `ret=-1`                                                                | Invalid tag                          |

***