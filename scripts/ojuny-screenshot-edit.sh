#!/usr/bin/env bash
set -euo pipefail

mode="${1:-region}"
metadata="$(dms screenshot "$mode" --no-clipboard --no-notify --json)"
path="$(printf '%s' "$metadata" | jq -r '.path // empty')"

[ -n "$path" ] || exit 0

exec satty --filename "$path" --output-filename "$path" --copy-to-clipboard
