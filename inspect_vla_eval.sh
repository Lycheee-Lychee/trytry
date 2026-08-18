#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd "$HOME/research/vla-evaluation-harness"
uv run vla-eval --help
echo '=== server config ==='
sed -n '1,220p' configs/model_servers/lerobot/pi05_libero.yaml
echo '=== smoke config ==='
sed -n '1,220p' configs/benchmarks/libero/smoke_test.yaml
