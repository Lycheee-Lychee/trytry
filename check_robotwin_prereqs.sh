#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
echo "=== disk ==="
df -h / /home/lychee | sed -n '1,5p'
echo "=== docker images ==="
docker images --format '{{.Repository}}:{{.Tag}} {{.Size}}' | sort
echo "=== hf token ==="
test -f "$HOME/.cache/huggingface/token" && echo present || echo missing
