#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$HOME/research/vla-evaluation-harness/results/pilot_libero_object_shift_15cm_max440_3x5"
dest="$workspace_dir/artifacts/pilot_libero_object_shift_15cm_max440_3x5"
mkdir -p "$dest"
cp -r "$src/." "$dest/"
echo '=== exported 15cm max440 ==='
du -sh "$dest"
