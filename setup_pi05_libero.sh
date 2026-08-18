#!/usr/bin/env bash
set -euo pipefail

echo '=== identity ==='
id
echo '=== distro ==='
head -n 3 /etc/os-release
echo '=== host gpu ==='
nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
echo '=== tools ==='
for c in git git-lfs curl uv docker; do
  if command -v "$c" >/dev/null 2>&1; then
    printf '%s: %s\n' "$c" "$(command -v "$c")"
  else
    printf '%s: MISSING\n' "$c"
  fi
done
echo '=== docker ==='
docker version --format '{{.Client.Version}} / {{.Server.Version}}'
echo '=== gpu container ==='
docker run --rm --gpus all nvidia/cuda:12.1.1-base-ubuntu22.04 nvidia-smi

echo '=== install uv ==='
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"
uv --version

echo '=== repository ==='
mkdir -p "$HOME/research"
repo="$HOME/research/vla-evaluation-harness"
if [[ -d "$repo/.git" ]]; then
  git -C "$repo" remote -v
  git -C "$repo" status --short --branch
elif [[ -e "$repo" ]]; then
  echo "BLOCKED: $repo exists but is not a Git repository" >&2
  exit 20
else
  git clone --branch v0.4.0 https://github.com/allenai/vla-evaluation-harness.git "$repo"
fi

echo '=== checkout pinned release ==='
git -C "$repo" fetch --tags origin
if [[ -n "$(git -C "$repo" status --porcelain)" ]]; then
  echo 'BLOCKED: repository has local changes; refusing to switch versions' >&2
  git -C "$repo" status --short
  exit 21
fi
git -C "$repo" checkout v0.4.0

echo '=== Python environment ==='
cd "$repo"
uv sync --python 3.11 --all-extras --dev

echo '=== LIBERO image ==='
docker pull ghcr.io/allenai/vla-evaluation-harness/libero:latest

echo '=== installed versions ==='
uv run python --version
uv run vla-eval --help | head -n 20
docker image inspect ghcr.io/allenai/vla-evaluation-harness/libero:latest --format '{{.Id}} {{.Size}}'
