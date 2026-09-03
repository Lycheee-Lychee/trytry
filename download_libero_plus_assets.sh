#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
mkdir -p "$HOME/research/libero-plus-assets"
cd "$HOME/research/libero-plus-assets"
echo "uvx: $(command -v uvx)"
echo "downloading Sylvest/LIBERO-plus assets.zip"
uvx --from huggingface_hub hf download Sylvest/LIBERO-plus assets.zip \
  --repo-type dataset \
  --local-dir "$HOME/research/libero-plus-assets"
ls -lh "$HOME/research/libero-plus-assets"
