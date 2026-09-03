#!/usr/bin/env bash
set -euo pipefail

workspace_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log_file="$workspace_dir/smoke_auto.log"

exec >>"$log_file" 2>&1
echo "=== watcher started: $(date --iso-8601=seconds) ==="

for attempt in $(seq 1 1440); do
  if curl -fsS http://localhost:8000/health >/tmp/pi05-health.json 2>/dev/null; then
    echo "=== server healthy: $(date --iso-8601=seconds) ==="
    cat /tmp/pi05-health.json
    echo
    exec bash "$workspace_dir/run_libero_smoke.sh"
  fi
  sleep 5
done

echo "ERROR: model server did not become healthy within two hours" >&2
exit 31
