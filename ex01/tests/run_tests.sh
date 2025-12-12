#!/usr/bin/env bash
set -euo pipefail

echo "[TEST] Hello, World! output"
out="$(./bin/hello || true)"

# Expect exactly "Hello, World!\n"
expected="Hello, World!"

if [ "$out" = "$expected" ]; then
  echo "  ✔ Passed"
  exit 0
else
  echo "  ✘ Failed"
  echo "    Expected:"
  printf "%s" "$expected"
  echo "    Got:"
  printf "%s" "$out"
  exit 1
fi