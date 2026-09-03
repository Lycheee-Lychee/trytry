#!/usr/bin/env bash
set -euo pipefail
repo="$HOME/research/vla-evaluation-harness"
sed -n '1,280p' "$repo/src/vla_eval/model_servers/lerobot.py"
echo '=== base server config ==='
cat "$repo/configs/model_servers/lerobot/_base.yaml"
