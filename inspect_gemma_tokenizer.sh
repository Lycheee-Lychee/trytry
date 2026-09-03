#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
cd "$HOME/research/vla-evaluation-harness"

echo "=== uv environments ==="
ls -d "$HOME/.cache/uv/environments-v2/"* 2>/dev/null | tail -20 || true

echo "=== resolve script env packages ==="
uv run --script src/vla_eval/model_servers/lerobot.py --help >/tmp/lerobot-help.txt 2>/tmp/lerobot-help.err || true
head -n 30 /tmp/lerobot-help.err || true

echo "=== env dirs after resolve ==="
ls -d "$HOME/.cache/uv/environments-v2/"lerobot* 2>/dev/null || ls -d "$HOME/.cache/uv/environments-v2/"* | tail -10

envdir="$(ls -d "$HOME/.cache/uv/environments-v2/"lerobot* 2>/dev/null | head -1 || true)"
if [[ -z "${envdir:-}" ]]; then
  envdir="$(ls -dt "$HOME/.cache/uv/environments-v2/"* | head -1)"
fi
echo "using envdir=$envdir"
py="$envdir/bin/python3"
"$py" - <<'PY'
import transformers, sys
print("python", sys.version)
print("transformers", transformers.__version__, transformers.__file__)
try:
    import sentencepiece
    print("sentencepiece", sentencepiece.__version__)
except Exception as e:
    print("sentencepiece FAIL", e)
import os, glob
g = os.path.join(os.path.dirname(transformers.__file__), "models", "gemma")
print("gemma dir", g)
print("files", sorted(os.listdir(g)) if os.path.isdir(g) else None)
try:
    from transformers.models.gemma.tokenization_gemma import GemmaTokenizer
    print("GemmaTokenizer OK", GemmaTokenizer)
except Exception as e:
    print("GemmaTokenizer FAIL", type(e), e)
try:
    from transformers import AutoTokenizer
    t = AutoTokenizer.from_pretrained("google/paligemma-3b-pt-224")
    print("AutoTokenizer OK", type(t), t.__class__.__name__)
except Exception as e:
    print("AutoTokenizer FAIL", type(e), e)
PY
