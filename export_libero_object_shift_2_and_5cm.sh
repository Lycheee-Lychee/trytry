#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$HOME/research/vla-evaluation-harness/results/pilot_libero_object_shift_5cm_3x5"
dest="$workspace_dir/artifacts/pilot_libero_object_shift_5cm_3x5"
mkdir -p "$dest"
cp -r "$src/." "$dest/"
echo '=== exported 5cm ==='
du -sh "$dest"
src2="$HOME/research/vla-evaluation-harness/results/pilot_libero_object_shift_2cm_3x5"
dest2="$workspace_dir/artifacts/pilot_libero_object_shift_2cm_3x5"
mkdir -p "$dest2"
cp -r "$src2/." "$dest2/"
echo '=== exported 2cm ==='
du -sh "$dest2"
