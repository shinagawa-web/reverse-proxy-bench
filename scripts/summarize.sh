#!/bin/bash
set -e

echo "## Benchmark Results"
echo ""
echo "VU: 20 / Duration: 60s / Endpoint: \`/ping\`"
echo ""
echo "| Proxy | req/s | p50 (ms) | p95 (ms) | p99 (ms) | Error rate |"
echo "|-------|------:|---------:|---------:|---------:|-----------:|"

for proxy in nginx caddy traefik haproxy; do
  file="/tmp/bench-${proxy}.json"
  if [ -f "$file" ]; then
    rps=$(jq -r '.rps' "$file")
    p50=$(jq -r '.p50' "$file")
    p95=$(jq -r '.p95' "$file")
    p99=$(jq -r '.p99' "$file")
    errors=$(jq -r '.errors' "$file")
    echo "| \`$proxy\` | $rps | $p50 | $p95 | $p99 | $errors |"
  else
    echo "| \`$proxy\` | — | — | — | — | — |"
  fi
done

echo ""
cpu=$(nproc)
mem=$(awk '/MemTotal/ { printf "%.0f GB", $2/1024/1024 }' /proc/meminfo)
echo "> GitHub Actions runner: ubuntu-latest (${cpu} vCPU, ${mem} RAM)"
