#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$HOME/research/vla-evaluation-harness/results/pilot_libero_object_shift_15cm_3x5"
dest="$workspace_dir/artifacts/pilot_libero_object_shift_15cm_3x5"
mkdir -p "$dest"
cp -r "$src/." "$dest/"
echo '=== exported 15cm ==='
du -sh "$dest"
find "$dest" -name '*fail.mp4' | sort
