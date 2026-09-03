#!/usr/bin/env bash
set -euo pipefail
root="/mnt/c/Users/Lychee/Desktop/跑跑"
out="$root/artifacts/failure_keyframes"
docker run --rm \
  -v "$out:/keyframes:ro" \
  -v "$out:/out" \
  -v "$root/compare_keyframes.py:/tmp/compare_keyframes.py:ro" \
  --entrypoint conda \
  ghcr.io/allenai/vla-evaluation-harness/libero:latest \
  run --no-capture-output -n libero python /tmp/compare_keyframes.py
