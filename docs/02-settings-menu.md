# 02 - Settings menu

The master page taxonomy. Every page is one file. A file with an `@menu`
header becomes a menu in nix-settings-gui; a file without one is skipped by
the scanner and is used for under-the-hood settings. This document defines what
each page contains and is the spec the repo is built from.

## 1. Menu model recap (from nix-settings-gui)

- One `.nix` file equals one menu, and only if it has an `@menu` header.
- `/* @menu ... */` sets `displayname`, `icon`, `order`, `description`,
  `category`, `systems`, `hidden`.
- `/* @option ... */` above an assignment sets `widget`, `label`,
  `description`, `group`, `order`, `choices`, `min`, `max`, `step`, `unit`,
  `advanced`, `hidden`, `readonly`, `nullable`, and list helpers.
- Assignments without an `@option` comment are not exposed as controls.
- Widgets: `switch`, `dropdown`, `radio`, `spin`, `slider`, `text`,
  `multiline`, `path`, `package`, `packages`, `list`, `color`, `submodule`,
  `raw`.
- Type, description, default, and choices come from nixd (fallback `nix eval`),
  so a page only needs the assignment plus the `@option` comment.

## 2. Non-menu files (D5)

- A file with no `@menu` header is ignored by the scanner. Use this for
  under-the-hood settings that should not be user-edited.
- `02-desktop/01-mango.nix` is the under-the-hood mango file.
- `04-system/02-hardware.nix` is generated and has no menu.
- Values that must never be changed (for example `system.stateVersion`) live
  in a menu file but carry no `@option` comment, so they are never shown.

## 3. Category map (final)

Categories are explicit strings in each page's `@menu` header. The GUI prints
the `category` string verbatim as the section heading and sorts categories by
that string, so the numeric prefix both orders the headings and is shown.
Sorting is ASCII, so `01-` ... `07-` precede unprefixed names such as
`Patches`. Physical folders keep their original grouping and do not set the
category; the `@menu` `category` string is authoritative.

| Category | Pages |
|----------|-------|
| `01-Users` | user, commonsettings |
| `02-Core` | display, input, binds, gestures, style, browser, git, terminal, autostart, updates, nixsettings |
| `03-Desktop` | login, mangosettings, mangomaster, mangodwindle, scroller, mangoworkspaces, notifications |
| `04-GUI` | bar, dock, launcher, dashboard, controlcenter, menu |
| `05-Applications` | applist, multimedia, office, vesktop, steam |
| `06-Utility` | webapps, plugins, phoneconnect |
| `07-System` | configuration, networking, bluetooth, graphics |
| `Patches` | patch-development |

Pages marked "(proposed)" below are additions to the scaffold and are the
current working set for review.

## 4. Pages

### 01-users

- `01-user.nix` `[menu]`. The account and its home. Everything specific to one
  user lives here (D13). Templated, filled by the setup script, shipped as a
  neutral `user` account. Options: `users.users.<name>.*` (isNormalUser, description,
  extraGroups, shell, hashedPassword, openssh keys) and `home.*`.
- `02-commonsettings.nix` `[menu]`. User settings that apply to all users:
  shared home-manager modules and shared user preferences (D8).
- `03-shell.nix` `[menu]` (proposed). zsh, oh-my-zsh, autosuggestions, syntax
  highlighting, powerlevel10k, aliases, fastfetch (default `fastfetch-den`)
  (D11, D17).

### 02-desktop

- `01-mango.nix` `[no menu]`. Under-the-hood mangoWM: session enable, internals,
  gesture internals (D5). Not user-edited.
- `02-mangosettings.nix` `[menu]`. `[global]`/`[env]`/`[var]`: input, mouse,
  trackpad, touch, focus, tags, window behaviour, appearance. Workspace/tag
  behaviour folds in here.
- `03-display.nix` `[menu]`. Monitor/output rules, resolution, scale, position,
  night mode.
- `04-style.nix` `[menu]`. Theming: stylix (enable, polarity, scheme,
  wallpaper, icons, cursor), DMS appearance keys, and fonts (D11). Wallpaper
  folds in here.
- `05-bar.nix` `[menu]`. DMS `barConfigs`.
- `06-dock.nix` `[menu]`. DMS `dockConfigs`.
- `07-launcher.nix` `[menu]`. DMS launcher/spotlight.
- `08-dashboard.nix` `[menu]`. DMS dash tabs, cards, options, control center.
- `09-notifications.nix` `[menu]`. DMS notifications and OSD.
- `10-menu.nix` `[menu]`. DMS application menu (`dankMenu.settings`).
- `11-plugins.nix` `[menu]`. DMS plugins and built-in plugin settings.
- `12-phoneconnect.nix` `[menu]`. KDE Connect via DMS.
- `13-binds.nix` `[menu]`. mango keybinds (binds, mousebind, axisbind,
  gesturebind).
- `14-autostart.nix` `[menu]`. mango exec/execOnce/source and session
  autostart.
- `15-windowrules.nix` `[menu]` (proposed). `desktop.ojuny.mango.rules.*` as a
  submodule list, since ojuny exposes rules menu-friendly.
- `16-login.nix` `[menu]` (proposed). Greeter and autologin (D9).
- `17-clipboard.nix` `[menu]` (proposed). DMS clipboard (`clsettings.json`).

Lockscreen is merged into the System `12-power.nix` page (idle, suspend, lock).

### 03-applications

- `01-applist.nix` `[menu]`. `environment.systemPackages` and simple installs
  (btop and similar), plus toggles for every app the ojuny-desktop extra-apps
  toggle provides (D8).
- `02-browser.nix` `[menu]`. firefox, zen, default-browser mime associations,
  extensions.
- `03-git.nix` `[menu]`. git enable, user identity, aliases, ssh startAgent.
- `04-multimedia.nix` `[menu]`. vlc, obs-studio.
- `05-office.nix` `[menu]`. libreoffice, hunspell, dictionaries.
- `06-vesktop.nix` `[menu]`. vesktop.
- `07-steam.nix` `[menu]`. steam and compat packages only (D12).
- `08-terminal.nix` `[menu]` (proposed). ghostty and terminal config (D11).
- `09-development.nix` `[menu]` (proposed). vscodium, editors, clang tools.
- `10-filemanager.nix` `[menu]` (proposed). nautilus and default file manager.
- `11-webapps.nix` `[menu]` (proposed). chromium-webapps entries.
- `12-notes.nix` `[menu]` (proposed). obsidian.
- `13-flatpak.nix` `[menu]` (proposed). flatpak and bazaar.
- `14-virtualization.nix` `[menu]` (proposed). libvirtd/virt-manager,
  podman/distrobox.

### 04-system

System-specific settings live here. A multi-system flake replicates and edits
this directory per system (D13).

- `01-configuration.nix` `[menu]`. Hostname, timezone, locale, boot, kernel,
  `hardware.graphics.enable`. `system.stateVersion` present but unannotated,
  never exposed (D15).
- `02-hardware.nix` `[no menu]` (generated). Filesystems, swap, kernel modules,
  microcode, hostPlatform (D5, D6).
- `03-networking.nix` `[menu]`. NetworkManager, firewall, hosts, DNS.
- `04-bluetooth.nix` `[menu]`. bluetooth enable/power.
- `05-graphics.nix` `[menu]`. GPU vendor selection (intel/amd/nvidia).
- `06-nixsettings.nix` `[menu]`. Nix daemon/flakes settings and nix tooling:
  the `nix-shell-gui` install (`services.nix-shell-gui.enable`) and
  `nix-regedit` (`services.nix-regedit.enable`).
- `07-updates.nix` `[menu]` (proposed). All update tooling: the
  `nix-settings-gui` install (`services.nix-settings-gui.enable`) and
  `simple-nix-update-gui` (`services.simple-nix-update-gui.*`: flakeUri,
  checkInterval, autoNotify, useNom, trayAutostart, clonePath) (D10).
- `08-audio.nix` `[menu]` (proposed). pipewire, pulse, rtkit.
- `09-printing.nix` `[menu]` (proposed). CUPS.
- `10-ssh.nix` `[menu]` (proposed). openssh daemon and client.
- `11-security.nix` `[menu]` (proposed). polkit, firewall policy, ydotool.
- `12-power.nix` `[menu]` (proposed). Power management and the lock screen:
  TLP/power profiles, idle, suspend, and lock-on-lock behaviour.
- `13-xserver.nix` `[menu]` (proposed). X11 enable, xkb layout/variant.

## 5. Resolved decisions

- D1a mangoWM + DMS only.
- D2a manual install, generated `hardware.nix` only.
- D3a template options under top-level `ojuny.*`.
- D4 page set as listed above (proposed pages under review).
- D5 no `@menu` means not a menu; unannotated values never shown.
- D6a generated files kept in `modules/`, `hardware.nix` is not a menu.
- D7a one file declares the nixos and/or home-manager module it needs.
- D8 commonsettings and applist as defined.
- D9a dedicated login page.
- D10 all update tooling in `07-updates.nix`.
- D11a shell in `01-users/03-shell.nix`, ghostty in `03-applications/08-terminal.nix`,
  fonts in `02-desktop/04-style.nix`.
- D12 steam only.
- D13 system-specific settings in the system directory; per-user settings in
  that user's `user.nix`; all system files templated except generated
  `hardware.nix`.
- D14a bash setup script.
- D15a stateVersion never exposed.
- D16 no rebuild from the script.
- D17 fastfetch included, default `fastfetch-den`, `user` as default user.
- D18a experimental-features flag on every nix call until the applied config
  enables the features permanently.
- T1 the template includes nix-settings-gui, nix-regedit, nix-shell-gui, and
  simple-nix-update-gui; dendrite-menu is dropped.
- T2 nix-shell-gui and nix-regedit in `06-nixsettings.nix`; nix-settings-gui
  and simple-nix-update-gui in `07-updates.nix`.
- Lockscreen merged into `12-power.nix`.
- Fold confirmations: wallpaper into `04-style.nix`, workspaces into
  `02-mangosettings.nix`, OSD into `09-notifications.nix`.

## 6. Remaining open

- Confirm the proposed pages to include.
