# 03 - Host setup

Spec for the setup script that turns the template into a working config for a
given machine. It generates `hardware.nix` and `user.nix` and wires a host into
the flake.

## 1. Goals

- A forked template becomes bootable with minimal manual editing.
- All machine-specific and personal data is produced by the script, never
  committed by hand.
- The generated `user.nix` is an ordinary `.nix` module with `@menu` /
  `@option` comments, so it shows up in the settings GUI. The generated
  `hardware.nix` has no `@menu` header and is never a menu (D5, D6a).

## 2. What the script generates

1. `hardware.nix` - filesystems, swap, kernel modules, CPU microcode, host
   platform. Generated from `nixos-generate-config --show-hardware-config`, or
   copied from `/etc/nixos/hardware-configuration.nix` when already on NixOS.
   This is the only generated file and the only one that is not templated
   (D13a).
2. `user.nix` - the account and home-manager home, templated then filled by the
   script. Prompts for:
   - username (default `user`, D17)
   - description / full name
   - groups (default `networkmanager`, `wheel`, D15a)
   - shell (default zsh, D15a)
   - password (hashed via `mkpasswd -m yescrypt` or `-m sha-512`)
   - optional SSH authorized keys (paste, repeatable)
   - `home.stateVersion` only; `system.stateVersion` is written once and never
     exposed or prompted (D15a)
3. Host wiring - the single host imports the pages it uses plus the generated
   files, and `flake.nix` registers `nixosConfigurations.<hostname>`. All
   system-specific settings live in the system directory; making a second
   system means replicating and editing that directory (D13a).

## 3. Prompt flow

1. Clear the screen and print instructions for forking the template.
2. Ask for the git URL of the user's fork.
3. Ask where to clone it, defaulting to `~/repos/nix-flake`.
4. Clone the fork, then run `generate-hw`, `generate-user` and
   `create-new-system` with `--force` against the clone.
5. Ask whether to rebuild and reboot, rebuild only, or do neither. On rebuild,
   run `nixos-rebuild boot --flake <clone>#<host> --sudo` (D16).

## 4. Safety

- Never overwrite an existing `hardware.nix` or `user.nix` without an explicit
  confirmation flag.
- Refuse to embed a plaintext password; store only the hash.
- Keep every generated value out of the tracked defaults so a fresh fork
  contains no personal data.

## 5. Requirements

- `git` must be available on `PATH`; the script clones your fork with it.
- `nix-command` and `flakes` must be enabled before running the installer,
  for example `nix run github:SDG-Den/ojuny-template#setup`. On a fresh install
  they are off and every flake command fails with `experimental Nix feature
  'nix-command' is disabled`; enable them in `nix.conf`
  (`experimental-features = nix-command flakes`).
- The script itself does not call `nix`; the rebuild it offers runs
  `nixos-rebuild`, which enables the flake features internally and does not
  accept `--extra-experimental-features`. The flag is only needed for the
  `nix run` that starts the installer.
- `nixos-generate-config` (from the NixOS install) is assumed present when the
  script runs on NixOS. When running on a non-NixOS Nix install, the script
  must fall back to reading an existing `hardware-configuration.nix` or ask the
  user to supply hardware data.

## 6. Packaging

- Location: `scripts/setup.sh` (portable bash), exposed as `nix run .#setup` via
  a `perSystem` app that wraps the script with the needed tools (`git`,
  `nixos-generate-config`, `nixos-rebuild`, `mkpasswd`, `nix`) (D14a). The clone
  target defaults to `~/repos/nix-flake` and can be changed with the prompt or
  the `OJUNY_CLONE_DIR` environment variable.

## 7. Interaction with the GUI

- The generated `01-users/01-user.nix` carries `@menu` / `@option` comments so
  the user can adjust it in the GUI. The generated `04-system/02-hardware.nix`
  has no `@menu` header and never appears (D5, D6a).
- The script never edits files that the GUI owns (the hand-written page files);
  it only creates the generated file and fills the templates.

## 8. Resolved decisions

- D6a generated/templated files under `modules/`.
- D13a single system, system-specific settings in the system directory; a
  second system replicates that directory.
- D14a bash script (`scripts/setup.sh`) exposed as `nix run .#setup`.
- D15a `system.stateVersion` written once, never prompted or exposed; default
  groups `networkmanager wheel`; default shell zsh.
- D16 the script offers to run `nixos-rebuild boot` (and optionally reboot) at
  the end; the user can decline.
- D18a `nix-command` and `flakes` must be enabled to run the installer;
  `nixos-rebuild` enables them internally for the rebuild.
