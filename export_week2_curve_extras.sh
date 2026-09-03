#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo="$HOME/research/vla-evaluation-harness"
for name in \
  pilot_libero_object_shift_10cm_neg_x_3x5 \
  pilot_libero_object_shift_7p5cm_y_3x5 \
  pilot_libero_object_shift_12p5cm_y_3x5
do
  src="$repo/results/$name"
  dest="$workspace_dir/artifacts/$name"
  mkdir -p "$dest"
  cp -r "$src/." "$dest/"
  echo "exported $name $(du -sh "$dest" | awk '{print $1}')"
done
