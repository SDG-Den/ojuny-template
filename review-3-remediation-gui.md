# review-3 remediation: GUI side

source: `review-3.md` (fresh-install review of ojuny template + nix-settings-gui custom modules)
repo analyzed: `/home/den/repos/nix-settings-gui`
companion: `review-3-remediation-template.md` (same review, template attribution)
date: 2026-10-18

## attribution key

the GUI repo owns the shape of the custom ojuny widgets, the functions of the GUI, rendering etc. (`review-3.md:7`). an issue is GUI-owned when the renderer, layout, widget builder, save path or dependency evaluator misbehaves even though the template's nix annotations are correct or where the requested improvement is a widget design change. template-owned issues (ordering, visibility flags, missing options, relocations) live in the companion doc; shared issues appear in both with their half described here.

architecture notes used throughout: directives (`@option`, `@menu`, `@snippet`, `@insert`, `@table-item`) are parsed in `src/dsl.rs`; scanning in `src/scan.rs`; every widget is built in `src/widgets.rs` (`build` at `:818`, `choose_widget` at `:872`); page layout, dirty tracking, visibleWhen evaluation and save are in `src/app.rs`; edits land on disk through `src/edit.rs` (`apply` at `:20`).

**attribution correction (confirmed):** the review ran against the most up-to-date SDG-Den inputs. every observation of correct template data rendering wrongly (craftapps table orientation, visibleWhen-gated options still visible, theme widget) is therefore a GUI defect, not a stale-config artifact. G6, G10 and G14 below absorb the items the template doc earlier listed as "verify".

---

## 02-Core

### G1. Monitors: add-monitor popup with detected modes; defaults 0/0/1.00; transform naming

review: "the add monitor prompt should be a pop-up that detects the monitor's name, refreshrate, width and height, prompting the user only to select one of their monitors, they can then position them interactively using the menu. the x/y currently start at -16K when they should default to 0, scale should default to 1.00, RR should be called transform and should be based on the details from the actual mango config."
status: open. GUI-owned.

current state (`src/widgets.rs`):
- "Add monitor" (`:2723-2764`) appends a scaffold `TableRowScan` with only `name = "\"\""` (`:2732-2736`). width/height/refresh/x/y/scale/rr all start empty; `number_spin` (`:2435-2441`) leaves the spin at the adjustment default when the value fails to parse, and the x/y ranges start at -16384 (`:2451-2452`), which is where the -16K observation comes from (an empty or out-of-range parse surfaces the range floor or a zero-height canvas normalization).
- there is no monitor detection. the app has a nixd/metadata path (`src/metadata.rs`, `src/nixd.rs`) but nothing queries the host's actual outputs (no sway-randr/wlr-randr/mango IPC call) to populate the add dialog.
- "RR" is a free-text `gtk::Entry` labeled "RR" with tooltip "Transform, 0-7" (`:2458-2476`). mango's monitor_rule field is `rr` in the template's data shape (`modules/02-core/01-display.nix:63` feeds whatever the GUI reads at `:2345-2369`), so renaming the display label to "Transform" is a GUI label change; changing the serialized key would need a template/data migration (template doc T4).

desired design:
1. add-monitor opens a dialog listing detected outputs (name, preferred width/height/refresh from the compositor); user picks one; the row is created with those values plus x=0, y=(stack below existing monitors or 0), scale=1.00, transform=0.
2. new-row defaults even without detection: width 1920, height 1080, refresh 60, x/y placed adjacent to the rightmost existing monitor (or 0), scale 1.00, transform "0".
3. rename the RR caption to "Transform" and offer a dropdown 0-7 with the rotation labels from mango docs (`~/repos/mango/docs`) instead of free text; serialize to the same `rr` key until the template migrates.
4. refresh/width/height become dropdowns populated from the selected monitor's reported modes (same detection source as (1)), falling back to the current spins when detection is unavailable.

files: `src/widgets.rs` (`build_monitors` `:2557`, `make_monitor_row` `:2433`, add handler `:2731-2763`, `monitor_row_nix` `:2345`); new detection helper (e.g. `src/monitor_detect.rs`); possibly `src/app.rs` for the dialog window.

### G2. Monitors: drag snapping, taller distinct canvas, full width

review: "monitors also need to snap to eachother when dragged around in the gui, and the canvas on which the monitors are dragged should be taller and be a different color to distinguish it, it should also always be the maximum width of the gui, not shrink if monitor positions allow it."
status: open. GUI-owned.

current state:
- canvas is a `gtk::DrawingArea` with fixed `content_width(640) content_height(240)` (`src/widgets.rs:2570-2573`), hexpand set but the content size caps the natural height at 240px. the draw func draws monitor rectangles on the theme default background with no distinct canvas fill (`:2575-2637`).
- drag (`:2694-2721`) adds the pixel delta / scale to the selected row's x/y with no snapping of any kind.

desired design:
1. snap: on drag update, after computing the candidate x/y, clamp each edge (left/right/top/bottom) of the dragged monitor to within ~8 canvas px (converted to config px via `view.scale`) of every other monitor's edges; prefer the smallest delta. write the snapped value back into the spins.
2. canvas: fixed height around 320-360 content px, explicit background fill (a surface color distinct from the page, e.g. `cr.set_source_rgb` on a dim theme tone or a CSS-classed backdrop box behind the drawing area), and `set_size_request(-1, 340)` so it never collapses. "always maximum width" means the canvas box must not be inside a container that shrinks; verify the page's control slot (`src/app.rs:1089-1096`, `slot.set_hexpand(true)` for non-inline editors) and that the monitors editor root hexpands (it does: `:2560`).

files: `src/widgets.rs` (`build_monitors` draw func `:2575`, drag `:2694`, canvas setup `:2570`).

### G3. Monitors: save/toggle desync

review: "saving with it and the gui updating when values are set via the toggles doesn't quite work correctly, things get desynced quite frequently."
status: open. GUI-owned.

current state: the monitors editor holds all rows in memory (`Rc<RefCell<Vec<MonitorRow>>>`, `:2562`) and serializes on save via `Editor::Monitors` -> `monitors_nix` (`:2378`). save (`src/app.rs` `save_all` `:1328`, `preview_changes` `:1489`) rewrites the assignment in the file through `src/edit.rs` `apply`. desync vectors identified:
1. the monitors record is a single assignment (`monitor_rule = [ ... ]`); any external change to the file (another editor tab, a rebuild writing defaults, nixfmt moving the block) invalidates `record.value` but the open editor keeps its in-memory rows; on save it overwrites the whole list from stale state.
2. toggle-driven visibleWhen refreshes (`connect_dirty` -> `refresh_dependencies` `src/app.rs:1158-1168, 1196`) rebuild page visibility but do not re-scan the monitors record, so rows never pick up external edits mid-session.
3. there is no reload path for a record after `edit.rs` rewrites the file other than a full page rebuild.

fix direction: after a successful `apply` for a bespoke-editor record, re-scan the assignment from disk and repopulate the editor (or at minimum refresh `record.value` and recompute `unchanged` so the dirty flag is honest). add a file-monitor or a manual "Reload page" hook so external edits repopulate. this is generic for all bespoke editors but manifests hardest on monitors because the user also edits the same file via rebuilds.

files: `src/app.rs` (`save_all` `:1328`, `collect_edits` `:1289`, `build_page` `:783`), `src/edit.rs` (`apply` `:20`), `src/widgets.rs` (Editor::Monitors population).

### G4. Keybinds: complete row rework (popup edit, styled preview, description subtext)

review: full rework from the current name/mods/keys/preview/foldout/delete row to: left-aligned name + description subtext; right-aligned [styled preview] [edit button] [delete]; edit opens a popup listing all fields as their relevant widgets; preview styled with a different background; foldout behavior (moving, tall cells) removed.
status: open. GUI-owned.

current state (`src/widgets.rs` `make_keybind_row` `:2073-2160`):
- main line is a horizontal box: key entry (14 chars) -> modifier entry (16) -> keys entry (12) -> preview label (dim caption, `bind_preview` `:1823`) -> `gtk::Expander` "Edit" wrapping dispatcher/args/description/group/subcat rows (`:2106-2124`) -> trash button.
- the expander reflows the list when opened (row height doubles) and pushes the trailing buttons; there is no description subtext, the name entry is inline rather than a label, and the preview has no background styling.
- rows sort by group/subcat/key (`build_keybinds` `:2218-2227`); serialization is `keybinds_nix` `:2175`.

desired design:
1. row layout: vertical box; top line horizontal with (a) vertical: name label/entry hexpand + description as dim caption below it, (b) trailing: preview label with an `css_classes(["pill"/"card"/"numeric"])`-style background, edit `gtk::Button` ("Edit"), trash icon button.
2. edit button opens a `gtk::Window`/`adw::Window` modal popup (transient for the app window) containing the full field set: name, modifier (list entry), keys (list entry), dispatcher (dropdown of known mango dispatchers if discoverable, else text), args, description, group, subcat - each as its natural widget with labels. closing the popup leaves the row height unchanged.
3. live preview keeps updating from the popup's modifier/keys fields the same way the inline watchers do today (`:2133-2145`).
4. drop the expander entirely; remove the inline modifier/keys entries from the main row (they live in the popup only).

files: `src/widgets.rs` (`make_keybind_row` `:2073`, `KeybindRow` struct, `connect_keybind_row` `:2198`, `keybinds_nix` `:2175`, `build_keybinds` `:2208`); CSS for the preview pill (there is precedent: `install_swatch_css` `:1790`).

### G5. Theme widget falls back to a text field

review: "color palette is not using the custom module, looks like a simple text field now."
status: open. GUI-owned (build/deploy).

current state:
- `build_theme` (`src/widgets.rs:1725-1787`) returns `Editor::Text(build_entry(...))` whenever `schemes::SCHEMES.is_empty()` (`:1726-1728`). otherwise it renders a swatch list (`install_swatch_css` `:1790`).
- `schemes::SCHEMES` is generated by `build.rs:8-26` from `TINTED_SCHEMES_DIR`; the env var is only set in the flake derivation (`flake.nix:58`). any `cargo build` / devshell build without it produces an empty table and thus the text field. the template's `widget = "theme"` annotation (`modules/02-core/05-style.nix:190`) is correct.

fix:
1. set `TINTED_SCHEMES_DIR` in the flake `devShells.default` (`flake.nix:94-114`) pointing at the `tinted-theming` input, so dev builds match release builds.
2. make the empty-schemes fallback louder: a label explaining schemes are missing plus the text entry, not a bare entry, so this failure mode is diagnosable.
3. optional hardening: fall back to scanning a runtime path if the compile-time table is empty.

files: `flake.nix` (devShell `:94`), `src/widgets.rs` (`build_theme` `:1725`), `build.rs` unchanged.

### G6. visibleWhen dependency evaluation failures (confirmed against current inputs)

review observations: gaps/borders/shadows sub-options "still available" with parent off; firefox group visible after switching browser; office defaults, vesktop settings and steam settings visible while their gates are off.
status: open. GUI-owned evaluator; template annotations confirmed present and correct (template doc T9, T11, T28-T30, T35), so the evaluator is the sole suspect.

current state: dependencies are evaluated in `src/app.rs` (`evaluate_dependencies` `:1196`, `apply_control_filter` `:1212`, refreshed from `connect_dirty` `:1158`). candidate failure modes to test and fix:
1. boolean `visibleWhen.equals = false` comparisons against switch editors whose current value is the nix literal `false` - string vs bool normalization when reading the dependency source record.
2. `visibleWhen.path` resolution for template-local option paths (`ojuny.style.customGaps`, `ojuny.browser.selected`) versus full attribute paths recorded by the scanner; a mismatch leaves the dependency permanently unsatisfied or permanently satisfied.
3. dependencies that key off an editor in a different group/page (browser dropdown -> firefox group works only if both records are on the same built page).
fix: write tests over `evaluate_dependencies` covering bool true/false, string equals, and path forms used in the template; fix whichever normalization is wrong; re-test the T38 checklist on a fresh install. the failure is systemic (it reproduces across style, browser, office, vesktop, steam), so prefer a root-cause fix in path resolution or value comparison over per-page patches.

files: `src/app.rs` (`evaluate_dependencies` `:1196`, `apply_control_filter` `:1212`), `src/dsl.rs` (`Visibility` `:342`), tests under `tests/`.

---

## 04-GUI

### G7. Bar and dock widget list editors: friendly names, hidden _order, grouped settings

review: leftwidgets/rightwidgets "a mess", complete redesign; dock widgets "shouldn't use dock_launcher style names and _order will not make sense to the end user, nothing has descriptive names"; autohide + autohidedelay as horizontal submodule; _order unexplained; position as dropdown.
status: open. GUI-owned widget; template supplies raw data (template doc T21, T22).

current state:
- `build_bar` (`src/widgets.rs:2959-3049`) splits `leftWidgets`/`rightWidgets`/`centerWidgets` out of the record (`:2968-2975`) and renders each with `build_attrset_rows` (`:2990-3017`), which uses `make_attrset_row` (`:1902`): a key entry (raw id like `workspaceSwitcher`) plus one editor per field name with the field name as its caption (`:1923-1932`). `_order` renders as a spin labeled "_order"; `showOccupiedWorkspacesOnly` renders as a raw caption. the extras (position, autoHide, autoHideDelay, transparency, island family...) fall into a flat "Settings" list (`:3020-3035`) via `build_child_row` (`:3172`), one per field, no grouping.
- `build_dock` (`:3079-3137`) is the same pattern for a single `widgets` attrset (`:3086-3108`); dock extras include `position` as a raw number (`02-dock.nix:26` feeds a spin) and many hidden fields.

desired design:
1. widget rows: replace the key entry with a static friendly label (a registry mapping `workspaceSwitcher` -> "Workspace switcher", `dankKDEConnect` -> "KDE Connect", `controlCenterButton` -> "Control center button", ... plus a fallback that title-cases the raw id); unknown ids still editable via a small "id" disclosure or editable label for advanced mode.
2. `_order`: do not render as a labeled field. either a small "Position" spin at the row's trailing edge, or reorderable rows (up/down buttons) that rewrite `_order` as 10/20/30 on save. prefer the position spin for cost.
3. per-widget tuning fields: render under a per-row expander or a nested horizontal flow instead of one long flat list; rename captions to sentences ("Show occupied workspaces only").
4. bar extras: group autoHide + autoHideDelay into one horizontal cell (the existing `build_horizontal_submodule` machinery at `:1393` can be reused for a synthetic group, or the extras renderer can pair known siblings). position becomes a dropdown "Top"/"Bottom" for both bar and dock (dock's current data documents 0=top/1=bottom at `02-dock.nix:26`).
5. descriptions: the control-row description only appears when the `@option` carries one; for bespoke child fields the GUI should surface a tooltip from a built-in help map when the template has none.

files: `src/widgets.rs` (`build_bar` `:2959`, `build_dock` `:3079`, `make_attrset_row` `:1902`, `build_attrset_rows` `:2010`, `build_child_row` `:3172`); new label registry (e.g. in `src/widgets.rs` or `build_support.rs`).

### G8. Dashboard and control center: real grid/table widget with add/remove

review: "col/row/w/h sections, we should turn those into tables, and allow the user to add/remove rows, this might need a custom module" (dashboard); "same as dashboard, but because the enable toggles are in here as well it's really messy" (control center).
status: open. GUI-owned; matches `missing-features.md:32` ("grid-configuration") and `:14` (generic table submodule).

current state:
- both pages use `widget = "horizontal-submodule"` (`modules/04-gui/04-dashboard.nix:40-62`, `05-controlcenter.nix:15-64`). `build_horizontal_submodule` (`src/widgets.rs:1393-1431`) renders each child attrset as a FlowBox cell with a dim label and the child's raw editors for enabled/_order/col/row/w/h. seventeen control-center cells x six raw fields is the mess the reviewer describes.
- the generic `build_table` (`:1435`) already handles `table-attrset`/`table-list` with columns and per-cell editors (`make_table_row` `:1531`, `build_cell` `:1633`) but has no notion of a fixed six-column grid widget with add/remove and no key entry.

desired design: a new `grid-configuration` widget kind (add to `WidgetKind` in `src/dsl.rs:252` and `choose_widget`):
1. one row per configured widget: [enabled switch] [friendly name (registry, same as G7)] [order spin] [col spin] [row spin] [w spin] [h spin] [delete].
2. "Add widget" button opens a picker of known-but-unconfigured widget ids (from a registry of valid control-center/bar widget names), or accepts a custom id in advanced mode.
3. serialization writes the same attrset shape the template already has (`{ enabled = true; _order = 120; col = 3; row = 4; w = 5; h = 1; }`), so no template migration is needed.
4. apply to dashboard cards/weather entries and all control-center widgets; phone connect's control-center widget (template T33) joins the same grid once relocated.

files: `src/dsl.rs` (`WidgetKind` `:252`, parse strings `:284-314`), `src/widgets.rs` (new builder near `build_table` `:1435`), `src/scan.rs` if column specs need scanning; template keeps `widget = "horizontal-submodule"` until switched to the new kind (coordinate: template T24/T25 note the field names stay stable).

### G9. Ojuny menu widget rework

review: "this module likewise needs a full rework" (after the template-side ordering/toggle asks).
status: open. GUI-owned widget; template handles ordering/removal (T26).

current state: `build_menu` (`src/widgets.rs:2774-2783`) is `build_attrset_rows` over the dankMenu attrset with a `label` scaffold default; rows are the generic attrset rows (key entry + one editor per present field: icon, label, aliases, provider, target, action, checked, when). for the template's 39-entry tree (`modules/04-gui/06-menu.nix:21-59`) this yields 39 flat rows of raw fields, sorted only by key, with dot-separated keys indented by `key.matches('.').count()` (`make_attrset_row` `:1910-1913`).

desired design:
1. tree-aware presentation: group rows under their top-level parent (apps, learn, trigger, setup, system) as sections, matching the dot hierarchy; keep the indent but add section headers.
2. per-row compact summary: icon (image button or named icon), label entry, aliases as a single comma entry, and a trailing "Edit" popup (reuse the G4 popup pattern) for provider/target/action/checked/when.
3. action/target rows distinguished (URL vs shell command); `when`/`checked` behind an "Advanced conditions" disclosure.
4. add-row scaffolds a child under a chosen parent (key becomes `parent.child`).
5. serialization keeps the flat attrset-of-attrsets shape the template has; no data migration.

files: `src/widgets.rs` (`build_menu` `:2774`, reusing popup machinery introduced in G4 and label registry from G7).

### G10. Table header alignment (webapps and all table-attrset pages)

review: "the labels for the columns are also not alligned" (web apps).
status: open. GUI-owned.

current state: `build_table` renders the header as one `gtk::Label` joining column names with three spaces (`src/widgets.rs:1453-1457`), while cells are independent editors in a vertical list per row (`make_table_row` `:1531`). the header cannot align with the cells.

fix: render the header as a horizontal box of labels laid out with the same spacing/expand flags as the row cells (reuse the row builder's column layout: for each column, a label with `hexpand` matching the cell editor's expand behavior). verify against `modules/06-utility/01-webapps.nix:58` (enable/name/url/icon) and `modules/05-applications/03-office.nix:56` (enable-only).

files: `src/widgets.rs` (`build_table` `:1435-1460`, `make_table_row` `:1531`).

### G10b. Craftapps table renders with editable names and inverted enable column (confirmed)

review: "craftapps section is completely the wrong way around, it has the names editable, but the false : behind it without edits."
status: open. GUI-owned; template data confirmed correct on current inputs.

current state: the template declares `table-attrset` with `columns = [ "enable" ]` and locks row names via `@table-item` labels (`modules/05-applications/03-office.nix:56-81`). `build_table` (`src/widgets.rs:1435`) reads `record.spec.key_editable` and `record.spec.first_value_editable` (`:1444-1450`) to decide whether the key column and the first data column are editable. the observed behavior (editable names, static enable cell behind them) means either (a) the scanner is not propagating the `@table-item` lock into `key_editable`/`first_value_editable`, or (b) `build_table`/`make_table_row` applies the flags inverted for single-column attrset tables.

fix: trace `@table-item` from `src/dsl.rs`/`src/scan.rs` (`scan_table` `:244`) into `OptionSpec` (`src/dsl.rs:377`), confirm the lock flags for `columns = [ "enable" ]` tables, and correct the flag or the rendering so that: row keys (craft app names) are static labels, the `enable` column is the switch, and add/remove row buttons still work. add a regression test over a minimal `table-attrset` value with one `@table-item`.

files: `src/dsl.rs` (`OptionSpec` `:377`, table-item parsing), `src/scan.rs` (`scan_table` `:244`), `src/widgets.rs` (`build_table` `:1435`, `make_table_row` `:1531`).

### G11. DMS plugins widget rework

review: "this module is a complete mess, it's a list of various raw option names (editable) with 'add plugin' below, each list also has a toggle which are all set to false atm. needs a full rework"
status: open. GUI-owned widget; template data at `modules/06-utility/02-plugins.nix` (template doc T32).

current state: `build_plugins` (`src/widgets.rs:2785-2922`) scans children, finds each plugin's `enable` record (`:2797-2805`), renders a row of [key entry][enable switch][trash] plus an indented body of `build_bespoke_child` rows for every other field (`:2827-2835`). field captions come from raw setting names (`showGenerations`, `updateInterval`, `scanSubdirectories`...). the "Add plugin" button scaffolds a row with an empty key and a switch from `"true"` (`:2870-2912`) - note existing rows whose enable record fails to scan fall back to `build_switch("false")` (`:2804`), which explains the reviewer's "all set to false" if the scan missed the enable fields.

desired design:
1. plugin registry: known plugin ids (dankMenu, dankKDEConnect, nixMonitor, localServices, scratchpadHelper, developerUtilities, screenCaptureToolbar, commandRunner, webSearch) mapped to display names, icons, and per-setting labels/types (bool/number/string). unknown ids degrade to the current raw-field row.
2. row: [icon][friendly name (static label)][enable switch][delete]; settings behind the row in a per-plugin expander or popup (G4 pattern), each setting rendered with its registry label, a proper widget type (switch for bools, spin for ints), and a one-line description.
3. fix the enable fallback: when no enable record exists, default the switch to true for known plugins (matching template defaults) rather than false, and write `enable = true` back on save.
4. add-plugin: a picker of registry ids not yet present, not a free-text key.

files: `src/widgets.rs` (`build_plugins` `:2785`, `plugins_nix` `:2924`, `connect_plugin_row` `:2950`); registry beside the G7/G8 registries; `build.rs` untouched.

---

## 05-Applications

### G12. System page: text/widgets do not span full width

review: "text doesn't span the whole width for something like hostname, which has quite a large description. this causes the option menu to need scrolling for only 4 options."
status: open. GUI-owned; also listed in `missing-features.md:8` ("widgets and text should both be full-width when needed (text input modules)") and `:7` (widgets left-aligned below their text).

current state: `build_control_row` (`src/app.rs:1049-1153`) puts the editor in a horizontal `slot` next to the labels for inline editors (`:1107-1111`) and stacks labels/editor for non-inline. text entries come from `build_entry` (`src/widgets.rs:1036`) which sets a bounded `width_chars`, so a hostname field renders narrow while its description wraps beside it. the page's flow (one column, many rows) scrolls because each row is tall, not because of option count.

fix: for text/path/multiline/package editors, always use the stacked (non-inline) layout with `hexpand` on the entry (align to the missing-features plan: label+description on top, full-width widget below, imported-from at the bottom). cap entry width only where the field is semantically short (e.g. port numbers). this single change fixes the System page and the general complaint.

files: `src/app.rs` (`build_control_row` `:1049`, `control_is_inline` `:1002`), `src/widgets.rs` (`build_entry` `:1036`, `control_is_inline` counterpart if the classification lives on `Editor`).

---

## 06-Utility

### G13. Monitors/keybinds/plugins pages: general bespoke-editor issues already tracked

no separate items; covered by G1-G4, G11.

### G14. Menu/page icons not rendered for all pages (display page confirmed)

review: "icon is missing" (02-Core / display).
status: open. GUI-owned; template annotation confirmed valid on current inputs.

- `modules/02-core/01-display.nix:4` sets `icon = "preferences-system-displays-symbolic"`, which exists in adwaita-icon-theme. other pages' icons render (the reviewer did not flag them), so the failure is specific to this lookup or to a silent fallback when `gtk::IconTheme::lookup_icon` misses (icon name length, symbolic suffix handling, or a page-list cache that dropped the entry).
- fix: find the page-list icon rendering path (`src/app.rs` `rebuild_menu_list` `:677` / `MenuPage` `:69`), log or surface lookup failures, verify the icon name resolves on the test theme, and fix whatever drops or fails the lookup. add a fallback (e.g. `preferences-system-symbolic`) so a missing name never renders as empty.

files: `src/app.rs` (`rebuild_menu_list` `:677`, `MenuPage` construction), possibly `src/scan.rs` (`find_menu` `:414`) if the icon field is dropped during scan.

---

## cross-cutting GUI items (from missing-features.md relevant to review-3)

these are already inventoried in `missing-features.md` and are the underlying work for several review-3 asks; listed here so the remediation maps review language onto existing plan language:

- `missing-features.md:3` ordering/grouping interference - contributes to T21/T22 feeling chaotic.
- `:7-8` full-width widgets/text below labels - G12.
- `:11` nestable submodules - helps G7 per-widget setting groups.
- `:12` horizontal submodule (exists as `build_horizontal_submodule` `:1393`) - used by dashboard/control center; superseded for those pages by G8.
- `:14` generic table submodule with auto-typed cells - the long-term form of G8/G10.
- `:16` snippet Add double-label - not raised in review-3, still open.
- `:18` hidden/advanced inside submodules - relevant to G6 verification.
- `:28-40` requested ojuny widgets (keybinds, monitors, grid-configuration, theme, menu, plugins, bar widgets) - keybinds G4, monitors G1-G3, grid G8, theme G5, menu G9, plugins G11, bar G7. all items on that list now have a remediation entry.

---

## summary table

| id | issue | status | depends on template |
|----|-------|--------|---------------------|
| G1 | monitor add dialog + defaults + transform | open | T4 naming decision |
| G2 | monitor snap + canvas | open | - |
| G3 | monitor save/desync | open | - |
| G4 | keybinds row rework + popup | open | description audit (T5) |
| G5 | theme fallback / devshell env | open | - |
| G6 | visibleWhen evaluator | open | gates already in template |
| G7 | bar/dock widget editors | open | names/labels (T21, T22) |
| G8 | grid-configuration widget | open | field names stable (T24, T25) |
| G9 | menu widget rework | open | ordering/toggle (T26) |
| G10 | table header alignment | open | - |
| G10b | craftapps table key lock inverted | open | data confirmed correct |
| G11 | plugins widget rework | open | optional labels (T32) |
| G12 | full-width text widgets | open | - |
| G14 | display page icon lookup | open | annotation confirmed valid |

---

## fix plan

scoped, per-issue fix designs produced by dedicated sub-agents, each step following the plan spec (numbered steps, 15-20 lines of code, file path + filename + line number + ctrl+f anchor, 1-2 sentence mechanical opener, one-sentence explanations for non-obvious lines). appended incrementally as each design completes.

### Fix plan: G1, G2, G3

#### Step 1

Creates the monitor detection module with the `DetectedMonitor` record and a parser for one `wlr-randr` mode line. `parse_mode_line` returns the size, refresh, and the preferred flag, or `None` for any non-mode line.

`src/monitor_detect.rs`, new file, line 1
ctrl+f: `pub struct DetectedMonitor`

```rust
#[derive(Debug, Clone)]
pub struct DetectedMonitor {
    pub name: String,
    pub width: u32,
    pub height: u32,
    pub refresh: f64,
}

fn parse_mode_line(line: &str) -> Option<(u32, u32, f64, bool)> {
    let mode = line.trim();
    let size = mode.split(" px").next()?;
    let mut parts = size.split('x');
    let width = parts.next()?.trim().parse().ok()?;
    let height = parts.next()?.trim().parse().ok()?;
    let refresh = mode
        .split(',')
        .nth(1)
        .and_then(|part| part.trim().split_whitespace().next())
        .and_then(|hz| hz.parse::<f64>().ok())
        .unwrap_or(0.0);
    let preferred = mode.contains("preferred");
    Some((width, height, refresh, preferred))
}
```

`refresh` reads the `, 60.010000 Hz` segment and defaults to `0.0` when the mode has no fixed rate.

#### Step 2

Walks the command output line by line, starting a new `DetectedMonitor` whenever a non-indented head line appears, and keeping the preferred mode for each head. Falls back to the first mode when no mode is marked preferred.

`src/monitor_detect.rs`, after `parse_mode_line`, line 23
ctrl+f: `fn parse_wlr_randr`

```rust
fn parse_wlr_randr(text: &str) -> Vec<DetectedMonitor> {
    let mut monitors = Vec::new();
    let mut current: Option<DetectedMonitor> = None;
    for line in text.lines() {
        if !line.starts_with(' ') {
            if let Some(previous) = current.take() {
                monitors.push(previous);
            }
            let name = line.split_whitespace().next().unwrap_or("");
            if !name.is_empty() {
                current = Some(DetectedMonitor {
                    name: name.to_string(),
                    width: 0,
                    height: 0,
                    refresh: 0.0,
                });
            }
            continue;
        }
        let Some(monitor) = current.as_mut() else {
            continue;
        };
        let Some((width, height, refresh, preferred)) = parse_mode_line(line) else {
            continue;
        };
        if preferred || monitor.width == 0 {
            monitor.width = width;
            monitor.height = height;
            monitor.refresh = refresh;
        }
    }
    if let Some(monitor) = current {
        monitors.push(monitor);
    }
    monitors
}
```

`line.starts_with(' ')` separates the indented mode, position, and scale lines from the head name line.

#### Step 3

Runs `wlr-randr`, returns an empty list on any spawn or exit failure, and parses stdout. Registers the module in the crate entry point.

`src/monitor_detect.rs`, after `parse_wlr_randr`, line 55
ctrl+f: `pub fn detect`

```rust
use std::process::Command;

pub fn detect() -> Vec<DetectedMonitor> {
    let Ok(output) = Command::new("wlr-randr").output() else {
        return Vec::new();
    };
    if !output.status.success() {
        return Vec::new();
    }
    let text = String::from_utf8_lossy(&output.stdout);
    parse_wlr_randr(&text)
}
```

`src/main.rs`, line 12
ctrl+f: `mod model;`

```rust
mod model;
mod monitor_detect;
mod nixd;
```

An absent or failing `wlr-randr` yields an empty list, so the add button falls back to defaults.

#### Step 4

Changes `number_spin` to take an explicit default and set it when parsing fails, so an empty field no longer leaves the spin at its range floor. Updates the geometry calls to default `x`, `y`, and `scale` to the values the review expects.

`src/widgets.rs`, `make_monitor_row`, line 2435
ctrl+f: `let number_spin = |value: &str, default: f64`

```rust
    let number_spin = |value: &str, default: f64, min: f64, max: f64, step: f64| {
        let spin = gtk::SpinButton::with_range(min, max, step);
        spin.set_digits(0);
        spin.set_value(value.parse::<f64>().unwrap_or(default));
        spin
    };

    let name = gtk::Entry::new();
    name.set_text(entry_text(get("name")).as_str());
    name.set_tooltip_text(Some("Output name"));

    let width = number_spin(get("width"), 0.0, 0.0, 16384.0, 1.0);
    let height = number_spin(get("height"), 0.0, 0.0, 16384.0, 1.0);
    let refresh = number_spin(get("refresh"), 0.0, 0.0, 1000.0, 1.0);
    let x = number_spin(get("x"), 0.0, 0.0, 16384.0, 1.0);
    let y = number_spin(get("y"), 0.0, 0.0, 16384.0, 1.0);
    let scale = gtk::SpinButton::with_range(0.0, 16.0, 0.05);
    scale.set_digits(2);
    scale.set_value(get("scale").parse::<f64>().unwrap_or(1.0));
```

This removes the `-16384` floor that made every monitor with an unset `x` or `y` read as already changed.

#### Step 5

Passes the per-field default into the spin comparison and treats an absent `rr` as transform `0`. This keeps the dirty flag honest now that the spins start at nonzero defaults.

`src/widgets.rs`, `monitor_row_unchanged`, line 2326
ctrl+f: `let spin_same =`

```rust
    let spin_same = |spin: &gtk::SpinButton, name: &str, default: f64| {
        match monitor_orig(row, name).parse::<f64>() {
            Ok(value) => (spin.value() - value).abs() < 1e-9,
            Err(_) => (spin.value() - default).abs() < 1e-9,
        }
    };
    let rr_same =
        monitor_orig(row, "rr").is_empty() || row.rr.unchanged(monitor_orig(row, "rr"));
    text_same(&row.name, "name")
        && spin_same(&row.width, "width", 0.0)
        && spin_same(&row.height, "height", 0.0)
        && spin_same(&row.refresh, "refresh", 0.0)
        && spin_same(&row.x, "x", 0.0)
        && spin_same(&row.y, "y", 0.0)
        && spin_same(&row.scale, "scale", 1.0)
        && rr_same
        && row.extras.iter().all(|field| field.editor.unchanged(&field.orig_value))
```

The `1.0` default for `scale` matches the spin default, so a rule without `scale` does not read as changed.

#### Step 6

Writes `scale` only when it differs from `1.0` or was present, and takes the transform literal from its editor. Stops a saved rule from gaining a spurious `scale` line.

`src/widgets.rs`, `monitor_row_nix`, line 2363
ctrl+f: `row.scale.value() != 0.0`

```rust
    if row.scale.value() != 1.0 || orig_has("scale") {
        parts.push(format!("scale = {};", number_literal(row.scale.value(), 2)));
    }
    let rr = row.rr.to_nix();
    if orig_has("rr") || rr != "0" {
        parts.push(format!("rr = {rr};"));
    }
```

`row.rr.to_nix()` returns the selected transform digit, which is only emitted when it is set or non-default.

#### Step 7

Adds the mango rotation labels as a constant and a helper that builds a `DropDown` editor over them. Changes `MonitorRow.rr` from a free-text entry to an `Editor` so it serializes as a digit.

`src/widgets.rs`, `MonitorRow`, line 324
ctrl+f: `rr: gtk::Entry,`

```rust
    scale: gtk::SpinButton,
    rr: Editor,
    extras: Vec<AttrsetField>,
```

`src/widgets.rs`, after `build_dropdown`, line 1011
ctrl+f: `fn build_dropdown`

```rust
const MONITOR_TRANSFORMS: &[(&str, &str)] = &[
    ("0", "No transform"),
    ("1", "90° counter-clockwise"),
    ("2", "180° counter-clockwise"),
    ("3", "270° counter-clockwise"),
    ("4", "180° vertical flip"),
    ("5", "Flip + 90° counter-clockwise"),
    ("6", "Flip + 180° counter-clockwise"),
    ("7", "Flip + 270° counter-clockwise"),
];

fn build_transform(value_text: &str) -> Editor {
    let labels: Vec<&str> = MONITOR_TRANSFORMS.iter().map(|(_, label)| *label).collect();
    let combo = gtk::DropDown::from_strings(&labels);
    let current = value_text.trim().trim_matches('"');
    let selected = MONITOR_TRANSFORMS
        .iter()
        .position(|(value, _)| *value == current)
        .unwrap_or(0);
    combo.set_selected(selected as u32);
    combo.set_halign(gtk::Align::Start);
    Editor::Dropdown {
        combo,
        choices: MONITOR_TRANSFORMS.iter().map(|(value, _)| (*value).to_string()).collect(),
    }
}
```

The chosen index still serializes to the `rr` key, so no template migration is needed.

#### Step 8

Builds the transform editor in `make_monitor_row`, captions it `Transform`, and connects it through the existing editor change signal.

`src/widgets.rs`, `make_monitor_row`, line 2458
ctrl+f: `let rr = gtk::Entry::new();`

```rust
    let rr = build_transform(get("rr"));
```

`src/widgets.rs`, `make_monitor_row`, line 2476
ctrl+f: `attach_cell(&grid, 3, 2, "RR", &rr);`

```rust
    attach_cell(&grid, 3, 2, "Transform", &rr.root());
```

`src/widgets.rs`, `connect_monitor_row`, line 2386
ctrl+f: `let update_rr = update.clone();`

```rust
    row.rr.connect_changed(update);
```

`Editor::connect_changed` already forwards a `Dropdown`'s selection signal, so no extra plumbing is required.

#### Step 9

Opens a popover anchored to the add button, listing each detected output with its mode, and reports the picked monitor or `None` for a manual row.

`src/widgets.rs`, imports, line 10
ctrl+f: `use crate::model::Record;`

```rust
use crate::model::Record;
use crate::monitor_detect::DetectedMonitor;
use crate::scan;
```

`src/widgets.rs`, before `build_monitors`, line 2557
ctrl+f: `fn build_monitors(record: &Record) -> Editor {`

```rust
fn open_monitor_picker<F: Fn(Option<DetectedMonitor>) + 'static>(
    anchor: &gtk::Widget,
    detected: Vec<DetectedMonitor>,
    on_pick: F,
) {
    if detected.is_empty() {
        on_pick(None);
        return;
    }
    let on_pick: Rc<dyn Fn(Option<DetectedMonitor>)> = Rc::new(on_pick);
    let popover = gtk::Popover::new();
    popover.set_parent(anchor);
    let content = gtk::Box::new(gtk::Orientation::Vertical, 6);
    let list = gtk::ListBox::new();
    list.set_selection_mode(gtk::SelectionMode::Single);
    for monitor in detected {
        let text = format!(
            "{} ({}x{}, {:.0} Hz)",
            monitor.name, monitor.width, monitor.height, monitor.refresh
        );
        let label = gtk::Label::builder().label(&text).xalign(0.0).margin_all(6).build();
        let row = gtk::ListBoxRow::new();
        row.set_child(Some(&label));
        list.append(&row);
        let on_pick = on_pick.clone();
        let picked = monitor.clone();
        let popover = popover.clone();
        row.connect_activate(move |_| {
            on_pick(Some(picked.clone()));
            popover.popdown();
        });
    }
    content.append(&list);
    let custom = gtk::Button::with_label("Add monitor manually");
    let on_pick_manual = on_pick.clone();
    let popover_manual = popover.clone();
    custom.connect_clicked(move |_| {
        on_pick_manual(None);
        popover_manual.popdown();
    });
    content.append(&custom);
    popover.set_child(Some(&content));
    popover.connect_closed(|popover| popover.unparent());
    popover.popup();
}
```

`on_pick` is held in an `Rc` so both the list rows and the manual button can call the same closure.

#### Step 10

Turns a picked monitor, or the manual fallback, into a table row scan with `x` placed to the right of the current monitors and `y` at zero. The refresh, size, scale, and transform defaults are written as fields so the row serializes them.

`src/widgets.rs`, after `build_monitors`, line 2772
ctrl+f: `fn build_menu(record: &Record, ctx: &BuildContext) -> Editor {`

```rust
fn monitor_scaffold(rows: &[MonitorRow], picked: Option<&DetectedMonitor>) -> scan::TableRowScan {
    let (name, width, height, refresh) = match picked {
        Some(monitor) => (
            monitor.name.clone(),
            monitor.width,
            monitor.height,
            monitor.refresh,
        ),
        None => (String::new(), 1920, 1080, 60.0),
    };
    let x = rows
        .iter()
        .map(|row| {
            let (rx, _, rw, _, _, _) = monitor_geometry(row);
            rx + rw
        })
        .fold(0.0f64, f64::max);
    let mut fields = vec![
        ("width".to_string(), width.to_string()),
        ("height".to_string(), height.to_string()),
        ("refresh".to_string(), format!("{refresh}")),
        ("x".to_string(), (x as i64).to_string()),
        ("y".to_string(), "0".to_string()),
        ("scale".to_string(), "1.0".to_string()),
        ("rr".to_string(), "0".to_string()),
    ];
    if !name.is_empty() {
        fields.insert(0, ("name".to_string(), quote(&name)));
    }
    scan::TableRowScan {
        key: String::new(),
        fields,
        spec: OptionSpec::default(),
    }
}
```

`fold(0.0, f64::max)` gives the rightmost edge, or `0` when no monitor exists yet.

#### Step 11

Pulls the remove-button wiring and push into one helper so the initial loop and the add handler share it. Returns the row's index for selection.

`src/widgets.rs`, before `build_monitors`, line 2557
ctrl+f: `fn open_monitor_picker`

```rust
fn attach_monitor_row(
    form: &gtk::Box,
    rows: &Rc<RefCell<Vec<MonitorRow>>>,
    on_change: &ChangeHook,
    row: MonitorRow,
) -> usize {
    let row_box = row.form_box.clone();
    {
        let form = form.clone();
        let rows = rows.clone();
        let on_change = on_change.clone();
        row.remove.connect_clicked(move |_| {
            form.remove(&row_box);
            rows.borrow_mut().retain(|r| r.form_box != row_box);
            if let Some(cb) = on_change.borrow().as_ref() {
                cb();
            }
        });
    }
    form.append(&row.form_box);
    let index = rows.borrow().len();
    rows.borrow_mut().push(row);
    index
}
```

The returned `index` is the position before the push, so the caller can select the new row immediately.

#### Step 12

Replaces the bare scaffold in the add button with detection, the picker, and `monitor_scaffold`, then attaches the chosen row and selects it. This is the add-monitor path described in G1.

`src/widgets.rs`, add-monitor handler, line 2731
ctrl+f: `add.connect_clicked`

```rust
    add.connect_clicked(move |button| {
        let anchor = button.clone().upcast::<gtk::Widget>();
        let detected = crate::monitor_detect::detect();
        let form = form.clone();
        let rows = rows.clone();
        let on_change = on_change.clone();
        let canvas = canvas.clone();
        let selected = selected.clone();
        let ctx = ctx.clone();
        open_monitor_picker(&anchor, detected, move |picked| {
            let scan_row = monitor_scaffold(&rows.borrow(), picked.as_ref());
            let row = make_monitor_row(&scan_row, &ctx);
            let index = attach_monitor_row(&form, &rows, &on_change, row);
            selected.set(index);
            for (position, item) in rows.borrow().iter().enumerate() {
                item.form_box.set_visible(position == index);
            }
            canvas.queue_draw();
            if let Some(cb) = on_change.borrow().as_ref() {
                cb();
            }
        });
    });
```

The `anchor` is the button itself, so the popover needs no application window reference.

#### Step 13

Raises the fixed canvas height and paints a distinct background before the monitor rectangles. This addresses the taller, differently coloured canvas in G2.

`src/widgets.rs`, `build_monitors`, line 2570
ctrl+f: `let canvas = gtk::DrawingArea::builder()`

```rust
    let canvas = gtk::DrawingArea::builder()
        .content_width(640)
        .content_height(320)
        .build();
    canvas.set_hexpand(true);
    canvas.set_size_request(-1, 320);
    canvas.set_draw_func({
        let rows = rows.clone();
        let selected = selected.clone();
        let view = view.clone();
        move |_, cr, width, height| {
            cr.set_source_rgb(0.08, 0.08, 0.10);
            cr.rectangle(0.0, 0.0, width as f64, height as f64);
            cr.fill().ok();
            let rows = rows.borrow();
```

`set_size_request(-1, 320)` keeps the drawing area from shrinking below its content height, and the fill uses the current draw callback's width and height.

#### Step 14

`snap_axis` clamps one edge, left or right, to the nearest other edge within tolerance, and `snap_monitor` applies it to both axes. This is the grid snapping required by G2.

`src/widgets.rs`, after `monitor_geometry`, line 2313
ctrl+f: `fn monitor_orig`

```rust
fn snap_axis(value: f64, size: f64, targets: &[f64], tolerance: f64) -> f64 {
    let mut best = value;
    let mut best_distance = tolerance + 1.0;
    for target in targets {
        for candidate in [value, value + size] {
            let distance = (candidate - target).abs();
            if distance <= tolerance && distance < best_distance {
                best_distance = distance;
                best = value + (target - candidate);
            }
        }
    }
    best
}

fn snap_monitor(
    x: f64,
    y: f64,
    w: f64,
    h: f64,
    others: &[(f64, f64, f64, f64)],
    tolerance: f64,
) -> (f64, f64) {
    let mut xs = Vec::new();
    let mut ys = Vec::new();
    for (ox, oy, ow, oh) in others {
        xs.push(*ox);
        xs.push(ox + ow);
        ys.push(*oy);
        ys.push(oy + oh);
    }
    (snap_axis(x, w, &xs, tolerance), snap_axis(y, h, &ys, tolerance))
}
```

`best_distance` starts above tolerance so the first in-range edge always wins, and each candidate shift moves the value by the target minus candidate delta.

#### Step 15

Rewrites the drag update to snap the candidate position against the other monitors before writing it back. The tolerance is a pixel distance converted to monitor units with the current canvas scale.

`src/widgets.rs`, `drag.connect_drag_update`, line 2706
ctrl+f: `drag.connect_drag_update`

```rust
        drag.connect_drag_update(move |gesture, _, _| {
            let (offset_x, offset_y) = gesture.offset().unwrap_or((0.0, 0.0));
            let (prev_x, prev_y) = last.get();
            last.set((offset_x, offset_y));
            let scale = view.get().scale;
            let rows = rows.borrow();
            let Some(row) = rows.get(selected.get()) else {
                return;
            };
            let (x, y, w, h, _, _) = monitor_geometry(row);
            let others: Vec<(f64, f64, f64, f64)> = rows
                .iter()
                .filter(|other| !std::ptr::eq(*other, row))
                .map(|other| {
                    let (ox, oy, ow, oh, _, _) = monitor_geometry(other);
                    (ox, oy, ow, oh)
                })
                .collect();
            let candidate_x = x + (offset_x - prev_x) / scale;
            let candidate_y = y + (offset_y - prev_y) / scale;
            let (snapped_x, snapped_y) =
                snap_monitor(candidate_x, candidate_y, w, h, &others, 12.0 / scale);
            row.x.set_value(snapped_x);
            row.y.set_value(snapped_y);
            drop(rows);
            redraw.queue_draw();
            if let Some(cb) = on_change.borrow().as_ref() {
                cb();
            }
        });
```

The others vector excludes the dragged row by reference identity, and `12.0 / scale` keeps the snap feel constant on screen.

#### Step 16

Rescans the flake after the close-time Save branch applies edits, so the in-memory rows match the file again. This removes the stale-editor path called out in G3.

`src/app.rs`, `run_changes_prompt`, line 1440
ctrl+f: `match edit::apply(&edits, &root) {`

```rust
                match edit::apply(&edits, &root) {
                    Ok(count) => {
                        state.status.set_text(&format!("Saved {count} file(s)"));
                        let base = state.base.borrow().clone();
                        spawn(&state.tx, move |tx| {
                            let result = scan::scan_root(&base);
                            let _ = tx.send_blocking(Msg::Scanned(result));
                        });
                        on_save();
                    }
                    Err(e) => {
                        state.status.set_text("Save failed");
                        show_error(&state.window, &e);
                    }
                }
```

This mirrors the rescan that `Msg::Saved` already runs after a normal save.

#### Step 17

Adds a monitor list to `App`, a function that attaches a `gio::FileMonitor` to each scanned file, and a call after every scan. External edits rescan when there are no pending edits, otherwise they surface a status message.

`src/app.rs`, `App` struct, line 171
ctrl+f: `pending_rebuild: Cell<bool>,`

```rust
    manual_host: Cell<bool>,
    pending_rebuild: Cell<bool>,
    watchers: RefCell<Vec<gio::FileMonitor>>,
}
```

`src/app.rs`, `App` construction, line 378
ctrl+f: `pending_rebuild: Cell::new(false),`

```rust
        manual_host: Cell::new(false),
        pending_rebuild: Cell::new(false),
        watchers: RefCell::new(Vec::new()),
    });
```

`src/app.rs`, before `handle_msg`, line 2423
ctrl+f: `fn handle_msg`

```rust
fn watch_files(app: &Rc<App>) {
    app.watchers.borrow_mut().clear();
    let mut files: Vec<String> = Vec::new();
    {
        let scan = app.scan.borrow();
        let Some(scan) = scan.as_ref() else {
            return;
        };
        for menu in &scan.menus {
            for record in &menu.records {
                if !record.file.is_empty() && !files.contains(&record.file) {
                    files.push(record.file.clone());
                }
            }
        }
    }
    for file in files {
        let Ok(monitor) = gio::File::for_path(&file)
            .monitor_file(gio::FileMonitorFlags::NONE, gio::Cancellable::NONE)
        else {
            continue;
        };
        let app = app.clone();
        monitor.connect_changed(move |_, _, _, _| {
            if collect_edits(&app).is_empty() {
                let base = app.base.borrow().clone();
                spawn(&app.tx, move |tx| {
                    let result = scan::scan_root(&base);
                    let _ = tx.send_blocking(Msg::Scanned(result));
                });
            } else {
                app.status
                    .set_text("File changed on disk; reload to refresh");
            }
        });
        app.watchers.borrow_mut().push(monitor);
    }
}
```

`src/app.rs`, `Msg::Scanned(Ok)`, line 2478
ctrl+f: `*app.scan.borrow_mut() = Some(result);`

```rust
            *app.scan.borrow_mut() = Some(result);
            watch_files(app);
            app.status.set_text("Ready");
            rebuild_view(app);
```

Keeping the monitors in `App::watchers` prevents them from being dropped, and clearing the list on each scan avoids duplicate handlers.

### Fix plan: G5

#### Step 1

Export the locked tinted-theming input as `TINTED_SCHEMES_DIR` inside the devshell, so dev builds compile the same schemes table as the release derivation at `flake.nix:58`.

`flake.nix:94`, ctrl+f `devShells.default = pkgs.mkShell`

```nix
        devShells.default = pkgs.mkShell {
          nativeBuildInputs =
            nativeBuildInputs
            ++ (with pkgs; [
              cargo
              rustc
              rustfmt
              clippy
              rust-analyzer
            ]);
          buildInputs =
            buildInputs
            ++ (with pkgs; [
              nix
              nixd
              nixfmt
            ]);
          TINTED_SCHEMES_DIR = "${tinted-theming}";
          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
        };
```

`"${tinted-theming}"` interpolates the input's store path, which is the directory `build.rs:11` reads when it collects palettes.

#### Step 2

Give the Theme editor an optional entry field beside its list, so the labeled fallback can hand `connect_changed` an entry to watch. Neighbouring enum variants are included as context.

`src/widgets.rs:388`, ctrl+f `    Theme {`

```rust
    Theme {
        root: gtk::Box,
        current: Rc<RefCell<String>>,
        list: gtk::ListBox,
        entry: Option<gtk::Entry>,
    },
    Keybinds {
        root: gtk::Box,
        rows: Rc<RefCell<Vec<KeybindRow>>>,
        on_change: ChangeHook,
    },
    Monitors {
        root: gtk::Box,
        rows: Rc<RefCell<Vec<MonitorRow>>>,
        on_change: ChangeHook,
    },
```

`entry` stays `None` for the swatch list and becomes `Some` only in the fallback, so the other Theme arms can tell the two apart.

#### Step 3

Wire the optional entry into the Theme arm of `connect_changed`, so typing in the fallback entry fires the same update as picking a swatch. The Keybinds arm below is context.

`src/widgets.rs:741`, ctrl+f `Editor::Theme { list`

```rust
            Editor::Theme { list, entry, .. } => {
                if let Some(entry) = entry {
                    let update = update.clone();
                    entry.connect_changed(move |_| update());
                }
                let update = update.clone();
                list.connect_row_selected(move |_, _| update());
            }
            Editor::Keybinds {
                rows, on_change, ..
            } => {
                *on_change.borrow_mut() = Some(update.clone());
                for row in rows.borrow().iter() {
                    connect_keybind_row(row, update);
                }
            }
```

`update` is cloned once per closure because each `move` closure takes ownership of its `Rc`.

#### Step 4

Add `theme_text_fallback`, the builder `build_theme` uses when the compiled schemes table is empty: a caption label above the text entry in one root box, with `current` kept in sync so `to_nix` still quotes it. Place it directly above `install_swatch_css`.

`src/widgets.rs:1789` (insert above `install_swatch_css`), ctrl+f `Install the one-time stylesheet that paints each palette swatch`

```rust
fn theme_text_fallback(value_text: &str) -> Editor {
    let entry = build_entry(value_text, &OptionSpec::default(), false);
    let current = Rc::new(RefCell::new(entry.text().to_string()));
    let (entry_watch, current_watch) = (entry.clone(), current.clone());
    entry.connect_changed(move |_| {
        *current_watch.borrow_mut() = entry_watch.text().to_string();
    });
    let warning = gtk::Label::new(Some("No schemes bundled: set TINTED_SCHEMES_DIR and rebuild"));
    warning.set_xalign(0.0);
    let root = gtk::Box::new(gtk::Orientation::Vertical, 6);
    root.set_hexpand(true);
    root.append(&warning);
    root.append(&entry);
    Editor::Theme {
        root,
        current,
        list: gtk::ListBox::new(),
        entry: Some(entry),
    }
}
```

The cloned entry and current feed the `move` closure that mirrors the entry text into `current`, and the rowless list keeps `row_selected` silent in this path.

#### Step 5

Mark the swatch construction as the non-fallback editor by carrying `entry: None`, so `connect_changed` wires only the list there. The block starts inside the selection handler to stay within 20 lines.

`src/widgets.rs:1770`, ctrl+f `*current.borrow_mut() = (*name).to_string()`

```rust
                    *current.borrow_mut() = (*name).to_string();
                }
            }
        });
    }

    let scrolled = gtk::ScrolledWindow::builder()
        .hscrollbar_policy(gtk::PolicyType::Never)
        .min_content_height(160)
        .child(&list)
        .build();
    scrolled.set_hexpand(true);
    root.append(&scrolled);
    Editor::Theme {
        root,
        current,
        list,
        entry: None,
    }
}
```

`entry: None` keeps the swatch editor on its `current`-backed value and tells `connect_changed` to wire only the list.

#### Step 6

Return the labeled fallback from `build_theme`'s empty branch and refresh the doc comment to name the `TINTED_SCHEMES_DIR` failure mode.

`src/widgets.rs:1721`, ctrl+f `A scheme selector backed by the base16 palettes`

```rust
/// A scheme selector backed by the base16 palettes bundled at build time. Each
/// row shows the scheme's sixteen colors and its name; the written value is the
/// short scheme name. With no palettes bundled (plain `cargo test`, or a build
/// without TINTED_SCHEMES_DIR) it degrades to a labeled text entry.
fn build_theme(value_text: &str) -> Editor {
    if schemes::SCHEMES.is_empty() {
        return theme_text_fallback(value_text);
    }

    install_swatch_css();

    let root = gtk::Box::new(gtk::Orientation::Vertical, 6);
    root.set_hexpand(true);
    let current = Rc::new(RefCell::new(entry_text(value_text)));
    let list = gtk::ListBox::new();
    list.add_css_class("theme-list");
    list.set_selection_mode(gtk::SelectionMode::Single);

    for (index, (name, palette)) in schemes::SCHEMES.iter().enumerate() {
        let content = gtk::Box::new(gtk::Orientation::Horizontal, 8);
```

The empty check still reads `schemes::SCHEMES`, which `build.rs` fills whenever `TINTED_SCHEMES_DIR` is present at build time.

### Fix plan: G6

Root cause confirmed: dendritic modules put annotated assignments inside `config = { ... }`, so `scan.rs` records paths with a leading `config.` segment (`collect_binding`, `src/scan.rs:682-683`, recursion at `:717-728`). Template `visibleWhen.path` values omit that wrapper (`ojuny.style.customGaps`, `ojuny.browser.selected`, `programs.steam.enable`, ...). `evaluate_dependencies` looks up `vis.path` verbatim, misses, and `Visibility::holds(None)` fails open (`src/dsl.rs:355-357`), so every gated control stays visible. Value normalization is correct: `Editor::Switch` emits `true`/`false` and `Editor::Dropdown` emits quoted literals (`src/widgets.rs:469-473`), matching `Lit::to_nix`. Vesktop's HM settings sit on the same page as the NixOS gate (both origins scan into one `MenuModel`), so one resolver fixes all five confirmed cases. Harness: in-module `#[cfg(test)]` unit tests via `cargo test`; `tests/` holds fixtures only; existing tests never construct GTK widgets, so the fix extracts pure functions and tests those plus `scan::scan_value`.

#### Step 1

Add a pure path resolver next to the evaluator, and import `Visibility` so its signature compiles. The resolver tries the annotation path, then the same path under the scanner's `config.` prefix, then strips a `config.` prefix from the annotation, covering both wrappered and flat module bodies.

**File:** `src/app.rs` · **Anchor:** `use crate::dsl::{SnippetSpec, WidgetKind};` (`src/app.rs:11`)

```rust
use crate::dsl::{SnippetSpec, Visibility, WidgetKind};
```

**File:** `src/app.rs` · **Anchor:** `fn resolve_dependency_value` (insert between `refresh_dependencies` and `fn evaluate_dependencies`, `src/app.rs:1191-1193`)

```rust
/// Current value of `path` in `values`, tolerating the `config.` prefix the
/// scanner records for annotated assignments inside a module's `config = { }`
/// wrapper: annotation paths omit that wrapper, so both spellings are tried.
fn resolve_dependency_value<'a>(
    values: &'a HashMap<String, String>,
    path: &str,
) -> Option<&'a String> {
    values
        .get(path)
        .or_else(|| values.get(&format!("config.{path}")))
        .or_else(|| path.strip_prefix("config.").and_then(|s| values.get(s)))
}

/// Whether `vis` holds for the governing value found in `values`.
fn dependency_visible(vis: &Visibility, values: &HashMap<String, String>) -> bool {
    let current = resolve_dependency_value(values, &vis.path).map(String::as_str);
    vis.holds(current)
}
```

The three `get` arms are the exact-path, add-prefix, and strip-prefix lookups; `dependency_visible` keeps `holds` as the single comparison policy.

#### Step 2

Rewire `evaluate_dependencies` to resolve through the new helper instead of a verbatim map lookup. The values map and fail-open semantics stay unchanged; only the path spelling mismatch is corrected.

**File:** `src/app.rs` · **Anchor:** `fn evaluate_dependencies` (replace the function at `src/app.rs:1193-1210`)

```rust
/// Set each control's `dep_visible` from its `visibleWhen` condition, looking
/// the governing value up through `resolve_dependency_value`. A governing
/// option that is absent fails open, so a stale path never hides a setting.
fn evaluate_dependencies(controls: &[Rc<ControlRow>]) {
    let mut values: HashMap<String, String> = HashMap::new();
    for control in controls {
        values
            .entry(control.record.path())
            .or_insert_with(|| control.editor.borrow().to_nix());
    }
    for control in controls {
        let visible = match &control.record.spec.visible_when {
            Some(vis) => dependency_visible(vis, &values),
            None => true,
        };
        control.dep_visible.set(visible);
    }
}
```

The single changed arm (`dependency_visible`) is the whole behavioral fix; everything else is the existing doc and loop structure.

#### Step 3

Add regression coverage in `dsl.rs` for the equality literal forms the template uses: bool `true`/`false` gates (style, office, vesktop, steam) and quoted string gates (browser, gpu). These lock the `Lit::to_nix` / editor-literal contract so a future normalization change cannot silently break comparison.

**File:** `src/dsl.rs` · **Anchor:** `fn visibility_holds_by_truthiness_and_equality` (insert after that test, `src/dsl.rs:638-664`)

```rust
    #[test]
    fn visibility_equality_matches_editor_literals() {
        let bool_true = Visibility {
            path: "a".into(),
            equals: Some("true".into()),
            not_equals: None,
        };
        assert!(bool_true.holds(Some("true")));
        assert!(!bool_true.holds(Some("false")));

        let bool_false = Visibility {
            path: "a".into(),
            equals: Some("false".into()),
            not_equals: None,
        };
        assert!(bool_false.holds(Some("false")));
        assert!(!bool_false.holds(Some("true")));

        let string_eq = Visibility {
            path: "a".into(),
            equals: Some("\"firefox\"".into()),
            not_equals: None,
        };
        assert!(string_eq.holds(Some("\"firefox\"")));
        assert!(!string_eq.holds(Some("\"chrome\"")));
    }
```

`equals` values come from `Lit::to_nix`, so `"true"`/`"false"` and the quoted `"\"firefox\""` mirror exactly what `parse_visibility` stores.

#### Step 4

Add pure-map unit tests for the resolver: exact match (flat body), add-`config.` (wrappered body), strip-`config.` (annotation that includes the wrapper), and a miss. No GTK objects are constructed.

**File:** `src/app.rs` · **Anchor:** `fn derives_suggestion_parent_from_text` (insert after that test, before the closing brace of `mod tests`, `src/app.rs:2754-2769`)

```rust
    #[test]
    fn resolves_dependency_paths_across_config_wrapper() {
        let mut values = HashMap::new();
        values.insert(
            "config.ojuny.browser.selected".to_string(),
            "\"firefox\"".to_string(),
        );
        assert_eq!(
            resolve_dependency_value(&values, "ojuny.browser.selected").map(String::as_str),
            Some("\"firefox\"")
        );
        values.insert("programs.steam.enable".to_string(), "false".to_string());
        assert_eq!(
            resolve_dependency_value(&values, "programs.steam.enable").map(String::as_str),
            Some("false")
        );
        assert_eq!(
            resolve_dependency_value(&values, "config.programs.steam.enable").map(String::as_str),
            Some("false")
        );
        assert_eq!(resolve_dependency_value(&values, "missing.path"), None);
    }
```

The four asserts map one-to-one onto the four lookup arms, using the two path shapes the template actually ships.

#### Step 5

Add the end-to-end pure regression: scan a template-shaped snippet (`config = { ... }` with a `visibleWhen.equals = false` gate), confirm the scanner stores the `config.`-prefixed record path, and confirm `dependency_visible` evaluates the annotation path against that map in both gate states. This is the test that fails on current `main` and passes after step 2.

**File:** `src/app.rs` · **Anchor:** `fn resolves_dependency_paths_across_config_wrapper` (insert after that test, `src/app.rs:2771`)

```rust
    #[test]
    fn visible_when_resolves_config_wrapped_scan_paths() {
        let text = "{ config = {\n  # @option widget = \"switch\"; label = \"Set gaps per edge\";\n  ojuny.style.customGaps = false;\n  # @option widget = \"spin\"; label = \"Gap size\"; visibleWhen.path = \"ojuny.style.customGaps\"; visibleWhen.equals = false;\n  ojuny.style.gaps = 4;\n} }";
        let records = scan::scan_value(text);
        let values: HashMap<String, String> = records
            .iter()
            .map(|record| (record.path(), record.value.clone()))
            .collect();
        let gated = records
            .iter()
            .find(|record| record.spec.visible_when.is_some())
            .unwrap();
        let vis = gated.spec.visible_when.as_ref().unwrap();
        assert_eq!(vis.path, "ojuny.style.customGaps");
        assert!(values.contains_key("config.ojuny.style.customGaps"));
        assert!(dependency_visible(vis, &values));
        values.insert("config.ojuny.style.customGaps".to_string(), "true".to_string());
        assert!(!dependency_visible(vis, &values));
    }
```

`scan_value` is already exercised headless in `model.rs` tests; the two `dependency_visible` asserts prove the gate hides the control once the governing switch flips to `true`, which is the exact G6 symptom.

### Fix plan: G7

Bar and dock widget list editors: friendly names, hidden `_order`, grouped settings.

#### Step 1

This adds the known-widget id to display-name table and a lookup used by the friendly label. Insert after `fn attrset_field_nix` (line 1898), before the `make_attrset_row` doc comment (line 1900).

**File:** `src/widgets.rs`, insert at line 1899. ctrl+f: `fn attrset_field_nix`

```rust
const WIDGET_NAMES: &[(&str, &str)] = &[
    ("workspaceSwitcher", "Workspace switcher"),
    ("dankKDEConnect", "KDE Connect"),
    ("layout", "Layout indicator"),
    ("scratchpadHelper", "Scratchpad helper"),
    ("systemTray", "System tray"),
    ("clipboard", "Clipboard"),
    ("developerUtilities", "Developer utilities"),
    ("nixMonitor", "Monitor widget"),
    ("localServices", "Local services"),
    ("controlCenterButton", "Control center button"),
    ("dock_launcher", "Dock launcher"),
    ("dock_apps", "Dock apps"),
    ("dock_trash", "Dock trash"),
];

fn known_widget_name(id: &str) -> Option<&'static str> {
    WIDGET_NAMES
        .iter()
        .find(|(key, _)| *key == id)
        .map(|(_, name)| *name)
}
```

The table matches the ids in `modules/04-gui/01-bar.nix` and `02-dock.nix`; `known_widget_name` returns `None` for unknown ids so the fallback path can take over.

#### Step 2

These lines turn a raw id like `showOccupiedWorkspacesOnly` into a spaced sentence fragment and resolve the registry first. Insert directly after `fn known_widget_name` (currently ends at line 1908).

**File:** `src/widgets.rs`, insert after the `known_widget_name` body (line 1908). ctrl+f: `.map(|(_, name)| *name)`

```rust
fn title_case_id(id: &str) -> String {
    let expanded = id.replace('_', " ");
    let mut out = String::new();
    for (index, ch) in expanded.chars().enumerate() {
        if ch.is_uppercase() && index > 0 && !out.ends_with(' ') {
            out.push(' ');
        }
        out.push(ch);
    }
    let mut chars = out.chars();
    match chars.next() {
        Some(first) => first.to_uppercase().collect::<String>() + chars.as_str(),
        None => out,
    }
}

fn widget_display_name(id: &str) -> String {
    known_widget_name(id)
        .map(str::to_string)
        .unwrap_or_else(|| title_case_id(id))
}
```

`title_case_id` splits on underscores and camelCase humps; `widget_display_name` prefers the registry and falls back to that title-casing.

#### Step 3

This table supplies tooltips for bespoke child fields that carry no template description. Insert after `fn widget_display_name` (currently ends at line 1928).

**File:** `src/widgets.rs`, insert after line 1928. ctrl+f: `.unwrap_or_else(|| title_case_id(id))`

```rust
const WIDGET_FIELD_HELP: &[(&str, &str)] = &[
    ("enabled", "Whether this widget is shown."),
    ("_order", "Sort position among sibling widgets; lower comes first."),
    ("showOccupiedWorkspacesOnly", "Only list workspaces that have open windows."),
    ("showWorkspaceIndex", "Show the workspace number."),
    ("showWorkspacePadding", "Pad single-digit workspace numbers."),
    ("workspacePaddingCount", "Pad workspace numbers up to this width."),
    ("dwlShowAllTags", "Show every dwl tag, not only used ones."),
    ("showAudioPercent", "Show the audio level as a percentage."),
    ("showBatteryIcon", "Show the battery icon."),
    ("showBrightnessIcon", "Show the brightness icon."),
    ("showBrightnessPercent", "Show brightness as a percentage."),
    ("showDoNotDisturbIcon", "Show the do not disturb icon."),
    ("showIdleInhibitorIcon", "Show the idle inhibitor icon."),
    ("showMicIcon", "Show the microphone icon."),
    ("showMicPercent", "Show the mic level as a percentage."),
    ("autoHide", "Hide the bar or dock when a window would overlap it."),
    ("autoHideDelay", "Milliseconds before auto hide engages."),
    ("position", "Screen edge: top or bottom."),
];
```

Entries cover the fields the template ships in bar widget rows, dock `widgets`, and the bar/dock extras the review calls out.

#### Step 4

These map a raw field name to a sentence caption and to the help text when present. Insert directly after the `WIDGET_FIELD_HELP` table.

**File:** `src/widgets.rs`, insert after line 1947 (end of `WIDGET_FIELD_HELP`). ctrl+f: `("position", "Screen edge: top or bottom.")`

```rust
fn field_caption(name: &str) -> String {
    if name == "_order" {
        return "Position".to_string();
    }
    title_case_id(name)
}

fn field_help(name: &str) -> Option<&'static str> {
    WIDGET_FIELD_HELP
        .iter()
        .find(|(key, _)| *key == name)
        .map(|(_, help)| *help)
}
```

`_order` is renamed to "Position" here so no renderer ever shows the raw key; `field_help` returns `None` when the map has no entry.

#### Step 5

This builds the main-line head: a static friendly label plus the id entry, shown only for unknown ids or advanced mode. Insert after `fn field_help` (line 1958).

**File:** `src/widgets.rs`, insert after `fn field_help` (line 1958). ctrl+f: `.map(|(_, help)| *help)`

```rust
fn widget_row_header(key: &str, ctx: &BuildContext) -> (gtk::Box, gtk::Entry) {
    let row_box = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    row_box.set_hexpand(true);
    let friendly = gtk::Label::builder()
        .xalign(0.0)
        .label(widget_display_name(key))
        .css_classes(["heading"])
        .build();
    row_box.append(&friendly);
    let key_entry = gtk::Entry::new();
    key_entry.set_width_chars(14);
    key_entry.set_text(key);
    key_entry.set_tooltip_text(Some("Id"));
    let known = WIDGET_NAMES.iter().any(|(id, _)| *id == key);
    key_entry.set_visible(ctx.advanced || !known);
    row_box.append(&key_entry);
    (row_box, key_entry)
}
```

The entry still holds the raw id for serialization and dirty tracking; `set_visible` only hides it when the id is known and Advanced is off.

#### Step 6

This wraps one inferred field editor in a cell with a sentence caption and a help tooltip. Insert after `fn widget_row_header` (currently ends at line 1976).

**File:** `src/widgets.rs`, insert after line 1976. ctrl+f: `fn widget_row_header`

```rust
fn widget_field_cell(name: &str, raw: &str, ctx: &BuildContext) -> (gtk::Box, AttrsetField) {
    let field = make_attrset_field(name, raw, ctx);
    let cell = gtk::Box::new(gtk::Orientation::Vertical, 2);
    let caption = gtk::Label::builder()
        .xalign(0.0)
        .label(field_caption(name))
        .css_classes(["dim-label", "caption"])
        .build();
    if let Some(help) = field_help(name) {
        caption.set_tooltip_text(Some(help));
    }
    cell.append(&caption);
    cell.append(&field.editor.root());
    (cell, field)
}
```

It reuses `make_attrset_field` so the editor type inference and `orig_value` bookkeeping stay identical to the generic row path.

#### Step 7

This routes `enabled` to the main line, `_order` to the trailing cell, and every other field into the tuning box. Insert after `fn widget_field_cell` (currently ends at line 1991).

**File:** `src/widgets.rs`, insert after line 1991. ctrl+f: `fn widget_field_cell`

```rust
fn collect_widget_fields(
    row_box: &gtk::Box,
    fields: &[(String, String)],
    ctx: &BuildContext,
) -> (Vec<AttrsetField>, Option<gtk::Box>, gtk::Box) {
    let mut attr_fields = Vec::new();
    let mut position_cell = None;
    let mut tuning = gtk::Box::new(gtk::Orientation::Vertical, 4);
    for (name, raw) in fields {
        let (cell, field) = widget_field_cell(name, raw, ctx);
        match name.as_str() {
            "_order" => position_cell = Some(cell),
            "enabled" => row_box.append(&cell),
            _ => tuning.append(&cell),
        }
        attr_fields.push(field);
    }
    (attr_fields, position_cell, tuning)
}
```

Fields are still pushed into `attr_fields` in scan order so `attrset_rows_nix` serializes every field, including `_order`, exactly as before.

#### Step 8

This appends the flexible spacer, the Position cell, the Tuning expander, and the trash button. Insert after `fn collect_widget_fields` (currently ends at line 2009).

**File:** `src/widgets.rs`, insert after line 2009. ctrl+f: `fn collect_widget_fields`

```rust
fn append_widget_trailing(
    row_box: &gtk::Box,
    position_cell: Option<gtk::Box>,
    tuning: &gtk::Box,
) -> gtk::Button {
    let spacer = gtk::Box::new(gtk::Orientation::Horizontal, 0);
    spacer.set_hexpand(true);
    row_box.append(&spacer);
    if let Some(cell) = position_cell {
        row_box.append(&cell);
    }
    if tuning.first_child().is_some() {
        let expander = gtk::Expander::new(Some("Tuning"));
        expander.set_child(Some(&tuning));
        row_box.append(&expander);
    }
    let remove = gtk::Button::from_icon_name("user-trash-symbolic");
    remove.add_css_class("flat");
    remove.set_tooltip_text(Some("Remove"));
    row_box.append(&remove);
    remove
}
```

The spacer pushes Position and Tuning to the trailing edge; the expander is skipped when a row has no tuning fields, matching the expander pattern already used in `make_keybind_row` (line 2106).

#### Step 9

These lines combine the header, partitioned fields, and trailing widgets into the shared `AttrsetRow` so serialization, `unchanged`, and `connect_attrset_row` keep working untouched. Insert after `fn append_widget_trailing` (currently ends at line 2029).

**File:** `src/widgets.rs`, insert after line 2029. ctrl+f: `fn append_widget_trailing`

```rust
fn make_widget_row(
    key: &str,
    fields: &[(String, String)],
    ctx: &BuildContext,
) -> AttrsetRow {
    let (row_box, key_entry) = widget_row_header(key, ctx);
    let (attr_fields, position_cell, tuning) = collect_widget_fields(&row_box, fields, ctx);
    let remove = append_widget_trailing(&row_box, position_cell, &tuning);
    AttrsetRow {
        key: key_entry,
        orig_key: key.to_string(),
        fields: attr_fields,
        row_box,
        remove,
    }
}
```

Returning the same `AttrsetRow` struct means `attrset_rows_nix` (line 1950), `attrset_rows_unchanged` (line 1965), and `connect_attrset_row` (line 1972) need no changes.

#### Step 10

This adds an `AttrsetRowStyle` switch so menu keeps the raw key-entry rows while bar and dock opt into the widget rows. Edit `make_attrset_row` (line 1902), `build_attrset_rows` (line 2010), and its five call sites.

**File:** `src/widgets.rs`, edit at line 1900 and the call sites at 2024, 2040, 2777, 2990, 3011, 3101. ctrl+f: `fn make_attrset_row`

```rust
#[derive(Clone, Copy)]
enum AttrsetRowStyle {
    KeyEntry,
    WidgetLabel,
}

fn make_attrset_row(
    key: &str,
    fields: &[(String, String)],
    indent_by_key: bool,
    style: AttrsetRowStyle,
    ctx: &BuildContext,
) -> AttrsetRow {
    if let AttrsetRowStyle::WidgetLabel = style {
        return make_widget_row(key, fields, ctx);
    }
```

Then thread `style: AttrsetRowStyle` through `build_attrset_rows` (line 2010), pass it at both inner `make_attrset_row` calls (lines 2024 and 2040), pass `AttrsetRowStyle::KeyEntry` at the menu call (line 2777), and `AttrsetRowStyle::WidgetLabel` at the bar left (2990), bar right (3011), and dock widgets (3101) calls, replacing the `indent_by_key` argument position only where it stays `false`.

The early return keeps the existing key-entry body intact for menu; the enum makes the previously boolean-argument call sites self-describing.

#### Step 11

These lines render the `position` extra as a Top/Bottom dropdown serializing `0`/`1`, and route all other extras through the existing bespoke builder. Insert after `fn build_bespoke_child` (line 2057, body ends at line 2069), before the `make_keybind_row` doc comment (line 2071).

**File:** `src/widgets.rs`, insert at line 2070. ctrl+f: `/// One bind of the \`keybinds\` widget`

```rust
fn build_position_dropdown(value_text: &str, tooltip: Option<&str>) -> Editor {
    let combo = gtk::DropDown::from_strings(&["Top", "Bottom"]);
    combo.set_selected(if value_text.trim() == "1" { 1 } else { 0 });
    combo.set_halign(gtk::Align::Start);
    if let Some(text) = tooltip {
        combo.set_tooltip_text(Some(text));
    }
    Editor::Dropdown {
        combo,
        choices: vec!["0".to_string(), "1".to_string()],
    }
}

fn build_extra_editor(record: &Record, ctx: &BuildContext) -> Editor {
    let name = record.segments.last().map(String::as_str).unwrap_or_default();
    if name == "position" {
        build_position_dropdown(&record.value, record.spec.description.as_deref())
    } else {
        build_bespoke_child(record, ctx)
    }
}
```

`Editor::Dropdown::to_nix` (line 470) emits the stored literal `0` or `1`, so the template's `02-dock.nix:26` data shape is preserved; the dock's `description` annotation becomes the tooltip.

#### Step 12

This builds one horizontal cell holding two extras side by side, each with caption and tooltip. Insert directly after `fn build_extra_editor` (currently ends at line 2088).

**File:** `src/widgets.rs`, insert after line 2088. ctrl+f: `fn build_extra_editor`

```rust
fn build_pair_row(
    first: &Record,
    first_editor: &Editor,
    second: &Record,
    second_editor: &Editor,
) -> gtk::Widget {
    let row = gtk::Box::new(gtk::Orientation::Horizontal, 12);
    row.set_margin_start(12);
    for (record, editor) in [(first, first_editor), (second, second_editor)] {
        let name = record.segments.last().cloned().unwrap_or_default();
        let cell = gtk::Box::new(gtk::Orientation::Vertical, 2);
        let caption = gtk::Label::builder()
            .xalign(0.0)
            .label(record.spec.label.clone().unwrap_or_else(|| field_caption(&name)))
            .css_classes(["dim-label"])
            .build();
        if let Some(help) = record.spec.description.as_deref().or_else(|| field_help(&name)) {
            caption.set_tooltip_text(Some(help));
        }
        cell.append(&caption);
        cell.append(&editor.root());
        row.append(&cell);
    }
    row.upcast()
}
```

The 12px start margin matches the `depth * 12` indent `build_child_row` uses, so the pair aligns with the other settings rows.

#### Step 13

These lines detect an `autoHide` extra immediately followed by `autoHideDelay` and return the delay pair for the grouped cell. Insert before `fn build_bar` (line 2959).

**File:** `src/widgets.rs`, insert before line 2959. ctrl+f: `fn build_bar`

```rust
fn autohide_delay_pair<'a>(
    extras: &'a [(Record, Editor)],
    index: usize,
) -> Option<&'a (Record, Editor)> {
    let (record, _) = extras.get(index)?;
    if record.segments.last().map(String::as_str) != Some("autoHide") {
        return None;
    }
    let (next, _) = extras.get(index + 1)?;
    if next.segments.last().map(String::as_str) == Some("autoHideDelay") {
        extras.get(index + 1)
    } else {
        None
    }
}
```

Pairing keys on scan order plus exact sibling names, so the grouping only fires when the two fields are adjacent in the record.

#### Step 14

This walks the extras list, emits the autoHide pair as one horizontal cell, and falls back to the indented child row otherwise. Insert directly after `fn autohide_delay_pair` (currently ends at line 2973).

**File:** `src/widgets.rs`, insert after line 2973. ctrl+f: `fn autohide_delay_pair`

```rust
fn append_settings_rows(
    root: &gtk::Box,
    extras: &[(Record, Editor)],
    ctx: &BuildContext,
) {
    let mut skip = false;
    for (index, (record, editor)) in extras.iter().enumerate() {
        if skip {
            skip = false;
            continue;
        }
        if record.spec.hidden && !ctx.advanced {
            continue;
        }
        match autohide_delay_pair(extras, index) {
            Some((delay_record, delay_editor)) => {
                root.append(&build_pair_row(record, editor, delay_record, delay_editor));
                skip = true;
            }
            None => root.append(&build_child_row(record, editor, 1)),
        }
    }
}
```

The `skip` flag consumes the delay entry once its pair has been drawn, so it is not rendered a second time as a lone row.

#### Step 15

This switches left/right lists to the widget row style and replaces the flat extras loop with `build_extra_editor` plus the grouped settings renderer. Edit `build_bar` at lines 2990, 3011, and 3020-3035.

**File:** `src/widgets.rs`, edit lines 2990-3035. ctrl+f: `fn build_bar`

At the left list (line 2990) and right list (line 3011) add `AttrsetRowStyle::WidgetLabel` after the `indent_by_key` argument:

```rust
    let (left_root, left) = build_attrset_rows(
        left_value.as_deref().unwrap_or("{ }"),
        ctx,
        &[("enabled", "true")],
        false,
        AttrsetRowStyle::WidgetLabel,
        &on_change,
    );
```

Replace the extras block (lines 3020-3035) with:

```rust
    let extras: Vec<(Record, Editor)> = extras
        .into_iter()
        .map(|record| {
            let editor = build_extra_editor(&record, ctx);
            (record, editor)
        })
        .collect();
    if extras
        .iter()
        .any(|(record, _)| !(record.spec.hidden && !ctx.advanced))
    {
        root.append(&heading("Settings"));
        append_settings_rows(&root, &extras, ctx);
    }
```

The `Editor::Bar` payload at line 3037 is unchanged because `extras` keeps the same `Vec<(Record, Editor)>` type, so `bar_nix` (line 3051) and the `unchanged`/`connect_changed` arms need no edits.

#### Step 16

This switches the dock widgets list to the widget row style, overrides the extras editor for `position`, and gates the Settings heading on visibility. Edit `build_dock` at lines 3101-3128.

**File:** `src/widgets.rs`, edit lines 3101-3128. ctrl+f: `fn build_dock`

At the widgets list (line 3101) add the style argument:

```rust
    let (widgets_root, widgets) = build_attrset_rows(
        widgets_value.as_deref().unwrap_or("{ }"),
        ctx,
        &[("enabled", "true")],
        false,
        AttrsetRowStyle::WidgetLabel,
        &on_change,
    );
```

Replace the settings heading and extras map (lines 3110-3128) with:

```rust
    let extras: Vec<(Record, Editor)> = extras
        .into_iter()
        .map(|record| {
            let editor = build_extra_editor(&record, ctx);
            (record, editor)
        })
        .collect();
    if extras
        .iter()
        .any(|(record, _)| !(record.spec.hidden && !ctx.advanced))
    {
        let settings = gtk::Label::builder()
            .xalign(0.0)
            .label("Settings")
            .css_classes(["heading"])
            .build();
        root.append(&settings);
        append_settings_rows(&root, &extras, ctx);
    }
```

`Editor::Dock` (line 3130) and `dock_nix` (line 3139) are untouched; the heading check now matches `build_bar` so a fully hidden extras set no longer shows an empty Settings section.

#### Step 17

This upgrades the shared `build_child_row` so bare records get a sentence caption and a help-map tooltip when the template carries no label or description. Edit the label block at lines 3175-3185 inside `fn build_child_row` (line 3172).

**File:** `src/widgets.rs`, edit lines 3175-3185. ctrl+f: `fn build_child_row`

Replace:

```rust
    let name = record.segments.last().cloned().unwrap_or_default();
    let label = record
        .spec
        .label
        .clone()
        .unwrap_or_else(|| field_caption(&name));
    let heading = gtk::Label::builder()
        .xalign(0.0)
        .label(label)
        .css_classes(["dim-label"])
        .build();
    if let Some(help) = record
        .spec
        .description
        .as_deref()
        .or_else(|| field_help(&name))
    {
        heading.set_tooltip_text(Some(help));
    }
```

The old fallback showed the raw segment (`:3179`); `field_caption` sentence-cases it and `field_help` supplies a tooltip only when `spec.description` is absent, so annotated submodule children render exactly as before.

### Fix plan: G4

#### Step 1
Adds a one-time CSS registration for the preview pill class, mirroring `install_swatch_css`.
**File:** `src/widgets.rs` · **Anchor:** `fn install_swatch_css` (:1790), insert the new fn directly after it (after :1812)

```rust
/// Install the one-time stylesheet that paints the keybind preview pill.
fn install_keybind_css() {
    use std::sync::Once;
    static ONCE: Once = Once::new();
    ONCE.call_once(|| {
        let css = ".keybind-preview {
            background-color: alpha(@window_fg_color, 0.08);
            border-radius: 8px;
            padding: 2px 8px;
        }";
        let provider = gtk::CssProvider::new();
        provider.load_from_data(css);
        if let Some(display) = gtk::gdk::Display::default() {
            gtk::style_context_add_provider_for_display(
                &display,
                &provider,
                gtk::STYLE_PROVIDER_PRIORITY_APPLICATION,
            );
        }
    });
}
```

`alpha(@window_fg_color, 0.08)` is a theme-aware faint background so the pill works in light and dark themes.

#### Step 2
Adds a small `dim_line` helper that pairs a dim caption label with a control, reused for every popup field row.
**File:** `src/widgets.rs` · **Anchor:** `fn make_keybind_row` (:2073), insert the new fn immediately above the `make_keybind_row` doc comment (:2071)

```rust
/// A horizontal line of a dim caption label and a child control, used in the
/// keybind edit popup.
fn dim_line(name: &str, child: &gtk::Widget) -> gtk::Box {
    let line = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    let label = gtk::Label::builder()
        .xalign(0.0)
        .width_chars(12)
        .label(name)
        .css_classes(["dim-label", "caption"])
        .build();
    line.append(&label);
    line.append(child);
    line
}
```

`&gtk::Widget` accepts `&gtk::Entry` and `&field.editor.root()` via deref coercion and owned temporary.

#### Step 3
Adds a `popup` field to `KeybindRow` so the trash handlers can destroy the hidden edit window with the row.
**File:** `src/widgets.rs` · **Anchor:** `pub(crate) struct KeybindRow` (:302)

```rust
/// One bind of the `keybinds` widget: name and description on the main line,
/// the bind's full field set in a hidden edit popup.
pub(crate) struct KeybindRow {
    key: gtk::Entry,
    orig_key: String,
    modifier: gtk::Entry,
    keys: gtk::Entry,
    orig_modifier: String,
    orig_keys: String,
    fields: Vec<AttrsetField>,
    row_box: gtk::Box,
    remove: gtk::Button,
    popup: gtk::Window,
}
```

`modifier`, `keys`, `fields`, `key`, `row_box`, `remove` keep the same types so `keybinds_nix` (:2175), the `unchanged` arm (:615), and `connect_keybind_row` (:2198) compile untouched.

#### Step 4
Replaces the top of `make_keybind_row`: the main line becomes a horizontal box holding a vertical `title_stack` with the hexpand name entry and a dim description caption beneath it.
**File:** `src/widgets.rs` · **Anchor:** `fn make_keybind_row` (:2073), replaces :2071-:2082

```rust
/// One bind of the `keybinds` widget: name and description on the main line,
/// the preview pill, and an edit popup holding every field.
fn make_keybind_row(scan_row: &scan::TableRowScan, ctx: &BuildContext) -> KeybindRow {
    install_keybind_css();
    let row_box = gtk::Box::new(gtk::Orientation::Vertical, 4);
    row_box.set_hexpand(true);
    let main = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    let title_stack = gtk::Box::new(gtk::Orientation::Vertical, 2);
    title_stack.set_hexpand(true);

    let key_entry = gtk::Entry::new();
    key_entry.set_hexpand(true);
    key_entry.set_placeholder_text(Some("Bind name"));
    key_entry.set_text(&scan_row.key);
    title_stack.append(&key_entry);

    let desc_caption = gtk::Label::builder()
        .xalign(0.0)
        .ellipsize(gtk::EllipsizeMode::End)
        .label(&entry_text(field(&scan_row.fields, "description").unwrap_or("")))
        .css_classes(["dim-label", "caption"])
        .build();
    title_stack.append(&desc_caption);
    main.append(&title_stack);
```

`entry_text` (:1062) unquotes the scanned `"..."` literal for the initial caption.

#### Step 5
Changes the modifier, keys, and preview construction: modifier/keys entries are no longer appended to `main`, the preview becomes a trailing pill, and the expander detail block collapses to a plain `fields` vector.
**File:** `src/widgets.rs` · **Anchor:** `fn make_keybind_row` (:2073), replaces :2084-:2124

```rust
    let modifier = gtk::Entry::new();
    modifier.set_width_chars(16);
    modifier.set_tooltip_text(Some("Modifiers, comma separated"));
    modifier.set_text(&list_text(field(&scan_row.fields, "modifier").unwrap_or("")));

    let keys = gtk::Entry::new();
    keys.set_width_chars(12);
    keys.set_tooltip_text(Some("Keys, comma separated"));
    keys.set_text(&list_text(field(&scan_row.fields, "keys").unwrap_or("")));

    let preview = gtk::Label::builder()
        .label(bind_preview(&modifier.text(), &keys.text()))
        .css_classes(["keybind-preview", "caption"])
        .halign(gtk::Align::End)
        .valign(gtk::Align::Center)
        .build();
    main.append(&preview);

    let mut fields = Vec::new();
    for name in ["dispatcher", "args", "description", "group", "subcat"] {
        fields.push(make_attrset_field(name, field(&scan_row.fields, name).unwrap_or(""), ctx));
    }
```

`halign(End)` keeps the pill pinned to the trailing edge; `bind_preview` (:1823) is unchanged.

#### Step 6
Inserts the hidden `gtk::Window` popup between the fields loop and the remove button, parenting name, modifier, keys, and every `AttrsetField` editor inside it via `dim_line`.
**File:** `src/widgets.rs` · **Anchor:** `fn make_keybind_row` (:2073), insert after the fields loop close and before `let remove = gtk::Button::from_icon_name("user-trash-symbolic")` (today :2126)

```rust
    let popup = gtk::Window::builder()
        .title(&scan_row.key)
        .modal(true)
        .default_width(440)
        .hide_on_close(true)
        .build();
    let popup_box = gtk::Box::new(gtk::Orientation::Vertical, 8);
    popup_box.set_margin_top(12);
    popup_box.set_margin_bottom(12);
    popup_box.set_margin_start(12);
    popup_box.set_margin_end(12);

    let popup_name = gtk::Entry::new();
    popup_name.set_hexpand(true);
    popup_name.set_text(&key_entry.text());
    popup_box.append(&dim_line("name", &popup_name));
    popup_box.append(&dim_line("modifier", &modifier));
    popup_box.append(&dim_line("keys", &keys));
    for f in &fields {
        popup_box.append(&dim_line(&f.name, &f.editor.root()));
    }
    popup.set_child(Some(&popup_box));
```

`hide_on_close(true)` is required: closing must not destroy the popup, because the `modifier`, `keys`, and field editors live inside it and `keybinds_nix` reads them later.

#### Step 7
Wires two-way name sync between the inline entry and the popup entry, plus a live description caption update from the description field's text editor.
**File:** `src/widgets.rs` · **Anchor:** `fn make_keybind_row` (:2073), insert immediately after `popup.set_child(Some(&popup_box));` (Step 6)

```rust
    {
        let key_entry = key_entry.clone();
        popup_name.connect_changed(move |entry| {
            if key_entry.text() != entry.text() {
                key_entry.set_text(&entry.text());
            }
        });
        let popup_name = popup_name.clone();
        key_entry.connect_changed(move |entry| {
            if popup_name.text() != entry.text() {
                popup_name.set_text(&entry.text());
            }
        });
    }
    if let Some(desc) = fields.iter().find(|f| f.name == "description") {
        if let Editor::Text(entry) = &desc.editor {
            let caption = desc_caption.clone();
            entry.connect_changed(move |_| caption.set_label(&entry.text()));
        }
    }
```

The equality guards stop `set_text` feedback loops; writing `key_entry.set_text` still fires the `update` hook connected later in `connect_keybind_row` (:2198).

#### Step 8
Replaces the expander-era tail: adds the "Edit" button that presents the popup, sets its transient parent from the toplevel at click time, and keeps the trash button and `row_box` append.
**File:** `src/widgets.rs` · **Anchor:** `let remove = gtk::Button::from_icon_name("user-trash-symbolic")` (:2126), replaces :2126-:2131

```rust
    let edit = gtk::Button::with_label("Edit");
    {
        let popup = popup.clone();
        let edit_probe = edit.clone();
        edit.connect_clicked(move |_| {
            if popup.transient_for().is_none() {
                if let Some(parent) = edit_probe.root().and_downcast::<gtk::Window>() {
                    popup.set_transient_for(Some(&parent));
                }
            }
            popup.present();
        });
    }
    main.append(&edit);

    let remove = gtk::Button::from_icon_name("user-trash-symbolic");
    remove.add_css_class("flat");
    remove.set_tooltip_text(Some("Remove bind"));
    main.append(&remove);
    row_box.append(&main);
```

`root()` on the button reaches the realized `adw::ApplicationWindow` at click time; `and_downcast::<gtk::Window>()` matches the `transient_for(&app.window)` pattern used in `src/app.rs` (:2207).

#### Step 9
Adds the `popup` field to the returned struct literal; the preview watcher block above it (:2133-:2145) stays verbatim and keeps live preview updating from the popup's entries.
**File:** `src/widgets.rs` · **Anchor:** `KeybindRow {` (:2147), replaces :2147-:2159

```rust
    KeybindRow {
        key: key_entry,
        orig_key: scan_row.key.clone(),
        modifier,
        keys,
        orig_modifier: field(&scan_row.fields, "modifier")
            .unwrap_or("")
            .to_string(),
        orig_keys: field(&scan_row.fields, "keys").unwrap_or("").to_string(),
        fields,
        row_box,
        remove,
        popup,
    }
}
```

The watchers connected at :2137 and :2142 hold clones of the same `modifier`/`keys` entries now parented inside the popup, so preview keeps updating with no wiring change.

#### Step 10
Updates the row-removal closure in the `build_keybinds` scan loop to destroy the popup alongside removing the row box.
**File:** `src/widgets.rs` · **Anchor:** `for scan_row in scanned` (:2229), replaces the closure block at :2231-:2244

```rust
        {
            let container = container.clone();
            let rows = rows.clone();
            let on_change = on_change.clone();
            let row_box = row.row_box.clone();
            let key = row.key.clone();
            let popup = row.popup.clone();
            row.remove.connect_clicked(move |_| {
                popup.destroy();
                container.remove(&row_box);
                rows.borrow_mut().retain(|r| r.key != key);
                if let Some(cb) = on_change.borrow().as_ref() {
                    cb();
                }
            });
        }
```

destroying the hidden window frees its child editors so removed rows do not leak windows.

#### Step 11
Applies the same popup destroy to the "Add bind" path's removal closure.
**File:** `src/widgets.rs` · **Anchor:** `add.connect_clicked` (:2255), replaces the inner closure block at :2266-:2279

```rust
            {
                let container = container.clone();
                let rows = rows.clone();
                let on_change = on_change.clone();
                let row_box = row.row_box.clone();
                let key = row.key.clone();
                let popup = row.popup.clone();
                row.remove.connect_clicked(move |_| {
                    popup.destroy();
                    container.remove(&row_box);
                    rows.borrow_mut().retain(|r| r.key != key);
                    if let Some(cb) = on_change.borrow().as_ref() {
                        cb();
                    }
                });
            }
```

`make_keybind_row` builds the popup for scaffold rows too, so this path needs the same cleanup as Step 10.

### Fix plan: G8

#### Step 1

Add the new variant to the enum and teach the annotation parser its hyphenated string. The `spec.widget` early-return path in `choose_widget` (widgets.rs:875) then delivers the kind to `build` with no other routing change.

**File:** `src/dsl.rs` · **Anchor:** `pub enum WidgetKind` (254), parse arm `"horizontal-submodule"` (301)

```rust
pub enum WidgetKind {
    Switch,
    Dropdown,
    Radio,
    Spin,
    Slider,
    Text,
    Multiline,
    Path,
    Package,
    Packages,
    List,
    NixosModules,
    HmModules,
    Color,
    Submodule,
    HorizontalSubmodule,
    GridConfiguration,
    TableAttrset,
    TableList,
    Keybinds,
    Monitors,
    Theme,
    Menu,
    Plugins,
    Bar,
    Dock,
    Raw,
}

impl WidgetKind {
    pub fn parse(s: &str) -> Option<Self> {
        Some(match s.trim().to_ascii_lowercase().as_str() {
            "horizontal-submodule" | "horizontalsubmodule" => Self::HorizontalSubmodule,
            "grid-configuration" | "gridconfiguration" => Self::GridConfiguration,
```

The serde `rename_all = "lowercase"` name (`gridconfiguration`) is only for serialization; annotations accept both spellings like every hyphenated kind before it.

#### Step 2

Add the display-name helper next to the other grid builder code near `build_dock`. It special-cases bar/dock region ids and common connectivity abbreviations, then title-cases camelCase or snake_case ids.

**File:** `src/widgets.rs` · **Anchor:** `fn build_dock` (3079), insert before it

```rust
fn widget_display_name(id: &str) -> String {
    let id = id.trim();
    match id {
        "left" => return "Left".to_string(),
        "center" => return "Center".to_string(),
        "right" => return "Right".to_string(),
        "wifi" => return "Wi-Fi".to_string(),
        "vpn" => return "VPN".to_string(),
        "builtin_vpn" | "builtinVpn" => return "Built-in VPN".to_string(),
        "uv" => return "UV".to_string(),
        _ => {}
    }
    let mut words: Vec<String> = Vec::new();
    let mut current = String::new();
    for (index, c) in id.chars().enumerate() {
        if c == '_' || c == '-' || c.is_whitespace() {
            if !current.is_empty() { words.push(std::mem::take(&mut current)); }
            continue;
        }
        if c.is_uppercase() && index > 0 && current.chars().last().is_some_and(|p| !p.is_uppercase()) {
            words.push(std::mem::take(&mut current));
        }
        current.push(c.to_ascii_lowercase());
    }
    if !current.is_empty() { words.push(current); }
    let mut display = words.join(" ");
    if let Some(first) = display.get_mut(0..1) { first.make_ascii_uppercase(); }
    display
}
```

The trim handles the quoted dashboard key `"daily "`; the uppercase-run check keeps `VPN`-style runs from splitting mid-acronym.

#### Step 3

Add a small per-page id registry so the add-picker can offer ids not yet present. It keys off the record path and mirrors the ids in the two template files.

**File:** `src/widgets.rs` · **Anchor:** `fn widget_display_name` (insert after it)

```rust
fn grid_registry(path: &str) -> Vec<String> {
    let ids: &[&str] = if path.contains("controlCenterWidgets") {
        &["user", "battery", "settings", "lock", "power", "brightnessSlider",
          "volumeSlider", "inputVolumeSlider", "wifi", "bluetooth", "builtin_vpn",
          "diskUsage", "nightMode", "doNotDisturb", "idleInhibitor", "runningApps"]
    } else if path.contains("dashCards") {
        &["clock", "weather", "notifications", "calendar", "media", "sysmon",
          "network", "user"]
    } else if path.contains("weather.widgets") {
        &["conditions", "hourly", "humidity", "wind", "daily", "precipitation", "uv"]
    } else {
        &[]
    };
    ids.iter().map(|s| s.to_string()).collect()
}
```

The registry lists `daily` trimmed; the live key `"daily "` stays distinct because ids are compared raw, and `attr_key` re-quotes it on write.

#### Step 4

Add the row struct next to the other bespoke row structs. `orig` is a tuple of the six parsed defaults used by the unchanged check; `added` marks rows created after load so they always count as dirty.

**File:** `src/widgets.rs` · **Anchor:** `pub(crate) struct PluginRow` (333), insert after it

```rust
pub(crate) struct GridRow {
    id: String,
    added: bool,
    enabled: gtk::Switch,
    order: gtk::SpinButton,
    col: gtk::SpinButton,
    row: gtk::SpinButton,
    w: gtk::SpinButton,
    h: gtk::SpinButton,
    row_box: gtk::Box,
    remove: gtk::Button,
    orig: (bool, f64, f64, f64, f64, f64),
}
```

`id` keeps the raw key including trailing spaces so `attr_key` round-trips quoted keys like `"daily "`.

#### Step 5

Add the `Grid` variant to the `Editor` enum and its `root` arm, mirroring the `Dock` wiring. Fields: rows, the original id list for the unchanged check, non-widget extras, and the change hook.

**File:** `src/widgets.rs` · **Anchor:** `Editor::Dock {` in enum (425), `Editor::Dock { root, .. }` in root (461)

```rust
    Dock {
        root: gtk::Box,
        widgets: Rc<RefCell<Vec<AttrsetRow>>>,
        widgets_present: bool,
        extras: Vec<(Record, Editor)>,
        on_change: ChangeHook,
    },
    Grid {
        root: gtk::Box,
        rows: Rc<RefCell<Vec<GridRow>>>,
        orig_ids: Vec<String>,
        extras: Vec<(Record, Editor)>,
        on_change: ChangeHook,
    },
    Raw {
        view: gtk::TextView,
        root: gtk::ScrolledWindow,
    },
}
// in impl Editor, fn root (439), after the Dock arm at 461:
            Editor::Dock { root, .. } => root.clone().upcast(),
            Editor::Grid { root, .. } => root.clone().upcast(),
            Editor::Raw { root, .. } => root.clone().upcast(),
```

No `widgets_present` flag: the group record always owns the whole value span, so an empty row list simply serializes `{ }`.

#### Step 6

Add the field parser: it reads one widget attrset's text and returns the six values with the defaults the template implies (enabled true, `_order` 0, col/row 0, w/h 1, matching rows like `runningApps` that omit col/row).

**File:** `src/widgets.rs` · **Anchor:** `fn scan_children` (3158), insert before it

```rust
fn parse_grid_fields(text: &str) -> (bool, f64, f64, f64, f64, f64) {
    let mut enabled = true;
    let mut order = 0.0;
    let mut col = 0.0;
    let mut grid_row = 0.0;
    let mut w = 1.0;
    let mut h = 1.0;
    for child in scan::scan_value(text) {
        let name = child.segments.last().map(String::as_str).unwrap_or("");
        let value = child.value.trim();
        match name {
            "enabled" => enabled = value == "true",
            "_order" => order = value.parse().unwrap_or(0.0),
            "col" => col = value.parse().unwrap_or(0.0),
            "row" => grid_row = value.parse().unwrap_or(0.0),
            "w" => w = value.parse().unwrap_or(1.0),
            "h" => h = value.parse().unwrap_or(1.0),
            _ => {}
        }
    }
    (enabled, order, col, grid_row, w, h)
}
```

It reuses `scan::scan_value` directly, the same scanner `scan_children` uses, and needs no byte offsets because only values are compared later.

#### Step 7

Add the spin constructor and the row builder. Each row is one horizontal box: enabled switch, name label from `widget_display_name`, five spins, delete button.

**File:** `src/widgets.rs` · **Anchor:** `fn parse_grid_fields` (insert after it)

```rust
fn grid_spin(value: f64, max: f64) -> gtk::SpinButton {
    let spin = gtk::SpinButton::with_range(0.0, max, 1.0);
    spin.set_value(value);
    spin
}

fn build_grid_row(id: &str, value_text: &str) -> GridRow {
    let fields = parse_grid_fields(value_text);
    let (enabled, order, col, row, w, h) = fields;
    let row_box = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    row_box.set_hexpand(true);
    let enabled_switch = gtk::Switch::new();
    enabled_switch.set_active(enabled);
    row_box.append(&enabled_switch);
    let name = gtk::Label::builder()
        .xalign(0.0).hexpand(true)
        .label(widget_display_name(id))
        .css_classes(["dim-label"])
        .build();
    row_box.append(&name);
    let order_spin = grid_spin(order, 9999.0);
    let col_spin = grid_spin(col, 64.0);
    let row_spin = grid_spin(row, 64.0);
    let w_spin = grid_spin(w, 32.0);
    let h_spin = grid_spin(h, 32.0);
    for spin in [&order_spin, &col_spin, &row_spin, &w_spin, &h_spin] {
        row_box.append(spin);
    }
    let remove = gtk::Button::from_icon_name("edit-delete-symbolic");
    remove.add_css_class("flat");
    row_box.append(&remove);
    GridRow { id: id.to_string(), added: false, enabled: enabled_switch,
        order: order_spin, col: col_spin, row: row_spin, w: w_spin, h: h_spin,
        row_box, remove, orig: fields }
}
```

Explicit `with_range` spins avoid depending on `build_spin`'s `OptionSpec` defaults; ranges cover order up to 9999 and grid geometry up to 64 cells.

#### Step 8

Add the per-row signal wiring helper. It is a small `dyn Fn` so `attach_grid_row` can reuse it for rows added at runtime, which the `connect_changed` pass never sees.

**File:** `src/widgets.rs` · **Anchor:** `fn build_attrset_rows` (2010), insert before it

```rust
fn connect_grid_row(row: &GridRow, update: &Rc<dyn Fn()>) {
    let update = update.clone();
    row.enabled.connect_active_notify(move |_| update());
    let update = update.clone();
    row.order.connect_value_changed(move |_| update());
    let update = update.clone();
    row.col.connect_value_changed(move |_| update());
    let update = update.clone();
    row.row.connect_value_changed(move |_| update());
    let update = update.clone();
    row.w.connect_value_changed(move |_| update());
    let update = update.clone();
    row.h.connect_value_changed(move |_| update());
}
```

Each closure needs its own clone because `Rc<dyn Fn()>` is moved into the previous handler, the same style as the `Editor::Spin` arm at widgets.rs:698.

#### Step 9

Add the attach helper that wires a row through the `ChangeHook` and registers it. The delete button removes by `row_box` object identity, then fires the hook.

**File:** `src/widgets.rs` · **Anchor:** `fn connect_grid_row` (insert after it)

```rust
fn attach_grid_row(
    container: &gtk::Box,
    rows: &Rc<RefCell<Vec<GridRow>>>,
    row: GridRow,
    on_change: &ChangeHook,
) {
    let hook: Rc<dyn Fn()> = {
        let on_change = on_change.clone();
        Rc::new(move || {
            if let Some(cb) = on_change.borrow().as_ref() {
                cb();
            }
        })
    };
    connect_grid_row(&row, &hook);
    let target = row.row_box.clone();
    let rows_for_remove = rows.clone();
    let hook_for_remove = hook.clone();
    row.remove.connect_clicked(move |_| {
        rows_for_remove.borrow_mut().retain(|r| r.row_box != target);
        hook_for_remove();
    });
    container.append(&row.row_box);
    rows.borrow_mut().push(row);
}
```

`gtk::Box` equality is GObject pointer identity, so retain drops exactly the clicked row; wiring at attach time keeps late-added rows live without touching `connect_changed` again.

#### Step 10

Add the add-widget bar: a dropdown of registry ids minus current rows, a custom-id entry, and the Add button, following the `Add` button pattern from `build_attrset_rows` (widgets.rs:2028).

**File:** `src/widgets.rs` · **Anchor:** `fn attach_grid_row` (insert after it)

```rust
fn build_grid_adder(
    container: &gtk::Box,
    rows: &Rc<RefCell<Vec<GridRow>>>,
    available: &[String],
    on_change: &ChangeHook,
) -> gtk::Box {
    let bar = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    let labels: Vec<String> = available.iter().map(|id| widget_display_name(id)).collect();
    let combo = gtk::DropDown::from_strings(&labels);
    let entry = gtk::Entry::new();
    entry.set_placeholder_text(Some("Custom id"));
    entry.set_width_chars(14);
    let add = gtk::Button::with_label("Add widget");
    bar.append(&combo);
    bar.append(&entry);
    bar.append(&add);
    let rows = rows.clone();
    let container = container.clone();
    let available = available.to_vec();
    let on_change = on_change.clone();
    add.connect_clicked(move |_| {
        let custom = entry.text().trim().to_string();
        let selected = available.get(combo.selected() as usize).cloned().unwrap_or_default();
        let id = if custom.is_empty() { selected } else { custom };
        if id.is_empty() || rows.borrow().iter().any(|row| row.id == id) {
            return;
        }
        let next_order = rows.borrow().iter().map(|row| row.order.value()).fold(0.0, f64::max) + 10.0;
        let scaffold = format!(
            "{{ enabled = true; _order = {}; col = 0; row = 0; w = 1; h = 1; }}",
            next_order as i64
        );
        let mut row = build_grid_row(&id, &scaffold);
        row.added = true;
        container.append(&row.row_box);
        rows.borrow_mut().push(row);
        if let Some(cb) = on_change.borrow().as_ref() {
            cb();
        }
    });
    bar
}
```

The dropdown list is computed once at build; the `any(|row| row.id == id)` check blocks duplicates and the custom entry covers ids outside the registry.

#### Step 11

Add the builder: scan the group record's children, turn every attrset child into a row, route everything else to the bespoke-child fallback like `build_dock` does, then mount the adder and return the variant.

**File:** `src/widgets.rs` · **Anchor:** `fn build_dock` (3079), insert before it; route in `fn build` (818) after the HorizontalSubmodule arm (847)

```rust
fn build_grid_configuration(record: &Record, ctx: &BuildContext) -> Editor {
    let root = gtk::Box::new(gtk::Orientation::Vertical, 8);
    root.set_hexpand(true);
    let on_change: ChangeHook = Rc::new(RefCell::new(None));
    let container = gtk::Box::new(gtk::Orientation::Vertical, 6);
    container.set_hexpand(true);
    let rows = Rc::new(RefCell::new(Vec::new()));
    let mut orig_ids = Vec::new();
    let mut extras = Vec::new();
    for child in scan_children(record, ctx.advanced) {
        if value::classify(&child.value) == value::ValueKind::AttrSet {
            let id = child.segments.last().cloned().unwrap_or_default();
            orig_ids.push(id.clone());
            let row = build_grid_row(&id, &child.value);
            attach_grid_row(&container, &rows, row, &on_change);
        } else {
            extras.push(child);
        }
    }
    let available: Vec<String> = grid_registry(&record.path())
        .into_iter()
        .filter(|id| !orig_ids.contains(id))
        .collect();
    root.append(&container);
    root.append(&build_grid_adder(&container, &rows, &available, &on_change));
    let extras: Vec<(Record, Editor)> = extras.into_iter().map(|child| {
        let visible = !(child.spec.hidden && !ctx.advanced);
        let editor = build_bespoke_child(&child, ctx);
        if visible {
            root.append(&build_child_row(&child, &editor, 1));
        }
        (child, editor)
    }).collect();
    Editor::Grid { root, rows, orig_ids, extras, on_change }
}
// in fn build, after WidgetKind::HorizontalSubmodule arm:
        WidgetKind::GridConfiguration => build_grid_configuration(record, ctx),
```

`value::classify` sorts children the same way `widget_from_kind` does, so any non-attrset child (stray config under the group) keeps working as its own control.

#### Step 12

Add serialization and the two one-line arms: routing already landed in step 11, so this step is `grid_nix` plus the `to_nix` arm after the `Dock` arm at widgets.rs:549. Field order is fixed: enabled, `_order`, col, row, w, h.

**File:** `src/widgets.rs` · **Anchor:** `fn dock_nix` (3139), insert after it; `to_nix` Dock arm (549)

```rust
fn grid_nix(rows: &[GridRow], extras: &[(Record, Editor)]) -> String {
    let mut parts = Vec::new();
    for row in rows {
        parts.push(format!(
            "{} = {{ enabled = {}; _order = {}; col = {}; row = {}; w = {}; h = {}; }};",
            attr_key(&row.id),
            row.enabled.is_active(),
            row.order.value() as i64,
            row.col.value() as i64,
            row.row.value() as i64,
            row.w.value() as i64,
            row.h.value() as i64,
        ));
    }
    for (record, editor) in extras {
        let name = record.segments.last().cloned().unwrap_or_default();
        parts.push(format!("{} = {};", attr_key(&name), editor.to_nix()));
    }
    format!("{{ {} }}", parts.join(" "))
}
// in fn to_nix, after the Dock arm:
            Editor::Grid { rows, extras, .. } => grid_nix(&rows.borrow(), extras),
```

The rewrite emits exactly the six template fields, so control-center extras like `small`, `footer`, and `mountpath` are dropped from any row when the group is rewritten; the default `edits` branch (widgets.rs:674) then applies one `PendingEdit` over the whole group value span, which is what makes add and delete work.

#### Step 13

Add the unchanged check: same id list, no added rows, every row matches its parsed originals within the 1e-9 tolerance the `Spin` arm uses, and extras untouched. Wire the arm before the catch-all at widgets.rs:653.

**File:** `src/widgets.rs` · **Anchor:** `unchanged` Dock arm (645), new arm before `_ => self.to_nix()` (653)

```rust
            Editor::Grid {
                rows, orig_ids, extras, ..
            } => {
                let rows = rows.borrow();
                rows.len() == orig_ids.len()
                    && rows.iter().zip(orig_ids.iter()).all(|(row, id)| {
                        row.id == *id
                            && !row.added
                            && row.enabled.is_active() == row.orig.0
                            && (row.order.value() - row.orig.1).abs() < 1e-9
                            && (row.col.value() - row.orig.2).abs() < 1e-9
                            && (row.row.value() - row.orig.3).abs() < 1e-9
                            && (row.w.value() - row.orig.4).abs() < 1e-9
                            && (row.h.value() - row.orig.5).abs() < 1e-9
                    })
                    && extras
                        .iter()
                        .all(|(record, editor)| editor.unchanged(&record.value))
            }
```

The length and positional zip checks make a delete count as a change even though every surviving row still matches its own original values.

#### Step 14

Wire the last `connect_changed` arm, which only stores the hook because attach-time wiring already covered every row including late adds. Then build and test; the compiler flags any remaining exhaustive `WidgetKind` match.

**File:** `src/widgets.rs` · **Anchor:** `connect_changed` Dock arm (797), new arm after it (match ends 811)

```rust
            Editor::Dock {
                widgets,
                extras,
                on_change,
                ..
            } => {
                *on_change.borrow_mut() = Some(update.clone());
                for row in widgets.borrow().iter() {
                    connect_attrset_row(row, update);
                }
                for (_, editor) in extras {
                    editor.connect_changed(update);
                }
            }
            Editor::Grid {
                extras, on_change, ..
            } => {
                *on_change.borrow_mut() = Some(update.clone());
                for (_, editor) in extras {
                    editor.connect_changed(update);
                }
            }
```

Verification: `cargo build && cargo test` in `/home/den/repos/nix-settings-gui`; the template files stay on `widget = "horizontal-submodule"` untouched, and the later one-line switch only re-points an annotation at the group parent with field names `enabled`/`_order`/`col`/`row`/`w`/`h` unchanged, so no data migration is needed.

### Fix plan: G9

#### Step 1
Add a `MenuRow` struct next to `AttrsetRow` holding the section, relative key entry, retained icon raw text, label and aliases entries, the five popup field editors, and the popup/row containers.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "pub(crate) struct AttrsetRow"` (:292), insert after the closing brace at :298
```rust
pub(crate) struct MenuRow {
    section: String,
    key: gtk::Entry,
    orig_key: String,
    icon: String,
    label: gtk::Entry,
    orig_label: String,
    aliases: gtk::Entry,
    orig_aliases: String,
    popup_fields: Vec<AttrsetField>,
    popup_box: gtk::Box,
    row_box: gtk::Box,
    remove: gtk::Button,
}
```
`popup_fields` holds provider, target, action, checked, when in that fixed order; `popup_box` is parented inside the shared popup on Edit and must outlive row removal.

#### Step 2
Extract the body of `attrset_field_nix` into a `field_nix` helper that takes name/editor/orig pieces directly, so the menu serializer can reuse it for entries that are not `AttrsetField`s.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn attrset_field_nix"` (:1889)
```rust
fn field_nix(
    name: &str,
    editor: &Editor,
    orig_value: &str,
    orig_present: bool,
) -> Option<String> {
    if !orig_present && !field_has_content(editor) {
        return None;
    }
    Some(format!("{} = {};", attr_key(name), editor.to_nix()))
}

fn attrset_field_nix(field: &AttrsetField) -> Option<String> {
    field_nix(
        &field.name,
        &field.editor,
        &field.orig_value,
        field.orig_present,
    )
}
```
`orig_value` is only used by callers of `unchanged` elsewhere, not inside `field_nix`, but keeping the signature uniform makes both serializers share one presence rule.

#### Step 3
Add aliases round-trip helpers: raw nix list to comma-joined display text, and display text back to a serialized `aliases = [ ... ];` line.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn field_nix"` (:1889), insert after it
```rust
fn menu_aliases_text(raw: &str) -> String {
    raw.split('"').skip(1).step_by(2).collect::<Vec<_>>().join(", ")
}

fn menu_aliases_nix(text: &str) -> Option<String> {
    let items: Vec<String> = text
        .split(',')
        .map(|s| s.trim().to_string())
        .filter(|s| !s.is_empty())
        .map(|s| expr_literal(&s))
        .collect();
    (!items.is_empty())
        .then(|| format!("aliases = {};", value::serialize_list(&items)))
}
```
The split-on-quote trick pulls only the quoted items out of `[ "app" "applications" ]`; `expr_literal` plus `value::serialize_list` matches how `Editor::List` serializes.

#### Step 4
Build the popup field stack: provider, target, and action via `dim_line`, then checked and when inside an "Advanced conditions" expander.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn make_attrset_row"` (:1902), insert before it
```rust
fn menu_popup_fields(fields: &[AttrsetField]) -> gtk::Box {
    let vbox = gtk::Box::new(gtk::Orientation::Vertical, 8);
    for field in fields.iter().take(3) {
        vbox.append(&dim_line(&field.name, &field.editor.root()));
    }
    let advanced = gtk::Expander::with_label("Advanced conditions");
    let inner = gtk::Box::new(gtk::Orientation::Vertical, 8);
    for field in fields.iter().skip(3) {
        inner.append(&dim_line(&field.name, &field.editor.root()));
    }
    advanced.set_child(Some(&inner));
    vbox.append(&advanced);
    vbox
}
```
The fixed field order from step 1 is what makes `take(3)`/`skip(3)` the split between popup body and advanced expander.

#### Step 5
Construct one row: relative key entry, label and aliases entries, retained icon, inferred popup editors, a compact summary box, and an Edit button that reparents `popup_box` into the shared window and presents it.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn make_attrset_row"` (:1902), insert before it
```rust
fn make_menu_row(
    section: &str,
    rel_key: &str,
    fields: &[(String, String)],
    ctx: &BuildContext,
    popup: &gtk::Window,
    popup_content: &gtk::Box,
) -> MenuRow {
    let raw_of = |name: &str| {
        fields
            .iter()
            .find(|(n, _)| n == name)
            .map(|(_, r)| r.trim().to_string())
            .unwrap_or_default()
    };
    let unquote = |raw: &str| raw.trim().trim_matches('"').to_string();

    let key = gtk::Entry::new();
    key.set_width_chars(16);
    key.set_text(rel_key);
    let orig_key = if rel_key.is_empty() {
        section.to_string()
    } else {
        format!("{section}.{rel_key}")
    };

    let icon = raw_of("icon");
    let label = gtk::Entry::new();
    label.set_text(&unquote(&raw_of("label")));
    let orig_label = label.text().to_string();
    let aliases = gtk::Entry::new();
    aliases.set_text(&menu_aliases_text(&raw_of("aliases")));
    let orig_aliases = aliases.text().to_string();

    let popup_fields: Vec<AttrsetField> = ["provider", "target", "action", "checked", "when"]
        .iter()
        .map(|name| make_attrset_field(name, &raw_of(name), ctx))
        .collect();
    let popup_box = menu_popup_fields(&popup_fields);
```
`orig_key` stores the full dotted key so `unchanged` can compare against the reconstructed key even though the visible entry only holds the child suffix.

#### Step 6
Finish `make_menu_row` by assembling the compact summary: icon widget or label-initial fallback, key/label/aliases entries, a link/shell/group caption, the Edit button, and the trash button.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn make_attrset_row"` (:1902), continue `make_menu_row` after step 5
```rust
    let icon_widget: gtk::Widget = if icon.is_empty() {
        gtk::Label::new(Some(&orig_label.chars().next().unwrap_or(' ').to_string()))
            .upcast()
    } else {
        gtk::Image::from_icon_name(&icon).upcast()
    };
    let kind = match (raw_of("target").as_str(), raw_of("action").as_str()) {
        (t, _) if !t.is_empty() && t != "null" => "link",
        (_, a) if !a.is_empty() && a != "null" => "shell",
        _ => "group",
    };
    let caption = gtk::Label::new(Some(kind));
    caption.add_css_class("dim-label");
    caption.add_css_class("caption");

    let main = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    main.set_hexpand(true);
    main.append(&icon_widget);
    if !rel_key.is_empty() {
        main.append(&key);
    }
    label.set_hexpand(true);
    main.append(&label);
    main.append(&aliases);
    main.append(&caption);

    let edit = gtk::Button::with_label("Edit");
    let remove = gtk::Button::from_icon_name("user-trash-symbolic");
    remove.add_css_class("flat");
    main.append(&edit);
    main.append(&remove);

    let row_box = gtk::Box::new(gtk::Orientation::Vertical, 4);
    row_box.set_hexpand(true);
    row_box.append(&main);

    MenuRow {
        section: section.to_string(),
        key,
        orig_key,
        icon,
        label,
        orig_label,
        aliases,
        orig_aliases,
        popup_fields,
        popup_box,
        row_box,
        remove,
    }
}
```
The key entry is omitted for section-own rows (rel_key empty) because their full key is the section name itself; the caption distinguishes URL targets from shell actions at a glance.

#### Step 7
Wire the Edit button in a small helper: clear the popup content, reparent this row's `popup_box`, set `transient_for` from the row's toplevel at click time, and present.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn make_attrset_row"` (:1902), insert `connect_menu_edit` before `make_menu_row`
```rust
fn connect_menu_edit(
    edit: &gtk::Button,
    row_box: &gtk::Box,
    popup_box: &gtk::Box,
    popup: &gtk::Window,
    popup_content: &gtk::Box,
) {
    let row_box = row_box.clone();
    let popup_box = popup_box.clone();
    let popup = popup.clone();
    let popup_content = popup_content.clone();
    edit.connect_clicked(move |_| {
        while let Some(child) = popup_content.first_child() {
            popup_content.remove(&child);
        }
        if let Some(win) = row_box.root().and_then(|w| w.downcast::<gtk::Window>().ok()) {
            popup.set_transient_for(Some(&win));
        }
        popup_content.append(&popup_box);
        popup.present();
    });
}
```
`hide_on_close` on the window keeps it alive so the reparented editors are never destroyed on close; call this from `make_menu_row` right before constructing `MenuRow`.

#### Step 8
Mirror `attach_attrset_row` for menu rows: wire remove to detach the row box, unparent `popup_box` if the popup currently shows it, drop the row from the vec, and fire the change hook.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn attach_attrset_row"` (:1983), insert after it
```rust
fn attach_menu_row(
    container: &gtk::Box,
    rows: &Rc<RefCell<Vec<MenuRow>>>,
    row: MenuRow,
    on_change: &ChangeHook,
    popup_content: &gtk::Box,
) {
    {
        let container = container.clone();
        let rows = rows.clone();
        let row_box = row.row_box.clone();
        let key = row.key.clone();
        let popup_box = row.popup_box.clone();
        let popup_content = popup_content.clone();
        let on_change = on_change.clone();
        row.remove.connect_clicked(move |_| {
            container.remove(&row_box);
            if popup_box.parent().is_some() && popup_content.contains(&popup_box) {
                popup_box.unparent();
            }
            rows.borrow_mut().retain(|r| r.key != key);
            if let Some(cb) = on_change.borrow().as_ref() {
                cb();
            }
        });
    }
    container.append(&row.row_box);
    rows.borrow_mut().push(row);
}
```
Unparenting before dropping the row prevents the open popup from holding a widget whose row was deleted.

#### Step 9
Wire change notification for one row: key, label, and aliases entries plus all five popup field editors.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn connect_attrset_row"` (:1972), insert after it
```rust
fn connect_menu_row(row: &MenuRow, update: &Rc<dyn Fn()>) {
    let update_key = update.clone();
    row.key.connect_changed(move |_| update_key());
    let update_label = update.clone();
    row.label.connect_changed(move |_| update_label());
    let update_aliases = update.clone();
    row.aliases.connect_changed(move |_| update_aliases());
    for field in &row.popup_fields {
        field.editor.connect_changed(update);
    }
}
```
Popup editors stay in the `MenuRow` even while displayed inside the window, so wiring them here covers edits made with the popup open.

#### Step 10
Serialize rows back to the flat attrset shape the template ships: full key from section plus relative entry, then icon, label, aliases list, and the five field lines.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn attrset_rows_nix"` (:1950), insert after it
```rust
fn menu_rows_nix(rows: &[MenuRow]) -> String {
    let parts: Vec<String> = rows
        .iter()
        .map(|row| {
            let full = if row.key.text().is_empty() {
                row.section.clone()
            } else {
                format!("{}.{}", row.section, row.key.text())
            };
            let mut fields: Vec<String> = Vec::new();
            if !row.icon.is_empty() {
                fields.push(format!("icon = {};", string_literal(&row.icon)));
            }
            if !row.orig_label.is_empty() || !row.label.text().is_empty() {
                fields.push(format!("label = {};", string_literal(&row.label.text())));
            }
            if let Some(line) = menu_aliases_nix(&row.aliases.text()) {
                fields.push(line);
            }
            for field in &row.popup_fields {
                if let Some(line) = attrset_field_nix(field) {
                    fields.push(line);
                }
            }
            format!("{} = {{ {} }};", attr_key(&full), fields.join(" "))
        })
        .collect();
    format!("{{ {} }}", parts.join(" "))
}
```
No nesting is introduced on purpose: the flat `key = { ... };` lines match what `06-menu.nix` ships, so no data migration is needed.

#### Step 11
Add the unchanged check comparing reconstructed full keys, entry texts against their originals, and popup editors against original sources.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn attrset_rows_unchanged"` (:1965), insert after it
```rust
fn menu_rows_unchanged(rows: &Rc<RefCell<Vec<MenuRow>>>) -> bool {
    rows.borrow().iter().all(|row| {
        let full = if row.key.text().is_empty() {
            row.section.clone()
        } else {
            format!("{}.{}", row.section, row.key.text())
        };
        full == row.orig_key
            && row.label.text() == row.orig_label
            && row.aliases.text() == row.orig_aliases
            && row
                .popup_fields
                .iter()
                .all(|f| f.editor.unchanged(&f.orig_value))
    })
}
```
The icon is not compared because it has no editor and cannot change after parse.

#### Step 12
Retarget the three `Editor::Menu` arms: the enum variant holds `Vec<MenuRow>`, `to_nix` and `unchanged` call the menu helpers, and `connect_changed` wires `connect_menu_row`.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "    Menu {"` (:404), then `ctrl+f "Editor::Menu { rows, .. } => attrset_rows_nix"` (:528), `ctrl+f "attrset_rows_unchanged(rows)"` (:622), `ctrl+f "Editor::Menu {"` (:761)
```rust
    Menu {
        root: gtk::Box,
        rows: Rc<RefCell<Vec<MenuRow>>>,
        on_change: ChangeHook,
    },
```
```rust
            Editor::Menu { rows, .. } => menu_rows_nix(&rows.borrow()),
```
```rust
            Editor::Menu { rows, .. } => menu_rows_unchanged(rows),
```
```rust
            Editor::Menu {
                rows, on_change, ..
            } => {
                *on_change.borrow_mut() = Some(update.clone());
                for row in rows.borrow().iter() {
                    connect_menu_row(row, update);
                }
            }
```
The `root` arm at :458 needs no change; it already returns `root.clone().upcast()`.

#### Step 13
Rewrite `build_menu` to create the shared popup window, scan rows, group them under per-section header boxes ordered by first appearance, and attach each row to its section container.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn build_menu"` (:2774), replace the whole function
```rust
fn build_menu(record: &Record, ctx: &BuildContext) -> Editor {
    let on_change: ChangeHook = Rc::new(RefCell::new(None));
    let root = gtk::Box::new(gtk::Orientation::Vertical, 12);
    root.set_hexpand(true);
    let rows = Rc::new(RefCell::new(Vec::new()));

    let popup = gtk::Window::builder()
        .hide_on_close(true)
        .default_width(440)
        .title("Entry details")
        .build();
    let popup_content = gtk::Box::new(gtk::Orientation::Vertical, 8);
    popup_content.set_margin_top(12);
    popup_content.set_margin_bottom(12);
    popup_content.set_margin_start(12);
    popup_content.set_margin_end(12);
    popup.set_child(Some(&popup_content));

    let mut sections: Vec<(String, gtk::Box)> = Vec::new();
    for scan_row in scan::scan_table(&record.value, false) {
        let (section, rel) = match scan_row.key.split_once('.') {
            Some((p, c)) => (p.to_string(), c.to_string()),
            None => (scan_row.key.clone(), String::new()),
        };
        let container = match sections.iter().find(|(name, _)| *name == section) {
            Some((_, c)) => c.clone(),
            None => {
                let header = gtk::Label::builder()
                    .xalign(0.0)
                    .label(&widget_display_name(&section))
                    .css_classes(["heading"])
                    .build();
                let vbox = gtk::Box::new(gtk::Orientation::Vertical, 6);
                vbox.set_hexpand(true);
                vbox.set_margin_start(12);
                root.append(&header);
                root.append(&vbox);
                sections.push((section.clone(), vbox.clone()));
                vbox
            }
        };
        let row = make_menu_row(&section, &rel, &scan_row.fields, ctx, &popup, &popup_content);
        attach_menu_row(&container, &rows, row, &on_change, &popup_content);
    }
```
The first-segment split gives the five top-level parents from `06-menu.nix` as section headers; deeper keys like `trigger.toggle.idle` keep their full relative suffix in the child key entry, so indentation is implicit in the section grouping.

#### Step 14
Finish `build_menu` with add-row scaffolding: a parent dropdown, a child-name entry, a label entry, and an Add button that builds an empty-field row under the chosen section with key `parent.child`.

**File:** `src/widgets.rs` · **Anchor:** `ctrl+f "fn build_menu"` (:2774), continue after step 13 before the closing brace
```rust
    let add_box = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    let names: Vec<String> = sections
        .iter()
        .map(|(name, _)| widget_display_name(name))
        .collect();
    let refs: Vec<&str> = names.iter().map(String::as_str).collect();
    let parent_menu = gtk::DropDown::from_strings(&refs);
    let child = gtk::Entry::new();
    child.set_placeholder_text(Some("child-id"));
    child.set_width_chars(14);
    let new_label = gtk::Entry::new();
    new_label.set_placeholder_text(Some("Label"));
    new_label.set_hexpand(true);
    let add = gtk::Button::with_label("Add");
    add_box.append(&parent_menu);
    add_box.append(&child);
    add_box.append(&new_label);
    add_box.append(&add);
    root.append(&add_box);
    {
        let child = child.clone();
        let new_label = new_label.clone();
        let parent_menu = parent_menu.clone();
        let sections = sections.clone();
        let rows = rows.clone();
        let on_change = on_change.clone();
        let popup = popup.clone();
        let popup_content = popup_content.clone();
        add.connect_clicked(move |_| {
            let idx = parent_menu.selected() as usize;
            let Some((section, container)) = sections.get(idx) else { return };
            let fields = vec![
                ("label".to_string(), string_literal(&new_label.text())),
                ("icon".to_string(), String::new()),
            ];
            let row = make_menu_row(section, &child.text(), &fields, &ctx, &popup, &popup_content);
            connect_menu_row(&row, &on_change.borrow().clone().unwrap_or_default());
            attach_menu_row(container, &rows, row, &on_change, &popup_content);
            if let Some(cb) = on_change.borrow().as_ref() {
                cb();
            }
        });
    }
    Editor::Menu {
        root,
        rows,
        on_change,
    }
}
```
`on_change.borrow().clone().unwrap_or_default()` wires the new row even though the hook is usually set by the time the user clicks Add; the `let Some(...) else` guards against an empty section list.

### Fix plan: G10

#### Step 1
Add a pure helper that reports whether a column's cell editor expands horizontally, mirroring `build_cell`'s widget choice (switch and spin are `halign Start`, text entries are `hexpand`). Insert it immediately before `build_cell`.

**File:** `src/widgets.rs` · **Anchor:** `fn build_cell` (:1633), insert before

```rust
fn column_expands(first_row: Option<&scan::TableRowScan>, column: &str) -> bool {
    let sample = first_row
        .and_then(|row| row.fields.iter().find(|(key, _)| key == column))
        .map(|(_, value)| value.as_str())
        .unwrap_or("null");
    !matches!(
        value::classify(sample),
        value::ValueKind::Bool | value::ValueKind::Int | value::ValueKind::Float
    )
}
```

`TableRowScan.fields` is `pub` (scan.rs:237) so tests can build one directly. `"null"` matches the add-row scaffold default (widgets.rs:1496) and classifies to `Null`, which `build_cell` renders as an expanding text entry.

#### Step 2
Add the header builder: a horizontal box with the same 6px spacing as `make_table_row`'s `row_box` (:1542), a leading spacer for the attrset key column, one caption label per visible column, and per-column expand taken from step 1. Insert it before `table_nix`.

**File:** `src/widgets.rs` · **Anchor:** `fn table_nix` (:1652), insert before

```rust
fn make_table_header(
    columns: &[String], list: bool, first_row: Option<&scan::TableRowScan>,
) -> gtk::Box {
    let header = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    header.set_hexpand(true);
    if !list {
        let spacer = gtk::Label::new(None);
        spacer.set_width_chars(12);
        header.append(&spacer);
    }
    for column in columns {
        let label = gtk::Label::builder()
            .label(column)
            .xalign(0.0)
            .hexpand(column_expands(first_row, column))
            .css_classes(["dim-label", "caption"])
            .build();
        header.append(&label);
    }
    header
}
```

The spacer uses `width_chars(12)` to match `key_entry.set_width_chars(12)` in `make_table_row` (:1546); `list` tables have no key column so they get no spacer.

#### Step 3
Replace the single joined `gtk::Label` header in `build_table` with the new box, hoisting `scan_table` above it so the header can sample the first row, and append a trailing spacer that reserves the remove-button width each row ends with.

**File:** `src/widgets.rs` · **Anchor:** `fn build_table` (:1435), replaces :1447-:1465

```rust
    let scan_rows = scan::scan_table(&record.value, list);

    if !key_editable {
        let mut names = columns.clone();
        if !first_value_editable && !names.is_empty() {
            names.remove(0);
        }
        if !names.is_empty() {
            let header = make_table_header(&names, list, scan_rows.first());
            let trailing = gtk::Box::new(gtk::Orientation::Horizontal, 0);
            trailing.set_size_request(34, -1);
            header.append(&trailing);
            root.append(&header);
        }
    }

    let rows: Rc<RefCell<Vec<TableRow>>> = Rc::new(RefCell::new(Vec::new()));
    let on_change: ChangeHook = Rc::new(RefCell::new(None));

    for scan_row in scan_rows {
```

`scan_rows` is consumed by the loop only after `scan_rows.first()` fed the header; the "hidden first column name" rule from :1449 is preserved unchanged so this step is purely presentational. The name set and key_editable gate stay exactly as today, so webapps (`columns = [ "enable" "name" "url" "icon" ]`, webapps.nix:58) renders spacer + name/url/icon captions over the matching entry columns, and craftapps (`columns = [ "enable" ]`, office.nix:56) keeps the empty-name behavior until G10b changes the row rules.

#### Step 4
Add a regression test that pins the expand classification against representative webapps cell values.

**File:** `src/widgets.rs` · **Anchor:** `mod tests` (:3256), append inside

```rust
    #[test]
    fn header_expand_follows_cell_editor_kind() {
        let row = scan::TableRowScan {
            key: "youtube".into(),
            fields: vec![
                ("enable".into(), "true".into()),
                ("name".into(), "\"YouTube\"".into()),
                ("icon".into(), "null".into()),
            ],
            spec: OptionSpec::default(),
        };
        assert!(!column_expands(Some(&row), "enable"));
        assert!(column_expands(Some(&row), "name"));
        assert!(column_expands(Some(&row), "icon"));
        assert!(column_expands(None, "url"));
    }
```

`TableRowScan` fields and `OptionSpec::default()` are both public and derived (scan.rs:232-240, dsl.rs:377), so no GTK initialization is needed for this test.


### Fix plan: G10b

Root cause, confirmed by tracing the whole path: the scanner is correct. `@table-item label = "PhotoCraft"` is parsed by `table_item_spec` (src/scan.rs:342) through `OptionSpec::from_directives`, which stores it in `spec.label` (src/dsl.rs:411), and the existing scan test asserts it lands on `TableRowScan.spec.label` (src/scan.rs:1290). The renderer never reads that label: `make_table_row` unconditionally appends an editable `gtk::Entry` for the attrset key (src/widgets.rs:1545-1550), so names stay editable, while the `is_first && !first_value_editable` branch (src/widgets.rs:1574) forces `columns[0]` static. For craftapps, `columns = [ "enable" ]` with both flags correctly defaulting to `false` (src/dsl.rs:426-427, the @option at office.nix:56 sets neither), that branch fires on the only value column, dropping its editor and leaving a static `false:` label. The "first cell is the row's name" assumption is wrong for `table-attrset`, whose row identity is already the parent key, so the flags are correct but the renderer misapplies them and ignores the `@table-item` lock. The fix is renderer-side: lock labeled attrset row identities to the `@table-item` label, and restrict the static-first-cell rule to `table-list` rows.

#### Step 1
Add two pure decision helpers so the lock and static-cell rules are testable and named. Insert them immediately before `build_table`.

**File:** `src/widgets.rs` · **Anchor:** `fn build_table` (:1435), insert before

```rust
fn table_row_identity_locked(list: bool, key_editable: bool, has_label: bool) -> bool {
    !list && !key_editable && has_label
}

fn table_first_cell_static(
    list: bool, is_first: bool, first_value_editable: bool,
) -> bool {
    list && is_first && !first_value_editable
}
```

An attrset row is locked only when its `@table-item` carried a `label`; new rows scaffolded by "Add row" use `OptionSpec::default()` (src/widgets.rs:1498) so they keep an editable key entry and users can still name them.

#### Step 2
Rework the row-identity block in `make_table_row`: when the helper from step 1 reports a lock, append a static label showing `spec.label` and leave `key_entry` unparented so `table_nix` (:1680-1683, reads `row.key_entry.text()`) and the remove handler's identity comparison (:1615) keep working unchanged.

**File:** `src/widgets.rs` · **Anchor:** `let key_entry = gtk::Entry::new();` (:1545), replaces :1545-:1555

```rust
    let key_entry = gtk::Entry::new();
    key_entry.set_width_chars(12);
    if !list {
        key_entry.set_text(&scan_row.key);
        if table_row_identity_locked(list, key_editable, scan_row.spec.label.is_some()) {
            let heading = gtk::Label::builder()
                .label(scan_row.spec.label.clone().unwrap_or_default())
                .xalign(0.0)
                .tooltip_text("Row key")
                .build();
            row_box.append(&heading);
        } else {
            key_entry.set_tooltip_text(Some("Row key"));
            row_box.append(&key_entry);
        }
        if let Some(update) = update {
            let update = update.clone();
            key_entry.connect_changed(move |_| update());
        }
    }
```

`key_entry` still holds the real nix key (`photocraft`) for serialization even when the visible heading shows the friendlier `@table-item` label (`PhotoCraft`); the widget instance stays alive off-tree so `TableRow` construction at :1624 is untouched.

#### Step 3
Swap the first-cell condition to the step 1 helper so the static "value:" branch applies only to `table-list` rows, where the first column carries the row identity; attrset rows always get a real editor for the first column.

**File:** `src/widgets.rs` · **Anchor:** `let show_editor = if key_editable {` (:1570), replaces :1570-:1584

```rust
        let show_editor = if key_editable {
            row_box.append(&cell_key);
            row_box.append(&gtk::Label::new(Some("=")));
            true
        } else if table_first_cell_static(list, is_first, first_value_editable) {
            let label = gtk::Label::builder()
                .label(entry_text(&field_value))
                .xalign(0.0)
                .build();
            row_box.append(&label);
            row_box.append(&gtk::Label::new(Some(":")));
            false
        } else {
            true
        };
```

With this, craftapps' `enable` cell becomes a `build_cell` switch (boolean classifies to `WidgetKind::Switch`, :1635) sitting after the static "PhotoCraft" heading, which is the intended orientation.

#### Step 4
Update the header's name set in `build_table` to match: hide the first column's name only for list tables, so attrset headers include the `enable` caption over the now-editable first column.

**File:** `src/widgets.rs` · **Anchor:** `let mut names = columns.clone();` (:1448), replaces :1448-:1451

```rust
        let mut names = columns.clone();
        if list && !first_value_editable && !names.is_empty() {
            names.remove(0);
        }
        if !names.is_empty() {
            let header = gtk::Label::builder()
                .xalign(0.0)
                .label(names.join("   "))
                .css_classes(["dim-label", "caption"])
                .build();
            root.append(&header);
        }
```

This keeps the old single-label header form (G10 replaces that form separately) but fixes which names appear; craftapps now shows an `enable` caption and webapps shows `enable name url icon`.

#### Step 5
Add a regression test pinning both helpers against the craftapps and webapps shapes.

**File:** `src/widgets.rs` · **Anchor:** `mod tests` (:3256), append inside

```rust
    #[test]
    fn craftapps_rows_lock_names_and_edit_first_cell() {
        assert!(table_row_identity_locked(false, false, true));
        assert!(!table_row_identity_locked(false, false, false));
        assert!(!table_row_identity_locked(false, true, true));
        assert!(!table_row_identity_locked(true, false, true));
        assert!(table_first_cell_static(true, true, false));
        assert!(!table_first_cell_static(false, true, false));
        assert!(!table_first_cell_static(true, false, false));
        assert!(!table_first_cell_static(true, true, true));
    }
```

The first three assertions cover craftapps (`list = false`, `key_editable = false`, label present) and the "Add row" scaffold (no label); the list cases cover the `rules` fixture shape from tests/fixtures/feature-widgets/configuration.nix:50.

### Fix plan: G14

Root cause, confirmed by tracing the full path: the annotation flows correctly end to end, `modules/02-core/01-display.nix:4` sets `icon = "preferences-system-displays-symbolic"`, `find_menu` (src/scan.rs:414) hands the comment to `MenuSpec::from_directives` (src/dsl.rs:332) which stores it in `spec.icon`, and `rebuild_menu_list` renders it at src/app.rs:724-725. Two things are wrong. First, the name itself does not exist: the complete adwaita-icon-theme 51.0 file list contains `preferences-desktop-display-symbolic`, `video-display-symbolic`, `video-joined-displays-symbolic` and similar, but no `preferences-system-displays-symbolic` in any context directory, so the prior review's "annotation confirmed valid" claim was false and the lookup misses on adwaita. Second, the app has no defense and no builtin per-page fallbacks: every sidebar icon goes through the single unconditional `gtk::Image::from_icon_name(icon)` call at src/app.rs:725 with no `IconTheme::has_icon` check, and GTK4 silently renders an empty image on a miss, which is why pages whose names do resolve (`web-browser-symbolic`, `x-office-document-symbolic`, `preferences-system-notifications-symbolic`, all present in adwaita) show icons while the display page shows nothing.

#### Step 1
Add a pure name-picker with an injectable `has_icon` predicate plus a thin GTK wrapper that queries the default display's `IconTheme` and falls back to `preferences-system-symbolic` (verified present in adwaita's `symbolic/categories`). Insert both before `rebuild_menu_list`.

**File:** `src/app.rs` · **Anchor:** `fn rebuild_menu_list` (:677), insert before

```rust
const FALLBACK_MENU_ICON: &str = "preferences-system-symbolic";

fn pick_icon_name(has_icon: impl Fn(&str) -> bool, icon: Option<&str>) -> Option<String> {
    let name = icon?;
    if has_icon(name) {
        return Some(name.to_string());
    }
    if has_icon(FALLBACK_MENU_ICON) {
        return Some(FALLBACK_MENU_ICON.to_string());
    }
    None
}

fn resolve_menu_icon(icon: Option<&str>) -> Option<String> {
    let display = gtk::gdk::Display::default()?;
    let theme = gtk::IconTheme::for_display(&display);
    pick_icon_name(|name| theme.has_icon(name), icon)
}
```

`pick_icon_name` is separated so tests need no display; `resolve_menu_icon` returns `None` only when neither the requested name nor the fallback resolves, so nothing empty is ever appended.

#### Step 2
Wire the resolver into the sidebar row so an unresolvable name renders the fallback instead of an empty image.

**File:** `src/app.rs` · **Anchor:** `if let Some(icon) = &menu.spec.icon {` (:724), replaces :724-:726

```rust
        let row = gtk::ListBoxRow::new();
        row.set_widget_name(&menu.file);
        let content = gtk::Box::new(gtk::Orientation::Horizontal, 8);
        if let Some(icon) = resolve_menu_icon(menu.spec.icon.as_deref()) {
            content.append(&gtk::Image::from_icon_name(icon.as_str()));
        }
        content.append(&label);
        row.set_child(Some(&content));
```

`menu.spec.icon.as_deref()` turns the owned `Option<String>` into the `Option<&str>` the resolver takes; the surrounding row construction is unchanged.

#### Step 3
Add a regression test proving a missing name falls back and a present name is kept.

**File:** `src/app.rs` · **Anchor:** `mod tests` (:2694), append inside

```rust
    #[test]
    fn missing_menu_icon_falls_back_to_generic() {
        let only_fallback = |name: &str| name == "preferences-system-symbolic";
        assert_eq!(
            pick_icon_name(only_fallback, Some("preferences-system-displays-symbolic")).as_deref(),
            Some("preferences-system-symbolic")
        );
        let all_present = |_: &str| true;
        assert_eq!(
            pick_icon_name(all_present, Some("web-browser-symbolic")).as_deref(),
            Some("web-browser-symbolic")
        );
        assert_eq!(pick_icon_name(only_fallback, None), None);
    }
```

The first case reproduces the display page's miss; the `None` case keeps menus with no `@menu` icon annotation icon-free as today.

#### Step 4
Correct the template annotation to a name that actually exists in adwaita, so the display page gets its own icon rather than riding the fallback forever.

**File:** `/home/den/repos/ojuny-template/modules/02-core/01-display.nix` · **Anchor:** line 4

```nix
/*
  @menu
  displayname = "Display";
  icon = "preferences-desktop-display-symbolic";
  order = 10;
  description = "Monitors, tearing and HDR";
  category = "02-Core";
*/
```

`preferences-desktop-display-symbolic` ships in adwaita's `symbolic/legacy` directory; `video-display-symbolic` is a second verified alternative if a plainer monitor glyph is preferred.

### Fix plan: G11

#### Step 1

Registry field kinds and field specs. The registry describes each plugin setting as a flat spec: a kind enum plus a struct pairing a dotted path with its heading, and a scoped import so registry lines can name kinds briefly.

**File:** `src/widgets.rs` · **Anchor:** line 7, the `use crate::dsl::{OptionSpec, WidgetKind}` import group

```rust
use self::PluginFieldKind::{Bool, Float, Int, Text};
```

the import lets later blocks write Bool instead of the full enum path; it is legal before the declaration because module items are order independent.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow, before the `/// The editing control` comment at line 341

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PluginFieldKind {
    Bool,
    Int,
    Float,
    Text,
}

/// One known setting of a known plugin: its dotted path under the plugin,
/// the heading shown above the control, and the control the setting uses.
#[derive(Debug, Clone, Copy)]
pub struct PluginFieldSpec {
    pub path: &'static str,
    pub label: &'static str,
    pub kind: PluginFieldKind,
}
```

the derives keep every spec copyable so lookup helpers can hand out &'static references.

#### Step 2

Registry entry struct and constructors. Each registry entry pairs an id with its display name and field list, and two const fn constructors keep both the struct literals and the call sites to one line.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack this block below the previous one)

```rust
/// One entry of the plugin registry: the id as written in configuration, its
/// display name, and the settings the app knows how to label.
#[derive(Debug, Clone, Copy)]
pub struct PluginSpec {
    pub id: &'static str,
    pub name: &'static str,
    pub fields: &'static [PluginFieldSpec],
}

const fn pspec(
    id: &'static str,
    name: &'static str,
    fields: &'static [PluginFieldSpec],
) -> PluginSpec {
    PluginSpec { id, name, fields }
}

const fn pfield(path: &'static str, label: &'static str, kind: PluginFieldKind) -> PluginFieldSpec {
    PluginFieldSpec { path, label, kind }
}
```

the PluginSpec literal body stays under the default struct literal width so rustfmt keeps it on one line, and pfield's signature lands just under the 100 character limit.

#### Step 3

Registry table A. The first table holds the plugins whose ids match the template: dankMenu, dankKDEConnect, and nixMonitor, with nixMonitor's five numeric and boolean settings.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
const PLUGIN_REGISTRY_A: &[PluginSpec] = &[
    pspec("dankMenu", "Dank Menu", &[]),
    pspec(
        "dankKDEConnect",
        "KDE Connect",
        &[pfield("settings.scanSubdirectories", "Scan subdirectories", Bool)],
    ),
    pspec(
        "nixMonitor",
        "Nix Monitor",
        &[
            pfield("settings.showGenerations", "Show generations", Bool),
            pfield("settings.showStoreSize", "Show store size", Bool),
            pfield("settings.updateInterval", "Update interval", Int),
            pfield("settings.updateCheckInterval", "Check interval", Int),
            pfield("settings.gcThresholdGB", "GC threshold", Int),
        ],
    ),
];
```

every pfield call keeps its arguments at or under 60 characters so rustfmt leaves the lines alone, and config.rebuildCommand is deliberately absent because a list value has no registry kind and falls through to the value's own shape.

#### Step 4

Registry table B. The second table covers localServices, scratchpadHelper, and developerUtilities, keeping each entry's arguments inside the same single line budget.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
const PLUGIN_REGISTRY_B: &[PluginSpec] = &[
    pspec(
        "localServices",
        "Local Services",
        &[
            pfield("settings.ignoredPorts", "Ignored ports", Text),
            pfield("settings.exactWatches", "Exact watches", Text),
            pfield("settings.labels", "Labels", Text),
        ],
    ),
    pspec(
        "scratchpadHelper",
        "Scratchpad Helper",
        &[
            pfield("settings.hideBarWhenEmpty", "Hide bar when empty", Bool),
            pfield("settings.namedManagerEnabled", "Named manager", Bool),
        ],
    ),
    pspec("developerUtilities", "Developer Utilities", &[]),
];
```

developerUtilities and dankMenu carry empty field lists because the template gives them only an enable binding.

#### Step 5

Registry table C. The last table covers screenCaptureToolbar and commandRunner; the block splits in two so each piece stays under twenty lines.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
const PLUGIN_REGISTRY_C: &[PluginSpec] = &[
    pspec(
        "screenCaptureToolbar",
        "Screen Capture Toolbar",
        &[
            pfield("settings.enableAudioRecorder", "Audio recorder", Bool),
            pfield("settings.multiMonitorScreenshot", "Multi monitor", Bool),
            pfield("settings.showNotify", "Show notify", Bool),
            pfield("settings.showRecPill", "Show record pill", Bool),
            pfield("settings.toolbarOpacity", "Toolbar opacity", Float),
            pfield("settings.pillOpacity", "Pill opacity", Float),
        ],
    ),
```

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (continuation of the same const)

```rust
    pspec(
        "commandRunner",
        "Command Runner",
        &[
            pfield("settings.terminal", "Terminal", Text),
            pfield("settings.trigger", "Trigger", Text),
            pfield("settings.execFlag", "Exec flag", Text),
        ],
    ),
    pspec("webSearch", "Web Search", &[]),
];
```

the two opacity settings take Float so build_spin gets digits from the decimal point in the value.

#### Step 6

Help table A. Tooltips live in a second table keyed by path alone, stored through a one field tuple struct so each entry is a plain constructor call with predictable wrapping.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
/// Help text for a setting path, stored as path and tooltip.
struct Help(&'static str, &'static str);

const HELP_A: &[Help] = &[
    Help("settings.scanSubdirectories", "Index nested plugin dirs"),
    Help("settings.showGenerations", "List system generations"),
    Help("settings.showStoreSize", "Show the nix store size"),
    Help("settings.updateInterval", "Seconds between refreshes"),
    Help("settings.updateCheckInterval", "Seconds between checks"),
    Help("settings.gcThresholdGB", "Store size that suggests gc"),
    Help("settings.ignoredPorts", "Comma separated ports to skip"),
    Help("settings.exactWatches", "Paths watched exactly"),
    Help("settings.labels", "Labels as an attrset"),
    Help("settings.hideBarWhenEmpty", "Collapse the bar when idle"),
];
```

the table is split in two for the same line budget reason as the registry, and each Help call stays under the 60 character argument width.

#### Step 7

Help table B and the help lookup. The second help table finishes the remaining settings, a two element table array joins them, and field_help answers a path lookup.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
const HELP_B: &[Help] = &[
    Help("settings.namedManagerEnabled", "Allow named scratchpads"),
    Help("settings.enableAudioRecorder", "Include microphone audio"),
    Help("settings.multiMonitorScreenshot", "Capture every monitor"),
    Help("settings.showNotify", "Notify after capture"),
    Help("settings.showRecPill", "Show the record pill"),
    Help("settings.toolbarOpacity", "Opacity of the toolbar"),
    Help("settings.pillOpacity", "Opacity of the pill"),
    Help("settings.terminal", "Terminal for commands"),
    Help("settings.trigger", "Key that opens the runner"),
    Help("settings.execFlag", "Flag for exec mode"),
];

const HELP_TABLES: [&[Help]; 2] = [HELP_A, HELP_B];

/// The help text recorded for a setting path, if any.
fn field_help(path: &str) -> Option<&'static str> {
    HELP_TABLES
        .iter()
        .find_map(|table| table.iter().find(|help| help.0 == path))
        .map(|help| help.1)
}
```

iterating a const array of slices yields only data extracted from the tables, so the returned &str stays valid regardless of the temporary the const inlining creates.

#### Step 8

Registry lookup helpers. A table array joins the three registry tables, and two lookup helpers resolve an id first, then a dotted path under that id.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
/// Every registry table, so lookup and iteration share one source of truth.
const PLUGIN_TABLES: [&[PluginSpec]; 3] = [
    PLUGIN_REGISTRY_A,
    PLUGIN_REGISTRY_B,
    PLUGIN_REGISTRY_C,
];

/// The registry entry for a plugin id, if it is known.
fn plugin_spec(id: &str) -> Option<&'static PluginSpec> {
    PLUGIN_TABLES
        .iter()
        .find_map(|table| table.iter().find(|spec| spec.id == id))
}

/// The registry entry for one dotted setting path under a plugin.
fn plugin_field(id: &str, path: &str) -> Option<&'static PluginFieldSpec> {
    plugin_spec(id)
        .and_then(|spec| spec.fields.iter().find(|field| field.path == path))
}
```

the split of the lookup into id then path means an unknown plugin id simply returns None and its fields render by their own shape.

#### Step 9

Identifier humanizer. Unknown ids and unlabeled leaves need a readable heading, so this splits camel case boundaries, turns underscores into spaces, and capitalizes the first letter.

**File:** `src/widgets.rs` · **Anchor:** line 339, the `}` closing PluginRow (stack below the previous block)

```rust
/// A heading from an identifier: split camel-case boundaries, turn snake case
/// into spaces, and capitalize the first letter.
fn humanize(raw: &str) -> String {
    let mut out = String::new();
    for (index, ch) in raw.chars().enumerate() {
        if ch == '_' {
            out.push(' ');
        } else if ch.is_ascii_uppercase() && index > 0 && out.ends_with(char::is_lowercase) {
            out.push(' ');
            out.push(ch);
        } else if index == 0 {
            out.extend(ch.to_uppercase());
        } else {
            out.push(ch);
        }
    }
    out
}
```

checking out.ends_with(char::is_lowercase) rather than the previous character keeps acronym runs like KDEConnect intact while still splitting at showGenerations.

#### Step 10

PluginRow struct rework. The row gains the two original value fields needed for dirty checking, plus the container handle and remove button so a shared attach helper can wire deletion, and an alias shortens the helper signatures.

**File:** `src/widgets.rs` · **Anchor:** lines 331 to 339, the `/// One plugin entry` comment and PluginRow struct

```rust
/// One plugin entry of the `plugins` widget: the plugin id, its enable
/// switch, and the entry's remaining settings as nested child rows.
pub(crate) struct PluginRow {
    key: gtk::Entry,
    orig_key: String,
    enable: Editor,
    enable_orig: String,
    enable_present: bool,
    children: Vec<(Record, Editor)>,
    row_box: gtk::Box,
    remove: gtk::Button,
}

/// The rows of a `plugins` editor, shared by construction and wiring.
type PluginRows = Rc<RefCell<Vec<PluginRow>>>;
```

key and orig_key keep the exact names the existing attrset and keybind rows use, enable_orig holds the starting switch value or the registry default when the binding is absent, and enable_present records whether the config actually had an enable line.

#### Step 11

Unchanged check for plugin rows. The Plugins arm of unchanged must now also compare the id and the enable control, because a rename or a toggle alone has to mark the page dirty.

**File:** `src/widgets.rs` · **Anchor:** line 623, `Editor::Plugins { rows, .. } => rows.borrow().iter().all(|row| {`

```rust
            Editor::Plugins { rows, .. } => rows.borrow().iter().all(|row| {
                row.key.text() == row.orig_key
                    && row.enable.unchanged(&row.enable_orig)
                    && row
                        .children
                        .iter()
                        .all(|(record, editor)| editor.unchanged(&record.value))
            }),
```

enable_orig is always a raw literal such as "true", so Editor::unchanged can feed it straight to truthy when it compares the switch.

#### Step 12

Enable control builder. One helper derives the switch, its original value, and the present flag from the plugin's leaves, defaulting missing bindings from the registry.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// The enable control of one plugin: the switch, the value it started from
/// (a registry default when the binding is absent), and whether the binding
/// exists in configuration.
fn plugin_enable(id: &str, leaves: &[Record]) -> (Editor, String, bool) {
    let record = leaves.iter().find(|field| field.segments.as_slice() == ["enable"]);
    let present = record.is_some();
    let fallback = if plugin_spec(id).is_some() { "true" } else { "false" };
    let original = record
        .map(|field| field.value.clone())
        .unwrap_or_else(|| fallback.to_string());
    let value = record.map(|field| field.value.as_str()).unwrap_or(fallback);
    (Editor::Switch(build_switch(value)), original, present)
}
```

record is an Option<&Record> which is Copy, so it can be tested and then read twice without cloning the leaf.

#### Step 13

Child editor by registry kind. A known field's registry kind picks the control directly, and an unknown path falls back to build_bespoke_child, which classifies the value itself.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// A plugin setting's control: the registry decides between a switch, a
/// number field, and a text field; anything unknown falls back to the value's
/// own shape.
fn build_plugin_child(id: &str, record: &Record, ctx: &BuildContext) -> Editor {
    let path = record.segments.join(".");
    match plugin_field(id, &path).map(|field| field.kind) {
        Some(PluginFieldKind::Bool) => Editor::Switch(build_switch(&record.value)),
        Some(PluginFieldKind::Int | PluginFieldKind::Float) => {
            let spec = OptionSpec {
                min: Some(0.0),
                ..OptionSpec::default()
            };
            Editor::Spin(build_spin(&spec, &record.value))
        }
        Some(PluginFieldKind::Text) => {
            Editor::Text(build_entry(&record.value, &OptionSpec::default(), false))
        }
        None => build_bespoke_child(record, ctx),
    }
}
```

the min: Some(0.0) spin spec mirrors the pattern build_field_cell already uses with ..OptionSpec::default(), and it keeps list values such as config.rebuildCommand on the fallback path where they become list editors.

#### Step 14

Setting row renderer. Each displayed setting gets a heading resolved through registry label, then the record's own annotation, then the humanized leaf name, with help text attached as a tooltip.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// One setting of a plugin row: a heading from the registry, the field's own
/// label, or the leaf name, with help text as its tooltip.
fn build_plugin_setting_row(id: &str, record: &Record, editor: &Editor) -> gtk::Widget {
    let path = record.segments.join(".");
    let leaf = record.segments.last().cloned().unwrap_or_else(|| path.clone());
    let label = plugin_field(id, &path)
        .map(|field| field.label.to_string())
        .or_else(|| record.spec.label.clone())
        .unwrap_or_else(|| humanize(&leaf));
    let cell = gtk::Box::new(gtk::Orientation::Vertical, 2);
    let heading = gtk::Label::builder()
        .xalign(0.0)
        .label(label)
        .css_classes(["dim-label", "caption"])
        .build();
    if let Some(help) = record.spec.description.as_deref().or(field_help(&path)) {
        heading.set_tooltip_text(Some(help));
    }
    cell.append(&heading);
    cell.append(&editor.root());
    cell.upcast()
}
```

the annotation is tested before the registry help only because Option::or needs the shorter 'static coercion direction to type check, and cell.upcast() infers gtk::Widget from the return position.

#### Step 15

Settings expander for one plugin. The per plugin settings sit behind an expander like the keybind rows do, with hidden fields skipped while Advanced is off.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// The settings of one plugin behind an expander, hidden fields dropped while
/// Advanced is off.
fn plugin_settings_box(id: &str, children: &[(Record, Editor)], ctx: &BuildContext) -> gtk::Widget {
    let detail = gtk::Box::new(gtk::Orientation::Vertical, 4);
    detail.set_margin_start(18);
    for (record, editor) in children {
        if record.spec.hidden && !ctx.advanced {
            continue;
        }
        detail.append(&build_plugin_setting_row(id, record, editor));
    }
    let expander = gtk::Expander::new(Some("Settings"));
    expander.set_child(Some(&detail));
    expander.upcast()
}
```

the 18 pixel start margin matches the old plugin body indentation, and gtk::Expander::new(Some(...)) follows the call shape at the keybind row.

#### Step 16

Main line of a plugin row. This builds the horizontal line holding the id entry, the enable switch, the optional settings expander, and the trash button, returning the three handles the row keeps.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// The main line of a plugin row: id entry, enable switch, settings expander
/// when the plugin has fields, and a remove button.
fn plugin_main_line(
    id: &str,
    enable: &Editor,
    settings: Option<gtk::Widget>,
) -> (gtk::Box, gtk::Entry, gtk::Button) {
    let main = gtk::Box::new(gtk::Orientation::Horizontal, 6);
    main.set_hexpand(true);
    let id_entry = gtk::Entry::new();
    id_entry.set_width_chars(16);
    id_entry.set_text(id);
    id_entry.set_tooltip_text(Some("Plugin name"));
    main.append(&id_entry);
    main.append(&enable.root());
    if let Some(settings) = settings {
        main.append(&settings);
    }
    let remove = gtk::Button::from_icon_name("user-trash-symbolic");
    remove.add_css_class("flat");
    remove.set_tooltip_text(Some("Remove plugin"));
    main.append(&remove);
    (main, id_entry, remove)
}
```

hexpand moves onto this horizontal box so the row still fills the container, which replaces the vertical wrapper the old code needed before fields lived inside the expander.

#### Step 17

Assemble one PluginRow. The row builder wires the enable control and children from the leaves, skips expanderless plugins, and moves the assembled pieces into the struct.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Assemble one plugin row from its leaves: enable control, child editors,
/// optional settings expander, and the structural handles.
fn make_plugin_row(id: &str, leaves: &[Record], ctx: &BuildContext) -> PluginRow {
    let (enable, enable_orig, enable_present) = plugin_enable(id, leaves);
    let children: Vec<(Record, Editor)> = leaves
        .iter()
        .filter(|field| field.segments.as_slice() != ["enable"])
        .map(|field| (field.clone(), build_plugin_child(id, field, ctx)))
        .collect();
    let settings = (!children.is_empty()).then(|| plugin_settings_box(id, &children, ctx));
    let (row_box, key_entry, remove) = plugin_main_line(id, &enable, settings);
    PluginRow {
        key: key_entry,
        orig_key: id.to_string(),
        enable,
        enable_orig,
        enable_present,
        children,
        row_box,
        remove,
    }
}
```

then rather than map keeps the expander entirely absent for plugins that only have an enable binding, and each child record is cloned after rebasing so the struct owns its data.

#### Step 18

Remove wiring helper. The remove handler is split out of the attach helper so the attach function stays within the line budget while keeping the hook read at click time.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Wire a row's remove button to drop it from the container and the row list.
/// The change hook is read at click time so rows added before the app
/// connects still notify.
fn wire_plugin_remove(
    row: &PluginRow,
    container: &gtk::Box,
    rows: &PluginRows,
    on_change: &ChangeHook,
) {
    let container = container.clone();
    let rows = rows.clone();
    let row_box = row.row_box.clone();
    let key = row.key.clone();
    let on_change = on_change.clone();
    row.remove.connect_clicked(move |_| {
        container.remove(&row_box);
        rows.borrow_mut().retain(|r| r.key != key);
        if let Some(cb) = on_change.borrow().as_ref() {
            cb();
        }
    });
}
```

retaining by widget equality mirrors the attrset row handler, and the single letter closure parameter matches the pattern the existing retain closures use.

#### Step 19

Attach helper with a visibility flag. Attach registers the row and wires removal, while the show flag lets a hidden but still serialized row stay out of the container.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Register a row with the row list and wire its remove button. `show` keeps
/// a hidden row in the data while leaving it out of the container.
fn attach_plugin_row(
    container: &gtk::Box,
    rows: &PluginRows,
    row: PluginRow,
    on_change: &ChangeHook,
    show: bool,
) {
    wire_plugin_remove(&row, container, rows, on_change);
    if show {
        container.append(&row.row_box);
    }
    rows.borrow_mut().push(row);
}
```

pushing into rows unconditionally preserves the old behavior where an invisible plugin still serialized on save.

#### Step 20

Hook backed notifier. A small adapter over the change hook lets rows built after connect_changed have already run notify the same handler.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Wrap the change hook so a row added after wiring still notifies the app's
/// handler, which the hook only holds once editing has begun.
fn hook_notify(on_change: &ChangeHook) -> Rc<dyn Fn()> {
    let hook = on_change.clone();
    Rc::new(move || {
        if let Some(cb) = hook.borrow().as_ref() {
            cb();
        }
    })
}
```

the borrow happens at event time, so the adapter works whether the hook was set before or after the row was created.

#### Step 21

Scaffold a row from the picker. Clicking a picker entry builds an empty row for that id, marks it new with the null original key trick, connects its editors through the hook adapter, and registers it.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Add a fresh plugin row for `id`: an unset original key marks it for
/// writing, and the hook notifies the change handler.
fn scaffold_plugin_row(
    id: &str,
    container: &gtk::Box,
    rows: &PluginRows,
    on_change: &ChangeHook,
    ctx: &BuildContext,
) {
    let row = make_plugin_row(id, &[], ctx);
    row.orig_key = "\0".to_string();
    connect_plugin_row(&row, &hook_notify(on_change));
    attach_plugin_row(container, rows, row, on_change, true);
    if let Some(cb) = on_change.borrow().as_ref() {
        cb();
    }
}
```

the "\0" original key copies the trick build_attrset_rows uses for freshly added rows so the empty row counts as changed until a reload.

#### Step 22

Picker button builder. Each button shows the registry name with the id as tooltip and runs the scaffold on click before closing the popover.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// One button of the add-plugin popover: the registry name with the id as
/// tooltip, scaffolding the row when clicked.
fn plugin_picker_button(
    spec: &'static PluginSpec,
    container: &gtk::Box,
    rows: &PluginRows,
    on_change: &ChangeHook,
    ctx: &BuildContext,
    popover: &gtk::Popover,
) -> gtk::Button {
    let button = gtk::Button::with_label(spec.name);
    button.add_css_class("flat");
    button.set_tooltip_text(Some(spec.id));
    let (container, rows) = (container.clone(), rows.clone());
    let (on_change, ctx) = (on_change.clone(), ctx.clone());
    let (popover, id) = (popover.clone(), spec.id.to_string());
    button.connect_clicked(move |_| {
        scaffold_plugin_row(&id, &container, &rows, &on_change, &ctx);
        popover.popdown();
    });
    button
}
```

the clones are grouped into tuples so the setup block stays inside the line budget, and popdown matches how the package search rows dismiss their popover.

#### Step 23

Refill the picker on open. The popover repopulates every time it maps, listing only registry ids the page does not already have.

**File:** `src/widgets.rs` · **Anchor:** line 2959, `fn build_bar(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Refill the picker's list with registry plugins the page does not already
/// have, so a plugin can only be added once.
fn populate_plugin_picker(
    list: &gtk::ListBox,
    rows: &PluginRows,
    on_change: &ChangeHook,
    ctx: &BuildContext,
    container: &gtk::Box,
    popover: &gtk::Popover,
) {
    clear_rows(list);
    let taken: Vec<String> = rows.borrow().iter().map(|row| row.key.text().to_string()).collect();
    let available: Vec<&PluginSpec> = PLUGIN_TABLES
        .iter()
        .flat_map(|table| table.iter())
        .filter(|spec| !taken.iter().any(|id| id == spec.id))
        .collect();
    for spec in available {
        list.append(&plugin_picker_button(spec, container, rows, on_change, ctx, popover));
    }
}
```

collecting before iterating keeps the temporary table array scoped inside the function, and clear_rows is the existing helper the package search popover already uses.

#### Step 24

Dotted path serializer. Rebased child records serialize as dotted attribute paths by quoting each segment individually.

**File:** `src/widgets.rs` · **Anchor:** line 2924, `fn plugins_nix(rows: &[PluginRow]) -> String {` (insert before it)

```rust
/// Serialize a setting's rebased path as a dotted attribute path, quoting
/// each segment that is not a plain identifier.
fn plugin_path_nix(record: &Record) -> String {
    record
        .segments
        .iter()
        .map(|segment| attr_key(segment))
        .collect::<Vec<String>>()
        .join(".")
}
```

applying attr_key per segment and only then joining keeps settings.showGenerations bare while still quoting a segment that needs it.

#### Step 25

Plugins serializer rework. plugins_nix now reads the id entry, writes enable from the present flag or the switch, and emits each child through the dotted path helper.

**File:** `src/widgets.rs` · **Anchor:** lines 2924 to 2948, the whole `fn plugins_nix` function

```rust
fn plugins_nix(rows: &[PluginRow]) -> String {
    let parts: Vec<String> = rows
        .iter()
        .map(|row| {
            let mut fields = Vec::new();
            let enabled = match &row.enable {
                Editor::Switch(w) => w.is_active(),
                _ => true,
            };
            if row.enable_present || enabled {
                fields.push(format!("enable = {};", row.enable.to_nix()));
            }
            for (record, editor) in &row.children {
                fields.push(format!("{} = {};", plugin_path_nix(record), editor.to_nix()));
            }
            format!("{} = {{ {} }};", attr_key(&row.key.text()), fields.join(" "))
        })
        .collect();
    format!("{{ {} }}", parts.join(" "))
}
```

the enable_present || enabled test keeps an absent binding absent for a disabled unknown plugin, while a known plugin that defaults on materializes enable = true the first time any change saves.

#### Step 26

Group leaves by plugin id. Since the scanner flattens nested attrsets, this helper regroups the leaves under their first segment, rebases each leaf's path relative to its plugin, and remembers row visibility.

**File:** `src/widgets.rs` · **Anchor:** line 2785, `fn build_plugins(record: &Record, ctx: &BuildContext) -> Editor {` (insert before it)

```rust
/// Group the plugin value's flattened leaves by plugin id, rebasing each
/// leaf's path under its plugin. The bool reports whether the row is shown.
fn plugin_groups(record: &Record, ctx: &BuildContext) -> Vec<(String, Vec<Record>, bool)> {
    let mut groups: Vec<(String, Vec<Record>, bool)> = Vec::new();
    for child in scan_children(record, true) {
        let Some(id) = child.segments.first().cloned() else { continue };
        let visible = ctx.advanced || !child.spec.hidden;
        let leaves = if child.segments.len() > 1 {
            let mut leaf = child;
            leaf.segments.remove(0);
            vec![leaf]
        } else if value::classify(&child.value) == value::ValueKind::AttrSet {
            scan_children(&child, true)
        } else {
            Vec::new()
        };
        match groups.iter_mut().find(|(gid, _, _)| *gid == id) {
            Some((_, existing, shown)) => { existing.extend(leaves); *shown &= visible; }
            None => groups.push((id, leaves, visible)),
        }
    }
    groups
}
```

a child whose value is an attrset is an annotated plugin binding that the scanner did not flatten, so it is scanned one level down for leaves that are already plugin relative, and single segment scalar bindings degrade to an id only group.

#### Step 27

Rewrite build_plugins. The scan loop becomes a group loop feeding the attach helper, and the plain add button becomes a menu button whose popover refills itself on open.

**File:** `src/widgets.rs` · **Anchor:** line 2793, `for child in scan_children(record, true) {`, through line 2913, the closing `});` of the old add handler (replace the whole region, leaving the init lines above and the root.append lines below untouched)

```rust
    for (id, leaves, shown) in &plugin_groups(record, ctx) {
        let row = make_plugin_row(id, leaves, ctx);
        attach_plugin_row(&container, &rows, row, &on_change, *shown);
    }

    let list = gtk::ListBox::new();
    list.set_selection_mode(gtk::SelectionMode::None);
    let popover = gtk::Popover::builder().child(&list).build();
    let add = gtk::MenuButton::builder()
        .label("Add plugin")
        .halign(gtk::Align::Start)
        .popover(&popover)
        .build();
    let (container, rows) = (container.clone(), rows.clone());
    let (on_change, ctx) = (on_change.clone(), ctx.clone());
    let (list, popover) = (list.clone(), popover.clone());
    popover.connect_map(move |_| {
        populate_plugin_picker(&list, &rows, &on_change, &ctx, &container, &popover);
    });
```

the tuple lines shadow the originals with clones so the closures can move them while the untouched root.append and Editor::Plugins lines below still find valid bindings, and connect_map refills the list on every open instead of only at page build.

### Fix plan: G12

#### Step 1

Width directive on OptionSpec. The optional character cap starts as a new width_chars field parsed from a width directive, clamped so a large literal cannot turn negative on the way to GTK's i32 API.

**File:** `src/dsl.rs` · **Anchor:** line 389, `pub placeholder: Option<String>,`

```rust
    pub placeholder: Option<String>,
    pub width_chars: Option<u32>,
```

the field sits next to placeholder in both the struct and the parser so the two lists keep the same order.

**File:** `src/dsl.rs` · **Anchor:** line 420, `placeholder: d.string("placeholder"),`

```rust
            placeholder: d.string("placeholder"),
            width_chars: d.int("width").map(|n| n.clamp(1, i32::MAX as i64) as u32),
```

clamp replaces the bare max the neighboring numeric directives use because this value is cast down to i32 later.

#### Step 2

build_entry honors the cap. The unconditional 44 character request goes away, and the cap only applies when the directive asked for one, in which case the entry stops expanding.

**File:** `src/widgets.rs` · **Anchor:** line 1036, `fn build_entry`

```rust
fn build_entry(value_text: &str, spec: &OptionSpec, monospace: bool) -> gtk::Entry {
    let unquoted = entry_text(value_text);
    let entry = gtk::Entry::new();
    entry.set_text(&unquoted);
    entry.set_hexpand(true);
    if let Some(width) = spec.width_chars {
        entry.set_width_chars(width as i32);
        entry.set_hexpand(false);
        entry.set_halign(gtk::Align::Start);
    }
    if monospace {
        entry.add_css_class("monospace");
    }
    if let Some(placeholder) = &spec.placeholder {
        entry.set_placeholder_text(Some(placeholder));
    }
    entry
}
```

without the directive the entry keeps hexpand(true) and no width request, so it fills the stacked row the non-inline layout already gives it, while a width = annotation pins it to a fixed size aligned left.

#### Step 3

Name the stacked text controls. The non inline arms of control_is_inline become explicit for the text style widgets so the seam the width change relies on is documented in the match itself.

**File:** `src/app.rs` · **Anchor:** line 1002, `fn control_is_inline`

```rust
fn control_is_inline(editor: &Editor) -> bool {
    match editor {
        Editor::Switch(_) | Editor::Spin(_) => true,
        Editor::Dropdown { choices, .. } => {
            choices.iter().map(|c| c.chars().count()).max().unwrap_or(0) < 24
        }
        Editor::Text(_)
        | Editor::Path(_)
        | Editor::Multiline { .. }
        | Editor::Package { .. } => false,
        _ => false,
    }
}
```

these arms change no behavior, they record that text, path, multiline, and package controls always stack below their label and therefore rely on the entry itself filling the slot.

---

### integration notes (cross-plan conflicts)

three collisions between independently designed plans, resolved at implementation time:

1. `widget_display_name` defined twice: G7 step 2 and G8 step 2 both add `fn widget_display_name` to `src/widgets.rs`. keep G7's, drop G8 step 2, and move G8's extra special cases (left/center/right, wifi, vpn, builtin_vpn, uv) into G7's `WIDGET_NAMES` table. G9 and G8 steps 7/10 consume the same helper.
2. `field_help` defined twice: G7 step 4 and G11 step 7 both add `fn field_help` to `src/widgets.rs`. rename G11's to `plugin_field_help` and update its one call site (G11 step 14).
3. header block edited twice: G10 step 3 replaces the header block in `build_table` (:1447-:1465) that G10b step 4 also edits. fold G10b's guard into G10 step 3's name-removal branch (`if list && !first_value_editable && !names.is_empty()`) and drop G10b step 4; without it craftapps' `enable` caption would be hidden again.
