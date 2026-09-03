#!/usr/bin/env bash
set -euo pipefail
envdir="$HOME/.cache/uv/environments-v2/lerobot-a911f3be0152a807"
echo "envdir=$envdir"
ls -d "$envdir" || { echo missing; exit 0; }
ls "$envdir/lib/python3.12/site-packages" | grep -iE 'transformers|sentencepiece|tokenizers' || true
ls "$envdir/lib/python3.12/site-packages/transformers/models/gemma" 2>/dev/null || echo "no gemma dir"
if [[ -x "$envdir/bin/python3" ]]; then
  "$envdir/bin/python3" -c "import transformers; print('ver', transformers.__version__)" || true
fi
