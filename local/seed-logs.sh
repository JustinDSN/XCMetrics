#!/usr/bin/env bash
# Integration branch only. Uploads .xcactivitylog files into the local stack.
#
# The XCMetrics client evicts old .xcactivitylog files from the directory it is
# pointed at, so this script always COPIES logs into a scratch staging tree
# first. Never point --buildDir at a directory whose logs you want to keep.
#
#   usage: local/seed-logs.sh <project-name> <path-to-log> [<path-to-log> ...]
set -euo pipefail

SERVICE_URL="${SERVICE_URL:-http://localhost:8080/v1/metrics}"
CLI="${CLI:-.build/release/xcmetrics}"
STAGE_ROOT="${STAGE_ROOT:-/tmp/xcm-seed}"

[ $# -ge 2 ] && [ -x "$CLI" ] || {
  echo "usage: $0 <project-name> <log> [log ...]" >&2
  [ -x "$CLI" ] || echo "error: $CLI not found — run 'swift build -c release' first" >&2
  exit 1
}

project="$1"; shift
stage="$STAGE_ROOT/$project"
mkdir -p "$stage/Build/Products" "$stage/Logs/Build"

for log in "$@"; do
  [ -f "$log" ] || { echo "error: no such log: $log" >&2; exit 1; }
  cp "$log" "$stage/Logs/Build/$(basename "$log")"
  echo "staged $(basename "$log")"
done

"$CLI" --name "$project" --buildDir "$stage/Build/Products" \
       --serviceURL "$SERVICE_URL" --timeout 3
echo "uploaded to $SERVICE_URL as project '$project'"
