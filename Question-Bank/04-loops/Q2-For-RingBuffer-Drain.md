# Drain a Circular Buffer Snapshot into a Linear Array

**Title:** Drain Snapshot of Ring Buffer to Linear Array
**Level:** Difficult  
**Concepts:** `for` loop with multiple control variables, modular arithmetic (wrap-around), bounds/snapshot safety, early termination, input validation, edge cases (empty/full indistinguishability), no dynamic memory

***

### Scenario

You have a **lock-free producer** writing bytes into a **circular buffer (ring buffer)** of fixed capacity. The consumer runs on another context and must copy out up to `max_to_copy` bytes. To avoid race conditions, the consumer is given a **consistent snapshot** of the buffer state: `read_index_snapshot` and `write_index_snapshot` (both in `[0, capacity)`), captured atomically by the producer before calling you.

Your job: **drain** up to `max_to_copy` bytes starting at `read_index_snapshot`, **wrapping** when reaching the end of the buffer, and **stop** when you reach `write_index_snapshot` or when you have copied `max_to_copy` bytes—**whichever happens first**.

All copying must be done using a **single `for` loop** (no `while`), showcasing advanced `for` control with **multiple loop variables** and **modulo wrap-around**.

***

### Problem Statement

Implement a function that copies bytes from a circular buffer (`buf`, `capacity`) into a linear output array (`out`) using **one `for` loop**. The copying begins at `read_index_snapshot` and proceeds forward (index + 1 modulo `capacity`) until either:

*   you have copied `max_to_copy` bytes, **or**
*   you reach `write_index_snapshot` (meaning there are no more bytes available in the snapshot).

The function must **not write past** the `out` array (the caller ensures `out` has room for `max_to_copy` bytes). Return how many bytes were copied via `*out_count`. Handle invalid inputs robustly.

***

### Requirements

*   **Allowed C types only:** `int`, `long`, `double`, `char`, `bool`, and `enum` (plus pointers/arrays).
*   Parameters:
    *   `buf` — circular buffer of bytes.
    *   `capacity` — buffer size, **must be > 0**.
    *   `read_index_snapshot` — starting index in `[0, capacity)`.
    *   `write_index_snapshot` — stop index in `[0, capacity)`.
    *   `max_to_copy` — maximum number of bytes to copy, **≥ 0**.
    *   `out` — destination linear array.
    *   `out_count` — outputs number of bytes copied.
*   Logic:
    *   Use **one `for` loop** with **two control variables**: a **linear counter** `i` and a **ring index** `idx`.
    *   Loop condition must check **both**: remaining quota (`i < max_to_copy`) **and** availability (`idx != write_index_snapshot`).
    *   On each iteration: `out[i] = buf[idx];` then advance both: `i++` and `idx = (idx + 1) % capacity`.
    *   No extra dynamic memory; O(1) extra space; O(k) time where `k = min(available, max_to_copy)`.
*   Validation (return `-1` on error and **do not modify** outputs):
    *   Pointers `buf`, `out`, `out_count` must be non-null.
    *   `capacity > 0`, `max_to_copy ≥ 0`.
    *   `0 ≤ read_index_snapshot < capacity`, `0 ≤ write_index_snapshot < capacity`.

***

### Function Details

*   **Name:** `drain_ring_snapshot`
*   **Arguments:**
    *   `const char *buf`
    *   `int capacity`
    *   `int read_index_snapshot`
    *   `int write_index_snapshot`
    *   `int max_to_copy`
    *   `char *out`
    *   `int *out_count`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    Copies up to `max_to_copy` bytes from the snapshot range `[read_index_snapshot … write_index_snapshot)` on the ring (wrapping by modulo) into `out` using **a single `for` loop**.
    The loop **terminates** when either quota is exhausted or the producer’s **write snapshot** is reached.

***

### Solution Approach

*   **Validate inputs** carefully; bail out with `-1` on any invalid argument and avoid writing outputs.
*   **Initialize** `i = 0` and `idx = read_index_snapshot`.
*   Use a **single `for` loop** that:
    *   Checks both **quota** (`i < max_to_copy`) and **availability** (`idx != write_index_snapshot`) in the loop condition.
    *   Advances `idx` with **modular arithmetic** to wrap at `capacity`.
*   On exit, write `*out_count = i` and return `0`.
*   **Corner cases** handled naturally:
    *   **Empty snapshot**: when `read_index_snapshot == write_index_snapshot`, zero bytes copied.
    *   **Full quota zero**: when `max_to_copy == 0`, zero bytes copied.
    *   **Wrap-around**: when `idx` reaches `capacity - 1`, next index becomes `0` via modulo.

***

### Tasks to Perform

1.  Validate:
    *   `buf != NULL`, `out != NULL`, `out_count != NULL`
    *   `capacity > 0`, `max_to_copy >= 0`
    *   `0 ≤ read_index_snapshot < capacity`, `0 ≤ write_index_snapshot < capacity`
    *   If any check fails → `return -1` (do not touch outputs).
2.  Initialize local variables:
    *   `int i = 0;`
    *   `int idx = read_index_snapshot;`
3.  Run a **single `for` loop**
4.  After the loop:
    *   `*out_count = i;`
    *   `return 0;`

***

### Test Cases

| #  | Inputs / Precondition                                 | Expected Output                   | Notes                                       |
| -- | ----------------------------------------------------- | --------------------------------- | ------------------------------------------- |
| 1  | `capacity=8, buf="ABCDEFGH", read=2, write=6, max=10` | `ret=0, *out_count=4, out="CDEF"` | No wrap; stops at write snapshot            |
| 2  | `capacity=8, buf="ABCDEFGH", read=6, write=2, max=10` | `ret=0, *out_count=4, out="GHAB"` | Wrap-around path (6→7→0→1)                  |
| 3  | `capacity=8, buf="ABCDEFGH", read=3, write=3, max=5`  | `ret=0, *out_count=0`             | Empty snapshot (read == write)              |
| 4  | `capacity=8, buf="ABCDEFGH", read=1, write=5, max=2`  | `ret=0, *out_count=2, out="BC"`   | Quota-limited (2 < available 4)             |
| 5  | `capacity=8, buf="ABCDEFGH", read=7, write=0, max=5`  | `ret=0, *out_count=1, out="H"`    | Single element available (wrap at 7→0 stop) |
| 6  | `capacity=8, buf="ABCDEFGH", read=0, write=5, max=0`  | `ret=0, *out_count=0`             | Zero quota                                  |
| 7  | `capacity=1, buf="X", read=0, write=0, max=3`         | `ret=0, *out_count=0`             | Empty snapshot in 1-slot ring               |
| 8  | `capacity=8, read=8 (invalid), write=0, max=3`        | `ret=-1`                          | Index out of range                          |
| 9  | `capacity=0 (invalid), read=0, write=0, max=3`        | `ret=-1`                          | Invalid capacity                            |
| 10 | `buf=NULL`                                            | `ret=-1`                          | Invalid pointer                             |