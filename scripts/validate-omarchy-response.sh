#!/usr/bin/env bash
set -euo pipefail

template="${HOME}/repos/ojuny-template"
installer="${HOME}/repos/ojuny-installer"
patches="${HOME}/repos/ojuny-patches"

cd "$template"
nix flake check
nix build .#prepare-repo .#regenerate-hardware --no-link

cd "$installer"
nix flake check
nix build .#ojuny-iso .#unattended-iso --no-link

cd "$patches"
for patch in modules/patches/patch-*.nix; do
  nix-instantiate --parse "$patch" > /dev/null
done
