#!/usr/bin/env bash
set -euo pipefail
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pid_file="$repo/logs/pi05_server.pid"
if [[ -f "$pid_file" ]]; then
  pid=$(cat "$pid_file")
  if kill -0 "$pid" 2>/dev/null; then
    pkill -TERM -P "$pid" 2>/dev/null || true
    kill -TERM "$pid" 2>/dev/null || true
    for _ in $(seq 1 20); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 0.5
    done
  fi
fi
rm -f "$pid_file"
exec bash "$workspace_dir/start_pi05_server.sh"
