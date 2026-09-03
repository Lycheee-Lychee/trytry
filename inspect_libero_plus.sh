#!/usr/bin/env bash
set -euo pipefail
repo="$HOME/research/vla-evaluation-harness"
cd "$repo"
echo '=== LIBERO-related configs ==='
find configs/benchmarks -maxdepth 4 -type f \( -iname '*libero*' -o -path '*/libero_plus/*' \) | sort
echo
echo '=== libero_plus tree ==='
find configs/benchmarks/libero_plus src/vla_eval/benchmarks/libero_plus -maxdepth 3 \( -type f -o -type d \) 2>/dev/null | sort || true
echo
echo '=== docs mentioning camera / libero_plus ==='
rg -n -i 'libero.plus|libero_plus|camera.view|camera_view|viewpoint' docs configs README.md --glob '!**/node_modules/**' | head -n 80 || true
