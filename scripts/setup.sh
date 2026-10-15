#!/usr/bin/env bash
set -euo pipefail

echo "==> generate-hw: hardware module"
generate-hw "$@"

echo "==> generate-user: account module"
generate-user "$@"

echo "==> create-new-system: host wiring"
create-new-system "$@"

cat <<'EOF'

Setup complete.

Next steps:
  1. Review the generated modules under modules/.
  2. git add .
  3. Build and switch, for example:
       nixos-rebuild switch --flake .#<hostname> \
         --extra-experimental-features 'nix-command flakes'
EOF
