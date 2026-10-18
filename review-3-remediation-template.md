# review-3 remediation: template side

source: `review-3.md` (fresh-install review of ojuny template + nix-settings-gui custom modules)
repo analyzed: `/home/den/repos/ojuny-template`
companion: `review-3-remediation-gui.md` (same review, GUI-repo attribution)
date: 2026-10-18

## attribution key

the template repo owns ordering, visibility, naming, option exposure, defaults and file layout (`review-3.md:5`). an issue is template-owned when the nix file fails to expose, gate, order, rename or relocate an option correctly, or when nix values apply unconditionally regardless of a selector. issues about widget shape, layout, rendering, drag behavior and save/sync are GUI-owned and listed in the companion doc; shared issues appear in both with their half described here.

many review observations predate fixes already present in the tree (visibleWhen gates added for gaps/borders/shadows/office/vesktop/steam). each entry below states the current tree state so already-fixed items are distinguishable from open ones.

**attribution correction (confirmed):** the review was performed against the most up-to-date versions of all SDG-Den inputs. therefore when the template-side implementation is correct but the reviewer still observed wrong behavior (e.g. craftapps rendering "the wrong way around" despite a correct table-attrset, visibleWhen-gated options still showing), the defect is on the GUI rendering side, not a stale-template issue. entries below that were earlier phrased as "verify" are re-attributed to the companion doc's G-ids accordingly.

---

## 01-Users

### T1. shell is not exposed, needs a zsh/bash/fish dropdown without pkgs in scope

review: "shell shouldn't be a raw, we could do with pkgs; to take pkgs out of the scope, and give a dropdown between zsh, bash, fish."
status: open. template-owned (option exposure).

- `modules/01-users/01-user.nix:32` is a bare `shell = pkgs.zsh;` with no `@option` annotation, so the scanner never shows it. it is not even a raw widget; it is invisible.
- the generator has the same gap: `scripts/generate-user.sh:98` emits `shell = pkgs.$shell;` with no annotation, so every generated user page also lacks the control.
- the fix shape is the repo's standard enum pattern: expose a template-local option (e.g. `ojuny.user.shell`) as an enum of `"zsh" | "bash" | "fish"`, annotate a dropdown with those choices, and derive `users.users.user.shell = pkgs.${cfg}` in an unannotated assignment. this matches the pattern in `modules/02-core/01-display.nix:41-57` (enumSpecs + derived integers) and `modules/02-core/06-browser.nix:21-29,36-37` (enum option + dropdown).
- `programs.zsh.enable = true` in `modules/02-core/08-terminal.nix:42` is also unannotated; when the shell dropdown lands, the zsh-only shell group (`08-terminal.nix:44-63`, all `visibleWhen.path = "programs.zsh.enable"`) should key off the new shell option or expose the zsh enable switch, otherwise selecting bash leaves a dangling zsh config.

### T2. Account group lists the raw account name

review: "under Account (group name) it just lists 'den' ... display of the account name (non-writeable)"
status: open. template-owned (naming), generator-owned.

- the submodule label is the account name: `modules/01-users/01-user.nix:15` `label = "user"`; the generator writes `label = "$username"` at `scripts/generate-user.sh:81`.
- `description = "user"` at `01-user.nix:20-21` (generator: `description = "$description"` at `:86-87`, defaulting to the username per the script's variable default) duplicates the same string under the same group, so the page shows the name twice and nothing describing the account.
- root cause: the label was chosen as the username instead of a human title. fix: label the submodule "Account" (or "User account") in both the template and the generator, and give the description a distinct default such as "Primary account". the account name itself does not need a writable field; if it should be visible, it belongs as a readonly text option on `users.users.user.name`.

---

## 02-Core

### T3. Display page icon is missing

review: "icon is missing" (02-Core / display)
status: open. GUI-owned (icon rendering), template annotation correct.

- `modules/02-core/01-display.nix:4` sets `icon = "preferences-system-displays-symbolic"`, a valid adwaita-icon-theme name (compare working pages such as `input-touchpad-symbolic` in `04-gestures.nix:4`). since the review ran against current inputs and the annotation is present and valid, the missing icon is a GUI-side icon lookup/render failure. tracked as GUI item G14; no template change.

### T4. Monitors: add-monitor flow, defaults, transform naming, snap, canvas

review: add-monitor prompt should be a popup that detects name/refresh/width/height; x/y should default to 0 not -16K; scale should default 1.00; "RR" should be "transform" per mango docs; monitors need snapping; canvas taller, different color, always full width.
status: open. split: template exposes the widget; behavior is GUI-owned (companion doc G1-G3).

- template side: `modules/02-core/01-display.nix:62-63` declares `widget = "monitors"` on `desktop.ojuny.mango.rules.monitor_rule` with an empty default list. the field names the template feeds the GUI (`name`, `width`, `height`, `refresh`, `x`, `y`, `scale`, `rr`) match what the GUI reads (`src/widgets.rs:2434-2460`).
- the label currently says "sizes and names stay editable in the rule" (`01-display.nix:62`); once the GUI gains detection and dropdowns this description should be updated, and if mango's field is officially `transform` rather than `rr` (see `~/repos/mango/docs`), the template default shape may need a rename pass on existing user configs. the GUI tooltip already says "Transform, 0-7" (`src/widgets.rs:2459`), so the mismatch is naming-only.
- no template change is required for defaults, snap or canvas; those are GUI work items G1-G3.

### T5. Keybinds need a complete rework

review: current row is name/mods/keys entries + preview + fold-out edit + delete; fold-out moves when opened, cells become very tall; desired layout is name + description subtext on the left, styled key preview + edit button + delete on the right, edit opens a popup (not a foldout).
status: open. GUI-owned widget shape (companion doc G4); template-side notes below.

- template exposes five `keybinds` widgets: `modules/02-core/03-binds.nix:31, 301, 589, 683, 813`. the data shape per bind is `modifier`, `keys`, `dispatcher`, `args`, `description`, `group`, `subcat`; the built-in binds already hide dispatcher/args/description (`03-binds.nix:858+` per review-2 follow-up).
- "description subtext" on the left requires the GUI to read the `description` field into the row header; no template change is needed as long as every bind keeps a `description` value. a audit of `03-binds.nix` should confirm all five sections populate `description` so the reworked row never shows an empty subtext.
- the fold-out's reflow and the tall cells are purely the `gtk::Expander` layout in `src/widgets.rs:2106-2124`; tracked as G4.

### T6. Gestures: fixed set of mango gestures with enable + command per gesture

review: "should be a set list of options for each available gesture in mango, with only an enable/disable toggle and the relevant command as fields (horizontal submodule)"
status: open. template-owned (option exposure).

- `modules/02-core/04-gestures.nix` currently exposes only two gesture commands: launcher (`:52-53`) and menu (`:60-61`), both free-text fields. workspaceNext (`:36-40`) and workspacePrev (`:42-46`) are hardcoded assignments with no `@option` at all, so the user cannot disable or rebind them. swipe tuning (`:65-78`) is unrelated to the per-gesture list.
- the fix is to annotate every `desktop.ojuny.mango.gesturebind.default.<name>` entry with enable/command fields grouped per gesture, using `horizontal-submodule` as the reviewer asked. each gesture needs: an enable switch (derived into presence of the bind or a mango-side flag), the command text for spawn binds, and read-only or advanced fields for direction/distance where mango supports them. the reference set comes from mango's gesture docs (`~/repos/mango/docs`).
- the enable mechanism has no precedent in the current gesturebind shape (mango binds are attrset presence, not bool flags); the module will likely need an `ojuny.mango.gesture.<name>.enable` option family mapped to bind presence, following the flag/enum pattern used elsewhere in this file (`:24-31`).

### T7. Color palette is not using the custom module (renders as text field)

review: "color palette is not using the custom module, looks like a simple text field now."
status: open. GUI-owned root cause; template is correct. cross-listed as G5.

- template side: `modules/02-core/05-style.nix:190-191` correctly declares `widget = "theme"` on `ojuny.style.palette = "everforest-dark-hard"`. the derived stylix path at `:194` is intentionally unannotated.
- the GUI's `build_theme` falls back to a plain text entry whenever the compiled-in scheme list is empty (`src/widgets.rs:1726-1728`), and schemes are only compiled in when `TINTED_SCHEMES_DIR` is set at build time (`build.rs:11-13`; set in `flake.nix:58` for nix builds only). a build without that env var produces the text field the reviewer saw. no template action.

### T8. stylix toggles should be hidden/advanced

review: "stylix enable and theme mango from stylix settings should be hidden/advanced"
status: open. template-owned (visibility).

- both switches are default-visible in the Theme group: `modules/02-core/05-style.nix:181-182` (`desktop.ojuny.stylix.enable`, "Theme mango from stylix") and `:184-185` (`stylix.enable`). neither carries `hidden` or `advanced`.
- fix: mark both `advanced = true` (stylix.enable is a power-user escape hatch; the ojuny stylix bridge even more so). polarity and palette at `:187-191` stay default-visible.

### T9. Gaps, borders, shadows sub-options visible when the parent toggle is off

review: "gaps - individual gaps are still available even if set gaps per edge is disabled"; same for per-surface borders and shadows.
status: template gates correct; misbehavior confirmed GUI-side. cross-listed as G6.

- the template already gates every sub-option:
  - unified gap gated on `customGaps == false` (`05-style.nix:243`), per-edge gaps on `customGaps == true` (`:249, 252, 255, 258`).
  - unified border on `customBorders == false` (`:265`), per-surface on `customBorders == true` (`:271, 274, 277`).
  - shadow size/blur/offsets on `shadows == true` (`:329, 332, 335, 338`).
- the reviewer saw the sub-options anyway on current inputs, so the GUI's `visibleWhen` dependency evaluation failed for these paths (`src/app.rs` `evaluate_dependencies` / `apply_control_filter`). template action: none; the gates stay. GUI action G6 fixes the evaluator.

### T10. Layer animations should sit below fade out

review: "layer animations toggle and other opts should be below fade out."
status: open. template-owned (ordering).

- current Animations group order (`05-style.nix:416-468`): window animations 10, layer animations 20, open 30, close 40, layer open 50, layer close 60, fade in 70, fade out 80, then the advanced duration/curve options 90+.
- desired: window animations, open, close, fade in, fade out first; then the layer toggle and layer open/close below. fix: renumber `order` so layer animations becomes 60, layer open 70, layer close 80 (or equivalent), pushing fade in/out to 50/60 and leaving the advanced tail above 90. the layer open/close dropdowns (`:428, 431`) already key their visibleWhen off the layer toggle, so they will follow the toggle wherever it moves.

### T11. Browser: chrome selected but firefox visible, no chrome settings

review: "switching to chrome - firefox is still visible, no chrome settings."
status: open. template-owned (missing groups, hardcoded MIME).

- `modules/02-core/06-browser.nix` has only a Firefox group (`:39-57` system, `:95-111` home-manager). there is no chrome or brave group anywhere.
- every Firefox option carries `visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox"` (`:39-57`), so if firefox was still visible after switching, either the save did not persist or the GUI dependency evaluation failed (cross-ref G6); the template gates are correct.
- MIME defaults are hardcoded to `firefox.desktop` regardless of selection: `:63, 66, 69, 72, 75, 78`. these must become derived assignments keyed off `config.ojuny.browser.selected` (mapping firefox/chrome/brave to `firefox.desktop`/`google-chrome.desktop`/`brave-browser.desktop`), with the editable text widgets removed or converted to readonly derived display.
- chrome/brave groups need real content: chromium policy options (safebrowsing, default search), extensions story (chrome web store is not declarative the way firefox-addons is), and home-manager profile handling if desired. minimum viable: enable switch + a few policies per browser, gated by the same visibleWhen pattern.

### T12. Git: packages should be advanced, no exposed enable toggle

review: "packages should be advanced, git should not have an exposed toggle (always enabled)"
status: open. template-owned (visibility).

- `modules/02-core/07-git.nix:43-44` exposes `programs.git.enable` as a default-visible switch. git is part of the base system (the update and patch flows depend on it); the switch should be removed entirely (hardcode `enable = true` unannotated, matching the `services.nix-settings-gui.enable` decision from review-2, `modules/02-core/10-updates.nix:27`).
- `:49-55` exposes `environment.systemPackages` (git, gh, lazygit, delta) as a default-visible packages widget. add `advanced = true` to its `@option`.

### T13. Terminal: needs btop.enable for stylix theming; aliases should be a table

review: "needs a btop.enable so it gets stylix-themed, aliasses need to be turned into a table with an 'add alias' button"
status: open. template-owned (option exposure + widget choice).

- btop is installed as an opaque package entry (`modules/02-core/08-terminal.nix:35`) with no stylix hookup. stylix themes btop via `stylix.targets.btop` (or `stylix.targets.btop.enable`); the module needs an `ojuny.apps.terminal.btop.enable` switch (default true) wired to enable the btop target, so toggling it both installs btop and applies the stylix theme. the package list entry at `:35` can stay or be derived.
- aliases: 17 individual `text` widgets at `08-terminal.nix:82-134` (ls, la, ll, lt, l., reloaddms, find, nixupdate, .., ..., ...., ....., ......, dir, vdir, grep, fgrep, egrep). the repo already has the table pattern: `table-attrset` with a locked name column and an enable/value column, as in `modules/05-applications/03-office.nix:56-81` (craftapps) and `modules/06-utility/01-webapps.nix:58-67`. convert `environment.shellAliases` to a keyed `ojuny.apps.terminal.aliases` attrset rendered with `widget = "table-attrset"`, `columns = [ "enable" "value" ]` (names from `@table-item` rows), derived into `environment.shellAliases` the way webapps derives its list (`01-webapps.nix:69-73`). the `nixupdate` alias embeds a store path (`:104`) and should stay a fixed, non-removable row or move to the unannotated derived set.

### T14. Startup, updates, nix settings pages

review: "looks fine" for all three.
status: no action. note for completeness: `modules/07-system/00-ssh-test.nix` is a temporary test module (header `:1-2`, hardcoded personal key `:11`) imported from `00-imports.nix:14`; it should be removed before any public release but is unrelated to the review.

---

## 03-Desktop

### T15. Login page should be a hidden menu

review: "this entire file should be hidden menu."
status: open. template-owned (visibility).

- `modules/03-desktop/01-login.nix:2-8` `@menu` block has no `hidden` field. the field exists in the directive grammar (`docs/02-settings-menu.md:11-12`) and the GUI parser (`src/dsl.rs:342+`), but is unused anywhere in the tree.
- fix: add `hidden = true;` to the `@menu` header at `01-login.nix:2-8`. the greeter/session wiring stays in the flake; the page only leaves the menu list.

### T16. Special workspace dim should move to workspaces

review: "special workspace dim should move to workspaces."
status: open. template-owned (relocation).

- the dim slider lives in Window management: `modules/03-desktop/02-mangosettings.nix:131-132` (`desktop.ojuny.mango.global.special_dim`, group "Special workspace"). the four special-workspace gap spins (`:134-144`, advanced) belong to the same group.
- the Workspaces page is `modules/03-desktop/06-mangoworkspaces.nix` (tag/scratchpad settings). fix: move the "Special workspace" group (`02-mangosettings.nix:130-144`) into `06-mangoworkspaces.nix` as a new group, or split dim to default-visible and keep advanced gaps in place if the reviewer only meant the dim. the reviewer said dim specifically; the gap spins are advanced and can move with it for coherence. update the stale comment at `02-mangosettings.nix:128` referencing old file numbers while at it.

### T17. Master layout: verify option parity with mango

review: "im sure there are more master layout settings than this? double-check"
status: open. template-owned (completeness).

- `modules/03-desktop/03-mangomaster.nix` exposes exactly five options: new_is_master (`:37-38`), default_master_factor (`:40-41`), default_master_count (`:43-44`), center_master_overspread (`:46-47`, hidden), center_when_single_stack (`:49-50`, hidden).
- action: diff against mango's master layout docs (`~/repos/mango/docs`, master section) for globals such as master row gaps, allow smart resize, and any master-specific rules; add missing ones with descriptions, and un-hide the two hidden switches if they are safe for users (same treatment as T18).

### T18. Dwindle: all settings user-exposed, none hidden/advanced

review: "there are more dwindle settings than this, and they should all be user-exposed, not hidden/advanced"
status: open. template-owned (visibility).

- `modules/03-desktop/04-mangodwindle.nix:69-90`: split ratio is `advanced = true` (`:69`); six switches/dropdowns are `hidden = true` (`:72, 75, 78, 81, 84, 87, 90` - smart split, horizontal split position, vertical split position, preserve split, smart resize, drop preview, manual split).
- fix: strip `hidden` and `advanced` from all seven. while editing, check mango's dwindle docs for any settings not yet covered (the flagDefaults block `:19-25` and enumSpecs `:29-46` are the full current surface).

### T19. Scroller, workspaces: fine

status: no action. (workspaces still hides tag carousel `06-mangoworkspaces.nix:47-48` and single scratchpad `:50-51`; the review did not flag these, leave as-is.)

### T20. Notifications: clipboard should move to its own file

review: "clipboard is not related to notifications, should probably move to its own file."
status: open. template-owned (file layout).

- `modules/03-desktop/07-notifications.nix:35-51` holds the six clipboard options (keep history, persist, clear at startup, auto clear, history size, max entry size) in a "Clipboard" group, all gated on `disableHistory == false`.
- fix: create `modules/03-desktop/08-clipboard.nix` with its own `@menu` (displayname "Clipboard", order 80, category "03-Desktop", icon `edit-paste-symbolic` or similar), move the Clipboard group there, and update the notifications page description at `07-notifications.nix:6` which currently advertises "Notification popups and clipboard history".

---

## 04-GUI

### T21. Bar left/right widgets are a mess; _order unexplained; autohide grouping

review: leftwidgets/rightwidgets need a complete redesign; some settings do not need direct exposure; autohide and autohidedelay should be a horizontal submodule; the _order fields make zero sense and nothing has explanations.
status: open. split: template structure + GUI rendering (G7).

- template side, `modules/04-gui/01-bar.nix`:
  - the whole bar is one opaque `widget = "bar"` record (`:15`) whose children are raw attrset fields with no per-field `@option` labels or descriptions. the GUI therefore displays raw key names (`src/widgets.rs:1915-1932` uses the field name as its caption).
  - `leftWidgets` (`:126-154`) and `rightWidgets` (`:156-197`) carry raw widget ids (`workspaceSwitcher`, `dankKDEConnect`, `layout`, `scratchpadHelper`, `systemTray`, `clipboard`, `developerUtilities`, `nixMonitor`, `localServices`, `controlCenterButton`) each with `_order`, plus per-widget tuning fields (`showOccupiedWorkspacesOnly`, the nine `show*` flags on controlCenterButton, etc.).
  - `_order = 10` also appears on the bar itself (`:38`). `autoHide` (`:40`) and `autoHideDelay` (`:42`) are loose sibling fields with no grouping. `position = 0` (`:22`) is an integer with no description (the dock at least documents "0 = top, 1 = bottom", `02-dock.nix:26`); `squareCorners = true` (`:64`) reads inverted next to `gothCornersEnabled = false` (`:114`).
  - nothing in this file carries a `description`, so the page has zero explanatory text, matching the review.
- fix directions, template half: add descriptions to the bar-level fields the widget exposes as extras (position, autoHide, autoHideDelay, transparency family, island family); rename or document `_order` (the GUI will present it as a position number, G7); group autoHide + autoHideDelay with a shared label or accept the GUI grouping them per review; give left/right widget ids friendly labels via `@option label` on the two container annotations (`:126, 156`) and rely on the GUI rework (G7) for the per-widget rows. the deeper redesign of the widget list editor is G7.

### T22. Dock: dock_launcher-style names, _order, no descriptive names

review: "dock widgets module is ok, but shouldn't use dock_launcher style names and _order will not make sense to the end user, nothing has descriptive names here. same issues as bar."
status: open. template-owned (naming) + GUI rendering (G7).

- `modules/04-gui/02-dock.nix:166-170`: `widgets = { dock_launcher = { enabled = true; _order = 10; }; dock_apps = ...; dock_trash = ...; }`. the `dock_` prefix is the raw DMS widget id; the end user has no reason to see it.
- unlike the bar, the dock's scalar fields do have labels and groupOrders (`:17-162`); the review's naming complaint is about the widgets block.
- fix: rename the widget keys to `launcher`, `apps`, `trash` if DMS accepts unprefixed ids (verify against ojuny-desktop's widget registry before renaming, since these keys are consumed by the desktop); if the ids are fixed upstream, the GUI must present friendly labels over the raw keys (G7) and the template keeps the ids. `_order` stays as data; the GUI hides or renames it (G7). also align the dock's position control with T21 (integer `position = 1` with description "0 = top, 1 = bottom" at `:26-27` should become a dropdown in both bar and dock, which is GUI widget work on the extras path).

### T23. Launcher: fine

status: no action.

### T24. Dashboard col/row/w/h should be tables

review: "the col/row/w/h sections, we should turn those into tables, and allow the user to add/remove rows, this might need a custom module"
status: template half current; table/grid shape is GUI-side (G8).

- template already moved to `horizontal-submodule` in review-2 follow-up: card layout entries at `modules/04-gui/04-dashboard.nix:40-62` and weather widgets at `:66-85`, each cell embedding enabled/_order/col/row/w/h as raw fields.
- the reviewer asks for a real table/grid editor with add/remove, which matches `missing-features.md:32` ("grid-configuration (for dashboard and control center)") and the generic table submodule at `:14`. no template change required beyond keeping the col/row/w/h field names stable for the new widget; the work is G8.

### T25. Control center: same as dashboard, plus enable toggles make it messy

review: "same as dashboard, but because the enable toggles are in here as well it's really messy."
status: template half current; GUI-side (G8).

- `modules/04-gui/05-controlcenter.nix:15-64`: seventeen `horizontal-submodule` entries, each an attrset embedding `enabled`, `_order`, `col`, `row`, `w`, `h` (e.g. `:16`). the enabled toggle sitting inside the same flow cell as the grid coordinates is what the reviewer calls messy.
- fix shape (GUI G8): the grid widget should render a row per widget with enabled as a leading switch and col/row/w/h as compact spin columns, add/remove buttons, not a flow of submodules. template keeps the data shape; optionally split `enabled` visibility or add labels, but the primary work is G8. phone connect's control-center widget (`modules/06-utility/03-phoneconnect.nix:29-48`) must land in this same grid after T28.

### T26. Ojuny menu: plugin settings at bottom, remove manage toggle, full rework

review: "extra plugin settings should be at the bottom, manage menu with nix is toggle-less and is a floating option, it should be removed (always enabled). this module likewise needs a full rework."
status: open. template-owned (ordering + exposure) + GUI rework (G9).

- ordering: `modules/04-gui/06-menu.nix` currently orders "Manage menu with Nix" at groupOrder 10/order 10 (`:14-15`), "Extra plugin settings" at 20 (`:17-18`), "Menu tree" at 30 (`:20`). the reviewer wants the plugin settings at the bottom, i.e. after the tree: swap so the tree is groupOrder 10 and extra plugin settings groupOrder 20 (or higher).
- exposure: the "Manage menu with Nix" switch (`:14-15`, `desktop.ojuny.dankMenu.enable = true`) should be removed like `services.nix-settings-gui.enable` was in review-2; keep the assignment unannotated so it is always on and invisible.
- "full rework" of the tree editor itself is GUI-side G9 (the `menu` widget is attrset rows over keys with icon/label/aliases/provider/target/action/checked/when fields, `src/widgets.rs:2774-2783`; the template tree at `:21-59` is the data). template-side contribution to the rework: audit each entry for a `label` and sensible `icon` so any reworked renderer always has display text (currently complete for all 39 entries).

---

## 05-Applications

### T27. Multimedia: four apps have no descriptions

review: "the 4 apps at the top have no descriptions"
status: open. template-owned (annotation).

- `modules/05-applications/02-multimedia.nix:30-36`: one `horizontal-submodule` named "Applications" whose children are the bare assignments `mpv = false; obs = false; audacity = false; gimp = false;` with no per-child `@option` labels or descriptions. the GUI falls back to raw segment names for labels and shows nothing for descriptions (`src/widgets.rs:1413-1423`).
- the `lib.mkEnableOption` texts at `:23-26` ("the mpv media player", "OBS Studio", "Audacity", "GIMP") exist on the option declarations but the scanner reads directive comments on the assignments, not nixdoc, so they never reach the GUI.
- fix: split the horizontal submodule children into individually annotated switches (label + description each), or annotate inside the grouped assignment if the scanner supports nested directives (it does: scan walks records). either way each of the four needs `label` and `description` on its own line, mirroring the control-center submodule style in `05-controlcenter.nix:15-64`.

### T28. Office: craftapps orientation + libreoffice-gated defaults

review: "craftapps section is completely the wrong way around ... opendocuments defaults should only be visible if libreoffice is enabled"
status: template correct; rendering/visibility failures confirmed GUI-side (G10, G6).

- the template implementation is correct: craftapps is `table-attrset` with `columns = [ "enable" ]` and names locked from `@table-item` labels (`modules/05-applications/03-office.nix:56-81`), so the enable cell should be the only editable one and names should be static. the reviewer saw editable names with a static false behind them, which means `build_table` ignored the `@table-item` key lock (`src/widgets.rs` `key_editable` / `first_value_editable` path at `:1444-1450`). GUI fix: G10.
- default-document options at `:31-47` correctly carry `visibleWhen.path = "ojuny.apps.office.enable"; visibleWhen.equals = true`, yet were visible on current inputs; that is the visibleWhen evaluator failure, GUI fix G6.

### T29. Vesktop settings visible with vesktop disabled

review: "vesktop settings are visible with vesktop disabled"
status: template gates correct; misbehavior confirmed GUI-side (G6).

- all eight settings at `modules/05-applications/04-vesktop.nix:59-83` correctly carry `visibleWhen.path = "ojuny.apps.vesktop.enable"`; the enable switch is at `:21-24` with order 1. the reviewer saw them anyway on current inputs, so the visibleWhen evaluator failed. template action: none. GUI fix: G6.

### T30. Gaming: steam-related settings with steam disabled

review: "steam-related settings are shown with steam disabled most likely"
status: template gates correct for steam options; any still-visible steam options are G6; one genuine template gap (GameMode).

- gated correctly: compat (`05-steam.nix:35-36`), protonGE (`:38-39`), gamescope session (`:44-45`), remote play (`:50-51`), LAN (`:53-54`), dedicated server (`:56-57`) all key off `programs.steam.enable`. if the reviewer saw these with steam disabled on current inputs, that is the G6 evaluator failure.
- genuine template gap: GameMode (`:47-48`, `programs.gamemode.enable`) has no visibleWhen. GameMode is a standalone perf tool useful without Steam. fix options: gate it on steam (matches the reviewer's mental model) or add a description stating it is independent of Steam and keep it visible. prefer the description unless the reviewer confirms they want it hidden; flag as a decision point in the fix plan.

---

## 06-Utility

### T31. Web apps: title shown twice, column labels misaligned

review: "the 'webapps' title is shown twice, once with the description, and once more after. the labels for the columns are also not alligned."
status: open. template-owned duplicate label; column alignment is GUI-side (G10).

- `modules/06-utility/01-webapps.nix:55` labels the enable switch "Web apps" and `:58` labels the table "Web apps", both in group "Web apps"; the page-level title plus two identical control labels read as the title twice.
- fix: rename the switch label to "Enable web apps" (or "Install Chromium web applications") and the table label to "Apps" or "Your web apps".
- column alignment: the GUI renders the table header as a single label joining names with spaces (`src/widgets.rs:1453-1457`), which cannot align with the cells. tracked as G10; the template column set `[ "enable" "name" "url" "icon" ]` (`:58`) is fine.

### T32. DMS plugins: complete mess, needs full rework

review: "a list of various raw option names (editable) with 'add plugin' below, each list also has a toggle which are all set to false atm. needs a full rework"
status: open. GUI-owned widget (G11); template notes below.

- template side, `modules/06-utility/02-plugins.nix`: `managePluginSettings` switch (`:14-15`) plus the `plugins` widget (`:20-88`) over nine plugins, every one with `enable = true`. the nested settings (nixMonitor `:32-46`, localServices `:50-54`, scratchpadHelper `:57-62`, screenCaptureToolbar `:67-75`, commandRunner `:79-83`) use raw DMS setting names as keys, which is what the reviewer saw as "raw option names".
- the "all toggles false" observation contradicts the template defaults (`enable = true` everywhere) and points at the GUI's missing-enable fallback (`src/widgets.rs:2804` builds a switch from `"false"` when no enable record is found) or a scan mismatch; G11 covers the rework and this bug.
- template contribution to the rework: give each plugin's settings keys friendly `@option label`/`description` annotations the way bar/dock extras would need, or accept that the reworked plugin widget (G11) carries a known-name registry with labels and hides raw keys. also verify `managePluginSettings` (`:14-15`) is not another always-on candidate for removal like the menu's manage toggle (T26).

### T33. Phone connect: relocate widgets, deprecate the page

review: "control center widget needs to be moved to control center with the rest of its modules, bar widget needs to be moved to bar widget setup. KDE connect toggle can move to applications, this menu can be deprecated"
status: open. template-owned (relocation).

- `modules/06-utility/03-phoneconnect.nix` currently owns: the KDE Connect enable + valent package (`:14-18`), the bar widget submodule `leftWidgets.dankKDEConnect` (`:20-27`), and the control-center widget submodule `controlCenterWidgets.plugin_dankKDEConnect` (`:29-48`).
- target state:
  - bar widget entry moves into `modules/04-gui/01-bar.nix` leftWidgets (it already exists there as a default entry at `:139-142`; remove the duplicate definition path from phoneconnect and let the bar own it, with the KDE-connect-specific enable living behind the plugin or the bar entry's own enabled flag).
  - control-center widget entry moves into `modules/04-gui/05-controlcenter.nix` alongside the other seventeen widgets.
  - `programs.kdeconnect.enable` + valent moves to `modules/05-applications/` (new `06-kdeconnect.nix` or into an existing apps page), with its own `@menu`.
  - `03-phoneconnect.nix` is deleted; update `docs/02-settings-menu.md:34-39` category table and any imports in `modules/07-system/00-imports.nix` that reference `desktop-phoneconnect`.

---

## 07-System

### T34. System page: text does not span full width, forces scrolling

review: "text doesn't span the whole width for something like hostname ... option menu needs scrolling for only 4 options."
status: open. GUI-owned (G12); template half: the System page only has four options (`modules/07-system/01-configuration.nix:26-38`: patches, hostname, timezone, locale, keymap) plus a long hostname description. nothing to change in the template beyond confirming the hostname description length is acceptable once widgets go full-width (G12, `missing-features.md:8`).

### T35. Graphics: all vendors shown, other vendors still applying, need "none"

review: "shows all 3 vendors regardless, also unsure if options from other vendors are still applying with a specific vendor set, also 'none' needs to be an option that applies no specific-vendor settings, only general ones."
status: open. template-owned (real bug + missing enum value). GUI verification cross-ref G6.

- vendor groups now carry visibleWhen (`modules/07-system/04-graphics.nix:46, 53, 57, 61, 64`); if all three still showed, that is G6. the template gates themselves are correct.
- the real bug the reviewer suspected: Intel extras apply unconditionally regardless of `ojuny.gpu`. `hardware.graphics.extraPackages` (`:47-51`) and `boot.kernelParams` (`:53-54`) are plain assignments; `visibleWhen` only hides the controls in the GUI, it does not conditionally apply the nix values. on an AMD box with `ojuny.gpu = "amd"`, the intel packages and i915 kernel param still land in the system config. fix: wrap each vendor block in `lib.mkIf (config.ojuny.gpu == "intel")` (and amd/nvidia equivalents), or move them under a vendor-keyed attrset the way `services.xserver.videoDrivers` already switches on `config.ojuny.gpu` (`:68-74`) and `LIBVA_DRIVER_NAME` switches (`:76-83`).
- "none" option: add `"none"` to the enum at `:21-29` and the dropdown choices at `:33`, default it appropriately (existing installs default to `"intel"` at `:27/:34`; keep `"intel"` as the default to avoid changing fresh-install behavior, or default new installs to `"none"` and let users pick - decision at implementation). with mkIf guards from the previous point, `"none"` naturally applies only the general options (acceleration `:36-37`, 32-bit `:39-40`, firmware `:42-43`). also extend the `videoDrivers` and `LIBVA_DRIVER_NAME` switches with a `"none"` arm so the attrset lookups do not throw (`:68-83` would fail on `.none`).

---

## patches

### T36. Development aliases need the table treatment

review: "aliasses needs the same treatment as the other aliasses"
status: open. template-owned (widget choice); depends on T13.

- `modules/patches/01-patch-development.nix:75-81`: two individual text widgets (llm, projects) inside a raw `environment.shellAliases` attrset.
- fix: same pattern as T13 - a `table-attrset` (or shared helper if one is extracted for aliases) with locked names and add-row support, derived into `environment.shellAliases`. if T13 introduces a reusable aliases submodule/helper in `02-core`, reuse it here rather than duplicating.

---

## cross-cutting template items

### T37. docs drift

not in the review, but discovered during analysis and required for any of the above relocations to stay documented:

- `docs/02-settings-menu.md:17-19` widget list omits every custom widget (`bar`, `dock`, `menu`, `monitors`, `plugins`, `keybinds`, `theme`, `horizontal-submodule`, `table-attrset`, `table-list`).
- `docs/02-settings-menu.md:55-147` and `docs/01-architecture.md:104-121` describe the old directory layout (02-desktop, 03-applications, 04-system) and propose files that do not exist.
- `docs/ojuny-desktop-gaps.md:71-73` claims palette `catppuccin-mocha` while the tree defaults `everforest-dark-hard` (`05-style.nix:191`).
- every relocation in this plan (T16, T20, T33) must update the category map at `docs/02-settings-menu.md:34-39`.

### T38. visibleWhen dependency verification (shared with GUI)

T9, T11, T28, T29, T35 all depend on `visibleWhen` evaluating correctly. the template annotations are in place for the already-gated items. after G6 lands in the GUI, re-test a fresh install against: style gaps/borders/shadows, browser firefox group, office defaults, vesktop settings, steam settings, graphics vendor groups.

---

## summary table

| id | issue | status | owner |
|----|-------|--------|-------|
| T1 | shell dropdown | open | template |
| T2 | account label | open | template + generator |
| T3 | display icon | open | GUI (G14) |
| T4 | monitors defaults/transform | open | GUI (template naming note) |
| T5 | keybinds rework | open | GUI (template description audit) |
| T6 | gestures per-gesture list | open | template |
| T7 | theme renders as text | open | GUI |
| T8 | stylix toggles advanced | open | template |
| T9 | gaps/borders/shadows gates | template correct | GUI (G6) |
| T10 | layer animation order | open | template |
| T11 | browser chrome groups + MIME | open | template |
| T12 | git toggle/packages | open | template |
| T13 | btop.enable + alias table | open | template |
| T14 | startup/updates/nix settings | none | - |
| T15 | login hidden menu | open | template |
| T16 | special ws dim relocation | open | template |
| T17 | master layout parity | open | template |
| T18 | dwindle expose all | open | template |
| T19 | scroller/workspaces | none | - |
| T20 | clipboard own file | open | template |
| T21 | bar structure/descriptions | open | template + GUI |
| T22 | dock widget names | open | template + GUI |
| T23 | launcher | none | - |
| T24 | dashboard grid | template current | GUI (G8) |
| T25 | control center grid | template current | GUI (G8) |
| T26 | menu ordering + toggle | open | template + GUI |
| T27 | multimedia descriptions | open | template |
| T28 | office craftapps/defaults | template correct | GUI (G10, G6) |
| T29 | vesktop gating | template correct | GUI (G6) |
| T30 | steam GameMode gate | open (decision) | template |
| T31 | webapps duplicate title | open | template + GUI |
| T32 | DMS plugins rework | open | GUI (template notes) |
| T33 | phone connect relocation | open | template |
| T34 | system text width | open | GUI |
| T35 | graphics mkIf + none | open | template |
| T36 | development aliases table | open | template |
| T37 | docs drift | open | template |
| T38 | visibleWhen verification | pending G6 | both |

---

## fix plan

scoped, per-issue fix designs produced by dedicated sub-agents, each step following the plan spec (numbered steps, 15-20 lines of code, file path + filename + line number + ctrl+f anchor, 1-2 sentence mechanical opener, one-sentence explanations for non-obvious lines). appended incrementally as each design completes; clusters ordered by dependency (T13 before T36, etc.).

### Fix plan: T1, T2

#### Step 1

`modules/01-users/01-user.nix` line 11, anchor `flake.modules.nixos.users-user`

Add `lib` to the module arguments, declare the `ojuny.user.shell` enum option, open an explicit `config` block (required once a module has `options`), add the annotated Shell dropdown in group "Account" (choice: group "Account" matches the file's only existing group, and the submodule label becomes "Account" to match the group name rather than the offered "User account"), and keep the submodule attrset opening.

```nix
  flake.modules.nixos.users-user = { config, lib, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    options.ojuny.user.shell = lib.mkOption {
      type = lib.types.enum [ "zsh" "bash" "fish" ];
      default = "zsh";
      description = "Login shell for the account.";
    };

    config = {
    /* @option widget = "dropdown"; label = "Shell"; group = "Account"; choices = [ "zsh" "bash" "fish" ]; */
    ojuny.user.shell = "zsh";

    /* @option widget = "submodule"; label = "Account"; group = "Account"; */
    users.users.user = {
      /* @option widget = "switch"; label = "Normal user"; group = "Account"; */
      isNormalUser = true;
```

The `config = { ... }` wrapper is required because a NixOS module that declares `options` must put its definitions under an explicit `config` attribute; children stay at their current indent, matching `modules/02-core/06-browser.nix:31-40`.

#### Step 2

`modules/01-users/01-user.nix` line 31, anchor `description = "user";`

Change the account description default to "Primary account" so the Account group no longer shows the account name twice, replace the bare `shell = pkgs.zsh;` with the derived package from the new enum, and close the `config` block opened in step 1.

```nix
      description = "Primary account";

      /* @option widget = "list"; label = "Extra groups"; group = "Account"; */
      extraGroups = [ "networkmanager" "wheel" ];

      /* @option widget = "text"; label = "Hashed password"; group = "Account"; advanced = true; description = "A \"!\" keeps the account locked until a password is set."; */
      hashedPassword = "$y$j9T$E8EmnxzkCLsphRMZbqKW/1$estItGAST4R1l5OTZaSUJLWUYvlAEGVLRTGar5d0osC";

      /* @option widget = "list"; label = "SSH keys"; group = "Account"; */
      openssh.authorizedKeys.keys = [ ];

      shell = pkgs.${config.ojuny.user.shell};
    };

    home-manager.users.user.home.stateVersion = "25.05";

    # scripts/setup.sh fills in the home wiring for this account, e.g.
    # home-manager.users.user.imports = [ ... ];

    };
```

`pkgs.${config.ojuny.user.shell}` maps the enum string onto the package set unannotated, so `pkgs` never appears in scope for the GUI, per the fix shape in the remediation entry.

#### Step 3

`modules/02-core/08-terminal.nix` line 42, anchor `programs.zsh.enable = true;`

Derive the zsh enable from the new shell option so the existing `visibleWhen.path = "programs.zsh.enable"` gates on the Shell group follow the dropdown and selecting bash or fish leaves no dangling zsh config.

```nix
        # Shell
        programs.zsh.enable = config.ojuny.user.shell == "zsh";

        # @option widget = "switch"; label = "Autosuggestions"; group = "Shell"; groupOrder = 20; order = 10; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.autosuggestions.enable = true;

        # @option widget = "switch"; label = "Async suggestions"; group = "Shell"; order = 20; visibleWhen.path = "programs.zsh.autosuggestions.enable"; visibleWhen.equals = true;
        programs.zsh.autosuggestions.async = true;

        # @option widget = "switch"; label = "Syntax highlighting"; group = "Shell"; order = 30; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.syntaxHighlighting.enable = true;

        # @option widget = "switch"; label = "oh-my-zsh"; group = "Shell"; order = 40; visibleWhen.path = "programs.zsh.enable"; visibleWhen.equals = true;
        programs.zsh.ohMyZsh.enable = true;

        # @option widget = "list"; label = "oh-my-zsh plugins"; group = "Shell"; order = 50; visibleWhen.path = "programs.zsh.ohMyZsh.enable"; visibleWhen.equals = true;
        programs.zsh.ohMyZsh.plugins = [
          "git"
          "sudo"
        ];
```

Choice: derive the enable rather than expose a separate switch, matching the derived-assignment pattern at `modules/02-core/01-display.nix:76-81`; `config` is already in scope from this module's arguments at line 15.

#### Step 4

`scripts/generate-user.sh` line 26, anchor `Description (full name)`

Change the generator's description prompt default from the username to "Primary account" so generated account pages get a distinct description, matching the template change in step 2; the shell prompt keeps its zsh default, which becomes the emitted enum's default.

```bash
read -rp "Username [user]: " username
username="${username:-user}"
read -rp "Description (full name) [Primary account]: " description
description="${description:-Primary account}"
read -rp "Extra groups [networkmanager wheel]: " groups
groups="${groups:-networkmanager wheel}"
read -rp "Login shell [zsh]: " shell
shell="${shell:-zsh}"

read -rsp "Password (empty to leave locked): " password
echo

hashed="!"
if [ -n "$password" ]; then
  if command -v mkpasswd >/dev/null 2>&1; then
    hashed="$(mkpasswd -m yescrypt "$password" 2>/dev/null || mkpasswd -m sha-512 "$password")"
```

The `$shell` variable collected here is reused unchanged as the default of the emitted enum in the next step.

#### Step 5

`scripts/generate-user.sh` line 77, anchor `flake.modules.nixos.users-$username`

Update the emitted module header to include `lib`, emit the same `ojuny.user.shell` enum option and `config` wrapper added in step 1, and change the submodule label from the username to "Account".

```bash
{ self, inputs, ... }: {

  flake.modules.nixos.users-$username = { config, lib, pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    options.ojuny.user.shell = lib.mkOption {
      type = lib.types.enum [ "zsh" "bash" "fish" ];
      default = "$shell";
      description = "Login shell for the account.";
    };

    config = {
    /* @option widget = "dropdown"; label = "Shell"; group = "Account"; choices = [ "zsh" "bash" "fish" ]; */
    ojuny.user.shell = "$shell";

    /* @option widget = "submodule"; label = "Account"; group = "Account"; */
    users.users.$username = {
      /* @option widget = "switch"; label = "Normal user"; group = "Account"; */
      isNormalUser = true;
```

`default = "$shell"` expands in the unquoted heredoc, so the prompt answer becomes the generated enum default while the choices stay the fixed three-value list.

#### Step 6

`scripts/generate-user.sh` line 109, anchor `shell = pkgs.$shell;`

Emit the derived shell assignment with the nix interpolation escaped from bash expansion, and close the emitted `config` block; line numbers below are as the script reads after step 5.

```bash
      /* @option widget = "text"; label = "Description"; group = "Account"; */
      description = "$description";

      /* @option widget = "list"; label = "Extra groups"; group = "Account"; */
      extraGroups = [ $group_list ];

      /* @option widget = "text"; label = "Hashed password"; group = "Account"; advanced = true; description = "A \"!\" keeps the account locked until a password is set."; */
      hashedPassword = "$hashed";

      /* @option widget = "list"; label = "SSH keys"; group = "Account"; */
      openssh.authorizedKeys.keys = $keys_block;

      shell = pkgs.\${config.ojuny.user.shell};
    };

    home-manager.users.$username.home.stateVersion = "$STATE_VERSION";

    };

  };
```

`pkgs.\${config.ojuny.user.shell}` emits the literal nix attribute reference because the heredoc delimiter is unquoted and would otherwise treat `${...}` as a bash expansion.

### Fix plan: T6

Template-owned (option exposure) in `modules/02-core/04-gestures.nix`; no GUI change is required for this entry.

`modules/02-core/04-gestures.nix`, after line 20 (ctrl+f: `gesture_live = true;`)

1. This adds a `workspaceGestures` table to the module `let` block, holding the fixed fields for the two workspace navigation gestures, keyed by the bind name the GUI will list.

```nix
      workspaceGestures = {
        workspaceNext = {
          keys = [ "left" "3" ];
          dispatcher = "viewtoright";
          args = [ "0" ];
          description = "Next workspace";
        };
        workspacePrev = {
          keys = [ "right" "3" ];
          dispatcher = "viewtoleft";
          args = [ "0" ];
          description = "Previous workspace";
        };
      };
```

`keys` packs the swipe direction and finger count in mango's fixed order, and `args` is the list passed after the dispatcher.

`modules/02-core/04-gestures.nix`, after the block from step 1, before line 21 `in` (ctrl+f: `gesture_live = true;`)

2. This adds the two spawn gestures and merges both tables into the single `gestureDefaults` lookup the option family and the derived bind read.

```nix
      spawnGestures = {
        launcher = {
          keys = [ "down" "3" ];
          dispatcher = "spawn";
          args = "dms ipc call spotlight toggle";
          description = "Launcher";
          spawn = true;
        };
        menu = {
          keys = [ "up" "3" ];
          dispatcher = "spawn";
          args = "dms ipc call dankMenu toggle root";
          description = "Settings menu";
          spawn = true;
        };
      };

      gestureDefaults = workspaceGestures // spawnGestures;
```

`spawn = true` marks the two gestures whose command the GUI exposes, and `gestureDefaults` is the merged name keyed table.

`modules/02-core/04-gestures.nix`, after line 31 (ctrl+f: `options.ojuny.mango.flag = lib.mapAttrs (`)

3. This declares the `ojuny.mango.gesture` option family, giving every gesture an `enable` switch and adding a `command` string only to spawn gestures.

```nix
      options.ojuny.mango.gesture = lib.mapAttrs (
        name: spec:
        {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the ${spec.description} gesture.";
          };
        }
        // lib.optionalAttrs (spec.spawn or false) {
          command = lib.mkOption {
            type = lib.types.str;
            default = spec.args;
            description = "Command run by the ${spec.description} gesture.";
          };
        }
      ) gestureDefaults;
```

`mapAttrs` turns each `gestureDefaults` entry into options under `ojuny.mango.gesture`, and the `//` arm attaches `command` only when `spawn` is set.

`modules/02-core/04-gestures.nix`, replacing lines 35-62 (ctrl+f: `# Workspace swipes`). the first snippet line (`config = {`, existing line 33) and the last (`# Swipe tuning`, existing line 64) are context lines for anchor orientation only - do not include them in the replacement, or a second `config` block nests inside the first and evaluation fails.

4. This replaces the four hardcoded or free-text gesture assignments with one annotated `horizontal-submodule` per gesture, so the GUI renders an enable toggle plus a command cell.

```nix
      config = {

        # Gestures
        # @option widget = "horizontal-submodule"; label = "Next workspace"; group = "Gestures"; groupOrder = 10; order = 10;
        ojuny.mango.gesture.workspaceNext = { enable = true; };

        # @option widget = "horizontal-submodule"; label = "Previous workspace"; group = "Gestures"; groupOrder = 10; order = 20;
        ojuny.mango.gesture.workspacePrev = { enable = true; };

        # @option widget = "horizontal-submodule"; label = "Launcher"; group = "Gestures"; groupOrder = 10; order = 30;
        ojuny.mango.gesture.launcher = { enable = true; command = "dms ipc call spotlight toggle"; };

        # @option widget = "horizontal-submodule"; label = "Settings menu"; group = "Gestures"; groupOrder = 10; order = 40;
        ojuny.mango.gesture.menu = { enable = true; command = "dms ipc call dankMenu toggle root"; };

        # Swipe tuning
```

Each annotated assignment becomes one horizontal row, and its literal children `enable` and `command` are the editable cells. only the four annotated assignments (from `# Gestures` through `menu = ...`) replace lines 35-62; `config = {` and `# Swipe tuning` stay where they are.

`modules/02-core/04-gestures.nix`, after line 81 (ctrl+f: `desktop.ojuny.mango.global.gesture_live = if config.ojuny.mango.flag.gesture_live then 1 else 0;`)

5. This derives `desktop.ojuny.mango.gesturebind.default` from the enabled gesture options, emitting a bind only for the gestures whose switch is on.

```nix
        # Derived mango integer (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.gesture_live = if config.ojuny.mango.flag.gesture_live then 1 else 0;

        # Derived gesture binds, gated on each gesture's enable switch (no @option).
        desktop.ojuny.mango.gesturebind.default =
          lib.mapAttrs
            (name: _: {
              modifier = [ "none" ];
              keys = gestureDefaults.${name}.keys;
              dispatcher = gestureDefaults.${name}.dispatcher;
              args =
                if gestureDefaults.${name}.spawn or false
                then config.ojuny.mango.gesture.${name}.command
                else gestureDefaults.${name}.args;
              description = gestureDefaults.${name}.description;
            })
            (lib.filterAttrs (name: _: config.ojuny.mango.gesture.${name}.enable) gestureDefaults);
```

`filterAttrs` drops disabled gestures so no bind is emitted, and the `if` picks the user command for spawn gestures and the fixed args for the rest.

### Fix plan: T8, T10

Both entries are template-owned and open; neither is GUI-owned.

#### Step 1 (T8: stylix toggles to advanced)

Adds `advanced = true;` to the two stylix switches in the Theme group of `modules/02-core/05-style.nix` (filename `05-style.nix`), starting at line 180. Ctrl+F anchor: `# Theme`.

```nix
      # Theme
      # @option widget = "switch"; label = "Theme mango from stylix"; group = "Theme"; advanced = true; groupOrder = 10; order = 10;
      desktop.ojuny.stylix.enable = true;

      # @option widget = "switch"; label = "Stylix"; group = "Theme"; advanced = true; groupOrder = 10; order = 20;
      stylix.enable = true;

      # @option widget = "dropdown"; label = "Polarity"; group = "Theme"; choices = [ "dark" "light" ]; groupOrder = 10; order = 30;
      stylix.polarity = "dark";

      # @option widget = "theme"; label = "Color palette"; group = "Theme"; description = "A base16 scheme."; groupOrder = 10; order = 40;
      ojuny.style.palette = "everforest-dark-hard";

      # Derived from the palette name; no @option so a GUI edit cannot lose the store path.
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.ojuny.style.palette}.yaml";

      # @option widget = "path"; label = "Wallpaper"; group = "Theme"; nullable = true; groupOrder = 10; order = 50;
      ojuny.style.wallpaper = null;
```

The two `advanced = true;` flags go right after `group`, matching the advanced-switch placement already used in `modules/05-applications/04-vesktop.nix:80` and `modules/04-gui/01-bar.nix:201`.

#### Step 2 (T10: layer animations below fade out)

Renumbers the `order` fields in the Animations group of `modules/02-core/05-style.nix` (filename `05-style.nix`), lines 419-438, so window animations (order 10, line 416, unchanged), open (20), close (30), fade in (40) and fade out (50) sort first, then layer animations (60), layer open (70) and layer close (80); the advanced tail at orders 90+ (lines 440-468) is untouched. Ctrl+F anchor: `label = "Layer animations"`.

```nix
      # @option widget = "switch"; label = "Layer animations"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 60;
      ojuny.mango.flag.layer_animations = false;

      # @option widget = "dropdown"; label = "Open animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 20;
      ojuny.mango.enum.animation_type_open = "zoom";

      # @option widget = "dropdown"; label = "Close animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 30;
      ojuny.mango.enum.animation_type_close = "zoom";

      # @option widget = "dropdown"; label = "Layer open animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.layer_animations"; visibleWhen.equals = true; groupOrder = 110; order = 70;
      ojuny.mango.enum.layer_animation_type_open = "zoom";

      # @option widget = "dropdown"; label = "Layer close animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.layer_animations"; visibleWhen.equals = true; groupOrder = 110; order = 80;
      ojuny.mango.enum.layer_animation_type_close = "zoom";

      # @option widget = "switch"; label = "Fade in"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 40;
      ojuny.mango.flag.animation_fade_in = true;

      # @option widget = "switch"; label = "Fade out"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 50;
      ojuny.mango.flag.animation_fade_out = true;
```

Display order is driven by the `order` field rather than file position, which is why the block is renumbered in place, the same way the Gaps group already lists order 20 (line 243) before order 10 (line 246); the layer open/close `visibleWhen` paths at the new lines keep them gated on the layer toggle wherever it sorts.

### Fix plan: T11

#### Step 1: Add the module-level browser-to-desktop map

Turns the module body into a `let ... in` expression so the browser to desktop-file mapping is computed once for the MIME step, and keeps the existing option declaration below it.

`modules/02-core/06-browser.nix:12` (ctrl+f `flake.modules.nixos.applications-browser`)

```nix
  flake.modules.nixos.applications-browser =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      browserDesktop =
        {
          firefox = "firefox.desktop";
          chrome = "google-chrome.desktop";
          brave = "brave-browser.desktop";
        }
        .${config.ojuny.browser.selected};
    in
    {
```

The `.${config.ojuny.browser.selected}` suffix is the attribute lookup that selects one desktop id from the map (same idiom as `04-graphics.nix:68-74`).

#### Step 2: Declare the Chrome and Brave options

Adds four template-local options after the existing browser selection option: an enable switch per browser and a password-saving switch per browser.

`modules/02-core/06-browser.nix:21` (ctrl+f `options.ojuny.browser.selected = lib.mkOption`)

```nix
      options.ojuny.browser.selected = lib.mkOption {
        type = lib.types.enum [
          "firefox"
          "chrome"
          "brave"
        ];
        default = "firefox";
        description = "Browser used for web and document links.";
      };

      options.ojuny.browser.chrome.enable = lib.mkEnableOption "the Google Chrome browser";
      options.ojuny.browser.chrome.savePasswords = lib.mkEnableOption "saving passwords in Chrome";
      options.ojuny.browser.brave.enable = lib.mkEnableOption "the Brave browser";
      options.ojuny.browser.brave.savePasswords = lib.mkEnableOption "saving passwords in Brave";
```

`lib.mkEnableOption` creates a boolean option defaulting to false, and the template options exist because nixpkgs ships no Chrome or Brave program module.

#### Step 3: Add the Chrome and Brave config groups

Inserts the two browser groups after the Firefox group: each has an enable switch, a password policy switch, and an install gated on its enable switch. Every control carries the same `visibleWhen` selector pattern as the Firefox group.

`modules/02-core/06-browser.nix:57` (ctrl+f `programs.firefox.policies.OfferToSaveLogins = false;`)

```nix
      # @option widget = "switch"; label = "Offer to save logins"; group = "Firefox"; order = 6; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.OfferToSaveLogins = false;

      # @option widget = "switch"; label = "Enable Chrome"; group = "Chrome"; groupOrder = 30; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "chrome";
      ojuny.browser.chrome.enable = false;

      # @option widget = "switch"; label = "Offer to save passwords"; group = "Chrome"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "chrome";
      ojuny.browser.chrome.savePasswords = false;

      environment.systemPackages = lib.mkIf config.ojuny.browser.chrome.enable [ pkgs.google-chrome ];

      # @option widget = "switch"; label = "Enable Brave"; group = "Brave"; groupOrder = 40; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "brave";
      ojuny.browser.brave.enable = false;

      # @option widget = "switch"; label = "Offer to save passwords"; group = "Brave"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "brave";
      ojuny.browser.brave.savePasswords = false;

      environment.systemPackages = lib.mkIf config.ojuny.browser.brave.enable [ pkgs.brave ];
```

`lib.mkIf` empties the package list while the switch is off, and the two `environment.systemPackages` definitions merge because the option is a list.

#### Step 4: Derive the Chromium policies from the selection

Adds the hidden Chromium policy plumbing between the browser groups and the default-application group. The policy mechanism turns on only for a Chromium-family selection, and the password policy follows the selection.

`modules/02-core/06-browser.nix:60` (ctrl+f `xdg.mime.enable = true;`). the first two snippet lines (the Firefox `Offer to save logins` annotation and assignment) are context lines already added by step 3 - insert only the `programs.chromium.*` lines above `xdg.mime.enable`; pasting the Firefox lines again duplicates the widget in the GUI.

```nix
      # @option widget = "switch"; label = "Offer to save logins"; group = "Firefox"; order = 6; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.OfferToSaveLogins = false;

      programs.chromium.enable = config.ojuny.browser.selected != "firefox";

      programs.chromium.defaultSearchProviderEnabled = true;

      programs.chromium.extraOpts =
        {
          firefox = { };
          chrome = {
            PasswordManagerEnabled = config.ojuny.browser.chrome.savePasswords;
          };
          brave = {
            PasswordManagerEnabled = config.ojuny.browser.brave.savePasswords;
          };
        }
        .${config.ojuny.browser.selected};
```

`programs.chromium.extraOpts` is the freeform policy map that nixpkgs writes to the Chromium, Chrome, and Brave policy directories, and the trailing lookup selects the policy set matching the current selection.

#### Step 5: Derive the MIME defaults and move the group below the browsers

Replaces the six hard-coded `firefox.desktop` values with the `browserDesktop` map from step 1, marks each text widget readonly, and renumbers the group to 50 so it sits after the Chrome and Brave groups.

`modules/02-core/06-browser.nix:59` (ctrl+f `MIME defaults (always on)`)

```nix
      # @option widget = "switch"; label = "MIME defaults (always on)"; group = "Default applications"; groupOrder = 50; order = 1; readonly = true;
      xdg.mime.enable = true;

      # @option widget = "text"; label = "HTML"; group = "Default applications"; order = 2; readonly = true;
      xdg.mime.defaultApplications."text/html" = browserDesktop;

      # @option widget = "text"; label = "HTTP"; group = "Default applications"; order = 3; readonly = true;
      xdg.mime.defaultApplications."x-scheme-handler/http" = browserDesktop;

      # @option widget = "text"; label = "HTTPS"; group = "Default applications"; order = 4; readonly = true;
      xdg.mime.defaultApplications."x-scheme-handler/https" = browserDesktop;

      # @option widget = "text"; label = "PDF"; group = "Default applications"; order = 5; readonly = true;
      xdg.mime.defaultApplications."application/pdf" = browserDesktop;

      # @option widget = "text"; label = "PNG images"; group = "Default applications"; order = 6; readonly = true;
      xdg.mime.defaultApplications."image/png" = browserDesktop;

      # @option widget = "text"; label = "Email links"; group = "Default applications"; order = 7; readonly = true;
      xdg.mime.defaultApplications."x-scheme-handler/mailto" = browserDesktop;
```

`readonly = true` keeps each widget visible while the value tracks the dropdown through `browserDesktop`, and `groupOrder = 50` orders the group after Chrome at 30 and Brave at 40.

### Fix plan: T12, T13

Both entries are template-owned; neither returns GUI-only.

#### Step 1: T12, unhide git enable and mark packages advanced

`modules/02-core/07-git.nix`, line 43, ctrl+f: `label = "Git"; group = "Git"; groupOrder = 10` and line 49, ctrl+f: `label = "Git packages"`. Delete the `@option` line above `programs.git.enable` so the assignment becomes an unannotated always-on value, matching `services.nix-settings-gui.enable` in `10-updates.nix:27`. Append `advanced = true;` to the packages annotation.

```nix
      config = {

        programs.git.enable = true;

        # @option widget = "switch"; label = "Git LFS"; group = "Large files"; groupOrder = 60; order = 10; description = "Track large binaries with Git LFS.";
        programs.git.lfs.enable = false;

        # @option widget = "packages"; label = "Git packages"; group = "Git"; groupOrder = 10; order = 20; advanced = true;
        environment.systemPackages = with pkgs; [
          git
          gh
          lazygit
          delta
        ];
```

The bare `programs.git.enable = true;` carries no directive so the scanner never renders it. The `advanced = true;` flag sits after `order` matching the placement used in `05-steam.nix:56`.

#### Step 2: T13, declare btop.enable and wire the stylix target

`modules/02-core/08-terminal.nix`, line 20, ctrl+f: `the terminal application set`, and line 23, ctrl+f: `ojuny.apps.terminal.enable = true;`. Restructure the single option into an attrset holding `enable` plus a new `btop.enable` bool defaulted true, then add the annotated switch and the unannotated stylix derivation in the config.

```nix
      options.ojuny.apps.terminal = {
        enable = lib.mkEnableOption "the terminal application set";

        btop.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Install btop and theme it with stylix.";
        };
      };

      config = {
        ojuny.apps.terminal.enable = true;

        # @option widget = "switch"; label = "btop"; group = "btop"; groupOrder = 70; order = 10; description = "Install btop and apply the stylix theme to it.";
        ojuny.apps.terminal.btop.enable = true;

        # Derived, no @option: mirrors the btop switch.
        stylix.targets.btop.enable = config.ojuny.apps.terminal.btop.enable;
```

The explicit `mkOption` with `default = true` mirrors `ojuny.steam.protonGE` in `05-steam.nix:24-28` since `mkEnableOption` defaults to false. The stylix derivation is unannotated so it stays out of the GUI; stylix itself is imported for the whole NixOS config by `05-style.nix:90`.

#### Step 3: T13, declare the aliases attrset option

`modules/02-core/08-terminal.nix`, insert after the `btop.enable` block from step 2, before the options closing `};`. Declare `ojuny.apps.terminal.aliases` as an `attrsOf submodule` with `enable` and `value` fields, mirroring the `ojuny.webapps` option in `06-utility/01-webapps.nix:25-52`.

```nix

        aliases = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Enable this alias.";
                };
                value = lib.mkOption {
                  type = lib.types.str;
                  description = "Command the alias expands to.";
                };
              };
            }
          );
          default = { };
          description = "Shell aliases keyed by name, converted to environment.shellAliases.";
        };
```

The `enable` default of true matches the webapps submodule so every shipped alias starts on. The empty `default = { };` lets the table accept a fully user-managed set.

#### Step 4: T13, gate the btop package behind the toggle

`modules/02-core/08-terminal.nix`, line 20, ctrl+f: `the terminal application set` (insert `imports` before the options block, as `03-office.nix:20-23` does), line 35, ctrl+f: `btop` (delete that package line), and line 138, ctrl+f: `# Ghostty is installed and configured through home-manager` (insert the companion module before that comment). The companion module mirrors `applications-office-apps` at `03-office.nix:104-118`.

```nix
      imports = [
        self.modules.nixos.applications-terminal-btop
      ];

  flake.modules.nixos.applications-terminal-btop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = lib.optionals config.ojuny.apps.terminal.btop.enable [ pkgs.btop ];
    };
```

The `imports` block sits between the module body open and the `options` attrset, matching office's layout. The companion module keeps the packages widget a plain editable list while the toggle alone decides whether btop is installed.

#### Step 5: T13, replace the first alias widgets with the table

`modules/02-core/08-terminal.nix`, line 82, ctrl+f: `group = "Aliases"; groupOrder = 50`. Replace all eighteen text widgets (current lines 82 through 134, everything under the `# Aliases` comment at line 81 which stays) with the table annotation, attrset open, the first eight rows, and the close, matching the `table-attrset` style of `05-applications/03-office.nix:56-81` and `06-utility/01-webapps.nix:58-67`.

```nix
        # @option widget = "table-attrset"; label = "Aliases"; group = "Aliases"; groupOrder = 50; columns = [ "enable" "value" ];
        ojuny.apps.terminal.aliases = {
          /* @table-item label = "ls"; */
          ls = { enable = true; value = "eza -al --color=always --group-directories-first --icons=always"; };
          /* @table-item label = "la"; */
          la = { enable = true; value = "eza -a --color=always --group-directories-first --icons=always"; };
          /* @table-item label = "ll"; */
          ll = { enable = true; value = "eza -l --color=always --group-directories-first --icons=always"; };
          /* @table-item label = "lt"; */
          lt = { enable = true; value = "eza -aT --level=4 --color=always --group-directories-first --icons=always"; };
          /* @table-item label = "l."; */
          "l." = { enable = true; value = "eza -a | grep -e '^\\.'"; };
          /* @table-item label = "reloaddms"; */
          reloaddms = { enable = true; value = "dms kill && mmsg dispatch spawn_shell,dms run"; };
          /* @table-item label = "find"; */
          find = { enable = true; value = "fzf --layout=reverse --preview='bat {}'"; };
          /* @table-item label = ".."; */
          ".." = { enable = true; value = "cd .."; };
        };
```

Keys containing dots are quoted exactly as the old `environment.shellAliases."l."` assignments quoted them. `nixupdate` is intentionally absent here; it lands in the unannotated derived set in step 7.

#### Step 6: T13, add the remaining alias rows

`modules/02-core/08-terminal.nix`, insert before the aliases attrset closing `};` from step 5, ctrl+f: `".." = { enable = true;`. Append the nine remaining rows in their original file order.

```nix
          /* @table-item label = "..."; */
          "..." = { enable = true; value = "cd ../.."; };
          /* @table-item label = "...."; */
          "...." = { enable = true; value = "cd ../../.."; };
          /* @table-item label = "....."; */
          "....." = { enable = true; value = "cd ../../../.."; };
          /* @table-item label = "......"; */
          "......" = { enable = true; value = "cd ../../../../.."; };
          /* @table-item label = "dir"; */
          dir = { enable = true; value = "dir --color=auto"; };
          /* @table-item label = "vdir"; */
          vdir = { enable = true; value = "vdir --color=auto"; };
          /* @table-item label = "grep"; */
          grep = { enable = true; value = "grep --color=auto"; };
          /* @table-item label = "fgrep"; */
          fgrep = { enable = true; value = "fgrep --color=auto"; };
          /* @table-item label = "egrep"; */
          egrep = { enable = true; value = "egrep --color=auto"; };
```

The dot-alias keys stay quoted. Values are copied verbatim from the removed text widgets so behavior is unchanged.

#### Step 7: T13, derive shellAliases and pin nixupdate

`modules/02-core/08-terminal.nix`, insert after the aliases attrset closing `};` and before the config closing `};` at current line 135, ctrl+f: `egrep = { enable = true;`. Map enabled table rows into `environment.shellAliases` following the webapps derivation at `01-webapps.nix:69-73`, and keep the store-path `nixupdate` alias as a fixed entry.

```nix

        # Derived, no @option: enabled rows become shell aliases; nixupdate stays fixed.
        environment.shellAliases =
          lib.mapAttrs (_: entry: entry.value)
            (lib.filterAttrs (_: entry: entry.enable) config.ojuny.apps.terminal.aliases)
          // {
            nixupdate = "${builtins.path { name = "nixupdate.sh"; path = ./terminal/nixupdate.sh; }}";
          };
```

The `//` puts the fixed block on the right so a user-added table row named `nixupdate` can never clobber the store-path alias. The `builtins.path` expression is copied verbatim from current line 104.

### Fix plan: T15, T16

#### Step 1. T15: add `hidden = true;` to the Login `@menu` header.

The lines add the menu-level `hidden` field to the page header (the same `field = value;` form used by the other `@menu` keys and by `@option hidden` everywhere in the tree) so the page keeps its file and module but leaves the menu list.

file: `modules/03-desktop/01-login.nix`, filename `01-login.nix`, line 2, ctrl+f anchor: `@menu`

```nix
/*
  @menu
  displayname = "Login";
  icon = "system-log-out-symbolic";
  order = 10;
  description = "Greeter and display manager";
  category = "03-Desktop";
  hidden = true;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-login =
    {
      config,
```

The `hidden = true;` line at `01-login.nix:8` is the only change; it only suppresses the page in the menu list while the greeter/session module below still evaluates normally.

#### Step 2. T16: insert the Special workspace group into the Workspaces page.

The lines add the dim slider plus the four advanced gap spins as a new "Special workspace" group inside the Workspaces `config` block, placed after the last Workspaces option and before the derived-integer section, copying the annotations verbatim from `02-mangosettings.nix:130-144`.

file: `modules/03-desktop/06-mangoworkspaces.nix`, filename `06-mangoworkspaces.nix`, line 51, ctrl+f anchor: `ojuny.mango.flag.single_scratchpad = false;`

```nix
        # @option widget = "switch"; label = "Single scratchpad at a time"; group = "Workspaces"; hidden = true;
        ojuny.mango.flag.single_scratchpad = false;

        # Special workspace (tag 0)
        # @option widget = "slider"; label = "Background dim"; group = "Special workspace"; min = 0.0; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.special_dim = 0.5;

        # @option widget = "spin"; label = "Inner gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_inner_horizontal = 5;

        # @option widget = "spin"; label = "Inner gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_inner_vertical = 5;

        # @option widget = "spin"; label = "Outer gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_outer_horizontal = 30;

        # @option widget = "spin"; label = "Outer gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true;
        desktop.ojuny.mango.global.special_gap_outer_vertical = 30;

        # Derived mango integers (no @option, hidden in the GUI).
```

The group label string `Special workspace` and the `advanced = true` flags on the four gap spins are unchanged from the source, so the group renders identically on the new page.

#### Step 3. T16: delete the group from Window management and fix the moved-groups comment.

The lines remove the five Special workspace options (old `02-mangosettings.nix:130-144`, dim slider plus four gap spins) now that step 2 owns them, and rewrite the stale comment at `02-mangosettings.nix:128` to name the real file `06-mangoworkspaces.nix`; the block is the region after the edit, from the tail of the Windows group into the start of Overview.

file: `modules/03-desktop/02-mangosettings.nix`, filename `02-mangosettings.nix`, line 128, ctrl+f anchor: `moved to its own page`

```nix
        ojuny.mango.flag.idle_inhibit_when_fullscreen = false;

        # Workspaces and Special workspace groups moved to their own page (06-mangoworkspaces.nix).

        # Overview
        # @option widget = "switch"; label = "Enable hot corner"; group = "Overview";
        ojuny.mango.flag.enable_hotarea = false;

        # @option widget = "dropdown"; label = "Hot corner"; group = "Overview"; choices = [ "top-left" "top-right" "bottom-left" "bottom-right" ];
        ojuny.mango.enum.hotarea_corner = "bottom-left";

        # @option widget = "switch"; label = "Disable hot corner when fullscreen"; group = "Overview"; hidden = true;
        ojuny.mango.flag.hotarea_disable_on_fullscreen = true;

        # @option widget = "spin"; label = "Hot corner size"; group = "Overview"; min = 0; max = 100; unit = "px"; hidden = true;
        desktop.ojuny.mango.global.hotarea_size = 0;
```

Only the comment line at `02-mangosettings.nix:128` is rewritten; the Windows option above it and the Overview options below it are unchanged context.

### Fix plan: T17, T18

#### Step 1 (T17)

Removes `hidden = true;` from the two center-tile master switches so the Master layout page exposes all five master-stack globals that mango's layouts documentation lists (`new_is_master`, `default_master_factor`, `default_master_count`, `center_master_overspread`, `center_when_single_stack`); no new options are added because the tree at `03-mangomaster.nix:19-33` already declares every documented master global.

`modules/03-desktop/03-mangomaster.nix`, filename `03-mangomaster.nix`, line 36, ctrl+f anchor: `# Master layout`

```nix
        # Master layout
        # @option widget = "switch"; label = "New window becomes master"; group = "Master layout";
        ojuny.mango.flag.new_is_master = true;

        # @option widget = "slider"; label = "Master factor"; group = "Master layout"; min = 0.1; max = 1.0; step = 0.05;
        desktop.ojuny.mango.global.default_master_factor = 0.65;

        # @option widget = "dropdown"; label = "Master count"; group = "Master layout"; choices = [ "1" "2" "3" "4" "5" ];
        desktop.ojuny.mango.global.default_master_count = 1;

        # @option widget = "switch"; label = "Master spreads when no stack"; group = "Master layout";
        ojuny.mango.flag.center_master_overspread = true;

        # @option widget = "switch"; label = "Center master with single stack window"; group = "Master layout";
        ojuny.mango.flag.center_when_single_stack = true;
```

Dropping `hidden` changes only default GUI visibility, while the options declared from `flagDefaults` at `03-mangomaster.nix:19-33` and the derived 0/1 assignments at `03-mangomaster.nix:53-57` stay untouched.

#### Step 2 (T18)

Drops `advanced = true;` from the split-ratio slider and `hidden = true;` from the first three dwindle controls, so all four render at the default visibility level.

`modules/03-desktop/04-mangodwindle.nix`, filename `04-mangodwindle.nix`, line 68, ctrl+f anchor: `# Dwindle layout`

```nix
        # Dwindle layout
        # @option widget = "slider"; label = "Split ratio"; group = "Dwindle layout"; min = 0.05; max = 0.95; step = 0.05;
        desktop.ojuny.mango.global.dwindle_split_ratio = 0.5;

        # @option widget = "switch"; label = "Split axis from cursor"; group = "Dwindle layout";
        ojuny.mango.flag.dwindle_smart_split = false;

        # @option widget = "dropdown"; label = "Horizontal split position"; group = "Dwindle layout"; choices = [ "follow-cursor" "right" "left" ];
        ojuny.mango.enum.dwindle_horizontal_split = "right";

        # @option widget = "dropdown"; label = "Vertical split position"; group = "Dwindle layout"; choices = [ "follow-cursor" "below" "above" ];
        ojuny.mango.enum.dwindle_vertical_split = "below";

        # @option widget = "switch"; label = "Preserve sibling split on close"; group = "Dwindle layout";
        ojuny.mango.flag.dwindle_preserve_split = true;
```

The two dropdown `.choices` lists remain byte-identical to `enumSpecs` at `04-mangodwindle.nix:29-46`, so each enum option and its dropdown stay in sync.

#### Step 3 (T18)

Removes `hidden = true;` from the last three dwindle switches; the derived integer assignments shown below are unchanged context that already mirrors each flag.

`modules/03-desktop/04-mangodwindle.nix`, filename `04-mangodwindle.nix`, line 84, ctrl+f anchor: `label = "Smart resize toward cursor"`

```nix
        # @option widget = "switch"; label = "Smart resize toward cursor"; group = "Dwindle layout";
        ojuny.mango.flag.dwindle_smart_resize = false;

        # @option widget = "switch"; label = "Two-zone drop preview"; group = "Dwindle layout";
        ojuny.mango.flag.dwindle_drop_simple_split = false;

        # @option widget = "switch"; label = "Manual split mode"; group = "Dwindle layout";
        ojuny.mango.flag.dwindle_manual_split = false;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.dwindle_smart_split =
          if config.ojuny.mango.flag.dwindle_smart_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_preserve_split =
          if config.ojuny.mango.flag.dwindle_preserve_split then 1 else 0;
        desktop.ojuny.mango.global.dwindle_smart_resize =
          if config.ojuny.mango.flag.dwindle_smart_resize then 1 else 0;
```

Each switch keeps its `ojuny.mango.flag` option from `flagDefaults` at `04-mangodwindle.nix:19-25`, and the derived block shown is unchanged context, not part of the edit.

### Fix plan: T20

#### Step 1

`modules/03-desktop/08-clipboard.nix`, filename `08-clipboard.nix`, line 1, ctrl+f anchor: `@menu`

Creates the new Clipboard page with its `@menu` header, the module wrapper, and the first two clipboard controls moved from the notifications page.

```nix
/*
  @menu
  displayname = "Clipboard";
  icon = "edit-paste-symbolic";
  order = 80;
  description = "Clipboard history settings";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-clipboard = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Keep history"; group = "Clipboard"; groupOrder = 20; order = 10;
    desktop.ojuny.dms.clipboardSettings.disableHistory = false;

    # @option widget = "switch"; label = "Persist across reboots"; group = "Clipboard"; groupOrder = 20; order = 20; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.disablePersist = false;
```

The `groupOrder = 20` value is carried over unchanged from the notifications annotations so the move is layout-only.

#### Step 2

`modules/03-desktop/08-clipboard.nix`, filename `08-clipboard.nix`, line 19, ctrl+f anchor: `desktop.ojuny.dms.clipboardSettings.clearAtStartup = true;`

Appends the remaining four clipboard controls and closes the module, completing the moved group on its own page.

```nix
    # @option widget = "switch"; label = "Clear at startup"; group = "Clipboard"; groupOrder = 20; order = 30; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.clearAtStartup = true;

    # @option widget = "spin"; label = "Auto clear after"; group = "Clipboard"; groupOrder = 20; order = 40; min = 0; unit = "days"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.autoClearDays = 1;

    # @option widget = "spin"; label = "History size"; group = "Clipboard"; groupOrder = 20; order = 50; min = 1; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxHistory = 25;

    # @option widget = "spin"; label = "Max entry size"; group = "Clipboard"; groupOrder = 20; order = 60; min = 0; step = 1024; unit = "bytes"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxEntrySize = 5242880;

  };

}
```

Every `visibleWhen.path` still names the same `disableHistory` option, so the five dependent controls keep hiding when history is turned off.

#### Step 3

`modules/03-desktop/07-notifications.nix`, filename `07-notifications.nix`, line 20, ctrl+f anchor: `label = "Overlay"`

Deletes the six clipboard controls from the notifications page; the block below is the resulting tail of that file after the Clipboard group is removed.

```nix
    # @option widget = "switch"; label = "Overlay"; group = "Popups"; groupOrder = 10; order = 30;
    desktop.ojuny.dms.settings.notificationOverlayEnabled = true;

    # @option widget = "switch"; label = "Show timeout bar"; group = "Popups"; groupOrder = 10; order = 40;
    desktop.ojuny.dms.settings.notificationShowTimeoutBar = true;

    # @option widget = "switch"; label = "Only on focused monitor"; group = "Popups"; groupOrder = 10; order = 50;
    desktop.ojuny.dms.settings.notificationFocusedMonitor = true;

    # @option widget = "spin"; label = "Summary font size"; group = "Popups"; groupOrder = 10; order = 60; min = 6; unit = "pt";
    desktop.ojuny.dms.settings.notificationSummaryFontSize = 16;

    # @option widget = "spin"; label = "Body font size"; group = "Popups"; groupOrder = 10; order = 70; min = 6; unit = "pt";
    desktop.ojuny.dms.settings.notificationBodyFontSize = 10;

  };

}
```

Only the seven Clipboard boundary lines from order 10 through the `maxEntrySize` assignment are removed; the Popups controls shown here stay untouched.

#### Step 4

`modules/03-desktop/07-notifications.nix`, filename `07-notifications.nix`, line 6, ctrl+f anchor: `description = "Notification popups and clipboard history";`

Rewrites the notifications page description so the page no longer advertises clipboard history.

```nix
/*
  @menu
  displayname = "Notifications";
  icon = "preferences-system-notifications-symbolic";
  order = 70;
  description = "Notification popups";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-notifications = { config, pkgs, ... }: {

    # @option widget = "spin"; label = "Popup duration"; group = "Popups"; groupOrder = 10; order = 10; min = 0; step = 50; unit = "ms";
    desktop.ojuny.dms.settings.notificationAnimationDuration = 400;
```

The single changed line is the description string at line 6; the surrounding header and first Popups control are unchanged.

#### Step 5

`modules/07-system/00-imports.nix`, filename `00-imports.nix`, line 30, ctrl+f anchor: `self.modules.nixos.desktop-notifications`

Registers the new module in the host import list directly after the notifications module so the Clipboard page is evaluated.

```nix
      self.modules.nixos.desktop-mango
      self.modules.nixos.desktop-mangosettings
      self.modules.nixos.desktop-mangomaster
      self.modules.nixos.desktop-mangodwindle
      self.modules.nixos.desktop-mangoworkspaces
      self.modules.nixos.desktop-scroller
      self.modules.nixos.desktop-display
      self.modules.nixos.desktop-style
      self.modules.nixos.desktop-bar
      self.modules.nixos.desktop-dock
      self.modules.nixos.desktop-dashboard
      self.modules.nixos.desktop-notifications
      self.modules.nixos.desktop-clipboard
      self.modules.nixos.desktop-menu
      self.modules.nixos.desktop-plugins
      self.modules.nixos.desktop-phoneconnect
      self.modules.nixos.desktop-binds
```

The insert point keeps the desktop imports grouped and follows the file numbering where `08-clipboard` follows `07-notifications`.

#### Step 6

`docs/02-settings-menu.md`, filename `02-settings-menu.md`, line 41, ctrl+f anchor: `| Category | Pages |`

Adds the new page to the category map table so the relocation stays documented.

```markdown
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
| `03-Desktop` | login, mangosettings, mangomaster, mangodwindle, scroller, mangoworkspaces, notifications, clipboard |
| `04-GUI` | bar, dock, launcher, dashboard, controlcenter, menu |
| `05-Applications` | applist, multimedia, office, vesktop, steam |
| `06-Utility` | webapps, plugins, phoneconnect |
| `07-System` | configuration, networking, bluetooth, graphics |
| `Patches` | patch-development |
```

The `03-Desktop` row gains `clipboard` at the end, matching the comma-separated page list format of the surrounding rows.

### Fix plan: T21, T22, T26 (template half)

#### T21: bar field annotations

##### Step 1

`modules/04-gui/01-bar.nix` line 21, anchor `position = 0;`

Annotate the bar's `position` integer with a labeled spin control in group "Bar", mirroring the dock's position control at `modules/04-gui/02-dock.nix:26`.

```nix
      enabled = true;

      name = "Main Bar";

      # @option widget = "spin"; label = "Position"; group = "Bar"; groupOrder = 10; min = 0; max = 1; step = 1; description = "0 = top, 1 = bottom.";
      position = 0;

      visible = true;

      showOnLastDisplay = true;

      screenPreferences = [ "all" ];

      centerWidgets = [
        "music"
        "clock"
        "weather"
      ];
```

The description text is copied from the dock so both pages document the integer the same way.

##### Step 2

`modules/04-gui/01-bar.nix` line 37, anchor `openOnOverview = false;`

Annotate the bar-level `_order` as a hidden spin (matching the dock's treatment of its own `_order` at `02-dock.nix:23-24`), then group `autoHide` and `autoHideDelay` under a shared "Auto hide" label with the delay gated on the switch.

```nix
      openOnOverview = false;

      # @option widget = "spin"; label = "Order"; group = "Bar"; groupOrder = 10; min = 1; max = 1000; hidden = true; description = "Sort order when several bars exist.";
      _order = 10;

      # @option widget = "switch"; label = "Auto hide"; group = "Auto hide"; groupOrder = 20; description = "Hide the bar until the pointer reaches the screen edge.";
      autoHide = false;

      # @option widget = "spin"; label = "Auto hide delay"; group = "Auto hide"; groupOrder = 20; min = 0; max = 5000; unit = "ms"; description = "Delay before the bar hides again."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.autoHide"; visibleWhen.equals = true;
      autoHideDelay = 250;

      attachToScreenEdge = false;

      useOverlayLayer = false;
```

The `visibleWhen` path keys off the full `barConfigs.default.autoHide` attribute, mirroring how the dock gates `smartAutoHide` at `02-dock.nix:51`.

##### Step 3

`modules/04-gui/01-bar.nix` line 47, anchor `transparency = 1;`

Annotate the transparency family as two sliders in a shared "Transparency" group, matching the dock's slider shape at `02-dock.nix:103`.

```nix
      useOverlayLayer = false;

      # @option widget = "slider"; label = "Transparency"; group = "Transparency"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar background.";
      transparency = 1;

      # @option widget = "slider"; label = "Widget transparency"; group = "Transparency"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar widgets.";
      widgetTransparency = 1;

      iconScale = 0.9;

      fontScale = 0.9;

      spacing = 0;

      bottomGap = 0;

      innerPadding = 0;

      widgetPadding = 9;
```

Min/max/step match the dock's transparency slider so both pages expose the same 0.0-1.0 range.

##### Step 4

`modules/04-gui/01-bar.nix` line 83, anchor `island = true;`

Annotate the island switch with a description and start the "Island" group, then annotate the compact thickness and the first three satellite gap fields as labeled spins.

```nix
      popupGapsAuto = true;

      popupGapsManual = 4;

      # @option widget = "switch"; label = "Island"; group = "Island"; groupOrder = 40; description = "Draw the bar as a floating island detached from the screen edge.";
      island = true;

      # @option widget = "spin"; label = "Compact thickness"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Island thickness in compact mode.";
      islandCompactThickness = 31;

      # @option widget = "spin"; label = "Outer gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px";
      islandOuterGap = 3;

      # @option widget = "spin"; label = "Satellite gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px";
      islandSatelliteGap = 8;

      # @option widget = "spin"; label = "Satellite hover gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px";
      islandSatelliteHoverGap = 5;
```

Gap and thickness spins use `unit = "px"` with generous maxes, matching the dock's sizing group style at `02-dock.nix:88-101`.

##### Step 5

`modules/04-gui/01-bar.nix` line 94, anchor `islandSatelliteHoverSize = 30;`

Annotate the four satellite size fields and the two hover delay fields in the "Island" group, giving the delays `unit = "ms"`.

```nix
      islandSatelliteHoverGap = 5;

      # @option widget = "spin"; label = "Satellite hover size"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px";
      islandSatelliteHoverSize = 30;

      # @option widget = "spin"; label = "Satellite hover size expanded"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px";
      islandSatelliteHoverSizeExpanded = 24;

      # @option widget = "spin"; label = "Satellite size"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px";
      islandSatelliteSize = 26;

      # @option widget = "spin"; label = "Satellite size expanded"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px";
      islandSatelliteSizeExpanded = 20;

      # @option widget = "spin"; label = "Hover open delay"; group = "Island"; groupOrder = 40; min = 0; max = 2000; unit = "ms";
      islandHoverOpenDelay = 350;

      # @option widget = "spin"; label = "Hover close delay"; group = "Island"; groupOrder = 40; min = 0; max = 2000; unit = "ms";
      islandHoverCloseDelay = 350;
```

The "expanded" labels mirror the DMS field names (`...Expanded`) so the mapping stays obvious.

##### Step 6

`modules/04-gui/01-bar.nix` line 106, anchor `islandWidgetPadding = 0;`

Annotate the remaining island widget-outline and goth-corner fields, gating the outline color/opacity on the outline switch and the radius on the override switch, cascading the way the dock gates border opacity on `borderEnabled` at `02-dock.nix:113-117`.

```nix
      islandHoverCloseDelay = 350;

      # @option widget = "spin"; label = "Widget padding"; group = "Island"; groupOrder = 40; min = 0; max = 40; unit = "px";
      islandWidgetPadding = 0;

      # @option widget = "switch"; label = "Widget outline"; group = "Island"; groupOrder = 40; description = "Outline the widgets inside the island.";
      islandWidgetOutlineEnabled = true;

      # @option widget = "text"; label = "Widget outline color"; group = "Island"; groupOrder = 40; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
      islandWidgetOutlineColor = "surfaceText";

      # @option widget = "slider"; label = "Widget outline opacity"; group = "Island"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
      islandWidgetOutlineOpacity = 0.5;

      # @option widget = "switch"; label = "Goth corners"; group = "Island"; groupOrder = 40; description = "Square off the island corners instead of rounding them.";
      islandGothCornersEnabled = false;

      # @option widget = "switch"; label = "Override goth corner radius"; group = "Island"; groupOrder = 40; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornersEnabled"; visibleWhen.equals = true;
      islandGothCornerRadiusOverride = false;

      # @option widget = "spin"; label = "Goth corner radius"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornerRadiusOverride"; visibleWhen.equals = true;
      islandGothCornerRadiusValue = 20;
```

The outline opacity uses the same 0.0-1.0 slider shape as the transparency family in step 3.

##### Step 7

`modules/04-gui/01-bar.nix` line 126, anchor `/* @option label = "Left widgets"; */`

Extend the left-widgets container annotation with a description that explains what the rows are and what `_order` means inside the attrset, since the per-widget rows themselves are rendered by the GUI (G7) and cannot carry template annotations.

```nix
      gothCornerRadiusValue = 12;

      islandGothCornersEnabled = false;

      islandGothCornerRadiusOverride = false;

      islandGothCornerRadiusValue = 20;

      /* @option label = "Left widgets"; description = "Widgets shown on the left of the bar. Each entry's _order sets its position."; */
      leftWidgets = {

        workspaceSwitcher = {
          enabled = true;
          _order = 10;
          showOccupiedWorkspacesOnly = true;
          showWorkspaceIndex = true;
          showWorkspacePadding = true;
          workspacePaddingCount = 5;
          dwlShowAllTags = false;
        };
```

Context lines above the edit are unchanged and only anchor the step in the file.

##### Step 8

`modules/04-gui/01-bar.nix` line 156, anchor `/* @option label = "Right widgets"; */`

Apply the same description treatment to the right-widgets container annotation, keeping the two container labels symmetric.

```nix
      };

      /* @option label = "Right widgets"; description = "Widgets shown on the right of the bar. Each entry's _order sets its position."; */
      rightWidgets = {

        systemTray = {
          enabled = true;
          _order = 10;
        };

        clipboard = {
          enabled = true;
          _order = 20;
        };

        developerUtilities = {
          enabled = true;
          _order = 30;
        };
```

The `dankKDEConnect` entry stays untouched; its relocation from `03-phoneconnect.nix` is T33, not this entry.

#### T22: dock widget ids stay, container gets a description

##### Step 9

`modules/04-gui/02-dock.nix` line 165, anchor `/* @option label = "Widgets"; */`

Add a description to the dock widgets container annotation documenting that the keys are fixed DMS widget ids and that `_order` inside each entry sets the item order; the keys themselves stay unrenamed because `toArray` in ojuny-desktop's `lib/mk-config.nix:32` turns each attrset key straight into the `id` field of the JSON DMS consumes, so renaming `dock_launcher`/`dock_apps`/`dock_trash` would break the widget registry lookup.

```nix
      # @option widget = "list"; label = "Item order"; group = "Dock"; groupOrder = 10; description = "Explicit dock item order, empty for default."; hidden = true;
      order = [ ];

      # Dock widgets
      /* @option label = "Widgets"; description = "Dock items keyed by their DMS widget id. _order sets the item order."; */
      widgets = {
        dock_launcher = { enabled = true; _order = 10; };
        dock_apps = { enabled = true; _order = 20; };
        dock_trash = { enabled = true; _order = 30; };
      };
    };

  };

}
```

Friendly display names over the raw ids are G7's job; the template's half is documenting the ids and leaving the data shape stable.

#### T26: menu ordering and redundant toggle

##### Step 10

`modules/04-gui/06-menu.nix` line 14, anchor `label = "Manage menu with Nix"`

Remove the `@option` annotation from `desktop.ojuny.dankMenu.enable` so it becomes an unannotated always-on assignment, matching the review-2 pattern at `modules/02-core/10-updates.nix:27`, then move the Menu tree to groupOrder 10 with a description and drop the Extra plugin settings block from the top of the file (it returns after the tree in step 11).

```nix
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-menu = { config, pkgs, ... }: {

    desktop.ojuny.dankMenu.enable = true;

    # @option widget = "menu"; label = "Menu tree"; group = "Menu"; groupOrder = 10; order = 10; description = "Entries shown in the Ojuny application menu.";
    desktop.ojuny.dankMenu.menu = {
      "apps" = { icon = "apps"; label = "Apps"; aliases = [ "app" "applications" ]; provider = "apps"; };
      "learn" = { icon = "school"; label = "Learn"; };
      "trigger" = { icon = "bolt"; label = "Utils"; };
      "setup" = { icon = "settings"; label = "Settings"; aliases = [ "settings" ]; };
      "system" = { icon = "power_settings_new"; label = "System"; aliases = [ "power-menu" ]; };
```

The bare `enable` assignment keeps the menu managed by Nix with no visible toggle, which is what the review asked for.

##### Step 11

`modules/04-gui/06-menu.nix` line 60 (after step 10), anchor `system.shutdown`

Insert the Extra plugin settings control after the closed menu tree with groupOrder 20 and order 20, so plugin settings sit at the bottom of the page; line numbers below are as the file reads after step 10.

```nix
      "setup.network" = { icon = "wifi"; label = "Network"; aliases = [ "wifi" "wlan" ]; action = "dms ipc call settings focusOrToggleWith network"; };
      "setup.control-center" = { icon = "tune"; label = "Control Center"; aliases = [ "audio" "bluetooth" ]; action = "dms ipc call control-center toggle"; };
      "setup.rebuild" = { icon = "restart_alt"; label = "Rebuild System"; action = "ghostty --title='Floating-Menu' -e zsh -c 'echo \"Initializing Update\"; source /etc/zshrc; sudo echo \"nixupdate source is $nixupdatesrc\"; $nixupdatesrc; echo \"press enter to exit\"; read -n 1'"; };
      "setup.update" = { icon = "restart_alt"; label = "Update and Rebuild System"; action = "ghostty --title='Floating-Menu' -e zsh -c 'echo \"Initializing Update\"; source /etc/zshrc; sudo echo \"pulling git update\"; git -C $HOME/repos/ojuny-template pull; echo \"nixupdate source is $nixupdatesrc\"; $nixupdatesrc; echo \"press enter to exit\"; read -n 1'"; };

      "system.lock" = { icon = "lock"; label = "Lock"; action = "loginctl lock-session"; };
      "system.suspend" = { icon = "bedtime"; label = "Suspend"; action = "systemctl suspend"; };
      "system.logout" = { icon = "logout"; label = "Logout"; action = "loginctl terminate-session \"$XDG_SESSION_ID\""; };
      "system.reboot" = { icon = "restart_alt"; label = "Reboot"; action = "systemctl reboot"; };
      "system.shutdown" = { icon = "power_settings_new"; label = "Shutdown"; action = "systemctl poweroff"; };
    };

    # @option widget = "raw"; label = "Extra plugin settings"; group = "Menu"; rows = 6; groupOrder = 20; order = 20; description = "Raw settings passed through to menu plugins.";
    desktop.ojuny.dankMenu.settings = { };

  };

}
```

The tree entries already carry a `label` and `icon` on all 39 rows, so no data changes are needed for the G9 rework's display text.

### Fix plan: T27, T30, T31

#### Step 1 (T27: multimedia app descriptions)

Add a nested `/* @option */` comment carrying a `label` and a `description` above each of the four boolean children inside the horizontal submodule, so the GUI renders a named switch with explanatory text instead of the raw segment names. The option declarations above, the parent annotation, and the default values are unchanged context.

`modules/05-applications/02-multimedia.nix` line 22, anchor `options.ojuny.apps.multimedia`

```nix
      options.ojuny.apps.multimedia = {
        mpv = lib.mkEnableOption "the mpv media player";
        obs = lib.mkEnableOption "OBS Studio";
        audacity = lib.mkEnableOption "Audacity";
        gimp = lib.mkEnableOption "GIMP";
      };

      config = {
        # @option widget = "horizontal-submodule"; label = "Applications"; group = "Apps"; groupOrder = 10;
        ojuny.apps.multimedia = {
          /* @option widget = "switch"; label = "mpv"; description = "Minimalist media player for video and audio."; */
          mpv = false;
          /* @option widget = "switch"; label = "OBS Studio"; description = "Video recording and live streaming."; */
          obs = false;
          /* @option widget = "switch"; label = "Audacity"; description = "Audio editor and recorder."; */
          audacity = false;
          /* @option widget = "switch"; label = "GIMP"; description = "Image editor and photo manipulation."; */
          gimp = false;
        };
```

The `/* @option */` form on the children matches the nested-directive style inside the submodule at `modules/01-users/01-user.nix:17`, and the untouched parent annotation keeps the four switches on one horizontal row.

#### Step 2 (T30: GameMode description, kept visible)

Choosing the description option over gating on Steam: extend the GameMode switch's description with a sentence stating it is independent of Steam, and leave the switch without a `visibleWhen`. Every other annotation in the block is unchanged context shown to locate the edit.

`modules/05-applications/05-steam.nix` line 41, anchor `feeds Steam's compatibility tool list`

```nix
        # Derived, no @option: feeds Steam's compatibility tool list.
        programs.steam.extraCompatPackages = lib.optionals config.ojuny.steam.protonGE [ pkgs.proton-ge-bin ];

        # @option widget = "switch"; label = "Gamescope session"; group = "Steam"; description = "Add a sessions entry that boots straight into Steam Big Picture through gamescope."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.gamescopeSession.enable = false;

        # @option widget = "switch"; label = "GameMode"; group = "Steam"; description = "Lets games request a temporary performance profile (governor, niceness, IO priority). Works independently of Steam and other launchers.";
        programs.gamemode.enable = true;

        # @option widget = "switch"; label = "Remote Play firewall"; group = "Steam"; description = "Open the ports Steam Remote Play uses on the local network."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.remotePlay.openFirewall = true;

        # @option widget = "switch"; label = "LAN game transfers"; group = "Steam"; description = "Allow Steam to copy game downloads between PCs on the local network."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.localNetworkGameTransfers.openFirewall = true;

        # @option widget = "switch"; label = "Dedicated server firewall"; group = "Steam"; advanced = true; description = "Open ports for hosted game servers."; visibleWhen.path = "programs.steam.enable"; visibleWhen.equals = true;
        programs.steam.dedicatedServer.openFirewall = false;
```

The only edited line is the GameMode annotation at current line 47; the appended sentence keeps the switch visible while telling the user it does not depend on Steam.

#### Step 3 (T31: webapps duplicate title, template half)

Rename the enable switch's label from "Web apps" to "Enable web apps" and the table's label from "Web apps" to "Apps", so the page title, the switch, and the table no longer show the same string three times. The descriptions, column set, table rows, and derived list are unchanged context.

`modules/06-utility/01-webapps.nix` line 55, anchor `widget = "switch"; label = "Web apps"`

```nix
        # @option widget = "switch"; label = "Enable web apps"; group = "Web apps"; description = "Install Chromium web applications as desktop entries.";
        programs.chromium-webapps.enable = true;

        # @option widget = "table-attrset"; label = "Apps"; group = "Web apps"; columns = [ "enable" "name" "url" "icon" ];
        ojuny.webapps = {
          /* @table-item label = "YouTube"; */
          youtube = {
            enable = true;
            name = "YouTube";
            url = "https://www.youtube.com";
            icon = null;
          };
        };

        # Derived list; no @option.
        programs.chromium-webapps.webApps =
          lib.mapAttrsToList
            (_: app: { inherit (app) name url; } // lib.optionalAttrs (app.icon != null) { inherit (app) icon; })
            (lib.filterAttrs (_: app: app.enable) config.ojuny.webapps);
      };
```

Both edits touch only the `label =` fields inside the existing `# @option` comments; the column misalignment noted in the review stays with the GUI-side item G10.

### Fix plan: T33, T36, T37

T33 and T36 are template-owned; T37 is the documentation drift the entry lists. Only the ranges the T37 entry names are edited; stale references outside them (for example `docs/02-settings-menu.md:52-53`, `docs/01-architecture.md:74-87,123-137`, `docs/04-scope.md:38`) stay as they are.

#### Step 1 (T33: create the KDE Connect applications page)

Adds the new page carrying only the KDE Connect enable switch and the valent package default moved from the deleted phone-connect page. The bar widget needs no new home because `modules/04-gui/01-bar.nix:139-142` already owns `leftWidgets.dankKDEConnect`, and the control-center entry lands in step 2.

file: `modules/05-applications/06-kdeconnect.nix`, filename `06-kdeconnect.nix`, line 1 (new file), ctrl+f anchor: `@menu`

```nix
/*
  @menu
  displayname = "KDE Connect";
  icon = "phone-symbolic";
  order = 60;
  description = "KDE Connect integration";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-kdeconnect = { pkgs, lib, ... }: {
    # @option widget = "switch"; label = "KDE Connect"; group = "KDE Connect"; groupOrder = 10; order = 1; description = "Phone notifications, file transfer and remote input.";
    programs.kdeconnect.enable = true;

    # themed fork of KDE Connect used by stylix; parity with dendrite desktop-svc.nix.
    programs.kdeconnect.package = lib.mkDefault pkgs.valent;

  };

}
```

`order = 60` sorts the page after Steam, the icon and description are carried over from the deleted page, and the module declares no `options` so its shorthand body needs no `config` wrapper.

#### Step 2 (T33: add the control-center widget entry)

Inserts the KDE Connect control-center entry between the VPN widget and the `# System` group comment; the other lines are unchanged context shown for orientation.

file: `modules/04-gui/05-controlcenter.nix`, filename `05-controlcenter.nix`, line 47, ctrl+f anchor: `label = "VPN"`

```nix
    # @option widget = "horizontal-submodule"; label = "VPN"; group = "Connectivity"; groupOrder = 30; order = 110; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn = { enabled = true; _order = 110; col = 3; row = 3; w = 5; h = 1; };

    # @option widget = "horizontal-submodule"; label = "KDE Connect"; group = "Connectivity"; groupOrder = 30; order = 120; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.plugin_dankKDEConnect = { enabled = true; _order = 120; col = 3; row = 4; w = 5; h = 1; };

    # System
    # @option widget = "horizontal-submodule"; label = "Disk usage"; group = "System"; groupOrder = 40; order = 130; maxColumns = 4; visibleWhen.path = "desktop.ojuny.dms.controlCenterWidgets.diskUsage.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage = { enabled = true; mountpath = "/"; _order = 130; col = 3; row = 5; w = 5; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Night mode"; group = "System"; groupOrder = 40; order = 140; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.nightMode = { enabled = true; _order = 140; col = 4; row = 6; w = 2; h = 1; footer = true; footerW = 1; };

    # @option widget = "horizontal-submodule"; label = "Do not disturb"; group = "System"; groupOrder = 40; order = 150; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb = { enabled = true; _order = 150; col = 4; row = 7; w = 2; h = 1; footer = true; footerW = 1; };

    # @option widget = "horizontal-submodule"; label = "Idle inhibitor"; group = "System"; groupOrder = 40; order = 160; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor = { enabled = true; _order = 160; col = 4; row = 6; w = 2; h = 1; footer = true; footerW = 1; };
```

The two inserted lines fill the order-120 and row-4 slot between VPN (110/row 3) and disk usage (130/row 5), and the group, groupOrder and maxColumns fields copy the neighbouring Connectivity entries so the row sorts and spans like the rest of the column-3 stack.

#### Step 3 (T33: delete the page, retarget the imports)

Deletes `modules/06-utility/03-phoneconnect.nix`, then replaces the imports block: the `desktop-phoneconnect` entry is removed and `applications-kdeconnect` is inserted after `applications-git` to keep the applications block alphabetical.

file: `modules/07-system/00-imports.nix`, filename `00-imports.nix`, line 31, ctrl+f anchor: `desktop-phoneconnect`

```nix
      self.modules.nixos.desktop-menu
      self.modules.nixos.desktop-plugins
      self.modules.nixos.desktop-binds
      self.modules.nixos.desktop-autostart
      self.modules.nixos.desktop-input
      self.modules.nixos.desktop-login
      self.modules.nixos.desktop-controlcenter
      self.modules.nixos.desktop-gestures
      self.modules.nixos.desktop-launcher

      self.modules.nixos.applications-applist
      self.modules.nixos.applications-browser
      self.modules.nixos.applications-git
      self.modules.nixos.applications-kdeconnect
      self.modules.nixos.applications-multimedia
      self.modules.nixos.applications-office
      self.modules.nixos.applications-steam
      self.modules.nixos.applications-terminal
      self.modules.nixos.applications-vesktop
    ];
```

`desktop-phoneconnect` is gone from the list because the file is deleted in this step, and the removed import was its only reference outside documentation.

#### Step 4 (T33: update the category map)

Moves `kdeconnect` into the Applications row and drops `phoneconnect` from the Utility row; the prose above the table and the other rows are unchanged context. This table reflects the state after the T20 clipboard step also applied; if T20 has not been applied yet, keep its `clipboard` addition in the 03-Desktop row.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, line 34, ctrl+f anchor: `Categories are explicit strings`

```markdown
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
| `03-Desktop` | login, mangosettings, mangomaster, mangodwindle, scroller, mangoworkspaces, notifications, clipboard |
| `04-GUI` | bar, dock, launcher, dashboard, controlcenter, menu |
| `05-Applications` | applist, multimedia, office, vesktop, steam, kdeconnect |
| `06-Utility` | webapps, plugins |
| `07-System` | configuration, networking, bluetooth, graphics |
| `Patches` | patch-development |
```

The two row edits make the category map match the `@menu` `category` strings set by step 1 and the deleted page; the T16 relocations have their own plan and are not touched here.

#### Step 5 (T36: open the config wrapper in the development patch)

The landed T13 plan declares its aliases submodule inline in `02-core/08-terminal.nix` and extracts no shared helper, so this patch repeats that pattern with its own option. This opens the explicit `config` wrapper the module needs once it declares `options`; only the `config = {` line is new, the rest is unchanged context.

file: `modules/patches/01-patch-development.nix`, filename `01-patch-development.nix`, line 57, ctrl+f anchor: `label = "Packages"`

```nix
    in
    {
      config = {
      # @option widget = "packages"; label = "Packages"; group = "Packages"; description = "Language servers, formatters and developer command line tools.";
      environment.systemPackages = with pkgs; [
        nixd
        nixfmt
        nixos-anywhere
        deploy-rs
        nvd
        nix-output-monitor
        clang-tools
        rust-analyzer
        pyright
        shellcheck
        github-cli
        netcat-openbsd
      ];
```

A module that declares `options` must put its definitions under an explicit `config` attribute, and the children keep their current indent the way `modules/02-core/05-style.nix:179-180` does; the gate in `modules/patches/00-patches.nix:30-43` passes `options` through and wraps `config` in `mkIf`, so the gated patch still evaluates.

#### Step 6 (T36: declare the aliases option)

Inserts the `ojuny.apps.development.aliases` option between the module body open and the `config = {` line added in step 5; `ojuny.patches` in `07-system/01-configuration.nix:22` is a leaf bool, so the aliases option lives under `ojuny.apps` like the terminal, multimedia, office and vesktop options.

file: `modules/patches/01-patch-development.nix`, filename `01-patch-development.nix`, line 58, ctrl+f anchor: `config = {`

```nix
    {
      options.ojuny.apps.development.aliases = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable this alias.";
              };
              value = lib.mkOption {
                type = lib.types.str;
                description = "Command the alias expands to.";
              };
            };
          }
        );
        default = { };
        description = "Shell aliases keyed by name, converted to environment.shellAliases.";
      };

      config = {
```

The option mirrors the `ojuny.webapps` submodule at `modules/06-utility/01-webapps.nix:25-52` and the aliases option the T13 plan adds to `02-core/08-terminal.nix`, with `enable` defaulting to true so both shipped aliases start on.

#### Step 7 (T36: replace the alias widgets with the table)

Replaces the raw `environment.shellAliases` block with the table annotation, the two rows and the derived assignment; the first (`];`) and last (`    };`) lines are unchanged context.

file: `modules/patches/01-patch-development.nix`, filename `01-patch-development.nix`, line 73, ctrl+f anchor: `environment.shellAliases = {`

```nix
      ];

      # @option widget = "table-attrset"; label = "Aliases"; group = "Aliases"; columns = [ "enable" "value" ];
      ojuny.apps.development.aliases = {
        /* @table-item label = "llm"; */
        llm = { enable = true; value = "nix develop -c opencode"; };
        /* @table-item label = "projects"; */
        projects = { enable = true; value = "${projects}/bin/projects"; };
      };

      # Derived, no @option: enabled rows become shell aliases.
      environment.shellAliases =
        lib.mapAttrs (_: entry: entry.value)
          (lib.filterAttrs (_: entry: entry.enable) config.ojuny.apps.development.aliases);
      };
    };
```

The per-alias `text` descriptions are dropped because `@table-item` only takes a label, the derivation follows the webapps/T13 `mapAttrs`/`filterAttrs` shape, the new `      };` closes the `config` block opened in step 5 while the trailing `    };` still closes the module body, and `config` plus `lib` are already in the module arguments at lines 17-18.

#### Step 8 (T37: complete the widget list)

Replaces the built-in widget bullet with two bullets: the original list unchanged, plus the custom widgets declared across `modules/`; the surrounding section text is unchanged context.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, line 8, ctrl+f anchor: `Widgets:`

```markdown
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
- Custom widgets: `bar`, `dock`, `menu`, `monitors`, `plugins`, `keybinds`,
  `theme`, `horizontal-submodule`, `table-attrset`, `table-list`.
- Type, description, default, and choices come from nixd (fallback `nix eval`),
  so a page only needs the assignment plus the `@option` comment.
```

Every custom name except `table-list` is declared by an `@option` annotation in the current tree; `table-list` is the additional kind the T37 entry names.

#### Step 9 (T37: rewrite the pages section head and 01-users)

Replaces original lines 55-68 (from `## 4. Pages` through the blank before the old `### 02-desktop`); the last text line of the old region anchors on `powerlevel10k`.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, line 57 (original 55; step 8 added 2 lines), ctrl+f anchor: `## 4. Pages`

```markdown
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
```

The `01-user.nix` bullet keeps its richer description from the old section, and `00-colors.nix` is marked `[no menu]` because it carries no `@menu` header.

#### Step 10 (T37: finish 02-core and open 03-desktop)

Replaces original lines 69-99 (from the old `### 02-desktop` header through the blank before `### 03-applications`, ending at the `Lockscreen is merged` line); earlier steps shift the numbers, so locate the region by ctrl+f.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, original line 69, ctrl+f anchor: `### 02-desktop`

```markdown
- `02-input.nix` `[menu]`. Keyboard, mouse, trackpad and touch.
- `03-binds.nix` `[menu]`. Key, mouse, axis and gesture bindings.
- `04-gestures.nix` `[menu]`. Touchpad swipe gestures and swipe tuning.
- `05-style.nix` `[menu]`. Theme, colors, fonts, gaps, borders, shadows and
  animations. Wallpaper folds in here.
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
```

Each bullet copies the file's `@menu` `description` string; the D11/D10 decision references are dropped because §5 still phrases those decisions with the old paths.

#### Step 11 (T37: finish 03-desktop and write 04-gui)

Replaces original lines 100-119 (from the old `### 03-applications` header through the `14-virtualization.nix` bullet); locate the region by ctrl+f since earlier steps shift the numbers.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, original line 100, ctrl+f anchor: `### 03-applications`

```markdown
- `03-mangomaster.nix` `[menu]`. Master and stack layout.
- `04-mangodwindle.nix` `[menu]`. Dwindle tiling layout.
- `05-scroller.nix` `[menu]`. Horizontal scrolling window layout.
- `06-mangoworkspaces.nix` `[menu]`. Workspace and tag settings.
- `07-notifications.nix` `[menu]`. Notification popups and clipboard history.

### 04-gui

- `01-bar.nix` `[menu]`. Bar layout, widgets and island style.
- `02-dock.nix` `[menu]`. Dock appearance and behaviour.
- `03-launcher.nix` `[menu]`. App launcher style, behaviour and plugin
  triggers.
- `04-dashboard.nix` `[menu]`. Dashboard cards, tabs and their placement.
- `05-controlcenter.nix` `[menu]`. Control center widgets and layout.
- `06-menu.nix` `[menu]`. Nix managed application menu.
```

The bullets follow the file order in `modules/03-desktop/` and `modules/04-gui/` with the `@menu` description as each summary, and the five nonexistent proposed applications pages are gone.

#### Step 12 (T37: write 05-applications, 06-utility and open 07-system)

Replaces original lines 121-130 (from the old `### 04-system` header through the `02-hardware.nix` bullet, ending at `hostPlatform (D5, D6).`); locate the region by ctrl+f.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, original line 121, ctrl+f anchor: `### 04-system`

```markdown
### 05-applications

- `01-applist.nix` `[menu]`. Applications installed system-wide (D8).
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
```

The applications list gains `06-kdeconnect.nix` from step 1, the old multi-system prose is dropped because §5 D13 still records that decision, and `00-hardware.nix` keeps the generated-file wording the old section used for its predecessor `02-hardware.nix`.

#### Step 13 (T37: finish 07-system and write patches)

Replaces original lines 131-147 (from the `03-networking.nix` bullet through the `13-xserver.nix` bullet, the last line of the old section); the blank line before `## 5. Resolved decisions` stays.

file: `docs/02-settings-menu.md`, filename `02-settings-menu.md`, original line 131, ctrl+f anchor: `03-networking.nix`

```markdown
- `00-host.nix` `[no menu]`. The host configuration: system and module list.
- `00-imports.nix` `[no menu]`. The import list that decides which pages a
  host loads.
- `00-ssh-test.nix` `[no menu]`. Temporary SSH test module.
- `01-configuration.nix` `[menu]`. Hostname, time zone, locale, console
  keymap and the patches switch. `system.stateVersion` present but never
  exposed (D15).
- `02-networking.nix` `[menu]`. NetworkManager, firewall, hosts, DNS.
- `03-bluetooth.nix` `[menu]`. Bluetooth pairing and services.
- `04-graphics.nix` `[menu]`. Graphics drivers and hardware acceleration.

### patches

- `00-patches.nix` `[no menu]`. Imports `patch-*` modules while
  `ojuny.patches` is enabled.
- `01-patch-development.nix` `[menu]`. Editors, language servers,
  formatters and develop-shell wrappers.
```

The plumbing files are listed so the section matches the numbering block in step 14, and the patches section names both files in `modules/patches/` with the gate condition from `00-patches.nix:46`.

#### Step 14 (T37: rewrite the architecture numbering block)

Replaces the code block that still lists `02-desktop/`, `03-applications/`, `04-system/` and the proposed files with the directories and files as they exist in `modules/` after step 1.

file: `docs/01-architecture.md`, filename `01-architecture.md`, line 104, ctrl+f anchor: `01-users/`

````
```
01-users/         01-user.nix  02-commonsettings.nix
02-core/          00-colors.nix  01-display.nix  02-input.nix  03-binds.nix
                  04-gestures.nix  05-style.nix  06-browser.nix  07-git.nix
                  08-terminal.nix  09-autostart.nix  10-updates.nix
                  11-nixsettings.nix
03-desktop/       00-mango.nix  01-login.nix  02-mangosettings.nix
                  03-mangomaster.nix  04-mangodwindle.nix  05-scroller.nix
                  06-mangoworkspaces.nix  07-notifications.nix
04-gui/           01-bar.nix  02-dock.nix  03-launcher.nix  04-dashboard.nix
                  05-controlcenter.nix  06-menu.nix
05-applications/  01-applist.nix  02-multimedia.nix  03-office.nix
                  04-vesktop.nix  05-steam.nix  06-kdeconnect.nix
06-utility/       01-webapps.nix  02-plugins.nix
07-system/        00-hardware.nix  00-host.nix  00-imports.nix  00-ssh-test.nix
                  01-configuration.nix  02-networking.nix  03-bluetooth.nix
                  04-graphics.nix
patches/          00-patches.nix  01-patch-development.nix
```
````

The block lists every `.nix` file in the current tree including the new `06-kdeconnect.nix`, excludes the deleted `03-phoneconnect.nix`, and the stale `[no menu]` note at line 123-124 plus the layout tree at lines 74-87 stay because they are outside the range the entry lists.

#### Step 15 (T37: fix the theme gap lines)

Replaces original lines 56-73 (from the ghostty `Ref:` line through the end of the file): the palette and monospace-font lines are deleted and the wallpaper line keeps its gap with corrected path references; the rest is unchanged context.

file: `docs/ojuny-desktop-gaps.md`, filename `ojuny-desktop-gaps.md`, line 56, ctrl+f anchor: `OJ only installs the package`

```markdown
- Ref: DEN/modules/terminal/ghostty.nix; OJ only installs the package.

## Zsh
- [ ] config.zsh (powerlevel10k rainbow prompt) missing.
- [ ] functions.zsh: plz(), EDITOR=micro, IMAGEPROGRAM=satty missing.
- [ ] suffix aliases (json/yaml/md/toml/conf/nix/png/jpg/webp/...) missing.
- [ ] aliases missing: reloaddms, projects, gityoink, eza ls/la/ll/lt/l., cd aliases, colorized greps, cmdhist.
- [ ] fastfetch on every interactive shell (per-user logo) missing.
- [ ] histSize = 10000 missing.
- [ ] ohMyZsh (git, sudo) missing.
- [ ] syntax highlighting missing.
- [ ] powerlevel10k promptInit wiring missing.
- Ref: DEN/modules/terminal/{zsh,aliases,functions.zsh,config.zsh,fastfetch}.nix; OJ TPL/modules/03-applications/08-terminal.nix.

## Theme / wallpaper / fonts
- [ ] wallpaper: DEN everforest.png vs OJ stylix.image = null (stylix-everforest.nix:9,14 vs TPL modules/02-core/05-style.nix:197).
```

The deleted lines are resolved differences, since the tree now defaults the palette to `everforest-dark-hard` (`modules/02-core/05-style.nix:191`) and the monospace font to `CaskaydiaCove Nerd Font` (`05-style.nix:204`), both matching DEN, and the file's stated purpose at lines 3-5 says resolved lines are removed; the wallpaper gap remains open with its reference retargeted to the current file and line.

### Fix plan: T35

Template-owned. The `"intel"` default is kept for both the option and the dropdown, per the entry's acceptable option, so fresh installs behave identically.

#### Step 1

Guard the Intel extras and kernel params with `lib.mkIf` so they apply only when `ojuny.gpu == "intel"`; the `visibleWhen` annotations stay as they are for the GUI.

`modules/07-system/04-graphics.nix`, line 46, ctrl+f anchor: `# Intel`

```nix
        # Intel
        # @option widget = "packages"; label = "Intel media packages"; group = "Intel"; groupOrder = 20; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "intel"; description = "intel-media-driver (VA-API/iHD), vpl-gpu-rt (oneVPL) and intel-compute-runtime (OpenCL) for Xe and Arc GPUs.";
        hardware.graphics.extraPackages = lib.mkIf (config.ojuny.gpu == "intel") (with pkgs; [
          intel-media-driver
          vpl-gpu-rt
          intel-compute-runtime
        ]);

        # @option widget = "list"; label = "Kernel parameters"; group = "Intel"; groupOrder = 20; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "intel"; description = "Helps VA-API and QSV initialise on Arc and Xe GPUs.";
        boot.kernelParams = lib.mkIf (config.ojuny.gpu == "intel") [ "i915.enable_guc=3" ];
```

Wrapping the values in `lib.mkIf` makes the nix assignments follow the same gate as the GUI, so Intel settings no longer leak when `ojuny.gpu` is `"amd"` or `"none"`.

#### Step 2

Guard the AMD initrd switch and the two NVIDIA switches with per-vendor `lib.mkIf` so they only apply for their vendor.

`modules/07-system/04-graphics.nix`, line 56, ctrl+f anchor: `# AMD`

```nix
        # AMD
        # @option widget = "switch"; label = "AMDGPU in initrd"; group = "AMD"; groupOrder = 30; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "amd";
        hardware.amdgpu.initrd.enable = lib.mkIf (config.ojuny.gpu == "amd") true;

        # NVIDIA
        # @option widget = "switch"; label = "NVIDIA open kernel module"; group = "NVIDIA"; groupOrder = 40; order = 10; description = "Turn off for older cards that need the proprietary module."; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "nvidia";
        hardware.nvidia.open = lib.mkIf (config.ojuny.gpu == "nvidia") false;

        # @option widget = "switch"; label = "NVIDIA modesetting"; group = "NVIDIA"; groupOrder = 40; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "nvidia";
        hardware.nvidia.modesetting.enable = lib.mkIf (config.ojuny.gpu == "nvidia") true;
```

Using `lib.mkIf` on each assignment keeps the values scoped to the selected vendor, so `"none"` applies only the general options (acceleration, 32-bit, firmware).

#### Step 3

Add `"none"` to the enum, keeping `"intel"` as the default so the option stays type-safe without changing fresh-install behavior.

`modules/07-system/04-graphics.nix`, line 21, ctrl+f anchor: `options.ojuny.gpu = lib.mkOption`

```nix
    options.ojuny.gpu = lib.mkOption {
      type = lib.types.enum [
        "intel"
        "amd"
        "nvidia"
        "none"
      ];
      default = "intel";
      description = "Graphics vendor. Drives the kernel video drivers, the vendor extras and the VA-API backend.";
    };
```

The `"none"` value joins the existing three so the mkIf guards from steps 1-2 have a vendor-free selection to key off.

#### Step 4

Update the dropdown choices to include `"none"` while keeping the default and other metadata unchanged.

`modules/07-system/04-graphics.nix`, line 33, ctrl+f anchor: `# @option widget = "dropdown"`

```nix
      # @option widget = "dropdown"; label = "GPU vendor"; group = "Graphics"; groupOrder = 10; order = 10; description = "Intel covers Intel GPUs and generic modesetting."; choices = [ "intel" "amd" "nvidia" "none" ];
      ojuny.gpu = "intel";
```

The dropdown choices must mirror the enum values; adding `"none"` here lets the GUI select the new option without a type mismatch.

#### Step 5

Add a `"none"` arm to the `videoDrivers` and `LIBVA_DRIVER_NAME` lookups so `"none"` does not throw, and return an empty driver list plus a null VA-API backend.

`modules/07-system/04-graphics.nix`, line 68, ctrl+f anchor: `services.xserver.videoDrivers`

```nix
      services.xserver.videoDrivers =
        {
          intel = [ "modesetting" ];
          amd = [ "amdgpu" ];
          nvidia = [ "nvidia" ];
          none = [ ];
        }
        .${config.ojuny.gpu};

      environment.sessionVariables = lib.mkIf (config.ojuny.gpu != "nvidia") {
        LIBVA_DRIVER_NAME =
          {
            intel = "iHD";
            amd = "radeonsi";
            none = null;
          }
          .${config.ojuny.gpu};
      };
```

Returning an empty list for `"none"` forces no video drivers, and `"none" = null` keeps the LIBVA lookup safe so no vendor-specific VA-API backend is set.
