#!/usr/bin/env bash
set -euo pipefail
echo '=== checkpoint config ==='
find "$HOME/.cache/huggingface/hub" -path '*pi05_libero_finetuned_v044*/snapshots/*/config.json' -print -exec sed -n '1,240p' {} \;
echo '=== pi05 compile flags in cached LeRobot ==='
envdir="$HOME/.cache/uv/environments-v2/lerobot-a9cf07f431c41423"
grep -RIn -E 'compile_model|gradient_checkpoint' "$envdir/lib/python3.12/site-packages/lerobot/policies/pi05" | head -n 100 || true
