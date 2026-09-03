#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
startup_timeout_seconds="${PI05_STARTUP_TIMEOUT_SECONDS:-3600}"
poll_interval_seconds=5
max_attempts=$((startup_timeout_seconds / poll_interval_seconds))
cd "$repo"
mkdir -p logs
cp "$workspace_dir/pi05_libero_rtx5090.yaml" configs/model_servers/lerobot/pi05_libero_rtx5090.yaml

if [[ -f logs/pi05_server.pid ]] && kill -0 "$(cat logs/pi05_server.pid)" 2>/dev/null; then
  echo "server already running: PID $(cat logs/pi05_server.pid)"
else
  nohup uv run vla-eval serve --config configs/model_servers/lerobot/pi05_libero_rtx5090.yaml > logs/pi05_server.log 2>&1 &
  echo $! > logs/pi05_server.pid
  echo "started server: PID $!"
fi

for attempt in $(seq 1 "$max_attempts"); do
  if curl -fsS http://localhost:8000/health >/tmp/pi05-health.json 2>/dev/null; then
    echo '=== HEALTHY ==='
    cat /tmp/pi05-health.json
    echo
    exit 0
  fi
  if ! kill -0 "$(cat logs/pi05_server.pid)" 2>/dev/null; then
    echo '=== SERVER EXITED ==='
    tail -n 120 logs/pi05_server.log
    exit 30
  fi
  if (( attempt % 6 == 0 )); then
    echo "waiting for model server: $((attempt * poll_interval_seconds))s / ${startup_timeout_seconds}s"
    tail -n 8 logs/pi05_server.log || true
  fi
  sleep "$poll_interval_seconds"
done

echo '=== TIMEOUT WAITING FOR SERVER ==='
tail -n 160 logs/pi05_server.log
exit 31
