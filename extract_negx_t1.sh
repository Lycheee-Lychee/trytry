#!/usr/bin/env bash
set -euo pipefail
root="/mnt/c/Users/Lychee/Desktop/跑跑"
out="$root/artifacts/negx_t1_sheets"
mkdir -p "$out"
docker run --rm \
  -v "$root/artifacts:/artifacts:ro" \
  -v "$out:/out" \
  -v "$root/extract_negx_t1.py:/tmp/extract_negx_t1.py:ro" \
  --entrypoint conda \
  ghcr.io/allenai/vla-evaluation-harness/libero:latest \
  run --no-capture-output -n libero python /tmp/extract_negx_t1.py
ls "$out" | wc -l
