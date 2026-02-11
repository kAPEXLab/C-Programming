# Count Lines in a Text File with Filters (LF/CRLF Safe)

**Title:** Count Text Lines with Optional Blank/Comment Filters  
**Level:** Easy  
**Concepts:** Text File I/O (`fopen`, `fgets`, `fclose`), newline handling (`\n`, `\r\n`), line trimming, input validation, error codes

### Scenario

You need a utility that counts how many **lines** a text file has, with options to **ignore blank lines** and **ignore comment lines** (lines whose first non-space character is `#`). The file may contain **LF** (`\n`) or **CRLF** (`\r\n`) newlines. You must not load the entire file into memory—process line by line.

### Problem Statement

Implement a function that opens a file by path, reads it line by line, and returns the **total line count** after applying the chosen filters. It must be robust to mixed `\n`/`\r\n` endings and very long lines (by reading them in chunks and treating a logical line as continuing until a newline is encountered).

### Requirements

*   Allowed types only: `int`, `long`, `double`, `char`, `bool`, `enum`.
*   Inputs:
    *   `const char *path` — file path.
    *   `bool ignore_blank` — skip lines that are blank or only spaces/tabs.
    *   `bool ignore_comment_hash` — skip lines where the first non-space is `#`.
*   Outputs:
    *   `int *out_count` — number of lines **after filtering**.
*   Behavior:
    *   Open file with `"rb"` (binary) to handle `\r\n` safely; parse text manually.
    *   Treat a **logical line** as bytes up to `\n`. Strip a trailing `\r` if present before checks.
    *   If `ignore_blank`, a line with only spaces or tabs is skipped.
    *   If `ignore_comment_hash`, a line whose first non-space char is `#` is skipped.
    *   Count every other logical line.
*   Error handling:
    *   On `NULL` pointers or open/read errors, return `-1` and **do not modify** outputs.
*   Performance: O(file size), fixed-size buffer (e.g., 4 KB), no dynamic allocation required.

### Function Details

*   **Name:** `count_lines_filtered`
*   **Arguments:**
    *   `const char *path`
    *   `bool ignore_blank`
    *   `bool ignore_comment_hash`
    *   `int *out_count`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input or I/O failure.
*   **Description:**  
    Open the file; read in chunks, constructing logical lines (accumulate until `\n`). For each logical line, trim a single trailing `\r` if present, then decide whether to count it based on `ignore_blank`/`ignore_comment_hash`. Close the file before returning.

### Solution Approach

*   Validate pointers.
*   `FILE *f = fopen(path, "rb");` on failure → `-1`.
*   Use a small buffer (e.g., `char buf[4096];`) and a secondary “line” buffer to accumulate until newline.
*   For each logical line:
    *   Remove final `\r` if preceded by `\n`.
    *   Check blank/comment rules.
    *   Increment count if not filtered.
*   Set `*out_count` and return `0`. Ensure `fclose(f)` on all paths.

### Tasks to Perform

1.  Validate `path` and `out_count` are not `NULL`.
2.  Open file with `"rb"`. Handle failure.
3.  Stream-read and assemble logical lines until EOF.
4.  For each line:
    *   Strip trailing `\r` if present.
    *   If `ignore_blank`, skip lines with only spaces/tabs.
    *   If `ignore_comment_hash`, skip lines whose first non-space is `#`.
    *   Otherwise, increment count.
5.  Close the file and set `*out_count`.
6.  Return `0` on success; `-1` on any error (without writing outputs).

### Test Cases

| # | Inputs / Precondition                                                              | Expected Output                       | Notes                          |
| - | ---------------------------------------------------------------------------------- | ------------------------------------- | ------------------------------ |
| 1 | File: `"A\nB\nC\n"`; `ignore_blank=false`, `ignore_comment_hash=false`             | `ret=0, *out_count=3`                 | Plain LF                       |
| 2 | File: `"A\r\n\r\n#x\r\nB\r\n"`; `ignore_blank=true`, `ignore_comment_hash=true`    | `ret=0, *out_count=2`                 | Skip blank and `#x`; CRLF safe |
| 3 | File: `"   # comment\n data \n"`; `ignore_blank=false`, `ignore_comment_hash=true` | `ret=0, *out_count=1`                 | Leading spaces before `#`      |
| 4 | File contains very long lines (>4 KB)                                              | `ret=0, count reflects logical lines` | Accumulates line across chunks |
| 5 | Non-existent path                                                                  | `ret=-1`                              | Open failure                   |
| 6 | `out_count=NULL`                                                                   | `ret=-1`                              | Invalid pointer                |

***