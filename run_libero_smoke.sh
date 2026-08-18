#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
cd "$repo"
cp /mnt/c/Users/user/Desktop/跑跑/smoke_test_docker_desktop.yaml configs/benchmarks/libero/smoke_test_docker_desktop.yaml

echo '=== health ==='
curl -fsS http://localhost:8000/health
echo
echo '=== smoke test ==='
uv run vla-eval run --config configs/benchmarks/libero/smoke_test_docker_desktop.yaml --record-video
echo '=== result files ==='
find results -maxdepth 4 -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %s %p\n' | sort
