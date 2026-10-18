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
