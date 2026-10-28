# 04 - Scope

What is ported from dendrite (x1carbon config) and what is dropped. Source:
`~/repos/nixos-configs/dendrite`. Everything is regrouped into settings pages
per `02-settings-menu.md`.

## 1. In scope (ported, generalized)

| dendrite source | ojuny target |
|-----------------|--------------|
| `features/common.nix` | `04-system/01-configuration.nix` + `04-system/06-nixsettings.nix` |
| `features/audio.nix` | `04-system/audio.nix` (proposed) |
| `features/bluetooth.nix` | `04-system/04-bluetooth.nix` |
| `features/amd.nix`, `intel.nix`, `nvidia.nix` | `04-system/05-graphics.nix` |
| `features/flatpak.nix` | `patches/02-patch-flatpak.nix` |
| `features/ydotool.nix` | `04-system/security.nix` (proposed) |
| `features/mimetypes.nix` | `03-applications/02-browser.nix` + `03-applications/01-applist.nix` (default apps, file manager via dux-files) |
| `networking/default.nix` | `04-system/03-networking.nix` |
| `networking/ssh.nix` | `04-system/ssh.nix` (proposed) |
| `terminal/zsh.nix`, `aliases.nix` | `01-users/03-shell.nix` (proposed, D11) |
| `terminal/ghostty.nix` | `03-applications/08-terminal.nix` (proposed, D11) |
| `terminal/font.nix` | `02-desktop/04-style.nix` (fonts, D11) |
| `styles/stylix.nix` + one palette | `02-desktop/04-style.nix` |
| `styles/colors.nix` helper | `02-desktop/04-style.nix` (or lib) |
| `utils/nix.nix`, `troubleshooting.nix` | `04-system/06-nixsettings.nix` |
| `services/simple-nix-update-gui.nix` | `04-system/07-updates.nix` |
| nix-settings-gui | `04-system/07-updates.nix` (T2) |
| nix-shell-gui | `04-system/06-nixsettings.nix` (T2) |
| nix-regedit | `04-system/06-nixsettings.nix` (T2) |
| `utils/homemanager.nix` | `01-users/commonsettings.nix` |
| `productivity/firefox.nix`, `zen.nix` | `03-applications/02-browser.nix` |
| `productivity/office.nix` | `03-applications/05-office.nix` |
| `productivity/webapps.nix` | `03-applications/webapps.nix` (proposed) |
| `gaming/steam.nix` | `03-applications/07-steam.nix` |
| `gaming/osu.nix`, `minecraft.nix`, `shadps4.nix` | steam built in; Prism Launcher via `patch-prismlauncher`; osu and shadps4 dropped (D12) |
| `multimedia/multimedia.nix` | `03-applications/04-multimedia.nix` |
| `social/vesktop.nix` | `03-applications/06-vesktop.nix` |
| `services/desktop-svc.nix` | `04-system/xserver.nix` + `02-desktop/12-phoneconnect.nix` + `04-system/printing.nix` (proposed) |
| `development/vscodium.nix` | `03-applications/development.nix` (proposed) |
| `development/vms.nix` | `patches/04-patch-virtualization.nix` |
| `development/distrobox.nix` | `03-applications/virtualization.nix` (proposed) |
| `desktops/mango/*` (core, binds, layouts, decoration) | `02-desktop/*` |
| `desktops/mango/dankshell.nix` + Dux Shell defaults | `02-desktop/*` (via `desktop.ojuny.dux.*`) |
| `desktops/mango/dgreet.nix` | `02-desktop/login.nix` (proposed) |
| `hosts/x1carbon/hardware.nix` (shape) | generated `04-system/02-hardware.nix` |
| `users/*/{userdetails,homeconfig,termpackages}` (shape) | generated `01-users/01-user.nix` |

## 2. Out of scope (dropped)

| dendrite source | reason |
|-----------------|--------|
| `services/g13-driver.nix`, `features/g13-config.nix`, `packages/linux-g13-driver` | G13 hardware accessory, personal. |
| `secrets/*` (sops, age key, store) | Personal secrets store and key path. |
| `services/hydra.nix`, `nix-serve.nix`, `glusterfs.nix` | Home-lab CI/cache/storage. |
| `services/portfolio.nix` | Personal portfolio service. |
| `services/simple-nix-update-gui.nix` (as-is) | Pointed at private repos; replaced by the generic `07-updates.nix` page. |
| `deploy/*`, `hosts/deploy.nix` | Server build/deploy workflow (deploy-rs targets). |
| `hosts/<server>` and all `hosts/*/hardware.nix`, `networking.nix`, `configuration.nix` | Machine-specific hardware/network and personal machines. |
| `users/den`, `noodle`, `joni`, `olaf`, `reena` module splits | Personal users and their package lists. |
| `styles/stylix-noodle.nix`, `stylix-olaf.nix`, `stylix-eldritch.nix`, `stylix-catppuccin.nix`, `stylix-everforest.nix` (as persons) | Named themes; replaced by one Style page with a scheme dropdown. |
| `desktops/mango/config-*noodle.nix`, `mangonoodle.nix`, `_dankshell-2.nix` | Personal variants and dead files. |
| `terminal/opencode.nix` | Personal agent rules; replaced by the Nix-managed harness in `patch-local-llm`. |
| `terminal/pi.nix` | Personal local-LLM stack; replaced by the opt-in `patch-local-llm`. |
| `terminal/aliases.nix` personal entries (gityoink, sdgyoink, projects, nixdeploy, nixconnect, agent) | Personal scripts and private remotes. |
| `desktops/{gnome,kde,xfce,cinnamon,cosmic,pantheon}`, associated display managers | Alternate desktops (subject to D1). |
| `utils/monitoring.nix`, `desktops/niri/_niri.nix`, other `_`-prefixed files | Empty or unused. |
| `multimedia/ableton*.nix`, `features/mimetypes.nix` zen-specific bits as personal | Personal app choices; keep only generic parts, with the file manager default moving to dux-files. |
| `terminal/fastfetch.nix` `-den`/`-noodle`/`-olaf` variants | Personal ASCII/logo variants; keep `fastfetch-den` as the default (D17). |

## 3. Notes

- dendrite's per-user module split (`base`, `desktop`, `guipackages`,
  `homeconfig`, `termpackages`, `userdetails`) collapses into the single
  `01-users/01-user.nix` page plus `01-users/02-commonsettings.nix`. The Users
  widget supports multiple accounts and their home-manager entries.
- dendrite's concern grouping (`features/`, `styles/`, `terminal/`, `utils/`)
  dissolves and is regrouped by settings page.
- The mango + Dux Shell config is not ported directly; it comes from
  ojuny-desktop via `desktop.ojuny.dux.*`. The Desktop pages only expose those
  options. Bar preset definitions also live in ojuny-desktop; the template
  keeps only the preset dropdown, the custom bar editor, and the
  `@widget-preset` catalog.

## 4. Resolved decisions

- D1a mangoWM + Dux Shell only; every alternate desktop is dropped.
- D12 Steam built in; Prism Launcher through `patch-prismlauncher`; other gaming apps dropped.
- D17 fastfetch kept, default `fastfetch-den`.
- D11 fonts in style, shell in `01-users/03-shell.nix`, ghostty in
  `03-applications/08-terminal.nix`.
- T1/T2 the four SDG-Den nix tools are in scope and wired as recorded in 02.
