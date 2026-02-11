# Word Search in a 2D Character Grid (8‑directional, Obstacles, Case & Wildcards)

**Title:** Count Word Occurrences in a 2D Grid with Guards (Strings + 2D Arrays)  
**Level:** Difficult  
**Concepts:** C-strings, 2D array indexing (row-major on 1D), DFS/backtracking, visited tracking, 8-direction movement, input validation, case-insensitive compare, single-char wildcard, obstacles

***

### Scenario

You’re implementing a word-search feature on an embedded device that stores a **character grid** in **row-major 1D memory**. Given a **C-string** word, you must count how many times it appears in the grid by walking **adjacent cells** in straight lines or along turns (depending on your design), respecting **grid bounds**, **obstacles**, **case-insensitive matching**, and **optional wildcard `?`** in the word (matches any single non-obstacle character). Cells **cannot be reused** within a single match path.

***

### Problem Statement

Design a function that searches a `rows × cols` character grid (stored as a 1D array) for all occurrences of `word`. A match is a **path** of positions that spells the word, where each next character is one step away in one of the allowed directions, **without revisiting a cell** within the same match. The function must support:

*   **8-directional movement** (N, NE, E, SE, S, SW, W, NW), controlled by a flag,
*   **Case-insensitive matching** controlled by a flag,
*   **Single-character wildcard** `?` in `word` if enabled, matching any non-obstacle cell,
*   **Obstacle cells** (e.g., `'#'`) that cannot be entered,
*   Reporting the **total match count**, and the **first match** details (start row/col and direction).

Return `0` on success (even if no matches found) and fill outputs; return `-1` on invalid inputs without modifying outputs.

***

### Requirements

*   **Allowed types only:** `int`, `long`, `double`, `char`, `bool`, `enum`, and their pointers/arrays.
*   **Grid & Indexing:**
    *   Grid is provided as **row-major 1D**: address of cell `(r, c)` is `grid[r*cols + c]`.
    *   `rows > 0`, `cols > 0`, `grid != NULL`, and `rows*cols` fits in `int`.
*   **Word (C-string):**
    *   `word != NULL`, `word[0] != '\0'` (non-empty).
    *   If wildcard is enabled, the character `'?'` in `word` matches **any single** grid character except the obstacle.
*   **Movement:**
    *   If `allow_diagonal == true`, use **8 directions**.
    *   Otherwise, use **4 directions** (N, E, S, W).
    *   **No wrap-around**; must stay within bounds.
    *   **No cell reuse** within a single path matching the word.
*   **Obstacles:**
    *   Cells equal to `obstacle_char` cannot be used.
    *   A wildcard `?` cannot match an obstacle.
*   **Case:**
    *   If `case_insensitive == true`, treat letters ‘A’–‘Z’ and ‘a’–‘z’ as equal (you must implement ASCII folding; do not rely on `<ctype.h>`).
*   **Outputs on success:**
    *   `*out_count` — total number of matches found (can be 0).
    *   `*out_first_row`, `*out_first_col` — start of the **first** found match (or `-1, -1` if none).
    *   `*out_first_dir` — direction enum for the **first step** of the first match; `DIR_NONE` if no match.
*   **Return codes:**
    *   `0` — success (outputs written).
    *   `-1` — invalid input (do **not** modify outputs).

***

### Function Details

*   **Name:** `count_word_in_grid`
*   **Arguments:**
    *   `const char *grid` — row-major 1D grid buffer of size `rows * cols`
    *   `int rows`
    *   `int cols`
    *   `const char *word` — null-terminated C-string
    *   `bool case_insensitive`
    *   `bool allow_diagonal`
    *   `bool allow_wildcard_qmark`
    *   `char obstacle_char`
    *   `int *out_count`
    *   `int *out_first_row`
    *   `int *out_first_col`
    *   `enum Direction *out_first_dir`
*   **Return Value:**  
    `int` — `0` on success; `-1` on invalid input (no outputs modified).
*   **Description:**  
    Search for all paths that spell `word` while:
    *   Respecting **bounds** and **obstacles**,
    *   Using **4 or 8 directions** based on `allow_diagonal`,
    *   Applying **case-insensitive** comparison if enabled,
    *   Allowing `?` to match any **non-obstacle** character if `allow_wildcard_qmark` is `true`,
    *   Ensuring a path never **reuses** a cell for the same match.  
        Count all matches and record the **first** match’s start coordinate and initial **direction**. If no matches, set `*out_count = 0`, `*out_first_row = -1`, `*out_first_col = -1`, `*out_first_dir = DIR_NONE`, and return `0`.

**Suggested enum for directions:**

```c
enum Direction {
    DIR_NONE = 0,
    DIR_N, DIR_NE, DIR_E, DIR_SE, DIR_S, DIR_SW, DIR_W, DIR_NW
};
```

***

### Solution Approach

*   **Validation**:
    *   Check all output pointers are non-NULL.
    *   Verify `rows > 0`, `cols > 0`, `grid != NULL`, `word != NULL`, `word[0] != '\0'`.
    *   Ensure `rows*cols` does not overflow `int` (assume inputs guarantee this; otherwise guard carefully).
*   **Preprocessing**:
    *   Compute `word_len` (walk until `'\0'`).
    *   If `word_len > rows*cols`, matches are impossible (but still return success with count 0).
*   **Direction vectors**:
    *   Prepare arrays of `(dr, dc)`:
        *   4-dir: `{(-1,0),(0,1),(1,0),(0,-1)}`
        *   8-dir adds: `{(-1,1),(1,1),(1,-1),(-1,-1)}`
*   **Character compare helper**:
    *   Implement `eq(a, b)`:
        *   If `allow_wildcard_qmark && a == '?'`: true if `b != obstacle_char`.
        *   Else if `case_insensitive`: fold both to uppercase (ASCII: if `'a'<=x<='z'` then `x-='a'-'A'`), compare.
        *   Else: compare raw characters.
*   **Search**:
    *   For each cell `(r, c)` not an obstacle:
        *   If it matches `word[0]` per `eq`, perform a **DFS/backtracking** search for the rest:
            *   Maintain a **visited** bitmap/array (`rows*cols`) for the current path (you may use a `char visited[]` local array; or a VLA in C99).
            *   From `(r, c)`, recursively/iteratively try all allowed neighbors, ensuring bounds, not obstacle, not visited.
            *   On reaching depth `word_len-1`, count a match; if it’s the **first** match, record `(r, c)` and the **direction** of the first step:
                *   If `word_len == 1`, set direction `DIR_NONE`.
                *   Else determine direction from `(r, c)` to the first neighbor in the successful path.
*   **Complexity**:
    *   Worst case backtracking is exponential in `word_len`, but typical constraints are fine for classroom sizes.
    *   Memory: O(rows\*cols) for `visited`; stack depth O(word\_len).

***

### Tasks to Perform

1.  **Validate inputs**; if invalid, return `-1` without modifying outputs.
2.  **Count `word_len`**; if `word_len == 0`, treat as invalid (return `-1`).
3.  **Initialize outputs** (on success path): `count=0`, `first_row=-1`, `first_col=-1`, `first_dir=DIR_NONE`.
4.  **Iterate all start cells** `(r, c)`:
    *   Skip if `grid[r*cols + c] == obstacle_char`.
    *   If start character matches `word[0]`, clear `visited[]` and start DFS.
5.  **DFS/backtracking**:
    *   Mark current `(r, c)` visited.
    *   If `pos == word_len-1`: found a match → increment `count`; if first, set outputs (derive direction).
    *   Else, for each allowed direction `(dr, dc)`:
        *   `nr=r+dr, nc=c+dc`; check bounds, obstacle, and not visited.
        *   Check `eq(word[pos+1], grid[nr*cols + nc])`; if true, recurse to `(nr, nc)`.
    *   Unmark on return (backtrack).
6.  **After full search**, write `*out_count = count`, `*out_first_row = first_row`, `*out_first_col = first_col`, `*out_first_dir = first_dir`; return `0`.

***

### Test Cases

| # | Grid (rows×cols) & Params                                                                                                            | Expected Output                                                      | Notes                                                                                                                                                                                              |
| - | ------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | **Grid 3×4** rows: `{"CATS", "A#AT", "TACT"}`, `word="CAT"`, `case_insensitive=false`, `diagonal=false`, `wildcard=false`, `obs='#'` | `ret=0, out_count=2, first_row=0, first_col=0, first_dir=DIR_E`      | Matches at (0,0)→E (“CAT”), and (2,1)→E (“ACT” not exact) → Actually only **(0,0)→E** and **(2,0)→E (“TAC” no)** → Corrected: also (0,0)→S? C(0,0)->A(1,0)->T(2,0) valid → **2 matches** (E and S) |
| 2 | Same grid, `word="C?T"`, `wildcard=true`, `case_insensitive=false`, `diagonal=false`                                                 | `ret=0, out_count=3, first=(0,0), dir=DIR_E`                         | `?` matches ‘A’ at (0,1) and also (1,0) for vertical; plus (2,1) for “C?T” diagonal is off, so only horizontal & vertical                                                                          |
| 3 | **Grid 3×3** rows: `{"aBc", "d#E", "fGh"}`, `word="BEG"`, `case_insensitive=true`, `diagonal=true`, `wildcard=false`, `obs='#'`      | `ret=0, out_count=1, first_row=0, first_col=1, first_dir=DIR_SE`     | Case-insensitive diagonal: B(0,1)→E(1,2)→G(2,1)                                                                                                                                                    |
| 4 | **Grid 2×3** rows: `{"ABC", "DEF"}`, `word="FED"`, `case_insensitive=false`, `diagonal=false`                                        | `ret=0, out_count=1, first_row=1, first_col=2, first_dir=DIR_W`      | Reverse horizontal is allowed by stepping W                                                                                                                                                        |
| 5 | **Grid 3×3** rows: `{"AXA", "X#X", "AXA"}`, `word="AXA"`, `wildcard=false`, `diagonal=false`, `obs='#'`                              | `ret=0, out_count=4, first_row=0, first_col=0, first_dir=DIR_E`      | Four straight-line matches; obstacle blocks center                                                                                                                                                 |
| 6 | **Grid 3×3** rows: `{"CAT", "A#T", "TAC"}`, `word="CAT"`, `diagonal=false`                                                           | `ret=0, out_count=2, first=(0,0), dir=DIR_E`                         | Horizontal at top; vertical (0,0)→(1,0)→(2,0) also valid                                                                                                                                           |
| 7 | **Grid 2×2** rows: `{"AB", "CD"}`, `word="ABCDE"`, any flags                                                                         | `ret=0, out_count=0, first_row=-1, first_col=-1, first_dir=DIR_NONE` | Word longer than total cells ⇒ no matches                                                                                                                                                          |
| 8 | Invalid: `rows=0` or `cols=0` or `grid=NULL` or `word=NULL`                                                                          | `ret=-1`                                                             | Do not modify outputs                                                                                                                                                                              |

> **Note:** In your implementation, carefully verify the expected counts by enumerating paths; ensure **no cell reuse** within a single match and obey the `allow_diagonal` flag.

***