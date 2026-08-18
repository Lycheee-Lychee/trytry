#!/usr/bin/env bash
set -u
export PATH="$HOME/.local/bin:$PATH"
echo '=== UV ==='
command -v uv || true
uv --version 2>/dev/null || true
echo '=== REPO ==='
repo="$HOME/research/vla-evaluation-harness"
if [[ -d "$repo/.git" ]]; then
  git -C "$repo" status --short --branch
  git -C "$repo" describe --tags --always
else
  echo missing
fi
echo '=== VENV ==='
if [[ -x "$repo/.venv/bin/python" ]]; then
  "$repo/.venv/bin/python" --version
else
  echo missing
fi
echo '=== IMAGE ==='
docker image inspect ghcr.io/allenai/vla-evaluation-harness/libero:latest --format '{{.Id}} {{.Size}}' 2>/dev/null || echo missing
