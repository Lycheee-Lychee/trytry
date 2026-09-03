#!/usr/bin/env bash
# Run inside Ubuntu-22.04 after a full Windows reboot restores WSL/GPU.
set -euo pipefail

workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_file="$workspace_dir/recovery.log"

exec > >(tee -a "$log_file") 2>&1
echo "=== post-reboot recovery started: $(date --iso-8601=seconds) ==="

echo "=== [1/5] WSL nvidia-smi ==="
nvidia-smi

echo "=== [2/5] Docker GPU check ==="
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi

echo "=== [3/5] start pi0.5 server (cached weights) ==="
bash "$workspace_dir/clean_restart_pi05_server.sh"

echo "=== [4/5] LIBERO smoke test ==="
bash "$workspace_dir/run_libero_smoke.sh"

echo "=== [5/5] artifact check ==="
repo="$HOME/research/vla-evaluation-harness"
find "$repo/results" -maxdepth 5 -type f \( -name '*aggregate*.json' -o -name '*.jsonl' -o -name '*.mp4' \) -printf '%TY-%Tm-%Td %TH:%TM:%TS %s %p\n' 2>/dev/null | sort | tail -20

echo "=== recovery complete: $(date --iso-8601=seconds) ==="
