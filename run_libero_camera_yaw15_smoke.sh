#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo"
cp "$workspace_dir/smoke_libero_camera_yaw15.yaml" configs/benchmarks/libero/smoke_camera_yaw15_docker_desktop.yaml

echo '=== health ==='
curl -fsS http://localhost:8000/health
echo
echo '=== camera-yaw 15° smoke ==='
uv run vla-eval run --config configs/benchmarks/libero/smoke_camera_yaw15_docker_desktop.yaml --record-video --yes
echo '=== result files ==='
find results/smoke_libero_camera_yaw15 -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %s %p\n' | sort
