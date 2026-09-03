#!/usr/bin/env bash
set -u
export PATH="$HOME/.local/bin:$PATH"
cd "$HOME/research/vla-evaluation-harness"
grep -RIn --exclude-dir=.git -E 'render_backend|render:|--render' src configs | head -n 100 || true
uv run vla-eval run --help
