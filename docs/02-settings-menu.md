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
| `02-Core` | display, input, binds, gestures, theme, typography, compositor, shell, browser, git, terminal, autostart, updates, nixsettings, audio |
| `03-Desktop` | login, mangosettings, mangomaster, mangodwindle, scroller, mangoworkspaces, notifications, screensaver, clipboard, monocle-deck |
| `04-GUI` | bar, dock, launcher, dashboard, controlcenter, menu |
| `05-Applications` | applist, screenshot, multimedia, office, vesktop, steam, kdeconnect |
| `06-Utility` | dux-tools, webapps, plugins |
| `07-System` | configuration, networking, bluetooth, graphics, plymouth |
| `Patches` | patch-development, patch-flatpak, patch-docker, patch-virtualization, patch-nixshell |

Pages marked "(proposed)" below are additions to the scaffold and are the
current working set for review.

## 4. Pages

### 01-users

- `01-user.nix` `[menu]`. The user accounts and their home-manager settings.
  The `users` widget manages `users.users`; with `homeManager = true` it also
  manages the sibling `home-manager.users` block. The setup script seeds a
  neutral `user` account, and additional accounts are added in the GUI. The
  editor default is global, not per-user.
- `02-commonsettings.nix` `[menu]`. User settings that apply to all users:
  shared home-manager modules and shared user preferences (D8).

### 02-core

- `00-colors.nix` `[no menu]`. Named color helpers derived from the stylix
  palette.
- `01-display.nix` `[menu]`. Monitors, tearing and HDR.
- `02-input.nix` `[menu]`. Keyboard, mouse, trackpad, touch and Fcitx5 input
  methods.
- `03-binds.nix` `[menu]`. Key, mouse, axis and gesture bindings.
- `04-gestures.nix` `[menu]`. Touchpad swipe gestures and swipe tuning.
- `05-theme.nix` `[menu]`. Palette, polarity, popup opacity and wallpaper.
- `05-typography.nix` `[menu]`. Fonts, shell text rendering, icon themes and
  cursors.
- `05-compositor.nix` `[menu]` "Compositor looks". Gaps, borders, corner
  radius, mango blur, shadows, decoration, animations and app theming.
- `05-shell.nix` `[menu]` "Shell looks". Interface shape and density, surface
  blur, floating windows, motion, surfaces and color modes for Dux Shell.
- `06-browser.nix` `[menu]`. Web browser, default browser and MIME
  associations; file manager and remote scheme defaults live on the
  Applications page and point at dux-files.
- `07-git.nix` `[menu]`. Git and version control defaults.
- `08-terminal.nix` `[menu]`. Terminal emulator, zsh, aliases and btop.
- `09-autostart.nix` `[menu]`. Commands run at login and on reload.
- `10-updates.nix` `[menu]`. Update tooling and automatic update checks.
- `11-nixsettings.nix` `[menu]`. Nix tooling, `nix-shell-gui`, `nix-regedit`
  and the LAN cache. The LAN cache controls enable the shared store cache,
  expose its port and scan ranges, and offer "Use only the LAN cache". While
  that toggle is on, the substituter list is hidden because the local daemon
  replaces it and fetches upstream paths itself.

### 03-desktop

- `00-mango.nix` `[no menu]`. Under-the-hood mangoWM + Dux Shell session
  switch (D5).
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

- `01-bar.nix` `[menu]`. Bar layout, widgets and island style. Preset
  definitions move out of this template into ojuny-desktop; what stays here is
  the preset dropdown (`ojuny.dux.barPreset`), the custom bar editor
  (`ojuny.dux.customBar`) and the `@widget-preset` catalog.
- `02-dock.nix` `[menu]`. Dock appearance and behaviour.
- `03-launcher.nix` `[menu]`. App launcher style, behaviour and plugin
  triggers.
- `04-dashboard.nix` `[menu]`. Dashboard cards, tabs and their placement.
- `05-controlcenter.nix` `[menu]`. Control center widgets and layout.
- `06-menu.nix` `[menu]`. Nix managed application menu.

### 05-applications

- `01-applist.nix` `[menu]`. Applications installed system-wide (D8),
  including dux-files (`dfiles`) as the default file browser, which replaces
  Nautilus.
- `07-screenshot.nix` `[menu]`. satty, OCR, the capture wrappers and the
  screenshot keybinds. The binds live in the always-active common mode.
- `02-multimedia.nix` `[menu]`. Viewers (media player, image viewer) and tools
  (OBS, Audacity, GIMP, satty).
- `03-office.nix` `[menu]`. Office suite, document tools, ArtCraft apps and
  Obsidian notes.
- `04-vesktop.nix` `[menu]`. Discord client.
- `05-steam.nix` `[menu]`. Steam and gaming (D12).
- `06-kdeconnect.nix` `[menu]`. Phone notifications, file transfer and
  remote input.

### 06-utility

- `00-dux-tools.nix` `[menu]`. dsearch, Dux Files, Dux Calendar and dgop.
- `01-webapps.nix` `[menu]`. Chromium based web applications.
- `02-plugins.nix` `[menu]`. Dux Shell plugins that ship with this desktop.

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

Registry patches available from `ojuny-patches`:

- `patch-local-llm`. llama-cpp-turboquant or Ollama, Gemma 4 models, OpenCode
  harness, LSPs, agent presets and the `ojuny-troubleshoot` CLI.
- `patch-retroarch`. RetroArch, libretro cores, assets and a default config.
- `patch-geforce-now`. NVIDIA's native GeForce NOW Flatpak.
- `patch-moonlight-sunshine`. Moonlight client and an optional Sunshine host.
- `patch-prismlauncher`. Prism Launcher for Minecraft.
- `patch-aux-hardware`. Fingerprint, OpenTabletDriver and FIDO2 support.
- `patch-home-snapshots`. Scheduled restic snapshots of `/home` only.

## Coverage ledger

[Dux Shell settings coverage](dux-settings-coverage.md) is the row ledger for the migration. The machine-readable copy is [dux-settings-coverage.csv](dux-settings-coverage.csv).

At migration time 496 of 1418 rows are covered under `desktop.ojuny.dux`. Each row is in one of four states: covered, stylix-owned through an exposed stylix option, deferred with a phase in the coverage document, or unexposed with a stated reason. A row marked uncovered in the ledger is not claimed as covered here.

## 5. Resolved decisions

- D1a mangoWM + Dux Shell only.
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
- D12 Steam built in; Prism Launcher through `patch-prismlauncher`.
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
