#!/usr/bin/env bash
set -euo pipefail
src="$HOME/research/vla-evaluation-harness/results/pilot_libero10_3x5"
dest="/mnt/c/Users/user/Desktop/跑跑/artifacts/pilot_libero10_3x5"
mkdir -p "$dest"
cp -r "$src/." "$dest/"
find "$dest" -type f | sort
du -sh "$dest"
