# review-3 re-review issues

concrete, de-duplicated issue list extracted from every `> re-review note` block in
`review-3.md`, written after the review-3 remediation plans
(`review-3-remediation-gui.md`, `review-3-remediation-template.md`) were executed.
this document is the input to the next resolution plan.

schema per issue: id, source lines, affected pages/files, owning repo, current
behaviour after remediation, desired behaviour, remediation id mapping, status
(`delta` = remediation landed but did not fully resolve, `regression` = broken by
remediation, `new` = reported after remediation, not previously tracked).

ids follow page order. good/"still good" notes are not listed as issues; full
coverage of every note line is in appendix A.

# section A: GUI-owned (nix-settings-gui)

## I01. table column alignment and broken add-row typing

- source: `review-3.md:145,147` (terminal aliases), `:336` (craftapps), `:362`
  (webapps), `:422,424` (development aliases)
- pages: 02-Core/Terminal, 05-Applications/Office, 06-Utility/Web apps,
  patches/Development
- files: nix-settings-gui table-attrset widget; template
  `modules/patches/01-patch-development.nix` (add-row field shape)
- owning: nix-settings-gui primary, template secondary (development add-row)
- current: each table row sizes its text column to its own content, so the
  enable toggle and delete button land at a different x per row; column headers
  align with exactly one row and float above the rest. the development aliases
  add-row presents three free-text fields instead of field + toggle + field, and
  writes the string `"true"` into the nix file instead of a boolean.
- desired: fixed column widths shared by all rows and the header row; the
  development add row presents a name field, an enable toggle, and a command
  field, and serialises the toggle as a real boolean.
- duplicates merged: terminal aliases, craftapps, webapps, development aliases
- maps to: G10, G10b, T13, T28, T31, T36
- status: delta (headers fixed by G10/G10b, row alignment and add-row typing remain)

## I02. pop-out chrome: missing apply/cancel and no auto-grow

- source: `review-3.md:83` (keybinds), `:308` (ojuny menu)
- pages: 02-Core/Keybinds, 04-GUI/Ojuny menu
- owning: nix-settings-gui
- current: the keybind edit pop-out applies changes immediately with no
  apply/cancel pair; the ojuny menu edit pop-out likewise has no apply/cancel
  and keeps a fixed size, clipping the advanced settings that appear when
  popped out.
- desired: both pop-outs get an apply/cancel button pair; the pop-out grows to
  fit its content (including the advanced section); descriptions explain what
  the advanced settings do.
- duplicates merged: keybinds pop-out, ojuny menu pop-out
- maps to: G4, G9
- status: delta

## I03. monitor editor: mode-selection pop-up, snap semantics, transform rendering

- source: `review-3.md:47,49,51`
- page: 02-Core/Display
- owning: nix-settings-gui
- current:
  - add monitor always defaults width/height/refresh instead of prompting.
  - dragging is constrained so the dragged monitor must stay touching the
    existing one; you cannot drag it around another monitor.
  - a 90-degree transformed monitor still renders horizontal in the canvas.
- desired:
  - add-monitor pop-out detects connected monitors (name, current mode) via
    `wlr-randr` (see I18 for the fallback question) and prompts the user to
    pick one monitor and one of its reported modes; the chosen mode decides
    width, height and refresh.
  - drag is free anywhere on the canvas; snapping to another monitor's edge
    happens on release only, pushing out if the released position overlaps.
  - the canvas draws rotated geometry for transformed monitors.
- duplicates merged: add-monitor prompt, snap direction, transform rendering
- maps to: G1, G2, T4
- status: delta (defaults and edge-snap landed, semantics and modes remain);
  transform rendering is new (G1 covered transform naming only)
- related: I18

## I04. bar/dock/center widget list editors

- source: `review-3.md:243` (bar), `:266` (dock)
- pages: 04-GUI/Bar, 04-GUI/Dock (center widgets are part of the bar module)
- owning: nix-settings-gui
- current: widget lists are "better but still terrible": raw widget ids,
  `_order` fields visible or implied, no per-widget settings entry point.
- desired: three lists (left, right, center) of draggable tiles; tile order is
  the position; each tile with extra settings carries a cog button opening a
  settings pop-out; an add button offers a preset list of all available DMS bar
  widgets (template must supply presets); an "add custom" button covers
  unsupported widgets. left/right/center share the same widget pool, since any
  widget can sit in any location (ojuny-template just leaves center empty in
  favour of the island).
- duplicates merged: bar widget list, dock widget list, center widgets
- maps to: G7, T21, T22
- status: delta
- family: I06 (plugin picker shares this shape)

## I05. dashboard and control center grid widget

- source: `review-3.md:286` (dashboard), `:296` (control center)
- pages: 04-GUI/Dashboard, 04-GUI/Control center
- owning: nix-settings-gui
- current: col/row/w/h remain plain fields/tables; control center additionally
  interleaves enable toggles, which makes the page messy.
- desired: one custom grid widget used by both pages: a fixed-width grid of
  draggable, resizable tiles; tiles are added from a list; selecting a tile
  shows its settings in a pane below; delete lives in the details pane; resize
  by dragging borders, pushing other tiles where possible but never beyond the
  grid. enable/disable is part of the same widget, matching DMS's own
  configuration shape.
- duplicates merged: dashboard grid, control center grid
- maps to: G8, T24, T25
- status: delta

## I06. DMS plugins picker

- source: `review-3.md:370`
- page: 06-Utility/DMS plugins
- owning: nix-settings-gui
- current: still a list of raw editable option names with toggles and add
  plugin below.
- desired: plugins selectable from a dropdown next to an add-plugin button; the
  settings button opens a pop-out; toggle right-aligned, settings button
  right-aligned immediately left of the toggle; wrapped in a dedicated
  top-level widget in nix-settings-gui.
- maps to: G11, T32
- status: delta
- family: I04

## I07. keybind rows: display labels, separators, descriptions

- source: `review-3.md:83,87`
- page: 02-Core/Keybinds
- owning: nix-settings-gui (template supplies descriptions via T5 audit)
- current: the main list still shows editable raw bind names; entries run
  together with no visual separator.
- desired: non-editable display labels in "Move Focus down:" style (title
  case, trailing colon, never an input field); a decorative separator line
  between entries; one-line descriptions inside the edit pop-out.
- maps to: G4, T5
- status: delta

## I08. group headers remain visible when all children are hidden

- source: `review-3.md:127,129` (browser), `:412` (graphics)
- pages: 02-Core/Browser, 07-System/Graphics
- owning: nix-settings-gui
- current: selecting chrome or brave leaves the chrome and brave group headers
  visible with no rows under them; the graphics page shows all three vendor
  groups regardless of selection. the visibleWhen fix (G6/T38) gates rows, not
  the group container.
- desired: a group header hides when every child in the group is hidden.
- maps to: G6, T38
- status: delta

## I09. `browserDesktop` exposed value stays literal

- source: `review-3.md:127`
- page: 02-Core/Browser
- owning: nix-settings-gui (template if the data side is at fault)
- current: with firefox selected the defaultApplications row displays the
  literal string `browserDesktop` instead of the resolved browser name.
- desired: the exposed value resolves to the selected browser's name.
- maps to: T11
- status: new
- open question: is the literal produced by the GUI's exposed-value
  resolution, or does the template emit the literal? (see I16 note in section
  B; if template-side, ownership moves there)

## I10. theme colour schemes empty under `nix run`

- source: `review-3.md:113`
- page: 02-Core/Style
- owning: nix-settings-gui
- current: the colour palette module reports "no schemes bundled" when the gui
  is started with `nix run`, falling back to a text field.
- desired: the palette module always works, schemes bundled regardless of how
  the gui was launched (the devshell-env fix from G5 evidently does not cover
  the `nix run` entrypoint).
- maps to: G5, T7
- status: delta

## I11. system page text does not span full width

- source: `review-3.md:388`
- page: 07-System/System
- owning: nix-settings-gui
- current: unchanged since the original review; the hostname description
  wraps in a narrow column and forces scrolling for a four-option page.
- desired: description text spans the full page width.
- maps to: G12, T34
- status: delta (unchanged; G12 fix did not land or did not apply here)

# section B: template-owned (ojuny-template)

## I12. multimedia app descriptions missing

- source: `review-3.md:326`
- page: 05-Applications/Multimedia
- files: `modules/05-applications/02-multimedia.nix`
- owning: template
- current: mpv, OBS, audacity and GIMP still have no descriptions.
- desired: one-line description per app.
- maps to: T27
- status: delta

## I13. notifications: expose the remaining DMS notification settings

- source: `review-3.md:229`
- page: 03-Desktop/Notifications
- files: `modules/03-desktop/07-notifications.nix`
- owning: template
- current: the page exposes exactly the 7 settings seeded in
  `ojuny-desktop/lib/defaults/dms.nix:30-36`
  (`notificationAnimationDuration`, `notificationBodyFontSize`,
  `notificationCompactMode`, `notificationFocusedMonitor`,
  `notificationOverlayEnabled`, `notificationShowTimeoutBar`,
  `notificationSummaryFontSize`), all as top-level rows in one group.
  DMS itself defines 26 notification settings (verified against
  `DankMaterialShell/quickshell/Common/settings/SettingsSpec.js`); the other 19
  are unreachable from the gui. all are writable into settings.json under the
  ojuny key (`ojuny-desktop/lib/mk-ojuny.nix:27` renders `00-ojuny.json`).
- desired: expose the remaining 19 settings, grouped like DMS's own settings
  UI (`quickshell/Modules/Settings/NotificationsTab.qml`); routine settings
  plain, history/privacy/timeouts marked `advanced`:

  | group | key | DMS default | widget |
  |---|---|---|---|
  | Popups | `notificationPopupPosition` | `0` (Top) | dropdown (enum) |
  | Popups | `notificationDedupeEnabled` | `true` | switch |
  | Popups | `notificationPopupBodyInvokesAction` | `false` | switch |
  | Popups | `notificationPopupShadowEnabled` | `true` | switch, advanced |
  | Popups | `notificationForegroundLayers` | `true` | switch |
  | Timeouts | `notificationTimeoutLow` | `5000` | spin (ms), advanced |
  | Timeouts | `notificationTimeoutNormal` | `5000` | spin (ms), advanced |
  | Timeouts | `notificationTimeoutCritical` | `0` | spin (ms), advanced |
  | Timeouts | `notificationIgnoreAppTimeout` | `false` | switch, advanced |
  | Do not disturb | `notificationDndWhileScreenSharing` | `true` | switch |
  | Do not disturb | `notificationDndAllowCritical` | `true` | switch |
  | Privacy | `notificationPopupPrivacyMode` | `false` | switch, advanced |
  | History | `notificationHistoryEnabled` | `true` | switch |
  | History | `notificationHistoryMaxAgeDays` | `7` | dropdown, advanced |
  | History | `notificationHistoryMaxCount` | `50` | spin, advanced |
  | History | `notificationHistorySaveLow` | `true` | switch, advanced |
  | History | `notificationHistorySaveNormal` | `true` | switch, advanced |
  | History | `notificationHistorySaveCritical` | `true` | switch, advanced |

  `notificationPopupPosition` uses DMS's Position enum
  (Top/Left/BottomCenter/Right/Bottom, `-1` = follow cursor).
- out of scope: `notificationRules` (26th key) is a runtime rules list backed
  by a full DMS sub-page (add/remove/expire per-app mute and dnd-bypass rules);
  it does not fit a declarative nix exposure and should stay DMS-managed.
- maps to: no G/T id (new scope beyond T20, which only moved clipboard)
- status: new

## I14. gestures: generic mango swipe list

- source: `review-3.md:95`
- page: 02-Core/Gestures
- files: `modules/02-core/04-gestures.nix`
- owning: template
- current: remediation landed a gesture list, but the review asks for the
  generic shape: every swipe option mango exposes, presented uniformly.
- desired: one row per mango swipe gesture, each with label + enable toggle +
  command field (table layout works: name, enable, command); the two-finger
  gestures unset, the three-finger gestures set to the defaults ojuny ships.
- maps to: T6
- status: delta

## I15. bar settings: position, colours, goth corners, descriptions

- source: `review-3.md:245,248,250,252,254`
- page: 04-GUI/Bar
- files: `modules/04-gui/01-bar.nix`
- owning: template
- current:
  - bar position lists only top/bottom although mango supports left/right.
  - icon scale, font scale, spacing, bottom gap and the related toggles sit as
    loose top-level fields.
  - colour options render as raw text instead of dropdowns.
  - most options have no descriptions.
  - goth corners expose duplicated toggle sets that are not distinguished
    (they are the regular bar corners vs the island corners).
- desired: position gains left/right; the scale/spacing cluster becomes a
  horizontal submodule with its toggles; every colour option is a dropdown;
  every option gets a description; the two goth-corners toggles are labelled
  and described as bar corners and island corners.
- maps to: T21
- status: delta

## I16. dock settings: descriptions, numeric fields, ordering

- source: `review-3.md:266,268,270`
- page: 04-GUI/Dock
- files: `modules/04-gui/02-dock.nix`
- owning: template
- current: smart auto hide and friends have no descriptions; max visible apps
  and max visible running apps are not plain numeric fields; show trash sits
  far from its related settings with no ordering rationale.
- desired: descriptions on the settings that need them; max visible apps and
  max visible running apps exposed as number fields (0 = unlimited);
  sections reordered so related settings sit together.
- maps to: T22
- status: delta

# section C: investigate / ambiguous

## I17. user account menu suddenly gone

- source: `review-3.md:20`
- page: 01-Users/User account
- owning: both
- current: the entire user account section disappeared between review passes;
  it was present in the original review (only shell and account-group issues
  were reported).
- desired: the section renders again with the shell dropdown and account label
  fixes (T1/T2) applied.
- maps to: T1, T2
- status: regression
- open question: is this a GUI visibility regression (group rendering /
  visibleWhen, cf. I08) or did a template change hide the page? must be
  confirmed on a fresh install before fixing.

## I18. monitor mode detection fallback

- source: `review-3.md:47` ("use xrandr or wlr-randr or something similar?")
- page: 02-Core/Display
- owning: nix-settings-gui
- extends: I03
- open question: should add-monitor fall back to `xrandr` when `wlr-randr` is
  absent, or require `wlr-randr` (it ships with the ojuny closure, so the
  fallback may be dead weight)? decide before implementing I03's mode picker.
- status: new

# appendix A: note coverage

every `> re-review note` block in `review-3.md` and where it landed:

| lines | outcome |
|---|---|
| 20 | I17 |
| 26-28 | no issue ("still good") |
| 47 | I03, I18 |
| 49 | I03 |
| 51 | I03 |
| 57-59 | no issue ("still good") |
| 83 | I02, I07 |
| 85 | no issue ("add/remove works") |
| 87 | I07 |
| 95 | I14 |
| 113 | I10 |
| 115 | no issue ("gaps toggle works") |
| 117 | no issue ("rest works great") |
| 127 | I08, I09 |
| 129 | I08 |
| 135-137 | no issue ("looks good") |
| 145, 147 | I01 |
| 153-155 | no issue |
| 161-163 | no issue |
| 169-171 | no issue |
| 179-181 | no issue |
| 187-189 | no issue |
| 195-197 | no issue |
| 203-205 | no issue |
| 211-213 | no issue |
| 219-221 | no issue |
| 229 | I13 |
| 243 | I04 |
| 245 | I15 |
| 248 | I15 |
| 250 | I15 |
| 252 | I15 |
| 254 | I15 |
| 266 | I04, I16 |
| 268 | I16 |
| 270 | I16 |
| 276-278 | no issue |
| 286 | I05 |
| 296 | I05 |
| 306 | no issue ("looks pretty good") |
| 308 | I02 |
| 316-318 | no issue |
| 326 | I12 |
| 336 | I01 |
| 342-344 | no issue |
| 350-352 | no issue |
| 362 | I01 |
| 370 | I06 |
| 376-378 | no issue |
| 388 | I11 |
| 394-396 | no issue |
| 402-404 | no issue |
| 412 | I08 |
| 422 | I01 |
| 424 | I01 |

# appendix B: de-dupe map

repeated notes collapsed into single issues:

| collapsed issue | source lines |
|---|---|
| I01 table alignment + add-row typing | 145, 147, 336, 362, 422, 424 |
| I02 pop-out apply/cancel + auto-grow | 83, 308 |
| I03 monitor editor (modes, snap, transform) | 47, 49, 51 |
| I04 widget-list-editor family (bar/dock/center) | 243, 266 |
| I05 grid-widget (dashboard + control center) | 286, 296 |
| I07 keybind display labels + separators | 83, 87 |
| I08 visibleWhen group headers | 127, 129, 412 |

note that `:83` feeds both I02 (apply/cancel) and I07 (labels, separators):
one source line, two distinct defects.

# appendix C: DMS settings parity gaps (outside review-3 scope)

survey of `DankMaterialShell/quickshell/Common/settings/SettingsSpec.js`
(410 keys) against ojuny-desktop defaults + template exposures (20 keys),
excluding hyprland/niri keys (irrelevant under mango), runtime-only keys
(`persist: false`), and collection keys the template manages through its own
pages (`barConfigs`, `dockConfigs`, `controlCenterWidgets`, `dashCards`,
`dashTabs`, `dashOptions`). all remaining keys are writable into settings.json
under the ojuny key. candidates for future plans, not review issues:

| group | missing count | examples |
|---|---|---|
| battery/power/lock | 49 | charge limit, low/critical thresholds, suspend/lock timeouts per AC profile, fprint/u2f, lock-screen video, custom power actions |
| matugen/theming | 45 | matugen scheme/seed/smart mode, icon+cursor theme pickers (template uses stylix; many deliberately out of scope) |
| launcher/spotlight/notepad/clipboard | 37 | launcher V2 border/size/footer, notepad page, clipboard paste behaviour |
| input (mouse/touchpad/keyboard) | 28 | accel, natural scroll, tap, repeat rate (template has its own `02-input.nix` via mango/libinput; parity check needed before exposing) |
| display profiles | 20 | displayProfiles, fadeToDpms/Lock, lower refresh on battery |
| notifications | 19 | see I13 |
| osd | 14 | per-event OSD toggles, osdPosition (template exposes only `osdAlwaysShowValue`) |
| updater | 13 | ignored packages, interval, flatpak, AUR |
| sounds | 7 | soundsEnabled, login/notification/plug sounds |
| mango layout via dms | 4 | mangoLayoutGaps/Border/Radius (template configures mango directly; may conflict) |
| blur/compositor (mango-relevant) | ~20 | blurEnabled/Strength, focusRing, floatingWindow, m3Elevation, reduceMotion, springBounce, frame* |
| misc | ~30 | clockDateFormat, firstDayOfWeek, showWeekNumber, calendarBackend, windSpeedUnit, mediaExcludePlayers, focusFollowsMouse, bluetoothMprisEnabled, workspaceNameIcons, appIdSubstitutions |
