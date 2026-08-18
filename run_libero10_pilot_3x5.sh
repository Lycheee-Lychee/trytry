#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
cd "$repo"

cp /mnt/c/Users/user/Desktop/跑跑/pilot_libero10_3x5.yaml configs/benchmarks/libero/pilot_libero10_3x5_docker_desktop.yaml

echo '=== model server health ==='
curl -fsS http://localhost:8000/health
echo
echo '=== pilot: LIBERO-10, 3 tasks x 5 episodes ==='
uv run vla-eval run --config configs/benchmarks/libero/pilot_libero10_3x5_docker_desktop.yaml

echo '=== generated artifacts ==='
find results/pilot_libero10_3x5 -type f -printf '%s %p\n' | sort -n
