#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo"

run_one() {
  local src_yaml="$1"
  local dest_name="$2"
  local label="$3"
  cp "$workspace_dir/$src_yaml" "configs/benchmarks/libero/$dest_name"
  echo
  echo "=== $label ==="
  curl -fsS http://localhost:8000/health
  echo
  uv run vla-eval run --config "configs/benchmarks/libero/$dest_name" --record-video --yes
}

run_one "pilot_libero_camera_yaw30_3x5.yaml" "pilot_camera_yaw30_3x5_docker_desktop.yaml" "D1 camera yaw 30"
run_one "pilot_libero_camera_yaw45_3x5.yaml" "pilot_camera_yaw45_3x5_docker_desktop.yaml" "D2 camera yaw 45"
run_one "pilot_libero_object_shift_10cm_x_3x5.yaml" "pilot_object_shift_10cm_x_3x5_docker_desktop.yaml" "D3 object +x 10cm"
run_one "pilot_libero_object_shift_10cm_neg_y_3x5.yaml" "pilot_object_shift_10cm_neg_y_3x5_docker_desktop.yaml" "D4 object -y 10cm"

echo
echo "=== discovery D1-D4 done ==="
