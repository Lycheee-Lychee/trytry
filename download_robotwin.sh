#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

echo "=== [1/3] docker pull robotwin ==="
docker pull ghcr.io/allenai/vla-evaluation-harness/robotwin:latest
docker image inspect ghcr.io/allenai/vla-evaluation-harness/robotwin:latest --format '{{.Id}} {{.Size}}'

echo "=== [2/3] X-VLA-WidowX (RoboTwin domain_id=6) ==="
uvx --from huggingface_hub hf download 2toINF/X-VLA-WidowX

echo "=== [3/3] DB-CogACT grab_roller (eval.yaml smoke task) ==="
uvx --from huggingface_hub hf download Dexmal/robotwin-db-cogact --include "grab_roller/**"

echo "=== done ==="
docker images ghcr.io/allenai/vla-evaluation-harness/robotwin --format '{{.Repository}}:{{.Tag}} {{.Size}}'
du -sh "$HOME/.cache/huggingface/hub/models--2toINF--X-VLA-WidowX" 2>/dev/null || true
du -sh "$HOME/.cache/huggingface/hub/models--Dexmal--robotwin-db-cogact" 2>/dev/null || true
