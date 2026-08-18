#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

echo '=== Hugging Face identity ==='
uvx --from huggingface_hub hf auth whoami

echo '=== PaliGemma gated access ==='
uvx --from huggingface_hub hf download google/paligemma-3b-pt-224 config.json

echo '=== Start π0.5 server ==='
exec bash /mnt/c/Users/user/Desktop/跑跑/start_pi05_server.sh
