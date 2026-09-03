#!/usr/bin/env bash
set -euo pipefail
root="/mnt/c/Users/Lychee/Desktop/跑跑"
out="$root/artifacts/failure_sheets"
mkdir -p "$out"
docker run --rm \
  -v "$root/artifacts:/artifacts:ro" \
  -v "$out:/out" \
  -v "$root/extract_failure_sheets.py:/tmp/extract_failure_sheets.py:ro" \
  --entrypoint conda \
  ghcr.io/allenai/vla-evaluation-harness/libero:latest \
  run --no-capture-output -n libero python /tmp/extract_failure_sheets.py
ls "$out" | wc -l
