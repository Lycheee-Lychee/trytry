#!/usr/bin/env bash
set -euo pipefail
echo '=== matching processes ==='
pgrep -af 'vla-eval serve|model_servers/lerobot.py' || true
echo '=== port 8000 ==='
ss -ltnp 'sport = :8000' || true
echo '=== log tail ==='
tail -n 40 "$HOME/research/vla-evaluation-harness/logs/pi05_server.log" || true
