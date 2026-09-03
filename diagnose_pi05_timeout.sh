#!/usr/bin/env bash
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
repo="$HOME/research/vla-evaluation-harness"
cd "$repo"
echo '=== server process ==='
pid=$(cat logs/pi05_server.pid)
ps -o pid,etime,%cpu,%mem,cmd -p "$pid" || true
echo '=== GPU ==='
nvidia-smi
echo '=== server log tail ==='
tail -n 200 logs/pi05_server.log
echo '=== timeout settings ==='
grep -RIn --exclude-dir=.git -E 'act_timeout|request_timeout|timeout.*30' configs src | head -n 100 || true
echo '=== aggregate ==='
cat results/LIBEROBenchmark_aggregate.json
