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
- Assignments without an `@option` comment are not exposed as controls at the
  top level. Inside an annotated `submodule` block unannotated children are
  still scanned and rendered, so such a child must carry `hidden = true` (with
  Advanced off) to stay out of the GUI.
- Widgets: `switch`, `dropdown`, `radio`, `spin`, `slider`, `text`,
  `multiline`, `path`, `package`, `packages`, `list`, `color`, `submodule`,
  `raw`.
- Custom widgets: `bar`, `dock`, `menu`, `monitors`, `plugins`, `keybinds`,
  `theme`, `horizontal-submodule`, `table-attrset`, `table-list`.
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
| `03-Desktop` | login, mangosettings, mangomaster, mangodwindle, scroller, mangoworkspaces, notifications, screensaver, clipboard |
| `04-GUI` | bar, dock, launcher, dashboard, controlcenter, menu |
| `05-Applications` | applist, screenshot, multimedia, office, vesktop, steam, kdeconnect |
| `06-Utility` | webapps, plugins |
| `07-System` | configuration, networking, bluetooth, graphics, plymouth |
| `Patches` | patch-development, patch-flatpak, patch-docker, patch-virtualization, patch-nixshell |

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

### 02-core

- `00-colors.nix` `[no menu]`. Named color helpers derived from the stylix
  palette.
- `01-display.nix` `[menu]`. Monitors, tearing and HDR.
- `02-input.nix` `[menu]`. Keyboard, mouse, trackpad and touch.
- `03-binds.nix` `[menu]`. Key, mouse, axis and gesture bindings.
- `04-gestures.nix` `[menu]`. Touchpad swipe gestures and swipe tuning.
- `05-style.nix` `[menu]`. Theme, colors, fonts, gaps, borders, shadows and
  animations. Wallpaper folds in here: `ojuny.style.wallpaperPreset` accepts a
  bundled preset name or a custom image path. Preset artwork is recolored with
  the active palette; custom paths are used as-is and are copied into
  `modules/02-core/wallpapers` by the settings GUI.
- `06-browser.nix` `[menu]`. Web browser, default browser and MIME
  associations.
- `07-git.nix` `[menu]`. Git and version control defaults.
- `08-terminal.nix` `[menu]`. Terminal emulator, zsh, aliases and btop.
- `09-autostart.nix` `[menu]`. Commands run at login and on reload.
- `10-updates.nix` `[menu]`. Update tooling and automatic update checks.
- `11-nixsettings.nix` `[menu]`. Nix tooling, `nix-shell-gui` and `nix-regedit`.

### 03-desktop

- `00-mango.nix` `[no menu]`. Under-the-hood mangoWM + DMS session switch (D5).
- `01-login.nix` `[menu]`. Greeter and display manager (D9).
- `02-mangosettings.nix` `[menu]`. Layouts, focus, tiling and workspaces.
- `03-mangomaster.nix` `[menu]`. Master and stack layout.
- `04-mangodwindle.nix` `[menu]`. Dwindle tiling layout.
- `05-scroller.nix` `[menu]`. Horizontal scrolling window layout.
- `06-mangoworkspaces.nix` `[menu]`. Workspace and tag settings.
- `07-notifications.nix` `[menu]`. Notification popups.
- `08-clipboard.nix` `[menu]`. Clipboard history settings.
- `11-screensaver.nix` `[menu]`. Configurable ASCII screensaver command and idle timeout.

### 04-gui

- `01-bar.nix` `[menu]`. Bar layout, widgets and island style.
- `02-dock.nix` `[menu]`. Dock appearance and behaviour.
- `03-launcher.nix` `[menu]`. App launcher style, behaviour and plugin
  triggers.
- `04-dashboard.nix` `[menu]`. Dashboard cards, tabs and their placement.
- `05-controlcenter.nix` `[menu]`. Control center widgets and layout.
- `06-menu.nix` `[menu]`. Nix managed application menu.

### 05-applications

- `01-applist.nix` `[menu]`. Applications installed system-wide (D8).
- `07-screenshot.nix` `[menu]`. satty and the capture-and-annotate wrapper.
- `02-multimedia.nix` `[menu]`. Video, audio and image applications.
- `03-office.nix` `[menu]`. Office suite, document tools and ArtCraft apps.
- `04-vesktop.nix` `[menu]`. Discord client.
- `05-steam.nix` `[menu]`. Steam and gaming (D12).
- `06-kdeconnect.nix` `[menu]`. Phone notifications, file transfer and
  remote input.

### 06-utility

- `01-webapps.nix` `[menu]`. Chromium based web applications.
- `02-plugins.nix` `[menu]`. DMS plugins that ship with this desktop.

### 07-system

- `00-hardware.nix` `[no menu]` (generated). Filesystems, swap, kernel
  modules, microcode, hostPlatform (D5, D6).
- `00-host.nix` `[no menu]`. The host configuration: system and module list.
- `00-imports.nix` `[no menu]`. The import list that decides which pages a
  host loads.
- `00-ssh-test.nix` `[no menu]`. Temporary SSH test module.
- `01-configuration.nix` `[menu]`. Hostname, time zone, locale, console
  keymap and the patches switch. `system.stateVersion` present but never
  exposed (D15).
- `02-networking.nix` `[menu]`. NetworkManager, firewall, hosts, DNS.
- `03-bluetooth.nix` `[menu]`. Bluetooth pairing and services.
- `04-graphics.nix` `[menu]`. Graphics drivers, hybrid PRIME and hardware acceleration.
- `07-plymouth.nix` `[menu]`. Stylix-coloured Plymouth boot splash with the Ojuny logo.

### patches

- `00-patches.nix` `[no menu]`. Imports `patch-*` modules while
  `ojuny.patches` is enabled.
- `01-patch-development.nix` `[menu]`. Editors, language servers,
  formatters and develop-shell wrappers.
- `02-patch-flatpak.nix` `[menu]`. Flatpak service and the Bazaar app
  store.
- `03-patch-docker.nix` `[menu]`. Docker daemon, pruning and declarative
  containers added with the container snippet.
- `04-patch-virtualization.nix` `[menu]`. libvirt daemon, QEMU settings
  and virt-manager, with a qemu hook snippet.
- `05-patch-nixshell.nix` `[menu]`. Shell aliases that run `nix shell`
  with preset packages, with an alias snippet.

## 5. Resolved decisions

- D1a mangoWM + DMS only.
- D2a manual install, generated `hardware.nix` only.
- D3a template options under top-level `ojuny.*`.
- D4 page set as listed above (proposed pages under review).
- D5 no `@menu` means not a menu; unannotated values never shown at the top
  level (inside an annotated `submodule` block they still render unless
  `hidden = true`).
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
