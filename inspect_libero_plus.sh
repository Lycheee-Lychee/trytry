#!/usr/bin/env bash
set -euo pipefail
repo="$HOME/research/vla-evaluation-harness"
cd "$repo"
echo '=== LIBERO-related configs ==='
find configs/benchmarks -maxdepth 3 -type f -iname '*libero*' -o -path '*/libero_plus/*' | sort
echo '=== LIBERO-Plus directory ==='
find configs/benchmarks/libero_plus -maxdepth 2 -type f -print 2>/dev/null | sort | while read -r file; do
  echo "--- $file ---"
  sed -n '1,240p' "$file"
done
echo '=== implementation parameters ==='
grep -RIn --exclude-dir=.git -E 'class .*LIBERO|perturb|camera|lighting|texture|background' src/vla_eval/benchmarks/libero_plus configs/benchmarks/libero_plus 2>/dev/null | head -n 240 || true
