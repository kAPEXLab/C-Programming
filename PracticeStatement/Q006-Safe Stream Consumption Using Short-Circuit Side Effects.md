# Title: Safe Stream Consumption Using Short‑Circuit Side Effects

## Level: Difficult  

## Concepts: Operator precedence, short‑circuit evaluation, side‑effects, pointer handling  

## Scenario  
You receive a stream of sensor samples in an `int` array. Starting from a given index, you must consume (sum) values strictly below a threshold, but stop when any of these occurs: you reach array end, you reach a maximum item limit, or the next value is not below the threshold. You must rely on short‑circuit evaluation so you never read out‑of‑bounds and you only advance the index when an element is actually consumed. The caller observes the updated index as a side effect.  

## Problem Statement  
Write a function that safely consumes elements from an integer array according to the rules above, using only `int`, `bool`, and pointers. The function must guarantee that no out‑of‑bounds read occurs by employing left‑to‑right `&&` short‑circuiting, and it must update the caller’s index only for consumed elements.  

## Requirements  
- Use only `int` and `bool` (plus pointers/arrays of these).  
- Inputs: array `a`, length `n`, in/out index, `threshold`, `limit`.  
- Starting at `*index`, repeatedly:  

  1. **Check bounds first**: `*index < n`  
  2. **Check value**: `a[*index] < threshold`  
  3. **Check limit**: number of items consumed `< limit`  

- On success: add `a[*index]` to `sum`, post‑increment the index (consume exactly one item), and increment the consumed count.  
- Stop as soon as any condition fails.  
- Guarantee no out‑of‑bounds read by using `&&` short‑circuiting with left‑to‑right evaluation.  
- Do **not** write expressions with multiple modifications of the same scalar without an intervening sequence point (e.g., avoid `a[(*index)++] + a[(*index)++]`).  
- Validate inputs:  

  * `a != NULL`  
  * `n >= 0`  
  * `index != NULL`  
  * `out_sum != NULL`  
  * `out_count != NULL`  
  * `limit >= 0`  

  If any validation fails, return error (`-1`) without modifying any output.  

- Time complexity: `O(consumed)`  
- Space complexity: `O(1)`  

## Function Details  

- **Name**: `consume_below_threshold`  

- **Arguments**:  

  ```c
  const int *a          // Input array
  int        n          // Array length
  int       *index      // In/out current position (0 ≤ *index ≤ n)
  int        threshold  // Strict upper bound for consumption
  int        limit      // Max items to consume this call
  int       *out_sum    // Sum of consumed items
  int       *out_count  // Number of items consumed
  ```  

- **Return Value**:  

  `int` — `0` on success; `-1` on invalid input.  

- **Description**:  
  The function consumes elements while the three guard conditions (`*index < n`, `a[*index] < threshold`, and consumed‑so‑far `< limit`) all hold, using short‑circuit `&&` to avoid out‑of‑bounds access. Each consumed element contributes to the sum and increments `*index` and the consumed count. If validation fails, the function returns `-1` and leaves all output pointers unchanged.  

## Solution Approach  

1. **Validate pointers and ranges**; on failure return `-1`.  
2. Initialise local `int sum = 0; int cnt = 0;`.  
3. Loop using short‑circuit logic:  

   ```c
   while (cnt < limit && *index < n && a[*index] < threshold) {
       sum += a[(*index)++];   // read the element, then advance index
       cnt++;
   }
   ```  

   The left‑to‑right evaluation of `&&` guarantees `a[*index]` is never evaluated when `*index >= n`.  
4. Store results: `*out_sum = sum; *out_count = cnt;`.  
5. Return `0`.  

## Tasks to Perform  

1. Implement the prototype and body described above using only `int`, `bool`, and pointers.  
2. Ensure the loop respects short‑circuit evaluation and does not contain multiple modifications of the same scalar without a sequence point.  
3. Write unit tests covering all listed test cases and additional edge conditions (e.g., limit = 0, empty array).  
4. Verify with static analysis / runtime checks that no out‑of‑bounds read can occur.  

## Test Cases (≥5)  

| # | Inputs / Pre‑condition                                                                                                    | Expected Output                                                                                                                                                      | Notes |
|---|---------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|
| 1 | `a = [1,2,3,9,1]`, `n = 5`, `*index = 0`, `threshold = 5`, `limit = 10`                                             | `ret = 0`, `*out_sum = 1+2+3 = 6`, `*out_count = 3`, `*index = 3`                                                                                                    | Stops at `9` (not `< 5`) |
| 2 | `a = [-1,-2,-3]`, `n = 3`, `*index = 0`, `threshold = 0`, `limit = 2`                                                | `ret = 0`, `*out_sum = -1 + -2 = -3`, `*out_count = 2`, `*index = 2`                                                                                                 | Limit reached early |
| 3 | `a = [1,2,3]`, `n = 3`, `*index = 3`, `threshold = 10`, `limit = 5`                                               | `ret = 0`, `*out_sum = 0`, `*out_count = 0`, `*index = 3`                                                                                                            | Index already at end |
| 4 | `a = [4,4,4]`, `n = 3`, `*index = 0`, `threshold = 4`, `limit = 5`                                                  | `ret = 0`, `*out_sum = 0`, `*out_count = 0`, `*index = 0`                                                                                                            | Values equal to threshold are not consumed |
| 5 | `a = [1,100,2]`, `n = 3`, `*index = 0`, `threshold = 50`, `limit = 5`                                             | `ret = 0`, `*out_sum = 1`, `*out_count = 1`, `*index = 1`                                                                                                            | Stops when next value `100` is not `< 50 |
| 6 | `a = [1,2,3]`, `n = 3`, `*index = 0`, `threshold = 5`, `limit = 0`                                                | `ret = 0`, `*out_sum = 0`, `*out_count = 0`, `*index = 0`                                                                                                            | Zero limit – consume none |
| 7 | `a = NULL`, any other parameters any valid values                                                                      | `ret = -1` (invalid pointer)                                                                                                                                          | No modifications of outputs |
| 8 | `a = [1]`, `n = -1`, `*index = 0`, `threshold = 5`, `limit = 1`                                                    | `ret = -1` (invalid length)                                                                                                                                           | No modifications of outputs |