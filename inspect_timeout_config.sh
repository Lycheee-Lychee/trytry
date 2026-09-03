#!/usr/bin/env bash
set -euo pipefail
repo="$HOME/research/vla-evaluation-harness"
cd "$repo"
sed -n '1,100p' src/vla_eval/config.py
sed -n '1,120p' configs/benchmarks/libero/_base.yaml 2>/dev/null || true
grep -RIn --exclude-dir=.git '^server:' configs/benchmarks/libero | head -n 20
