# Ojuny desktop: missing / different vs x1carbon dendrite

Purpose: every place the ojuny desktop setup differs from the x1carbon dendrite
setup. Delete any line that *should* stay different or missing; what remains is
the "things to fix" list.

Refs: DEN = ~/repos/nixos-configs/dendrite, OJ = ~/repos/ojuny-desktop,
TPL = ~/repos/ojuny-template


## Mango global settings

- [ ] button_map = 1 missing (config-core.nix:44).
- [ ] cursor_hide_timeout = 30 missing (config-core.nix:55).
- [ ] cursor_hide_on_keypress = 0 missing (config-core.nix:56).
- [ ] drag { tile.to_tile, tile.small, corner, warp_cursor } missing (config-core.nix:57).

## Keybinds
- [ ] SUPER+SHIFT+1..0 -> tagsilent (move window to workspace); OJ has no keyboard move-to-workspace bind (config-binds.nix:134).
- [ ] SUPER+Tab -> terminal (config-binds.nix:64).
- [ ] SUPER+V -> paste.sh; OJ uses SUPER+V for togglefloating (config-binds.nix:55 vs OJ/defaults/mango.nix:275).
- [ ] SUPER+H -> layoutbutton.sh (config-binds.nix:58).
- [ ] SUPER+ALT+SPACE toggle_special_tag, SUPER+T tag_special_tag (config-binds.nix:68-69).
- [ ] SUPER+Escape -> settings (DEN has both Escape and x; OJ only x) (config-binds.nix:72).
- [ ] SUPER+SHIFT+Tab -> projects.sh (config-binds.nix:73).
- [ ] SUPER+BACKSPACE -> keymode default (config-binds.nix:77).
- [ ] SUPER+F1/F2/F3 -> keymodes movement/groups/resize (config-binds.nix:82-84).
- [ ] ALT+Tab -> overcircle,next (config-binds.nix:78).
- [ ] SUPER+Up/Down -> viewtoleft/viewtoright (DEN has arrows + Up/Down; OJ only Left/Right) (config-binds.nix:86-89).
- [ ] key_mode.movement (exchange_client, tagsilent, focusstack/exchange_stack) (config-binds.nix:157).
- [ ] key_mode.groups (groupsmart, toggleview, groupfocus) (config-binds.nix:183).
- [ ] key_mode.resize (smartresizewin) (config-binds.nix:209).
- [ ] Helper scripts missing: paste.sh, layoutbutton.sh, projects.sh (DEN/modules/desktops/mango/scripts/).

## Autostart
- [ ] ghostty on login missing (config-autostart.nix:37).
- [ ] ydotoold missing (config-autostart.nix:38).
- [ ] systemd.xdgAutostart = true missing (config-autostart.nix:43).

## Menus
- [ ] setup.rebuild action: DEN uses `zsh -c 'source /etc/zshrc; $nixupdatesrc...'`; OJ uses `sudo nixos-rebuild switch` (DEN menu.jsonc:55 vs TPL 10-menu.nix:340).
- [ ] setup.update action: DEN does `git -C ~/repos/nixos-configs pull` then rebuild; OJ uses `--upgrade` (menu.jsonc:56 vs 10-menu.nix:349).

## Dux Shell
- [ ] DEN sets Dux Shell program flags enableSystemMonitoring / enableVPN / enableAudioWavelength / enableCalendarEvents; OJ has no equivalent (DEN dankshell.nix).
- [x] barConfigs keys surfaceColor="sch", widgetFollowInterfaceStyle=true, followInterfaceStyle=false missing from OJ default bar (DEN dankshell.nix vs OJ/lib/defaults/dux.nix:44). Closed by the 2.0 migration: bar preset definitions move to ojuny-desktop, so the default bar and these keys are defined at the source.

## Ghostty (entire config missing in OJ)
- [ ] command = zsh.
- [ ] scrollback-limit = 1048576000.
- [ ] background-opacity = 0.5.
- [ ] font-family = CaskaydiaCove Nerd Font Mono.
- [ ] window-decoration = none.
- [ ] theme / colors.
- [ ] keybinds: alt+arrows new_split, ctrl+alt+r reload, ctrl+shift+c/v copy/paste.
- Ref: DEN/modules/terminal/ghostty.nix; OJ only installs the package.

## Zsh
- [ ] config.zsh (powerlevel10k rainbow prompt) missing.
- [x] functions.zsh: satty is installed by the screenshot module; `plz()` and `EDITOR=micro` remain.
- [ ] suffix aliases (json/yaml/md/toml/conf/nix/png/jpg/webp/...) missing.
- [ ] aliases missing: reloaddms, projects, gityoink, eza ls/la/ll/lt/l., cd aliases, colorized greps, cmdhist.
- [ ] fastfetch on every interactive shell (per-user logo) missing.
- [ ] histSize = 10000 missing.
- [ ] ohMyZsh (git, sudo) missing.
- [ ] syntax highlighting missing.
- [ ] powerlevel10k promptInit wiring missing.
- Ref: DEN/modules/terminal/{zsh,aliases,functions.zsh,config.zsh,fastfetch}.nix; OJ TPL/modules/03-applications/08-terminal.nix.

## Theme / wallpaper / fonts
- [ ] wallpaper: DEN everforest.png vs OJ stylix.image = null (stylix-everforest.nix:9,14 vs modules/02-core/05-theme.nix).
