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
     category = "System";
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

- `desktop.ojuny.*` comes from ojuny-desktop and is used unchanged by the
  Desktop pages (mango, DMS).
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
    02-desktop/
    03-applications/
    04-system/
  templates/                nix-settings-gui "Add file" scaffolds (_-prefixed)
  scripts/                  setup script + helpers
  packages/                 any local packages
```

Rules:

- Category folders are numbered `01-`, `02-`, ... in the order they should
  appear in the GUI.
- Page files are numbered within their folder, `01-`, `02-`, ... in the order
  they should appear within the category.
- The numbers exist only to order vscodium and the GUI list. The visible label
  is the `@menu` `displayname`, which never contains numbers.
- `@menu category` is set from the folder's GUI label (for example `"System"`),
  and `@menu order` is set from the file number (for example `40`), so GUI
  ordering does not depend on file scanning order.

The numbering currently applied (see `02-settings-menu.md` for meanings):

```
01-users/         01-user.nix  02-commonsettings.nix  03-shell.nix
02-desktop/       01-mango.nix  02-mangosettings.nix  03-display.nix
                  04-style.nix  05-bar.nix  06-dock.nix  07-launcher.nix
                  08-dashboard.nix  09-notifications.nix  10-menu.nix
                  11-plugins.nix  12-phoneconnect.nix  13-binds.nix
                  14-autostart.nix  15-windowrules.nix  16-login.nix
                  17-clipboard.nix
03-applications/  01-applist.nix  02-browser.nix  03-git.nix
                  04-multimedia.nix  05-office.nix  06-vesktop.nix
                  07-steam.nix  08-terminal.nix  09-development.nix
                  10-filemanager.nix  11-webapps.nix  12-notes.nix
                  13-flatpak.nix  14-virtualization.nix
04-system/        01-configuration.nix  02-hardware.nix  03-networking.nix
                  04-bluetooth.nix  05-graphics.nix  06-nixsettings.nix
                  07-updates.nix  08-audio.nix  09-printing.nix
                  10-ssh.nix  11-security.nix  12-power.nix  13-xserver.nix
```

Files marked `[no menu]` in 02 carry no `@menu` header and are skipped by the
scanner: `02-desktop/01-mango.nix` and generated `04-system/02-hardware.nix`.

## 5. Generated and templated files

The setup script (see `03-host-setup.md`) writes machine-specific files. These
are the only tracked files that may contain personal data, and they are
generated or templated, not hand-written:

- `modules/04-system/02-hardware.nix`: generated by the script from the host's
  detected hardware, and the only file that is generated rather than templated.
  It carries no `@menu` header (D5, D6a).
- `modules/01-users/01-user.nix`: templated and filled by the script, defaults
  modeled on den (D13, D17).
- All of `04-system/`, except `02-hardware.nix`, is templated so a second
  system can be made by replicating and editing the system directory (D13).

## 6. Flake outputs

- `nixosConfigurations.<host>` for each host (initially one host generated by
  the setup script).
- `nixosModules.default`, `homeManagerModules.default` re-exported from
  ojuny-desktop (so the template can also be consumed as a module).
- `packages.*` for any local packages.

## 7. Relation to other repos

- **ojuny-desktop** is an input; it supplies mangoWM, DMS, and the
  `desktop.ojuny.*` options plus the wrapped session package.
- **nix-settings-gui** is an input; enabling it installs the GUI
  (`services.nix-settings-gui.enable`) and it renders one menu per page file.
- **nix-shell-gui** is an input (`services.nix-shell-gui.enable`) and
  **nix-regedit** is an input (`services.nix-regedit.enable`); both are placed
  in `04-system/06-nixsettings.nix`.
- **simple-nix-update-gui** is an input
  (`services.simple-nix-update-gui.*`), placed in `04-system/07-updates.nix`
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
