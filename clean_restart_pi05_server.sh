#!/usr/bin/env bash
set -euo pipefail
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pattern="$HOME/research/vla-evaluation-harness/src/vla_eval/model_servers/lerobot.py"

mapfile -t model_pids < <(pgrep -f "$pattern" || true)
mapfile -t launcher_pids < <(pgrep -f 'vla-eval serve --config configs/model_servers/lerobot/pi05_libero' || true)
pids=("${model_pids[@]}" "${launcher_pids[@]}")

if (( ${#pids[@]} > 0 )); then
  printf 'stopping PIDs: %s\n' "${pids[*]}"
  kill -TERM "${pids[@]}" 2>/dev/null || true
  for _ in $(seq 1 20); do
    alive=0
    for pid in "${pids[@]}"; do
      kill -0 "$pid" 2>/dev/null && alive=1
    done
    (( alive == 0 )) && break
    sleep 0.5
  done
  for pid in "${pids[@]}"; do
    kill -0 "$pid" 2>/dev/null && kill -KILL "$pid" 2>/dev/null || true
  done
fi

rm -f "$HOME/research/vla-evaluation-harness/logs/pi05_server.pid"
if ss -ltn 'sport = :8000' | grep -q ':8000'; then
  echo 'BLOCKED: port 8000 still occupied' >&2
  ss -ltnp 'sport = :8000' >&2 || true
  exit 40
fi

exec bash "$workspace_dir/start_pi05_server.sh"
