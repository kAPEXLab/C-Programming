# In-Place Tokenization with Pointers (Trim Spaces, Skip Empties)

**Title:** Tokenize a Mutable C-String In-Place Using Two Pointers  
**Level:** Difficult  
**Concepts:** Pointer traversal, read/write pointers, in-place modification (`'\0'` insertion), pointer difference, trimming via pointer arithmetic, output list of `char*`

### Scenario

You receive a **mutable C-string** containing comma-separated values, possibly with **extra spaces** and **consecutive delimiters**. You must **split** the string into tokens **in-place** (by writing `'\0'` terminators), **trim spaces** around each token, **skip empty tokens**, and return an array of **pointers** to the tokens. No dynamic allocation; only pointer arithmetic.

### Problem Statement

Implement a function that:

1.  Takes a **writable** null-terminated string `s`,
2.  Splits on a single-character delimiter `delim`,
3.  Trims **leading and trailing spaces** (`' '`) from each token,
4.  Skips **empty tokens** (after trimming),
5.  Stores up to `max_tokens` pointers to tokens into `out_tokens[]`,
6.  Returns the **number of tokens** found via `*out_count` and a **truncation flag** if more tokens existed than capacity.

All work must be done **in-place** using **two-pointer** logic; no library calls.

### Requirements

*   Inputs:
    *   `char *s` — mutable, **null-terminated** input string; will be modified.
    *   `char delim` — delimiter character (e.g., `','`).
    *   `char **out_tokens` — array to store pointers to token starts.
    *   `int max_tokens` — capacity of `out_tokens` (`max_tokens ≥ 0`).
*   Outputs:
    *   `int *out_count` — number of stored tokens (`0..max_tokens`).
    *   `bool *out_truncated` — `true` if more tokens existed than stored.
*   Behavior:
    *   Use pointer variables: `char *read`, `*write`, `*token_start`, and `*p`.
    *   Replace delimiter(s) with `'\0'` **after** trimming each token.
    *   **Trim** spaces: advance token start over leading spaces; and for trailing spaces, **backtrack** from last character to the last non-space, then write `'\0'`.
    *   **Skip** tokens that become empty after trimming.
*   Validation:
    *   On any `NULL` pointer or `max_tokens < 0`, return `-1` without modifying outputs.
*   Time: O(L) where L is length of `s`; Space: O(1) extra (besides `out_tokens`).
*   Note: Only ASCII space `' '` is treated as whitespace in this problem.

### Function Details

*   **Name:** `tokenize_in_place`
*   **Arguments:**
    *   `char *s`
    *   `char delim`
    *   `char **out_tokens`
    *   `int max_tokens`
    *   `int *out_count`
    *   `bool *out_truncated`
*   **Return Value:**  
    `int` — `0` on success; `-1` on invalid input.
*   **Description:**  
    Walk the string with a **read pointer** to find token boundaries and a **write pointer** to place characters. When a delimiter is hit or the string ends, **trim trailing spaces** by moving a pointer backward to the last non-space, place `'\0'`, and if the token is non-empty, record its start pointer into `out_tokens` (provided there is capacity). Multiple adjacent delimiters collapse to zero or one stored token depending on content (empties are skipped).

### Solution Approach

*   Validate inputs.
*   Initialize: `read = s; write = s; count = 0; truncated = false;`
*   While `true`:
    *   **Skip leading spaces before token:** advance `read` while `*read == ' '`.
    *   Set `token_start = write;`
    *   **Copy until delimiter or `'\0'`:** while `*read != delim` and `*read != '\0'`, write `*write++ = *read++;`
    *   **Trim trailing spaces:** set `p = write - 1`; while `p >= token_start && *p == ' '`, `p--;`
    *   **Terminate token:** set `write = p + 1; *write = '\0';`
    *   **Record token if non-empty:** if `write > token_start`, then if `count < max_tokens` set `out_tokens[count++] = token_start;` else set `truncated = true;`
    *   If `*read == '\0'` → break; otherwise (`*read == delim`) advance `read++` and set `write++` to start next token (we’ll overwrite next chars).
*   After loop: set `*out_count = count; *out_truncated = truncated; return 0;`

### Tasks to Perform

1.  Validate: `s`, `out_tokens`, `out_count`, `out_truncated` non-`NULL`; `max_tokens ≥ 0`.
2.  Initialize `char *read = s; char *write = s; int count = 0; bool truncated = false;`
3.  Loop over tokens separated by `delim`:
    *   Skip leading spaces: advance `read`.
    *   `token_start = write;`
    *   Copy chars until `delim` or `'\0'` to `write` (advance both).
    *   Trim trailing spaces using a backtracking pointer `p`.
    *   Terminate with `'\0'` and (if non-empty) store pointer if capacity allows; otherwise set truncated flag.
    *   If at `'\0'`, break; else advance past delimiter and prepare for next token (`write++` to leave room for the next token).
4.  On exit: write outputs and return `0`.
5.  On invalid input: return `-1` without modifying outputs.

### Test Cases

| # | Inputs / Precondition                                    | Expected Output                                                                                                    | Notes                                                |
| - | -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| 1 | `s="  alpha, beta , , gamma  ", delim=',', max_tokens=5` | `ret=0, out_tokens → {"alpha","beta","gamma"}, out_count=3, truncated=false; s becomes `"alpha\0beta\0\0gamma\0"\` | Leading/trailing spaces trimmed; empty token skipped |
| 2 | `s="a,b,c", delim=',', max_tokens=2`                     | `ret=0, out_tokens → {"a","b"}, out_count=2, truncated=true`                                                       | Capacity limit sets truncated flag                   |
| 3 | `s="  ,  ,  ", delim=',', max_tokens=4`                  | `ret=0, out_count=0, truncated=false`                                                                              | All tokens empty after trimming                      |
| 4 | `s="one", delim=';', max_tokens=3`                       | `ret=0, out_tokens → {"one"}, out_count=1, truncated=false`                                                        | No delimiters present                                |
| 5 | `s="" (empty)`, any `delim`, max\_tokens=3               | `ret=0, out_count=0, truncated=false`                                                                              | Empty string                                         |
| 6 | `s=NULL` or `out_tokens=NULL` or `out_count=NULL`        | `ret=-1`                                                                                                           | Invalid pointers                                     |
| 7 | `max_tokens=-1`                                          | `ret=-1`                                                                                                           | Invalid capacity                                     |

***