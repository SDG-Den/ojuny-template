#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${OJUNY_ROOT:-$PWD}"
CONFIG="$REPO_ROOT/modules/04-system/01-configuration.nix"
HOST_MODULE="$REPO_ROOT/modules/04-system/00-host.nix"

for arg in "$@"; do
  case "$arg" in
  --force) ;;
  *)
    echo "create-new-system: unknown argument: $arg" >&2
    exit 2
    ;;
  esac
done

read -rp "Hostname [ojuny]: " hostname
hostname="${hostname:-ojuny}"

if [ -f "$CONFIG" ]; then
  sed -i "s|^\( *\)networking\.hostName = .*;|\1networking.hostName = \"$hostname\";|" "$CONFIG"
  echo "create-new-system: set networking.hostName in $CONFIG"
else
  echo "create-new-system: $CONFIG not found, skipping hostname" >&2
fi

{
  cat <<EOF
{ self, inputs, ... }: {

  flake.nixosConfigurations.$hostname = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ self.modules.nixos.host-imports ];
  };

}
EOF
} >"$HOST_MODULE"

echo "create-new-system: wrote $HOST_MODULE (nixosConfigurations.$hostname)"
