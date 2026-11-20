#!/bin/sh
# Runs the test harness for each character and compares with tests/expected/.
# Run from the repository root: sh tests/run.sh   (update expected: sh tests/run.sh --update)
set -e
cd "$(dirname "$0")/.."
fail=0
for c in Galdorin Meagor Thorim Nobody; do
  out=$(lua5.1 tests/mock.lua "$c")
  if [ "$1" = "--update" ]; then
    printf '%s\n' "$out" > "tests/expected/$c.txt"; echo "updated $c"
  elif printf '%s\n' "$out" | cmp -s - "tests/expected/$c.txt"; then
    echo "ok   $c"
  else
    echo "FAIL $c"; printf '%s\n' "$out" | diff "tests/expected/$c.txt" - | head -20; fail=1
  fi
done
if [ "$1" = "--update" ]; then lua5.1 overview/build.lua; else lua5.1 overview/build.lua --check || fail=1; fi
exit $fail
