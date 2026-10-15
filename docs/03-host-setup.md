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
   - username (default den, D17)
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

1. Detect whether running NixOS. If yes, offer to import the existing
   `/etc/nixos/hardware-configuration.nix`; otherwise call
   `nixos-generate-config`.
2. Ask for hostname. Write it to `04-system/01-configuration.nix`
   (`networking.hostName`).
3. Ask for user details, write `01-users/01-user.nix`.
4. Ask which Applications pages to enable (writes the host imports).
5. Print next steps: `git add`, then the rebuild command with the feature flag.
   The script does not run the rebuild (D16).

## 4. Safety

- Never overwrite an existing `hardware.nix` or `user.nix` without an explicit
  confirmation flag.
- Refuse to embed a plaintext password; store only the hash.
- Keep every generated value out of the tracked defaults so a fresh fork
  contains no personal data.

## 5. Fresh Nix install requirements

The script must run against a freshly installed Nix or NixOS, where
`nix-command` and `flakes` are not yet enabled. A fresh install rejects every
flake command with `experimental Nix feature 'nix-command' is disabled`.

- Every `nix` invocation the script makes must pass
  `--extra-experimental-features 'nix-command flakes'`, for example
  `nix --extra-experimental-features 'nix-command flakes' build ...`.
- The same flag must be added to the printed `nixos-rebuild` next step, for
  example `nixos-rebuild switch --flake .#<host>
  --extra-experimental-features 'nix-command flakes'`.
- The script does not write `nix.conf`. Once the generated config is applied,
  `nix.settings.experimental-features` in `04-system/06-nixsettings.nix` enables
  the features permanently, so the flag is only needed until first apply
  (D18a).
- `nixos-generate-config` (from the NixOS install) is assumed present when the
  script runs on NixOS. When running on a non-NixOS Nix install, the script
  must fall back to reading an existing `hardware-configuration.nix` or ask the
  user to supply hardware data.

## 6. Packaging

- Location: `scripts/setup.sh` (portable bash), exposed as `nix run .#setup` via
  a `perSystem` app that wraps the script with the needed tools
  (`nixos-generate-config`, `mkpasswd`, `nix`) (D14a).

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
- D16 the script does not run `nixos-rebuild`.
- D18a experimental-features flag on every nix call until the applied config
  enables the features permanently.
