#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo"
cp "$workspace_dir/pilot_libero_object_shift_5cm_3x5.yaml" configs/benchmarks/libero/pilot_object_shift_5cm_3x5_docker_desktop.yaml
echo '=== health ==='
curl -fsS http://localhost:8000/health
echo
echo '=== object-shift 5cm pilot: 3 tasks x 5 episodes ==='
uv run vla-eval run --config configs/benchmarks/libero/pilot_object_shift_5cm_3x5_docker_desktop.yaml --record-video --yes
echo '=== result files ==='
find results/pilot_libero_object_shift_5cm_3x5 -type f -printf '%s %p\n' | sort -n
