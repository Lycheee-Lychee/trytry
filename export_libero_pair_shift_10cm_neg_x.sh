#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$HOME/research/vla-evaluation-harness/results/pilot_libero_pair_shift_10cm_neg_x_3x5"
dest="$workspace_dir/artifacts/pilot_libero_pair_shift_10cm_neg_x_3x5"
mkdir -p "$dest"
cp -r "$src/." "$dest/"
echo "exported $(du -sh "$dest" | awk '{print $1}')"
