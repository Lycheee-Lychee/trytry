#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$HOME/research/vla-evaluation-harness/results/pilot_libero10_3x5"
dest="$workspace_dir/artifacts/pilot_libero10_3x5"
mkdir -p "$dest"
cp -r "$src/." "$dest/"
find "$dest" -type f | sort
du -sh "$dest"
