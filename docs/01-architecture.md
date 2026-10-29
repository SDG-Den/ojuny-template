# 01 - Architecture

This document defines the repo layout, naming and numbering rules, the
dendritic module shape, and how a file maps to a settings-menu page. See
`02-settings-menu.md` for the page list itself.

## 1. Dendritic pattern

Same as dendrite: flake-parts plus import-tree.

`flake.nix` collects every `.nix` file under `modules/` (recursively, skipping
`flake.nix`, files whose name starts with `_`, and hidden directories) and
treats each as a flake-parts module. A page file therefore is a flake-parts
module that declares one or more of:

- `flake.modules.nixos.<page>`
- `flake.modules.homeManager.<page>`

A host configuration (`flake.nixosConfigurations.<host>`) imports the pages it
wants via `self.modules.nixos.<page>`. Because the nix-settings-gui follows the
import graph for its "current system only" mode, the host's imports are what
decide which menus are shown for that host.

## 2. Page file shape

Each page file has a `@menu` header and one or more inner modules. The `@menu`
comment sits before the first `flake.modules.*` assignment. `@option` comments
sit inside the inner module, directly above the assignment they describe.

```nix
{ self, inputs, ... }:
{
  /* @menu
     displayname = "Bluetooth";
     icon = "bluetooth-symbolic";
     order = 40;
     description = "Bluetooth devices and power";
     category = "07-System";
  */
  flake.modules.nixos.system-bluetooth = { config, pkgs, ... }: {
    /* @option widget = "switch"; label = "Enable Bluetooth"; */
    hardware.bluetooth.enable = true;

    /* @option widget = "switch"; label = "Power on at boot";
       group = "Devices"; */
    hardware.bluetooth.powerOnBoot = true;
  };
}
```

A page that also needs home-manager settings declares a second module in the
same file:

```nix
  flake.modules.homeManager.system-bluetooth-hm = { ... }: {
    /* @option ... */
    home.packages = [ ... ];
  };
```

Both modules live in one file so the page stays self-contained.

## 3. Shared settings and namespaces

- `desktop.ojuny.*` comes from ojuny-desktop and is consumed by the Desktop
  pages (mango, Dux Shell) without local renaming. The naming is deliberately
  split three ways: the product is Dux Shell, every upstream runtime
  identifier stays `dms` (the `dms` binary, `~/.config/dms`,
  `~/.local/state/dms`, `dms ipc call ...`, `dms.service`), and the option
  namespace is `desktop.ojuny.dux.*`, with a one-release alias for
  `desktop.ojuny.dux.*`. The CLI surface is `ojuny dux ...`; `ojuny dms` is a
  deprecated alias.
- Template-local options (for values used across pages, e.g. the user name,
  hostname, enabled-app toggles) are declared under a top-level `ojuny.*`
  namespace (D3a). A page may instead annotate the real NixOS or home-manager
  option directly; this is preferred when the value is used only on that page.

## 4. Layout and numbering

```
ojuny-template/
  flake.nix                 dendritic entrypoint (import-tree ./modules)
  flake.lock
  docs/                     this spec
  modules/
    01-users/
    02-core/
    03-desktop/
    04-gui/
    05-applications/
    06-utility/
    07-system/
  templates/                nix-settings-gui "Add file" scaffolds (_-prefixed)
  scripts/                  setup script + helpers
  packages/                 any local packages
```

Rules:

- Category folders are numbered `01-`, `02-`, ... to order the repository
  tree; page files are numbered within their folder.
- The GUI does not read folder or file names. It sorts menus by the `@menu`
  `category` string, then by `@menu order`, then by `displayname`.
- `@menu category` is an explicit string carrying its own sort prefix (for
  example `"07-System"`); the GUI prints it verbatim as the section heading.
  Because sorting is ASCII, prefixes `01-` ... `07-` precede unprefixed names
  such as `Patches`.
- `@menu order` is the page's position within its category (for example `40`),
  independent of the file number.

The numbering currently applied (see `02-settings-menu.md` for meanings):

```
01-users/         01-user.nix  02-commonsettings.nix
02-core/          00-colors.nix  01-display.nix  02-input.nix  03-binds.nix
                  04-gestures.nix  05-theme.nix  05-typography.nix
                  05-compositor.nix  05-shell.nix  06-browser.nix  07-git.nix
                  08-terminal.nix  09-autostart.nix  10-updates.nix
                  11-nixsettings.nix  12-audio.nix
03-desktop/       00-mango.nix  01-login.nix  02-mangosettings.nix
                  03-mangomaster.nix  04-mangodwindle.nix  05-scroller.nix
                  06-mangoworkspaces.nix  07-notifications.nix
                  08-clipboard.nix  09-osd.nix  10-sounds.nix
                  11-screensaver.nix  13-monocle-deck.nix
04-gui/           01-bar.nix  02-dock.nix  03-launcher.nix  04-dashboard.nix
                  05-controlcenter.nix  06-menu.nix
05-applications/  01-applist.nix  02-multimedia.nix  03-office.nix
                  04-vesktop.nix  05-steam.nix  06-kdeconnect.nix
                  07-screenshot.nix
06-utility/       00-dux-tools.nix  01-webapps.nix  02-plugins.nix
07-system/        00-hardware.nix  00-host.nix  00-imports.nix  00-ssh-test.nix
                  01-configuration.nix  02-networking.nix  03-bluetooth.nix
                  04-graphics.nix  05-power.nix  06-lock.nix  07-plymouth.nix
patches/          00-patches.nix  01-patch-development.nix
                  02-patch-flatpak.nix  03-patch-docker.nix
                  04-patch-virtualization.nix  05-patch-nixshell.nix
```

Files marked `[no menu]` in 02 carry no `@menu` header and are skipped by the
scanner: `03-desktop/00-mango.nix` and generated `07-system/00-hardware.nix`.

## 5. Generated and templated files

The setup script (see `03-host-setup.md`) writes machine-specific files. These
are the only tracked files that may contain personal data, and they are
generated or templated, not hand-written:

- `modules/07-system/00-hardware.nix` and `modules/07-system/facter.json`:
  generated by the script from the host's detected hardware and a
  `nixos-facter` report. The hardware module carries no `@menu` header
  (D5, D6a).
- `modules/01-users/01-user.nix`: templated and filled by the script, shipped
  with a neutral `user` account. The Users widget manages `users.users` and,
  with `homeManager = true`, the sibling `home-manager.users` block (D13, D17).
- All of `07-system/`, except `00-hardware.nix`, is templated so a second
  system can be made by replicating and editing the system directory (D13).

## 6. Flake outputs

- `nixosConfigurations.<host>` for each host (initially one host generated by
  the setup script).
- `nixosModules.default`, `homeManagerModules.default` re-exported from
  ojuny-desktop (so the template can also be consumed as a module).
- `packages.*` for any local packages.

## 7. Relation to other repos

- **ojuny-desktop** is an input; it supplies mangoWM, Dux Shell, and the
  `desktop.ojuny.dux.*` options plus the wrapped session package.
- **nix-settings-gui** is an input; enabling it installs the GUI
  (`services.nix-settings-gui.enable`) and it renders one menu per page file.
- **nix-shell-gui** is an input (`services.nix-shell-gui.enable`) and
  **nix-regedit** is an input (`services.nix-regedit.enable`); both are placed
  in `02-core/11-nixsettings.nix`.
- **simple-nix-update-gui** is an input
  (`services.simple-nix-update-gui.*`), placed in `02-core/10-updates.nix`
  together with nix-settings-gui.

## 8. Resolved decisions

- D3a template options under top-level `ojuny.*`.
- D5 no `@menu` header means the file is not a menu; unannotated values are
  never shown.
- D6a generated/templated files live under `modules/`; `hardware.nix` is not a
  menu.
- D7a one file declares the nixos and/or home-manager module it needs.
- D13a system-specific settings in the system directory, per-user settings in
  that user's `user.nix`; all system files templated except generated
  `hardware.nix`.
- T1 the template includes nix-settings-gui, nix-regedit, nix-shell-gui, and
  simple-nix-update-gui; dendrite-menu is dropped.
- T2 nix-shell-gui and nix-regedit in `06-nixsettings.nix`; nix-settings-gui
  and simple-nix-update-gui in `07-updates.nix`.

Open: none.
