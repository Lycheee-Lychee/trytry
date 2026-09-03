#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo"
cp "$workspace_dir/smoke_libero_object_shift_10cm.yaml" configs/benchmarks/libero/smoke_object_shift_10cm_docker_desktop.yaml
echo '=== health ==='
curl -fsS http://localhost:8000/health
echo
echo '=== object-shift 10cm smoke ==='
uv run vla-eval run --config configs/benchmarks/libero/smoke_object_shift_10cm_docker_desktop.yaml --record-video --yes
echo '=== result files ==='
find results/smoke_libero_object_shift_10cm -type f -printf '%s %p\n' | sort -n
