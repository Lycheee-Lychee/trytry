#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo '=== Hugging Face identity ==='
uvx --from huggingface_hub hf auth whoami

echo '=== PaliGemma gated access ==='
uvx --from huggingface_hub hf download google/paligemma-3b-pt-224 config.json

echo '=== Start π0.5 server ==='
exec bash "$workspace_dir/start_pi05_server.sh"
