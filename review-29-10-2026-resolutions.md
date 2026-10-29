# review 29-10-2026 resolutions

Each entry follows the review order. Status is one of implemented, deferred
until the nix-settings-gui work lands, or rejected with the reason.

## general

- dux-search not working: implemented. The template imports the dux-search
  Home Manager module, enables `programs.dsearch`, and writes a default index
  configuration for the home directory.
- dux-files, dux-search and dux-gop settings: implemented on the new Dux tools
  page. Dux Calendar and dgop are included. Dux Files settings are written to
  `~/.config/dfiles/ui-settings.json`.
- nix-settings-gui config seeding on the ISO: implemented in the Calamares and
  unattended installer paths.
- reload DMS on rebuild for template installs: implemented in
  `scripts/setup.sh`; the GUI code default is unchanged.

## users page

- home-manager state version: implemented in the GUI users widget. The field is
  no longer rendered; the default value is still serialized.

## audio page

- options inside `lib.mkMerge`: implemented. The annotated defaults are a
  direct `config` attribute set and the PipeWire service is a separate backend
  module gated by `lib.mkIf`.

## input methods page

- merge with inputs: implemented. The page is now part of `02-input.nix` and
  `13-input-method.nix` is deleted.
- `lib.mkMerge` options: implemented with the same defaults/backend split.

## keybinds

- individually searchable: implemented in the GUI by matching keybind record
  values in the page and menu search.
- quake bind blank: implemented by replacing the conditional bind row with
  `ojuny.quake.modifier` and `ojuny.quake.keys` options and a generated
  `binds.common` entry.
- quake geometry: implemented with width `0.7`, height `0.55`.

## style

- split the page: implemented as Theme, Typography, Compositor looks and Shell
  looks.

## browsers

- Firefox extensions: implemented as a top-level
  `ojuny.browser.firefox.extensions` option.
- Chromium theming position: implemented with a Chromium group ordered between
  Firefox and Chrome/Brave.
- default browser apply command: implemented with `xdg-mime default` for
  `text/html`, `x-scheme-handler/http` and `x-scheme-handler/https`.

## git

- askpass helper dropdown: implemented with `ojuny.git.askpass`.

## terminal

- fastfetch logo upload/select: implemented in the template with the new GUI
  `file` widget bound to `modules/02-core/logos`.

## startup

- duplicate add buttons: implemented by removing the snippets and insert
  markers.

## nix settings

- fallback substituters: implemented with a separate list shown while the LAN
  cache is exclusive.

## workspaces

- per-tag layout: fixed by forcing the generated tag rules when the table is
  non-empty; the rest of the page is unchanged.
- quake console descriptions: implemented.

## dock

- missing dock widgets: implemented by adding the dock section to every bar
  widget preset except the island.

## dashboard

- duplicated card options: implemented by removing the controls the grid card
  defaults already provide.
- weather widget corruption: implemented by adding geometry for moon, sun and
  readings.
- grid overlap: the template defaults no longer overlap; the GUI should still
  repack overlaps defensively.
- more grid layouts: partially implemented. The per-screen desktop and lock
  screen grid settings are exposed as tables. The widget instance lists still
  need a dedicated GUI instance editor; they are free-position widgets, not
  `col`/`row`/`w`/`h` card grids.

## control center

- footer item editing: implemented in the GUI grid editor with a Footer add
  toggle and a move-to-footer action. The control center edit tile is skipped so
  it is not managed as a footer item.

## ojuny menu

- page does not match the menu: moved to ojuny-desktop. The Home Manager module
  now reads `osConfig.desktop.ojuny.dankMenu` when available so both install
  paths use the same tree.

## digital wellbeing

- drop the page: implemented. The file and host import are removed.

## installed applications

- sops and age: removed from the base package list.

## multimedia

- image viewer dropdown: implemented with imv, qimgv and gwenview.
- OBS, Audacity and GIMP row: implemented as the Tools row, with satty added.

## screenshots

- move screenshot binds: implemented by moving the bind definitions into
  `07-screenshot.nix` while keeping them in the common bind mode.

## obsidian

- move to office: implemented. The page is merged into Office.

## DMS plugins

- added plugin settings and name: implemented in the GUI plugins widget. Every
  row has a settings cog, registry ids are not editable, and schemas are fetched
  for rows without configured settings.

## power

- layout: implemented by regrouping into Battery, Battery alerts, Power
  profiles, Idle, Power menu and Advanced.

## patches

- options not showing: implemented by moving annotated defaults out of the
  list-of-attribute-sets expressions and into direct `config` attribute sets.
  The failure mode is documented in `docs/05-settings-gui-limitations.md`.
