# Stream Binary Records: Validate, Filter, Copy, and Index

**Title:** Filter & Compact a Binary Record File to a New File with Sparse Index  
**Level:** Difficult  
**Concepts:** Binary File I/O (`fopen`, `fread`, `fwrite`, `fseek`, `ftell`, `fflush`), fixed-size records, runtime `sizeof` checks, checksums, streaming without full-file load, sparse indexing, error handling

### Scenario

A device logs fixed-size **binary records** to a file. Each file starts with a 16-byte **header** containing a 4-byte ASCII magic `"LOG1"`, a 4-byte `int` **version**, and 8 bytes reserved (zeros). After the header, there are **N records**, each exactly **24 bytes** in this layout:

    offset +0 : long  ts_ms          (8 bytes; milliseconds since boot)
    offset +8 : int   type           (4 bytes; application-defined)
    offset +12: int   value          (4 bytes)
    offset +16: int   checksum       (4 bytes; computed rule below)
    offset +20: int   reserved       (4 bytes; must be 0)

**Checksum rule:** `checksum = (int)((ts_ms & 0xFFFFFFFF) + type + value)`.  
If any field is invalid (e.g., reserved != 0) or checksum mismatches, the record is **invalid**.

You must stream the **input** file, validate each record, optionally **filter** by `type` and by time window `[t_start_ms, t_end_ms]`, and write only valid & selected records to the **output** file (using the **same 24-byte format**). Additionally, write a separate **index** file that stores a **sparse index**: for every **K-th** written record (e.g., every 100th), write a pair `(record_number, output_offset)` as ASCII text lines (`"rec=<num> off=<offset>\n"`). The process must **not** load the whole file into memory and must handle **partial trailing** bytes as corruption (ignore incomplete tail).

> **Platform assumption (checked at runtime):** `sizeof(int) == 4` and `sizeof(long) == 8`. If not, the function returns an error.

### Problem Statement

Implement a function that:

1.  Opens input, output, and index files.
2.  Validates the header.
3.  Iterates records with `fread` in 24-byte chunks; discards invalid or out-of-filter records.
4.  Writes valid, selected records to the output file.
5.  Emits an ASCII index line for every K-th written record with its **sequential record number** (starting at 1 in the output stream) and byte **offset** within the output file (relative to its start).
6.  Returns counts: total read, valid, and written.

### Requirements

*   Allowed types only: `int`, `long`, `double`, `char`, `bool`, `enum`, plus pointers/arrays.
*   Inputs:
    *   `const char *in_path`
    *   `const char *out_path`
    *   `const char *idx_path`
    *   `int version_expected` — expected version in header.
    *   `int kth_for_index` — write an index entry every K-th written record (`kth_for_index ≥ 1`).
    *   `bool filter_by_type`
    *   `int type_eq` — only pass records whose `type == type_eq` when `filter_by_type == true`.
    *   `bool filter_by_time`
    *   `long t_start_ms`, `long t_end_ms` — inclusive window when `filter_by_time == true`.
*   Outputs:
    *   `int *out_total_read` — number of full 24-byte records read (including invalid).
    *   `int *out_total_valid` — number of records that passed validation (before filters).
    *   `int *out_total_written` — number of records written to output after filters.
*   Behavior:
    *   Header (16 bytes): read and check `magic == "LOG1"`, `version == version_expected`, and reserved 8 bytes all zero.
    *   Each record: read exactly 24 bytes; if fewer bytes remain (EOF partial), stop without error.
    *   Validate: `reserved == 0` and `checksum == ((int)((ts_ms & 0xFFFFFFFF) + type + value))`.
    *   If `filter_by_type`, keep only `type == type_eq`.
    *   If `filter_by_time`, keep only `t_start_ms ≤ ts_ms ≤ t_end_ms`.
    *   For every kept record, write 24 bytes to `out_path`. For every K-th kept record, write `"rec=<n> off=<offset>\n"` to `idx_path`, where `offset = (long)16 + (long)24 * (n - 1)` if output starts with the same 16-byte header as input; **however**, in this task the **output has no header**, so `offset = (long)24 * (n - 1)`.
*   Error handling:
    *   Any invalid pointers, open failures, runtime `sizeof` mismatch, failed writes/reads (beyond EOF conditions), or invalid parameters → return `-1` (and do not modify outputs).
    *   On success, write all three output counters and return `0`.

### Function Details

*   **Name:** `filter_compact_binary_log`
*   **Arguments:**
    *   `const char *in_path`
    *   `const char *out_path`
    *   `const char *idx_path`
    *   `int version_expected`
    *   `int kth_for_index`
    *   `bool filter_by_type`
    *   `int type_eq`
    *   `bool filter_by_time`
    *   `long t_start_ms`
    *   `long t_end_ms`
    *   `int *out_total_read`
    *   `int *out_total_valid`
    *   `int *out_total_written`
*   **Return Value:**
    *   `int` — `0` on success; `-1` on invalid input or any I/O failure.
*   **Description:**  
    Stream the input log, record-by-record. Validate header and each record, apply filters, write selected records to the output file (no header), and emit sparse index lines to the index file on every K-th written record with the recorded output offset. The function must **not** leak resources; ensure all opened files are closed on every return path.

### Solution Approach

*   Validate pointers and parameters (`kth_for_index ≥ 1`, and if `filter_by_time`, ensure `t_start_ms ≤ t_end_ms`).
*   Check runtime sizes: `if (sizeof(int) != 4 || sizeof(long) != 8) return -1;`.
*   Open `in_path` in `"rb"`, `out_path` in `"wb"`, and `idx_path` in `"wb"`.
*   Read and validate header:
    *   4 bytes magic: must be `'L','O','G','1'`.
    *   4 bytes `int version`: equals `version_expected`.
    *   8 bytes reserved: all zero.
*   Loop:
    *   Read 24 bytes; if `fread` returns less than 24 due to EOF and no error, stop cleanly.
    *   Unpack fields in host endianness (assume same writer/reader platform per teaching scope).
    *   Validate `reserved==0` and checksum rule.
    *   If filters enabled, check `type` and `ts_ms` window.
    *   If passing, `fwrite` the 24 bytes to output; increment written count.
    *   If `(written % kth_for_index) == 0`, compute `offset = (long)24 * (written - 1)` and write an ASCII line to `idx_path`.
*   On exit, set output counters, close all files, return `0`.

### Tasks to Perform

1.  Validate all string and counter pointers are non-`NULL`. Validate `kth_for_index ≥ 1`. If `filter_by_time`, ensure `t_start_ms ≤ t_end_ms`.
2.  Verify runtime sizes: `sizeof(int)==4`, `sizeof(long)==8`; otherwise return `-1`.
3.  Open input/output/index files; on any open failure, return `-1`.
4.  Read and validate the 16-byte header (`"LOG1"`, matching `version_expected`, reserved zeros).
5.  Initialize counters: `total_read=0`, `total_valid=0`, `total_written=0`.
6.  While true:
    *   Attempt to read 24 bytes. If <24 and EOF, break; if error, return `-1`.
    *   Parse fields and validate `reserved` and `checksum`.
    *   If valid, increment `total_valid`.
    *   Apply filters; if accepted:
        *   Write the raw 24 bytes to output; on failure, return `-1`.
        *   Increment `total_written`. If `total_written % kth_for_index == 0`, write the ASCII index line with computed `offset`.
    *   Increment `total_read` for each full 24-byte chunk consumed (regardless of validity).
7.  Flush and close all files. Set `*out_total_read`, `*out_total_valid`, `*out_total_written`. Return `0`.

### Test Cases

| # | Inputs / Precondition                                        | Expected Output                                                                           | Notes                           |
| - | ------------------------------------------------------------ | ----------------------------------------------------------------------------------------- | ------------------------------- |
| 1 | Valid header; 3 valid records; no filters; `kth_for_index=2` | `ret=0; total_read=3; total_valid=3; total_written=3; idx has entries for rec=2 (off=24)` | Basic path                      |
| 2 | Valid header; records with some bad checksum/reserved        | `ret=0; total_read=N; total_valid=M<N; total_written=M`                                   | Invalid dropped; counts reflect |
| 3 | Type filter on `type_eq=5`                                   | Only records where `type==5` are written; index lines at 5th, 10th… written               | Filter by type                  |
| 4 | Time filter `[t_start_ms, t_end_ms]`                         | Only records within window kept                                                           | Filter by time                  |
| 5 | Partial trailing bytes (file truncated mid-record)           | `ret=0; total_read` excludes partial; no error                                            | Graceful EOF                    |
| 6 | Wrong header magic or version                                | `ret=-1`                                                                                  | Header validation fails         |
| 7 | `kth_for_index=0` or `sizeof` mismatch at runtime            | `ret=-1`                                                                                  | Parameter/runtime guard         |
| 8 | Write failure (e.g., disk full)                              | `ret=-1`                                                                                  | Robust error propagation        |
| 9 | Mixed valid records; check index offsets                     | Index lines: `rec=K off=24*(K-1)` with no header in output                                | Offset rule                     |

***