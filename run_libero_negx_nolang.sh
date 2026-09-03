#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo"
python3 "$workspace_dir/patch_object_shift_language.py"
cp "$workspace_dir/pilot_libero_object_shift_10cm_neg_x_nolang_3x5.yaml" configs/benchmarks/libero/pilot_object_shift_10cm_neg_x_nolang_3x5_docker_desktop.yaml
echo '=== health ==='
curl -fsS http://localhost:8000/health
echo
echo '=== -x 10cm object-only, drop “next to the ramekin” (~12 min) ==='
uv run vla-eval run --config configs/benchmarks/libero/pilot_object_shift_10cm_neg_x_nolang_3x5_docker_desktop.yaml --record-video --yes
python3 - <<'PY'
import json
from pathlib import Path
p = Path("results/pilot_libero_object_shift_10cm_neg_x_nolang_3x5")
agg = list(p.glob("*aggregate.json"))
print("=== pose traces (language ablation) ===")
if not agg:
    print("no aggregate")
else:
    data = json.loads(agg[0].read_text())
    for task in data.get("tasks", []):
        for ep in task.get("episodes", []):
            m = ep.get("metrics", {})
            print(
                f"t{ep.get('task_id')} ep{ep.get('episode_id')} succ={m.get('success')} "
                f"on_plate={m.get('on_plate')} pick={m.get('pick_to_plate_m')} "
                f"ramekin={m.get('ramekin_to_plate_m')} "
                f"pick_moved={m.get('pick_moved_m')} ramekin_moved={m.get('ramekin_moved_m')}"
            )
PY
