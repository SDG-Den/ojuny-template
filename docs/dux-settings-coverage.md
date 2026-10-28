# Dux Shell 2.0 settings coverage matrix

> Source: `github:duxlabs-dev/dux-shell` at commit `18af7856` (v2.0.0-115). Generated 2026-10-28. The machine-readable ledger is `dux-settings-coverage.csv` in this directory.

Generated from the `dux-shell` tree at commit `18af7856` and the current `ojuny-desktop` / `ojuny-template` working trees. **1418** leaf rows, **530** already present under `desktop.ojuny.dux` (`covered=yes`, **37.4%**). At migration time the covered count was **496**; the 2026-10-28 settings batch raised it by **34** to **530**.

Companion file: `dux-settings-coverage.csv` (same rows, no `covered` column, which is kept here).

## Method

- `Common/settings/SettingsSpec.js` parsed with a JS object-literal parser (`scripts/jsparse.py`), not by eye: 415 `LOCAL_SPEC` keys, defaults and `onChange` hooks.
- `Common/SettingsData.qml` property declarations (`property <type> <key>: Spec.SPEC.<key>.def`) supplied the full 466-key union plus QML types, including the 51 keys that only exist in the shared spec.
- `Common/settings/SessionSpec.js` parsed the same way (94 local session keys) and merged with the 13 shared session keys (107 total); defaults cross-checked against the inline defaults in `Common/SessionData.qml`.
- `Common/SettingsTabs.qml` structure parsed for the page/subpage tree; `Modals/Settings/SettingsContent.qml` `pageFiles` maps leaf pages to QML files.
- Page assignment for each key: the settings page that reads or writes it (`SettingsData.<key>`, `SettingsData.set("<key>", ...)`, `page.value("<key>")`), falling back to the `translations/settings_search_index.json` `page` field. Keys whose UI lives outside the settings window are marked in `notes`.
- Widget option rows come from `Common/settings/BarWidgetDefaults.js` `DEFAULTS` (authoritative per widget type) and the controls in `Modules/Settings/BarWidgetOptions/*.qml`.
- Collections (`barConfigs`, `dockConfigs`, `controlCenterWidgets`, `dashCards`, `dashTabs`, `dashOptions`, `cursorSettings`, built-in plugin settings) are expanded to one row per leaf field.
- `apply_command` is only filled for scalar settings; collections get an empty value because the IPC handler explicitly rejects objects and arrays (`DMSShellIPC.qml` "Setting Objects and Arrays not supported").

### Sources

| Source | Status | Contents |
| --- | --- | --- |
| `quickshell/DCommon/Common/settings/SharedSettingsSpec.js` | **parsed** | 51 shared settings keys with `def`, `coerce` and `onChange`; the two widget-instance defaults are functions (`lockWidgetDefaults()`, `greeterWidgetDefaults()`). |
| `quickshell/DCommon/Common/settings/SharedSessionSpec.js` | **parsed** | 13 shared session keys with defaults and two `MaterialWallpaper` coerce hooks. |
| `quickshell/DCommon/Common/settings/SpecUtil.js` | **parsed** | helpers only: `percentToUnit`, `mergeSpec`, `stableStringify`, `isDefault`, `cloneDef`, `stripDefaults`; no keys. |

Every source parsed. No spec, tab registry, widget default, QML or search-index file failed to parse.

## Totals

### By scope

| Scope | Rows | Covered | Covered % |
| --- | ---: | ---: | ---: |
| `settings` | 1062 | 466 | 43.9% |
| `session` | 102 | 18 | 17.6% |
| `config_file` | 11 | 8 | 72.7% |
| `runtime_only` | 13 | 0 | 0.0% |
| `widget_option` | 212 | 34 | 16.0% |
| `plugin` | 18 | 4 | 22.2% |
| **total** | **1418** | **530** | **37.4%** |

### By tier

| Tier | Rows | Covered |
| --- | ---: | ---: |
| `normal` | 420 | 203 |
| `advanced` | 932 | 313 |
| `hidden` | 36 | 14 |
| `unexposed` | 30 | 0 |

### By page

| Page | Subpage | Rows | Covered | normal | advanced | hidden | unexposed |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `(no settings page)` |  | 356 | 112 | 43 | 295 | 0 | 18 |
| `dankbar_widgets` | `bar_widget` | 214 | 35 | 85 | 129 | 0 | 0 |
| `dank_dash` |  | 164 | 80 | 0 | 164 | 0 | 0 |
| `dankbar` | `dankbar_appearance` | 66 | 36 | 12 | 54 | 0 | 0 |
| `dankbar` | `dankbar_dot` | 58 | 6 | 0 | 58 | 0 | 0 |
| `launcher` |  | 48 | 22 | 43 | 5 | 0 | 0 |
| `system` | `compositor_layout` | 48 | 1 | 0 | 48 | 0 | 0 |
| `personalization` | `theme_apps` | 36 | 0 | 30 | 6 | 0 | 0 |
| `dankbar` | `dankbar_settings` | 34 | 8 | 1 | 33 | 0 | 0 |
| `personalization` |  | 33 | 5 | 11 | 11 | 0 | 11 |
| `theme_surfaces` |  | 30 | 19 | 14 | 16 | 0 | 0 |
| `power_battery` | `power_sleep` | 28 | 21 | 19 | 0 | 9 | 0 |
| `security_accounts` | `lock_screen` | 27 | 18 | 14 | 1 | 12 | 0 |
| `notifications` |  | 24 | 24 | 18 | 6 | 0 | 0 |
| `dock` | `dock_appearance` | 21 | 21 | 0 | 21 | 0 | 0 |
| `input` | `mouse_touchpad` | 20 | 0 | 1 | 19 | 0 | 0 |
| `dock` | `dock_general` | 15 | 14 | 0 | 15 | 0 | 0 |
| `osd` |  | 15 | 14 | 15 | 0 | 0 | 0 |
| `typography` |  | 15 | 13 | 15 | 0 | 0 | 0 |
| `power_battery` | `battery` | 14 | 13 | 11 | 2 | 1 | 0 |
| `dock` | `dock_advanced` | 13 | 13 | 0 | 13 | 0 | 0 |
| `system` | `clipboard` | 13 | 13 | 13 | 0 | 0 | 0 |
| `system` | `updater` | 13 | 0 | 0 | 7 | 6 | 0 |
| `personalization` | `theme_schedule` | 12 | 10 | 12 | 0 | 0 | 0 |
| `personalization` | `wallpaper_cycling` | 10 | 7 | 8 | 2 | 0 | 0 |
| `theme_surfaces` | `surface_shadows` | 10 | 2 | 9 | 1 | 0 | 0 |
| `date_time_region` | `time_weather` | 9 | 4 | 9 | 0 | 0 | 0 |
| `input` | `keyboard` | 9 | 0 | 0 | 9 | 0 | 0 |
| `personalization` | `theme` | 9 | 2 | 8 | 1 | 0 | 0 |
| `sound_media` | `sounds` | 7 | 7 | 7 | 0 | 0 | 0 |
| `date_time_region` | `weather` | 6 | 1 | 6 | 0 | 0 | 0 |
| `displays` | `display_config` | 6 | 0 | 0 | 5 | 0 | 1 |
| `sound_media` | `media_player` | 6 | 4 | 6 | 0 | 0 | 0 |
| `security_accounts` | `greeter` | 5 | 0 | 0 | 0 | 5 | 0 |
| `displays` | `display_gamma` | 4 | 1 | 2 | 2 | 0 | 0 |
| `system` | `multiplexers` | 4 | 1 | 0 | 4 | 0 | 0 |
| `desktop_widgets` |  | 3 | 0 | 0 | 3 | 0 | 0 |
| `security_accounts` | `greeter_auth` | 3 | 0 | 0 | 0 | 3 | 0 |
| `wellbeing` |  | 3 | 0 | 3 | 0 | 0 | 0 |
| `sound_media` | `audio` | 2 | 2 | 2 | 0 | 0 | 0 |
| `applications` | `running_apps` | 1 | 0 | 1 | 0 | 0 | 0 |
| `displays` | `display_widgets` | 1 | 0 | 0 | 1 | 0 | 0 |
| `input` | `keybinds` | 1 | 0 | 1 | 0 | 0 | 0 |
| `notifications` | `notification_rules` | 1 | 0 | 0 | 1 | 0 | 0 |
| `user_accounts` |  | 1 | 1 | 1 | 0 | 0 | 0 |

`(no settings page)` covers Control Center tiles (edited in the overlay), notepad settings (separate popup), transient session state and runtime-only keys.

## Pages in `SettingsTabs.qml`

Top-level entries and their children, in sidebar order. `hidden` subpages are reached from their parent page, not the sidebar; `advanced` pages are behind the advanced toggle.

- `personalization` Wallpaper & colors - hub `WallpaperColorsTab`
  - `theme` Theme & colors - hidden
  - `theme_schedule` Dark mode - hidden
  - `wallpaper_cycling` Automatic cycling - hidden
  - `theme_apps` App theming - advanced
  - `palette_inject` Injected palettes - advanced
- `theme_surfaces` Interface style - hub `ThemeSurfacesTab`
  - `surface_shadows` Shadows - hidden
- `typography` Fonts & motion
- `dankbar` Bar - hub `BarHubHeader`
  - `dankbar_settings` General - hidden
  - `dankbar_appearance` Appearance - hidden
  - `dankbar_dot` Dot - hidden
- `dankbar_widgets` Bar widgets - hub `WidgetsTab`
  - `bar_widget` Widget settings - hidden
- `dock` Dock - hub `DockHubHeader`
  - `dock_general` General - hidden
  - `dock_widgets` Apps & widgets - hidden
  - `dock_appearance` Appearance - hidden
  - `dock_advanced` Advanced - advanced
- `launcher` Launcher
- `dank_dash` Dashboard
- `desktop_widgets` Desktop widgets - hub `DesktopWidgetsTab`
  - `desktop_widget` Widget settings - hidden
- `notifications` Notifications - hub `NotificationsTab`
  - `notification_rules` Rules - hidden
- `osd` On-screen displays
- `wellbeing` Digital wellbeing
- `sound_media` Sound & media
  - `audio` Audio
  - `sounds` Sounds
  - `media_player` Media player
- `displays` Displays
  - `display_config` Configuration
  - `display_gamma` Gamma control
  - `display_widgets` Display assignment
- `input` Input
  - `keybinds` Keyboard shortcuts
  - `keyboard` Keyboard
  - `mouse_touchpad` Mouse & touchpad
- `power_battery` Power & battery
  - `power_sleep` Power & sleep
  - `battery` Battery
- `network` Network
  - `network_wifi` Wi-Fi
  - `network_ethernet` Ethernet
  - `network_vpn` VPN
  - `network_cellular` Cellular
  - `network_status` Status - advanced
- `user_accounts` Users & accounts - hub `UserAccountsTab`
  - `users` Accounts
  - `user_create` Add user - hidden
- `security_accounts` Security
  - `lock_screen` Lock screen
  - `greeter` Greeter
  - `greeter_auth` Authentication - hidden
- `applications` Applications
  - `default_apps` Default apps
  - `autostart` Autostart apps
  - `window_rules` Window rules
  - `running_apps` Running apps - advanced
- `date_time_region` Date, time & region
  - `time_weather` Time & weather
  - `weather` Weather
  - `locale` Locale
- `system` System & integrations
  - `updater` Software updates
  - `updater_changelog` Release notes - hidden
  - `clipboard` Clipboard
  - `compositor_layout` CompositorService.displayName
  - `multiplexers` Multiplexers - advanced
  - `printers` Printers - advanced
- `plugins` Plugins - hub `PluginsHubHeader`
  - `plugins_manage` Manage Registries - hidden
- `about` About

## Bar widget option pages

`Modules/Settings/BarWidgetOptions/` holds 16 option pages; `BarWidgetCatalog.qml` maps them to 20 widget types. `SystemMonitorOptions.qml` is shared by five monitor widgets, so its controls appear once per widget type in the CSV.

| Option page | Widget types | Controls on the page | Distinct fields | Rows (all types) |
| --- | --- | ---: | ---: | ---: |
| `IslandOptions.qml` | island | 20 | 57 | 58 |
| `WorkspaceSwitcherOptions.qml` | workspaceSwitcher | 20 | 45 | 46 |
| `AppsDockOptions.qml` | appsDock | 24 | 19 | 20 |
| `ControlCenterOptions.qml` | controlCenterButton | 15 | 15 | 16 |
| `SystemMonitorOptions.qml` | cpuTemp, cpuUsage, diskUsage, gpuTemp, memUsage | 8 | 8 | 17 |
| `BatteryOptions.qml` | battery | 7 | 7 | 8 |
| `LauncherButtonOptions.qml` | launcherButton | 6 | 6 | 7 |
| `MusicOptions.qml` | music | 6 | 6 | 7 |
| `SystemTrayOptions.qml` | systemTray | 8 | 5 | 6 |
| `RunningAppsOptions.qml` | runningApps | 4 | 4 | 5 |
| `ClockOptions.qml` | clock | 3 | 3 | 4 |
| `FocusedWindowOptions.qml` | focusedWindow | 3 | 3 | 4 |
| `KeyboardLayoutOptions.qml` | keyboard_layout_name | 3 | 3 | 4 |
| `PrivacyOptions.qml` | privacyIndicator | 3 | 3 | 4 |
| `NetworkMonitorOptions.qml` | network_speed_monitor | 2 | 2 | 3 |
| `SystemUpdateOptions.qml` | systemUpdate | 1 | 1 | 2 |

`spacer` has no options page (`size` is edited inline on the widget row and is still a CSV row).

## Existing `desktop.ojuny.dux` keys

631 leaf paths found in `ojuny-desktop/lib/defaults/dux.nix`, `dux-clipboard.nix`, `plugins.nix`, `modules/**/*.nix` and `ojuny-template/modules/**/*.nix` (the repo is mid-rename from `desktop.ojuny.dms` to `desktop.ojuny.dux`; both prefixes were read). The 2026-10-28 template batch added 34 covered paths (33 `settings` and 1 `clipboardSettings`). The `_order` fields are ojuny array-ordering markers, not Dux keys, and the `plugins.*` entries are third-party plugin settings outside `SettingsSpec`; both are marked `no` and explained below.

| Namespace | Keys | Covered |
| --- | ---: | ---: |
| `barConfigs` | 89 | 60 |
| `clipboardSettings` | 8 | 6 |
| `controlCenterWidgets` | 127 | 102 |
| `dashCards` | 40 | 32 |
| `dashOptions` | 53 | 42 |
| `dashTabs` | 12 | 6 |
| `dockConfigs` | 64 | 48 |
| `managePluginSettings` | 1 | 0 |
| `plugins` | 17 | 1 |
| `session` | 20 | 19 |
| `settings` | 200 | 198 |

<details><summary>Full key list</summary>

| Key | covered |
| --- | --- |
| `barConfigs` | yes |
| `barConfigs.default._order` | no |
| `barConfigs.default.attachToScreenEdge` | yes |
| `barConfigs.default.autoHide` | yes |
| `barConfigs.default.autoHideDelay` | yes |
| `barConfigs.default.borderColor` | yes |
| `barConfigs.default.borderEnabled` | yes |
| `barConfigs.default.borderOpacity` | yes |
| `barConfigs.default.borderThickness` | yes |
| `barConfigs.default.bottomGap` | yes |
| `barConfigs.default.centerWidgets` | yes |
| `barConfigs.default.enabled` | yes |
| `barConfigs.default.followInterfaceStyle` | yes |
| `barConfigs.default.fontScale` | yes |
| `barConfigs.default.gothCornerRadiusOverride` | yes |
| `barConfigs.default.gothCornerRadiusValue` | yes |
| `barConfigs.default.gothCornersEnabled` | yes |
| `barConfigs.default.iconScale` | yes |
| `barConfigs.default.innerPadding` | yes |
| `barConfigs.default.island` | yes |
| `barConfigs.default.islandCompactThickness` | yes |
| `barConfigs.default.islandGothCornerRadiusOverride` | no |
| `barConfigs.default.islandGothCornerRadiusValue` | no |
| `barConfigs.default.islandGothCornersEnabled` | no |
| `barConfigs.default.islandHoverCloseDelay` | yes |
| `barConfigs.default.islandHoverOpenDelay` | yes |
| `barConfigs.default.islandOuterGap` | yes |
| `barConfigs.default.islandSatelliteGap` | yes |
| `barConfigs.default.islandSatelliteHoverGap` | no |
| `barConfigs.default.islandSatelliteHoverSize` | no |
| `barConfigs.default.islandSatelliteHoverSizeExpanded` | no |
| `barConfigs.default.islandSatelliteSize` | no |
| `barConfigs.default.islandSatelliteSizeExpanded` | no |
| `barConfigs.default.islandWidgetOutlineColor` | no |
| `barConfigs.default.islandWidgetOutlineEnabled` | no |
| `barConfigs.default.islandWidgetOutlineOpacity` | no |
| `barConfigs.default.islandWidgetPadding` | no |
| `barConfigs.default.leftWidgets.dankKDEConnect._order` | no |
| `barConfigs.default.leftWidgets.dankKDEConnect.enabled` | no |
| `barConfigs.default.leftWidgets.layout._order` | no |
| `barConfigs.default.leftWidgets.layout.enabled` | no |
| `barConfigs.default.leftWidgets.scratchpadHelper._order` | no |
| `barConfigs.default.leftWidgets.scratchpadHelper.enabled` | no |
| `barConfigs.default.leftWidgets.workspaceSwitcher._order` | no |
| `barConfigs.default.leftWidgets.workspaceSwitcher.dwlShowAllTags` | yes |
| `barConfigs.default.leftWidgets.workspaceSwitcher.enabled` | yes |
| `barConfigs.default.leftWidgets.workspaceSwitcher.showOccupiedWorkspacesOnly` | yes |
| `barConfigs.default.leftWidgets.workspaceSwitcher.showWorkspaceIndex` | yes |
| `barConfigs.default.leftWidgets.workspaceSwitcher.showWorkspacePadding` | yes |
| `barConfigs.default.leftWidgets.workspaceSwitcher.workspaceIndicatorCompact` | yes |
| `barConfigs.default.leftWidgets.workspaceSwitcher.workspacePaddingCount` | yes |
| `barConfigs.default.name` | yes |
| `barConfigs.default.noBackground` | yes |
| `barConfigs.default.openOnOverview` | yes |
| `barConfigs.default.popupGapsAuto` | yes |
| `barConfigs.default.popupGapsManual` | yes |
| `barConfigs.default.position` | yes |
| `barConfigs.default.rightWidgets.clipboard._order` | no |
| `barConfigs.default.rightWidgets.controlCenterButton._order` | no |
| `barConfigs.default.rightWidgets.controlCenterButton.enabled` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showAudioPercent` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showBatteryIcon` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showBrightnessIcon` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showBrightnessPercent` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showDoNotDisturbIcon` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showIdleInhibitorIcon` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showMicIcon` | yes |
| `barConfigs.default.rightWidgets.controlCenterButton.showMicPercent` | yes |
| `barConfigs.default.rightWidgets.developerUtilities._order` | no |
| `barConfigs.default.rightWidgets.developerUtilities.enabled` | no |
| `barConfigs.default.rightWidgets.localServices._order` | no |
| `barConfigs.default.rightWidgets.localServices.enabled` | no |
| `barConfigs.default.rightWidgets.nixMonitor._order` | no |
| `barConfigs.default.rightWidgets.nixMonitor.enabled` | no |
| `barConfigs.default.rightWidgets.systemTray._order` | no |
| `barConfigs.default.screenPreferences` | yes |
| `barConfigs.default.shadowIntensity` | yes |
| `barConfigs.default.shadowOpacity` | yes |
| `barConfigs.default.showOnLastDisplay` | yes |
| `barConfigs.default.spacing` | yes |
| `barConfigs.default.squareCorners` | yes |
| `barConfigs.default.surfaceColor` | yes |
| `barConfigs.default.transparency` | yes |
| `barConfigs.default.useOverlayLayer` | yes |
| `barConfigs.default.visible` | yes |
| `barConfigs.default.widgetFollowInterfaceStyle` | yes |
| `barConfigs.default.widgetOutlineEnabled` | yes |
| `barConfigs.default.widgetPadding` | yes |
| `barConfigs.default.widgetTransparency` | yes |
| `clipboardSettings.autoClearDays` | yes |
| `clipboardSettings.clearAtStartup` | yes |
| `clipboardSettings.disableHistory` | no |
| `clipboardSettings.disablePersist` | no |
| `clipboardSettings.disabled` | yes |
| `clipboardSettings.maxEntrySize` | yes |
| `clipboardSettings.maxHistory` | yes |
| `clipboardSettings.maxPinned` | yes |
| `controlCenterWidgets.battery._order` | no |
| `controlCenterWidgets.battery.col` | yes |
| `controlCenterWidgets.battery.enabled` | yes |
| `controlCenterWidgets.battery.h` | yes |
| `controlCenterWidgets.battery.row` | yes |
| `controlCenterWidgets.battery.w` | yes |
| `controlCenterWidgets.bluetooth._order` | no |
| `controlCenterWidgets.bluetooth.col` | yes |
| `controlCenterWidgets.bluetooth.enabled` | yes |
| `controlCenterWidgets.bluetooth.h` | yes |
| `controlCenterWidgets.bluetooth.row` | yes |
| `controlCenterWidgets.bluetooth.w` | yes |
| `controlCenterWidgets.brightnessSlider._order` | no |
| `controlCenterWidgets.brightnessSlider.col` | yes |
| `controlCenterWidgets.brightnessSlider.enabled` | yes |
| `controlCenterWidgets.brightnessSlider.h` | yes |
| `controlCenterWidgets.brightnessSlider.row` | yes |
| `controlCenterWidgets.brightnessSlider.w` | yes |
| `controlCenterWidgets.builtin_vpn._order` | no |
| `controlCenterWidgets.builtin_vpn.col` | yes |
| `controlCenterWidgets.builtin_vpn.enabled` | yes |
| `controlCenterWidgets.builtin_vpn.h` | yes |
| `controlCenterWidgets.builtin_vpn.row` | yes |
| `controlCenterWidgets.builtin_vpn.w` | yes |
| `controlCenterWidgets.diskUsage._order` | no |
| `controlCenterWidgets.diskUsage.col` | yes |
| `controlCenterWidgets.diskUsage.enabled` | yes |
| `controlCenterWidgets.diskUsage.h` | yes |
| `controlCenterWidgets.diskUsage.mountpath` | no |
| `controlCenterWidgets.diskUsage.row` | yes |
| `controlCenterWidgets.diskUsage.w` | yes |
| `controlCenterWidgets.doNotDisturb._order` | no |
| `controlCenterWidgets.doNotDisturb.col` | yes |
| `controlCenterWidgets.doNotDisturb.enabled` | yes |
| `controlCenterWidgets.doNotDisturb.footer` | yes |
| `controlCenterWidgets.doNotDisturb.h` | yes |
| `controlCenterWidgets.doNotDisturb.row` | yes |
| `controlCenterWidgets.doNotDisturb.small` | yes |
| `controlCenterWidgets.doNotDisturb.w` | yes |
| `controlCenterWidgets.edit._order` | no |
| `controlCenterWidgets.edit.col` | yes |
| `controlCenterWidgets.edit.enabled` | yes |
| `controlCenterWidgets.edit.h` | yes |
| `controlCenterWidgets.edit.row` | yes |
| `controlCenterWidgets.edit.small` | yes |
| `controlCenterWidgets.edit.w` | yes |
| `controlCenterWidgets.idleInhibitor._order` | no |
| `controlCenterWidgets.idleInhibitor.col` | yes |
| `controlCenterWidgets.idleInhibitor.enabled` | yes |
| `controlCenterWidgets.idleInhibitor.footer` | yes |
| `controlCenterWidgets.idleInhibitor.h` | yes |
| `controlCenterWidgets.idleInhibitor.row` | yes |
| `controlCenterWidgets.idleInhibitor.small` | yes |
| `controlCenterWidgets.idleInhibitor.w` | yes |
| `controlCenterWidgets.inputVolumeSlider._order` | no |
| `controlCenterWidgets.inputVolumeSlider.col` | yes |
| `controlCenterWidgets.inputVolumeSlider.enabled` | yes |
| `controlCenterWidgets.inputVolumeSlider.h` | yes |
| `controlCenterWidgets.inputVolumeSlider.row` | yes |
| `controlCenterWidgets.inputVolumeSlider.w` | yes |
| `controlCenterWidgets.lock._order` | no |
| `controlCenterWidgets.lock.col` | yes |
| `controlCenterWidgets.lock.enabled` | yes |
| `controlCenterWidgets.lock.h` | yes |
| `controlCenterWidgets.lock.row` | yes |
| `controlCenterWidgets.lock.small` | yes |
| `controlCenterWidgets.lock.w` | yes |
| `controlCenterWidgets.nightMode._order` | no |
| `controlCenterWidgets.nightMode.col` | yes |
| `controlCenterWidgets.nightMode.enabled` | yes |
| `controlCenterWidgets.nightMode.footer` | yes |
| `controlCenterWidgets.nightMode.h` | yes |
| `controlCenterWidgets.nightMode.row` | yes |
| `controlCenterWidgets.nightMode.small` | yes |
| `controlCenterWidgets.nightMode.w` | yes |
| `controlCenterWidgets.plugin_dankKDEConnect._order` | no |
| `controlCenterWidgets.plugin_dankKDEConnect.col` | no |
| `controlCenterWidgets.plugin_dankKDEConnect.enabled` | no |
| `controlCenterWidgets.plugin_dankKDEConnect.h` | no |
| `controlCenterWidgets.plugin_dankKDEConnect.row` | no |
| `controlCenterWidgets.plugin_dankKDEConnect.w` | no |
| `controlCenterWidgets.power._order` | no |
| `controlCenterWidgets.power.col` | yes |
| `controlCenterWidgets.power.enabled` | yes |
| `controlCenterWidgets.power.h` | yes |
| `controlCenterWidgets.power.row` | yes |
| `controlCenterWidgets.power.small` | yes |
| `controlCenterWidgets.power.w` | yes |
| `controlCenterWidgets.quickTiles._order` | no |
| `controlCenterWidgets.quickTiles.col` | yes |
| `controlCenterWidgets.quickTiles.enabled` | yes |
| `controlCenterWidgets.quickTiles.h` | yes |
| `controlCenterWidgets.quickTiles.row` | yes |
| `controlCenterWidgets.quickTiles.w` | yes |
| `controlCenterWidgets.runningApps._order` | no |
| `controlCenterWidgets.runningApps.col` | yes |
| `controlCenterWidgets.runningApps.enabled` | yes |
| `controlCenterWidgets.runningApps.footer` | yes |
| `controlCenterWidgets.runningApps.h` | yes |
| `controlCenterWidgets.runningApps.row` | yes |
| `controlCenterWidgets.runningApps.small` | yes |
| `controlCenterWidgets.runningApps.w` | yes |
| `controlCenterWidgets.settings._order` | no |
| `controlCenterWidgets.settings.col` | yes |
| `controlCenterWidgets.settings.enabled` | yes |
| `controlCenterWidgets.settings.h` | yes |
| `controlCenterWidgets.settings.row` | yes |
| `controlCenterWidgets.settings.small` | yes |
| `controlCenterWidgets.settings.w` | yes |
| `controlCenterWidgets.user._order` | no |
| `controlCenterWidgets.user.col` | yes |
| `controlCenterWidgets.user.enabled` | yes |
| `controlCenterWidgets.user.h` | yes |
| `controlCenterWidgets.user.row` | yes |
| `controlCenterWidgets.user.w` | yes |
| `controlCenterWidgets.volumeSlider._order` | no |
| `controlCenterWidgets.volumeSlider.col` | yes |
| `controlCenterWidgets.volumeSlider.enabled` | yes |
| `controlCenterWidgets.volumeSlider.h` | yes |
| `controlCenterWidgets.volumeSlider.row` | yes |
| `controlCenterWidgets.volumeSlider.w` | yes |
| `controlCenterWidgets.wifi._order` | no |
| `controlCenterWidgets.wifi.col` | yes |
| `controlCenterWidgets.wifi.enabled` | yes |
| `controlCenterWidgets.wifi.h` | yes |
| `controlCenterWidgets.wifi.row` | yes |
| `controlCenterWidgets.wifi.w` | yes |
| `dashCards.calendar._order` | no |
| `dashCards.calendar.col` | yes |
| `dashCards.calendar.h` | yes |
| `dashCards.calendar.row` | yes |
| `dashCards.calendar.w` | yes |
| `dashCards.clock._order` | no |
| `dashCards.clock.col` | yes |
| `dashCards.clock.h` | yes |
| `dashCards.clock.row` | yes |
| `dashCards.clock.w` | yes |
| `dashCards.media._order` | no |
| `dashCards.media.col` | yes |
| `dashCards.media.h` | yes |
| `dashCards.media.row` | yes |
| `dashCards.media.w` | yes |
| `dashCards.network._order` | no |
| `dashCards.network.col` | yes |
| `dashCards.network.h` | yes |
| `dashCards.network.row` | yes |
| `dashCards.network.w` | yes |
| `dashCards.notifications._order` | no |
| `dashCards.notifications.col` | yes |
| `dashCards.notifications.h` | yes |
| `dashCards.notifications.row` | yes |
| `dashCards.notifications.w` | yes |
| `dashCards.sysmon._order` | no |
| `dashCards.sysmon.col` | yes |
| `dashCards.sysmon.h` | yes |
| `dashCards.sysmon.row` | yes |
| `dashCards.sysmon.w` | yes |
| `dashCards.user._order` | no |
| `dashCards.user.col` | yes |
| `dashCards.user.h` | yes |
| `dashCards.user.row` | yes |
| `dashCards.user.w` | yes |
| `dashCards.weather._order` | no |
| `dashCards.weather.col` | yes |
| `dashCards.weather.h` | yes |
| `dashCards.weather.row` | yes |
| `dashCards.weather.w` | yes |
| `dashOptions.calendar.weekends` | yes |
| `dashOptions.media.playerStyle` | yes |
| `dashOptions.weather.widgets.conditions._order` | no |
| `dashOptions.weather.widgets.conditions.city` | yes |
| `dashOptions.weather.widgets.conditions.col` | yes |
| `dashOptions.weather.widgets.conditions.h` | yes |
| `dashOptions.weather.widgets.conditions.row` | yes |
| `dashOptions.weather.widgets.conditions.tone` | yes |
| `dashOptions.weather.widgets.conditions.w` | yes |
| `dashOptions.weather.widgets.daily .col` | no |
| `dashOptions.weather.widgets.daily .h` | no |
| `dashOptions.weather.widgets.daily .row` | no |
| `dashOptions.weather.widgets.daily .w` | no |
| `dashOptions.weather.widgets.daily._order` | no |
| `dashOptions.weather.widgets.daily.col` | yes |
| `dashOptions.weather.widgets.daily.forecast` | yes |
| `dashOptions.weather.widgets.daily.h` | yes |
| `dashOptions.weather.widgets.daily.row` | yes |
| `dashOptions.weather.widgets.daily.w` | yes |
| `dashOptions.weather.widgets.hourly._order` | no |
| `dashOptions.weather.widgets.hourly.col` | yes |
| `dashOptions.weather.widgets.hourly.forecast` | yes |
| `dashOptions.weather.widgets.hourly.h` | yes |
| `dashOptions.weather.widgets.hourly.row` | yes |
| `dashOptions.weather.widgets.hourly.w` | yes |
| `dashOptions.weather.widgets.humidity._order` | no |
| `dashOptions.weather.widgets.humidity.col` | yes |
| `dashOptions.weather.widgets.humidity.graphics` | yes |
| `dashOptions.weather.widgets.humidity.h` | yes |
| `dashOptions.weather.widgets.humidity.row` | yes |
| `dashOptions.weather.widgets.humidity.tone` | yes |
| `dashOptions.weather.widgets.humidity.w` | yes |
| `dashOptions.weather.widgets.precipitation._order` | no |
| `dashOptions.weather.widgets.precipitation.col` | yes |
| `dashOptions.weather.widgets.precipitation.graphics` | yes |
| `dashOptions.weather.widgets.precipitation.h` | yes |
| `dashOptions.weather.widgets.precipitation.row` | yes |
| `dashOptions.weather.widgets.precipitation.tone` | yes |
| `dashOptions.weather.widgets.precipitation.w` | yes |
| `dashOptions.weather.widgets.uv._order` | no |
| `dashOptions.weather.widgets.uv.col` | yes |
| `dashOptions.weather.widgets.uv.graphics` | yes |
| `dashOptions.weather.widgets.uv.h` | yes |
| `dashOptions.weather.widgets.uv.row` | yes |
| `dashOptions.weather.widgets.uv.tone` | yes |
| `dashOptions.weather.widgets.uv.w` | yes |
| `dashOptions.weather.widgets.wind._order` | no |
| `dashOptions.weather.widgets.wind.col` | yes |
| `dashOptions.weather.widgets.wind.graphics` | yes |
| `dashOptions.weather.widgets.wind.h` | yes |
| `dashOptions.weather.widgets.wind.row` | yes |
| `dashOptions.weather.widgets.wind.tone` | yes |
| `dashOptions.weather.widgets.wind.w` | yes |
| `dashTabs.media._order` | no |
| `dashTabs.media.enabled` | yes |
| `dashTabs.notifications._order` | no |
| `dashTabs.notifications.enabled` | yes |
| `dashTabs.overview._order` | no |
| `dashTabs.overview.enabled` | yes |
| `dashTabs.wallpaper._order` | no |
| `dashTabs.wallpaper.enabled` | yes |
| `dashTabs.weather._order` | no |
| `dashTabs.weather.enabled` | yes |
| `dashTabs.wellbeing._order` | no |
| `dashTabs.wellbeing.enabled` | yes |
| `dockConfigs.dock._order` | no |
| `dockConfigs.dock.autoHide` | yes |
| `dockConfigs.dock.borderColor` | yes |
| `dockConfigs.dock.borderEnabled` | yes |
| `dockConfigs.dock.borderOpacity` | yes |
| `dockConfigs.dock.borderThickness` | yes |
| `dockConfigs.dock.bottomGap` | yes |
| `dockConfigs.dock.editOnRightClick` | yes |
| `dockConfigs.dock.enabled` | yes |
| `dockConfigs.dock.followInterfaceStyle` | yes |
| `dockConfigs.dock.groupByApp` | yes |
| `dockConfigs.dock.iconSize` | yes |
| `dockConfigs.dock.indicatorStyle` | yes |
| `dockConfigs.dock.isolateDisplays` | yes |
| `dockConfigs.dock.itemSpacing` | yes |
| `dockConfigs.dock.launcherEnabled` | yes |
| `dockConfigs.dock.launcherLogoBrightness` | yes |
| `dockConfigs.dock.launcherLogoColorOverride` | yes |
| `dockConfigs.dock.launcherLogoContrast` | yes |
| `dockConfigs.dock.launcherLogoCustomPath` | yes |
| `dockConfigs.dock.launcherLogoMode` | yes |
| `dockConfigs.dock.launcherLogoSizeOffset` | yes |
| `dockConfigs.dock.magnification` | yes |
| `dockConfigs.dock.magnificationExpand` | yes |
| `dockConfigs.dock.magnificationProfile` | yes |
| `dockConfigs.dock.magnificationScale` | yes |
| `dockConfigs.dock.margin` | yes |
| `dockConfigs.dock.maxVisibleApps` | yes |
| `dockConfigs.dock.maxVisibleRunningApps` | yes |
| `dockConfigs.dock.mode` | yes |
| `dockConfigs.dock.name` | yes |
| `dockConfigs.dock.openOnOverview` | yes |
| `dockConfigs.dock.order` | yes |
| `dockConfigs.dock.position` | yes |
| `dockConfigs.dock.restoreSpecialWorkspaceOnClick` | yes |
| `dockConfigs.dock.screenPreferences` | yes |
| `dockConfigs.dock.separatePinnedAndRunningApps` | yes |
| `dockConfigs.dock.showOnFullscreen` | yes |
| `dockConfigs.dock.showOnLastDisplay` | yes |
| `dockConfigs.dock.showOverflowBadge` | yes |
| `dockConfigs.dock.showTrash` | yes |
| `dockConfigs.dock.smartAutoHide` | yes |
| `dockConfigs.dock.spacing` | yes |
| `dockConfigs.dock.taskbarAlign` | yes |
| `dockConfigs.dock.transparency` | yes |
| `dockConfigs.dock.trashCustomCommand` | yes |
| `dockConfigs.dock.trashFileManager` | yes |
| `dockConfigs.dock.useOverlayLayer` | yes |
| `dockConfigs.dock.widgetExpansion` | yes |
| `dockConfigs.dock.widgets.appsDock._order` | no |
| `dockConfigs.dock.widgets.appsDock.enabled` | no |
| `dockConfigs.dock.widgets.dockLauncher._order` | no |
| `dockConfigs.dock.widgets.dockLauncher.enabled` | no |
| `dockConfigs.dock.widgets.dockTrash._order` | no |
| `dockConfigs.dock.widgets.dockTrash.enabled` | no |
| `dockConfigs.dock.widgets.dock_apps._order` | no |
| `dockConfigs.dock.widgets.dock_apps.enabled` | no |
| `dockConfigs.dock.widgets.dock_apps.widgetId` | no |
| `dockConfigs.dock.widgets.dock_launcher._order` | no |
| `dockConfigs.dock.widgets.dock_launcher.enabled` | no |
| `dockConfigs.dock.widgets.dock_launcher.widgetId` | no |
| `dockConfigs.dock.widgets.dock_trash._order` | no |
| `dockConfigs.dock.widgets.dock_trash.enabled` | no |
| `dockConfigs.dock.widgets.dock_trash.widgetId` | no |
| `managePluginSettings` | no |
| `plugins` | yes |
| `plugins.dankKDEConnect.enable` | no |
| `plugins.dankKDEConnect.settings.scanSubdirectories` | no |
| `plugins.dankMenu.enable` | no |
| `plugins.emojiLauncher.enable` | no |
| `plugins.emojiLauncher.settings.pasteOnSelect` | no |
| `plugins.emojiLauncher.settings.trigger` | no |
| `plugins.emojiLauncher.settings.useDMS` | no |
| `plugins.localServices.settings` | no |
| `plugins.nixMonitor.config.rebuildCommand` | no |
| `plugins.nixMonitor.enable` | no |
| `plugins.nixMonitor.settings.gcThresholdGB` | no |
| `plugins.nixMonitor.settings.showGenerations` | no |
| `plugins.nixMonitor.settings.showStoreSize` | no |
| `plugins.nixMonitor.settings.updateCheckInterval` | no |
| `plugins.nixMonitor.settings.updateInterval` | no |
| `plugins.screenCaptureToolbar.settings` | no |
| `session` | yes |
| `session.includedTransitions` | yes |
| `session.nightModeAutoEnabled` | yes |
| `session.nightModeAutoMode` | yes |
| `session.nightModeEndHour` | yes |
| `session.nightModeEndMinute` | yes |
| `session.nightModeExcludeFullscreen` | no |
| `session.nightModeHighTemperature` | yes |
| `session.nightModeLocationName` | yes |
| `session.nightModeStartHour` | yes |
| `session.nightModeStartMinute` | yes |
| `session.nightModeTemperature` | yes |
| `session.nightModeTransitionMinutes` | yes |
| `session.nightModeUseIPLocation` | yes |
| `session.wallpaperCyclingEnabled` | yes |
| `session.wallpaperCyclingInterval` | yes |
| `session.wallpaperCyclingMode` | yes |
| `session.wallpaperCyclingRandom` | yes |
| `session.wallpaperCyclingTime` | yes |
| `session.wallpaperTransition` | yes |
| `settings` | yes |
| `settings.acLockTimeout` | yes |
| `settings.acMonitorTimeout` | yes |
| `settings.acPostLockMonitorTimeout` | yes |
| `settings.acProfileName` | yes |
| `settings.acSuspendBehavior` | yes |
| `settings.acSuspendTimeout` | yes |
| `settings.animationDuration` | yes |
| `settings.appPickerViewMode` | yes |
| `settings.audioMono` | yes |
| `settings.audioShowStreamDevices` | yes |
| `settings.audioVisualizerEnabled` | yes |
| `settings.audioWheelScrollAmount` | yes |
| `settings.avatarRing` | yes |
| `settings.barElevationEnabled` | yes |
| `settings.batteryAutoPowerSaver` | yes |
| `settings.batteryChargeLimit` | yes |
| `settings.batteryChargeLimitNotificationType` | yes |
| `settings.batteryCriticalAnimation` | yes |
| `settings.batteryCriticalNotificationType` | yes |
| `settings.batteryCriticalThreshold` | yes |
| `settings.batteryLockTimeout` | yes |
| `settings.batteryLowNotificationType` | yes |
| `settings.batteryLowThreshold` | yes |
| `settings.batteryMonitorTimeout` | yes |
| `settings.batteryNotifyChargeLimit` | yes |
| `settings.batteryNotifyCritical` | yes |
| `settings.batteryNotifyLow` | yes |
| `settings.batteryPostLockMonitorTimeout` | yes |
| `settings.batteryProfileName` | yes |
| `settings.batterySuspendBehavior` | yes |
| `settings.batterySuspendTimeout` | yes |
| `settings.bluetoothMprisEnabled` | yes |
| `settings.blurBorderColor` | yes |
| `settings.blurBorderEnabled` | yes |
| `settings.blurBorderOpacity` | yes |
| `settings.blurEnabled` | yes |
| `settings.blurForegroundLayers` | yes |
| `settings.blurLayerOutlineOpacity` | yes |
| `settings.blurredWallpaperLayer` | yes |
| `settings.blurStrength` | yes |
| `settings.blurWallpaperOnOverview` | yes |
| `settings.browserPickerViewMode` | yes |
| `settings.builtInPluginSettings.dms_clipboard_search.trigger` | yes |
| `settings.builtInPluginSettings.dms_power.trigger` | yes |
| `settings.builtInPluginSettings.dms_qr_generator.trigger` | yes |
| `settings.builtInPluginSettings.dms_settings_search.trigger` | yes |
| `settings.buttonColorMode` | yes |
| `settings.calendarBackend` | yes |
| `settings.cardSurfaceColor` | yes |
| `settings.centeringMode` | yes |
| `settings.chipSurfaceColor` | yes |
| `settings.clipboardClickToPaste` | yes |
| `settings.clipboardEnterToPaste` | yes |
| `settings.clipboardRememberTypeFilter` | yes |
| `settings.clipboardSize` | yes |
| `settings.clipboardTypeFilter` | yes |
| `settings.clipboardUseOverlayLayer` | yes |
| `settings.clipboardVisibleEntryActions` | yes |
| `settings.clockDateFormat` | yes |
| `settings.containerSaturation` | yes |
| `settings.currentThemeName` | yes |
| `settings.customPowerActionHibernate` | yes |
| `settings.customPowerActionLock` | yes |
| `settings.customPowerActionLogout` | yes |
| `settings.customPowerActionPowerOff` | yes |
| `settings.customPowerActionReboot` | yes |
| `settings.customPowerActionSuspend` | yes |
| `settings.customThemeFile` | yes |
| `settings.dankLauncherV2BorderColor` | yes |
| `settings.dankLauncherV2BorderEnabled` | yes |
| `settings.dankLauncherV2BorderThickness` | yes |
| `settings.dankLauncherV2IncludeFilesInAll` | yes |
| `settings.dankLauncherV2IncludeFoldersInAll` | yes |
| `settings.dankLauncherV2ShowFooter` | yes |
| `settings.dankLauncherV2ShowSourceBadges` | yes |
| `settings.dankLauncherV2Size` | yes |
| `settings.dankLauncherV2UnloadOnClose` | yes |
| `settings.density` | yes |
| `settings.dmsWindowsFloatingSeeded` | no |
| `settings.dockTransparency` | no |
| `settings.enableFprint` | yes |
| `settings.enableU2f` | yes |
| `settings.fadeToDpmsEnabled` | yes |
| `settings.fadeToDpmsGracePeriod` | yes |
| `settings.fadeToLockEnabled` | yes |
| `settings.fadeToLockGracePeriod` | yes |
| `settings.firstDayOfWeek` | yes |
| `settings.fixedRadius` | yes |
| `settings.focusRingColor` | yes |
| `settings.focusRingEnabled` | yes |
| `settings.focusRingWidth` | yes |
| `settings.fontFamily` | yes |
| `settings.fontScale` | yes |
| `settings.fontWeight` | yes |
| `settings.foregroundLayerTransparency` | yes |
| `settings.frameEnabled` | yes |
| `settings.hostSurfaceColor` | yes |
| `settings.interfaceStyle` | yes |
| `settings.launcherEnterAction` | yes |
| `settings.launcherHistoryEnabled` | yes |
| `settings.launcherStyle` | yes |
| `settings.launcherUseOverlayLayer` | yes |
| `settings.lockAtStartup` | yes |
| `settings.lockBeforeSuspend` | yes |
| `settings.lockScreenInactiveColor` | yes |
| `settings.lockScreenPowerOffMonitorsOnLock` | yes |
| `settings.lockScreenSecurityKeyShortcut` | yes |
| `settings.lockScreenSecurityKeyShortcutEnabled` | yes |
| `settings.lockScreenShowPowerActions` | yes |
| `settings.lockScreenShowProfileImage` | yes |
| `settings.lockScreenShowWeather` | yes |
| `settings.lockScreenVideoCycling` | yes |
| `settings.lockScreenVideoEnabled` | yes |
| `settings.lockScreenVideoPath` | yes |
| `settings.lockScreenWallpaperFillMode` | yes |
| `settings.loginctlLockIntegration` | yes |
| `settings.maxFprintTries` | yes |
| `settings.mediaExcludePlayers` | yes |
| `settings.modalAnimationDuration` | yes |
| `settings.modalDarkenBackground` | yes |
| `settings.monoFontFamily` | yes |
| `settings.motionEffect` | yes |
| `settings.muteSoundsWhenMediaPlaying` | yes |
| `settings.muxType` | yes |
| `settings.nightModeExcludedApps` | yes |
| `settings.notepadAutoSave` | yes |
| `settings.notepadDefaultMode` | yes |
| `settings.notepadEdgeGap` | yes |
| `settings.notepadFontFamily` | yes |
| `settings.notepadFontSize` | yes |
| `settings.notepadShowLineNumbers` | yes |
| `settings.notepadSlideoutSide` | yes |
| `settings.notepadUseCompositorGap` | yes |
| `settings.notepadUseMonospace` | yes |
| `settings.notificationAnimationDuration` | yes |
| `settings.notificationBodyFontSize` | yes |
| `settings.notificationCompactMode` | yes |
| `settings.notificationDedupeEnabled` | yes |
| `settings.notificationDndAllowCritical` | yes |
| `settings.notificationDndWhileScreenSharing` | yes |
| `settings.notificationFocusedMonitor` | yes |
| `settings.notificationForegroundLayers` | yes |
| `settings.notificationHistoryEnabled` | yes |
| `settings.notificationHistoryMaxAgeDays` | yes |
| `settings.notificationHistoryMaxCount` | yes |
| `settings.notificationHistorySaveCritical` | yes |
| `settings.notificationHistorySaveLow` | yes |
| `settings.notificationHistorySaveNormal` | yes |
| `settings.notificationIgnoreAppTimeout` | yes |
| `settings.notificationOverlayEnabled` | yes |
| `settings.notificationPopupBodyInvokesAction` | yes |
| `settings.notificationPopupPosition` | yes |
| `settings.notificationPopupPrivacyMode` | yes |
| `settings.notificationPopupShadowEnabled` | yes |
| `settings.notificationShowTimeoutBar` | yes |
| `settings.notificationSummaryFontSize` | yes |
| `settings.notificationTimeoutCritical` | yes |
| `settings.notificationTimeoutLow` | yes |
| `settings.notificationTimeoutNormal` | yes |
| `settings.osdAlwaysShowValue` | yes |
| `settings.osdAudioOutputEnabled` | yes |
| `settings.osdBrightnessEnabled` | yes |
| `settings.osdCapsLockEnabled` | yes |
| `settings.osdIdleInhibitorEnabled` | yes |
| `settings.osdMediaPlaybackEnabled` | yes |
| `settings.osdMediaVolumeEnabled` | yes |
| `settings.osdMicMuteEnabled` | yes |
| `settings.osdMicVolumeEnabled` | yes |
| `settings.osdPosition` | yes |
| `settings.osdPowerProfileEnabled` | yes |
| `settings.osdTouchpadEnabled` | yes |
| `settings.osdVolumeEnabled` | yes |
| `settings.osdWorkspaceEnabled` | yes |
| `settings.popoutAnimationDuration` | yes |
| `settings.popupTransparency` | no (stylix) |
| `settings.powerMenuActions` | yes |
| `settings.radiusMode` | yes |
| `settings.reduceMotion` | yes |
| `settings.sectionDividerOpacity` | yes |
| `settings.showWeekNumber` | yes |
| `settings.soundLogin` | yes |
| `settings.soundNewNotification` | yes |
| `settings.soundPluggedIn` | yes |
| `settings.soundVolumeChanged` | yes |
| `settings.soundsEnabled` | yes |
| `settings.spotlightBarShowModeChips` | yes |
| `settings.springBounce` | yes |
| `settings.syncComponentAnimationSpeeds` | yes |
| `settings.systemTrayIconTintMode` | yes |
| `settings.textRenderQuality` | yes |
| `settings.textRenderType` | yes |
| `settings.u2fMode` | yes |
| `settings.useSystemSoundTheme` | yes |
| `settings.wallpaperBackgroundColorMode` | yes |
| `settings.wallpaperBackgroundCustomColor` | yes |
| `settings.wallpaperFillMode` | yes |
| `settings.widgetBackgroundColor` | yes |
| `settings.widgetColorMode` | yes |
| `settings.windSpeedUnit` | yes |

</details>

Notes on the `no` rows:

- `_order` (every collection): ojuny bookkeeping appended when rendering arrays; not a Dux setting.
- `plugins.*` (except the built-in `dms_*` launcher plugins): third-party plugin settings, defined by plugin manifests, outside the Dux spec.
- `barConfigs.*.islandGothCornersEnabled`, `islandSatelliteSize`, `islandSatelliteSizeExpanded`: no reader anywhere in the 2.0 tree (the current bar field is `gothCornersEnabled`, and the island satellite size is computed from bar metrics). The ojuny defaults are stale; see the defect re-check below.
- `controlCenterWidgets.*.mountpath`: typo in ojuny's `options.md`; the Dux field is `mountPath`.
- `settings.dockTransparency`: legacy key read only by the pre-v20 migration in `SettingsStore.js`; the current config version is 42, so it is inert.
- `dashOptions.weather.widgets."daily "`: trailing space in the ojuny widget id; should be `daily`.
- `clipboardSettings.disableHistory` / `disablePersist`: not accepted by the clipboard daemon (`ClipboardTab.qml` sends `disabled` and has no `disablePersist`).

## Cross-source check

Union of `SettingsSpec.js` (415 local keys) + the shared spec (51 keys) = 466 settings keys, plus QML `settings.<key>` reads. Keys appearing in only one source:

### In the spec but no direct `settings.<key>` QML read

| Key | Why |
| --- | --- |
| `connectedFrameBarStyleBackups` | internal backup blob, written by the frame migration |
| `dashTabs` | read through `SettingsData.getDashTabs()` rather than the property |
| `hyprlandLayoutRadiusOverride` | passed straight to the compositor adapter |
| `lockScreenShowPowerActions` | mirrored from the lock widget instances at `SettingsData.qml:1188-1190` |
| `lockScreenShowProfileImage` | mirrored from the lock widget instances at `SettingsData.qml:1188-1190` |
| `lockScreenShowWeather` | mirrored from the lock widget instances at `SettingsData.qml:1188-1190` |
| `mangoLayoutRadiusOverride` | passed straight to the compositor adapter |
| `niriLayoutRadiusOverride` | passed straight to the compositor adapter |
| `osdPosition` | read through `osdPositionFor()` |
| `osdPositionOverrides` | read through `osdPositionFor()` |
| `registryThemeVariants` | theme registry cache |
| `systemDefaultIconTheme` | detected at runtime, `persist: false` |
| `workspaceNameIcons` | internal map used by the workspace widget |

### Read from QML but not in the spec (excluding widget-option keys)

These are computed properties, enums, signals or functions on `SettingsData`, not settings keys.

`AnimationEffect`, `AnimationSpeed`, `Bottom`, `Left`, `Position`, `Right`, `Stage`, `SuspendBehavior`, `TextRenderQuality`, `TextRenderType`, `Top`, `_hasLoaded`, `_islandHomeGroupIds`, `addMuteRuleForApp`, `barInnerPaddingDefault`, `barIpcRevealStates`, `barPosition`, `barWidgetPaddingDefault`, `connectedFrameModeActive`, `dankIslandEnabled`, `dotBarConfig`, `edgeBarConfigCount`, `effectiveWallpaperBackgroundColor`, `enabledIslandBarConfigs`, `frameBarConfig`, `frameBarContentGap`, `frameBarContentGapExtra`, `frameModalEmergeSide`, `frameSurfaceBase`, `frameSurfaceOpacity`, `getCursorEnvironment`, `greeterFingerprintCanEnable`, `greeterFingerprintReason`, `greeterFingerprintSource`, `greeterU2fCanEnable`, `greeterU2fReason`, `greeterU2fSource`, `hasTimedNotificationRules`, `iconTheme`, `isReadOnly`, `islandDashActivities`, `islandDefaults`, `lastUsedBarByScreen`, `lockFingerprintCanEnable`, `lockFingerprintReady`, `lockFingerprintReason`, `lockU2fCanEnable`, `lockU2fReady`, `lockU2fReason`, `notepadEffectiveEdgeGap`, `pendingNotificationRule`, `qtengineActive`, `unsavedUserChanges`, `use24HourClock`, `useAutoLocationChanged`, `weatherCoordinates`, `weatherCoordinatesChanged`, `weatherEnabledChanged`, `weatherLocation`, `weatherLocationChanged`

### Shared-spec-only keys

`animationDuration`, `blurBorderColor`, `blurBorderCustomColor`, `blurBorderEnabled`, `blurBorderOpacity`, `clockFormat`, `currentThemeName`, `customThemeFile`, `displayFontFamily`, `displayNameMode`, `enableRippleEffects`, `fixedRadius`, `fontFamily`, `fontScale`, `fontWeight`, `greeterEnableFprint`, `greeterEnableU2f`, `greeterRememberLastSession`, `greeterRememberLastUser`, `greeterWidgetInstances`, `lockDateFormat`, `lockScreenFontFamily`, `lockScreenShowPowerActions`, `lockScreenShowProfileImage`, `lockScreenShowWeather`, `lockScreenWallpaperFillMode`, `lockScreenWallpaperPath`, `lockScreenWidgetInstances`, `monoFontFamily`, `padHours12Hour`, `popoutElevationEnabled`, `powerActionConfirm`, `powerActionHoldDuration`, `powerMenuActions`, `powerMenuDefaultAction`, `powerMenuGridLayout`, `radiusMode`, `radiusStrength`, `registryThemeVariants`, `scrollbarsEnabled`, `showSeconds`, `textRenderQuality`, `textRenderType`, `tooltipSurfaceColor`, `tooltipSurfaceCustomColor`, `useAutoLocation`, `useFahrenheit`, `wallpaperBackgroundColorMode`, `wallpaperBackgroundCustomColor`, `wallpaperFillMode`, `weatherEnabled`

## Shared spec keys and defaults

All 64 shared keys are now parsed: 51 settings keys and 13 session keys. No shared key has an unknown default. Defaults are the literal `def` values; `lockScreenWidgetInstances` and `greeterWidgetInstances` use function defaults and are recorded as source, not evaluated.

Five shared session keys (`materialWallpapers`, `materialWallpaperProfiles`, `desktopWidgetInstancePositions`, `lockScreenAutoPositions`, `greeterAutoPositions`) have no CSV row: they were never read as QML settings properties, so the original 1418-row extraction did not include them. Their defaults are in the table below.

### Shared settings keys

| Key | Type | Default | Notes |
| --- | --- | --- | --- |
| `lockScreenWidgetInstances` | array | `lockWidgetDefaults()` | expression default, not evaluated |
| `greeterWidgetInstances` | array | `greeterWidgetDefaults()` | expression default, not evaluated |
| `displayNameMode` | string | system |  |
| `currentThemeName` | string | purple | onChange `applyStoredTheme` |
| `customThemeFile` | string | (empty string) |  |
| `registryThemeVariants` | object | `{}` | theme registry cache |
| `radiusStrength` | int | 50 | coerce `Shape.normalizeStrength`; onChange `updateCompositorLayout` |
| `radiusMode` | string | scale | onChange `updateCompositorLayout` |
| `fixedRadius` | int | 16 | coerce `Shape.normalizeFixedRadius`; onChange `updateCompositorLayout` |
| `clockFormat` | string | auto |  |
| `showSeconds` | bool | false |  |
| `padHours12Hour` | bool | false |  |
| `useFahrenheit` | bool | false |  |
| `animationDuration` | int | 250 |  |
| `enableRippleEffects` | bool | true |  |
| `popoutElevationEnabled` | bool | true |  |
| `tooltipSurfaceColor` | string | default |  |
| `tooltipSurfaceCustomColor` | string | #6750A4 |  |
| `scrollbarsEnabled` | bool | true |  |
| `blurBorderEnabled` | bool | false |  |
| `blurBorderColor` | string | outline |  |
| `blurBorderCustomColor` | string | #ffffff |  |
| `blurBorderOpacity` | number | 0.35 | coerce `Util.percentToUnit` |
| `wallpaperFillMode` | string | Fill |  |
| `wallpaperBackgroundColorMode` | string | black |  |
| `wallpaperBackgroundCustomColor` | string | #000000 |  |
| `lockDateFormat` | string | (empty string) |  |
| `greeterRememberLastSession` | bool | true |  |
| `greeterRememberLastUser` | bool | true |  |
| `greeterEnableFprint` | bool | false | onChange `markGreeterSyncPending` |
| `greeterEnableU2f` | bool | false | onChange `markGreeterSyncPending` |
| `useAutoLocation` | bool | false |  |
| `weatherEnabled` | bool | true |  |
| `fontFamily` | string | Google Sans Flex |  |
| `monoFontFamily` | string | Fira Code |  |
| `displayFontFamily` | string | DM Serif Display |  |
| `fontWeight` | int | 400 |  |
| `fontScale` | number | 1.0 |  |
| `textRenderType` | int | 0 |  |
| `textRenderQuality` | int | 0 |  |
| `lockScreenShowPowerActions` | bool | false |  |
| `lockScreenShowProfileImage` | bool | true |  |
| `lockScreenShowWeather` | bool | true |  |
| `lockScreenWallpaperPath` | string | (empty string) |  |
| `lockScreenWallpaperFillMode` | string | (empty string) |  |
| `lockScreenFontFamily` | string | (empty string) |  |
| `powerActionConfirm` | bool | true |  |
| `powerActionHoldDuration` | number | 0.5 |  |
| `powerMenuActions` | array | `["reboot","logout","poweroff","lock","suspend","restart"]` |  |
| `powerMenuDefaultAction` | string | logout |  |
| `powerMenuGridLayout` | bool | false |  |

### Shared session keys

| Key | Type | Default | Notes |
| --- | --- | --- | --- |
| `isLightMode` | bool | false |  |
| `materialWallpapers` | object | `{}` | coerce `MaterialWallpaper.normalizeStore` |
| `materialWallpaperProfiles` | object | `{}` | coerce `MaterialWallpaper.normalizeProfiles` |
| `wallpaperPath` | string | (empty string) |  |
| `perMonitorWallpaper` | bool | false |  |
| `perModeWallpaper` | bool | false |  |
| `monitorWallpapers` | object | `{}` |  |
| `monitorWallpaperFillModes` | object | `{}` |  |
| `weatherLocation` | string | New York, NY |  |
| `weatherCoordinates` | string | 40.7128,-74.0060 |  |
| `desktopWidgetInstancePositions` | object | `{}` |  |
| `lockScreenAutoPositions` | object | `{}` |  |
| `greeterAutoPositions` | object | `{}` |  |

## Defect claims re-checked

| Claim | Verdict | Evidence |
| --- | --- | --- |
| `controlCenterWidgets.diskUsage.mountpath` should be `mountPath` | **confirmed** | `ojuny-desktop/options.md:625` spells it `mountpath`; `ojuny-desktop/lib/defaults/dux.nix:333` already uses `mountPath`, and `Modules/ControlCenter/Widgets/DiskUsageTile.qml:10` reads `widgetData.mountPath`. |
| `barConfigs.*.islandGothCornersEnabled`, `islandSatelliteSize`, `islandSatelliteSizeExpanded` are stale | **confirmed** | Written at `ojuny-desktop/lib/defaults/dux.nix:66`, `:74`, `:75`; no match anywhere in `dux-shell/quickshell`. The current bar field is `gothCornersEnabled` (`Common/settings/SettingsSpec.js:1562`); the satellite goth flag is `islandSatelliteGothCorners` (`Common/settings/BarWidgetDefaults.js:57`); there is no satellite-size key. |
| `settings.dockTransparency` is stale | **confirmed** | The only reader is the pre-v20 migration at `Common/settings/SettingsStore.js:589`; the current version is 42 (`Common/SettingsData.qml:27`). ojuny still writes it at `modules/nixos/default.nix:188` and `modules/home-manager/default.nix:204`. |
| `session.wallpaperPath` is not a session key | **retracted** | `dux-qml-common/DCommon/Common/settings/SharedSessionSpec.js:16` defines `wallpaperPath: { def: "" }`; `Common/SessionData.qml:177` declares the property and `Common/settings/SessionStore.js:5-39` reads and serialises every `SPEC` key. It is a session key. Caveat: `SessionData.syncWallpaperForCurrentMode()` (`SessionData.qml:1754-1763`) rewrites it from `wallpaperPathLight`/`wallpaperPathDark`, which is why ojuny writes those instead (`options.md:991`). |

## Stylix-owned keys

Some rows cannot be exposed as `desktop.ojuny.dux.settings.*` controls because Ojuny sets those values from stylix, since the layer does not use the upstream Home Manager module. These rows are not gaps: the menu control is the stylix option.

| DMS key | Source of truth | Menu control |
| --- | --- | --- |
| `currentThemeName`, `customThemeFile` | generated stylix theme JSON | `ojuny.style.palette` |
| `fontFamily`, `monoFontFamily`, `displayFontFamily` | `stylix.fonts.sansSerif`, `stylix.fonts.monospace` | font pickers on the Style page |
| `popupTransparency` | `stylix.opacity.popups` | opacity slider on the Style page |
| `wallpaperPathLight`, `wallpaperPathDark`, `lockScreenWallpaperPath` | generated wallpaper set | `ojuny.style.wallpaperPreset` and `desktop.ojuny.wallpaper.*` |
| `iconThemeDark`, `iconThemeLight`, `iconThemePerMode`, `cursorSettings.*` | `stylix.icons.*`, `stylix.cursor.*` | icon and cursor pickers on the Style page |

Treat these rows as `stylix_owned` when reading the totals. They are intentionally outside the `desktop.ojuny.dux` surface, and adding a second control for them would create two sources of truth.

## Top 20 gaps

Ordered by user impact. Every item is uncovered unless the existing-keys table above marks the key covered. The CSV does not carry a `covered` column; this document records coverage in the page table and the existing-keys table.

The 2026-10-28 batch covered the scalar keys in gaps 1, 3, 5 (partly), 12 (partly), 18 and 20, plus the scalar rows of gap 2. The lists below are the pre-batch analysis; check the existing-keys table for current status.

1. **Interface style / blur** - The whole blur pipeline is unmatched; it is the most visible surface effect and has a dedicated page section.
   - Keys: `blurEnabled`, `blurStrength`, `blurBorderEnabled`, `blurBorderColor`, `blurBorderOpacity`, `blurForegroundLayers`, `blurLayerOutlineOpacity`, `foregroundLayerTransparency`, `sectionDividerOpacity`, `blurredWallpaperLayer`, `blurWallpaperOnOverview`
2. **Lock screen personalization** - 13 of 27 lock-screen rows are missing, including the wallpaper and the widget layout; this is a first-run customization users look for.
   - Keys: `lockScreenWallpaperPath`, `lockScreenWallpaperFillMode`, `lockScreenShowWeather`, `lockScreenShowProfileImage`, `lockScreenShowPowerActions`, `lockScreenWidgetInstances`
3. **Global typography** - Fonts only arrive indirectly through the stylix branch; the font page has no declarative equivalent.
   - Keys: `displayFontFamily`, `lockScreenFontFamily`, `fontScale`, `fontWeight`, `textRenderType`, `textRenderQuality`
4. **Bar shape and surface** - Position and size presets are exposed, but the bar's shape, shadow and scroll behaviour are not.
   - Keys: `barLengthMode`, `barLengthPercent`, `barLengthPadding`, `barInsetPadding`, `widgetStyle`, `shadowIntensity`, `shadowOpacity`, `shadowColorMode`, `widgetOutline*`, `hoverPopouts`, `scrollXBehavior`, `scrollYBehavior`, `clickThrough`
5. **Radius, elevation and focus ring** - Sets the overall material feel; currently only indirectly affected by `radiusStrength`-adjacent keys.
   - Keys: `radiusMode`, `radiusStrength`, `fixedRadius`, `m3Elevation*`, `modalElevationEnabled`, `focusRingEnabled`, `focusRingWidth`, `focusRingColor`, `containerSaturation`, `interfaceStyle`, `density`
6. **Compositor layout** - Only one of the compositor-layout keys is mapped, so gaps/borders/tiling cannot be configured from the menu.
   - Keys: 47 `hyprland*`/`niri*`/`mango*` keys plus `closeNiriOverviewOnWindowFocus`
7. **Pointer and keyboard behaviour** - Every input-device preference is missing, including tap-to-click and natural scroll.
   - Keys: 20 `mouse*`/`touchpad*` keys and 9 `keyboard*` keys
8. **Display configuration** - Profile handling and gamma are absent; only basic display settings exist today.
   - Keys: `displayProfiles`, `displayProfileAutoSelect`, `displayShowDisconnected`, `displaySnapToEdge`, `displayGamma`, `displayContrast`
9. **Software update policy** - Updates are system-level and partly hidden, but the everyday check/notify switches have no option.
   - Keys: `updaterCheckOnStart`, `updaterIntervalSeconds`, `updaterNotify`, `updaterPauseOnBattery`, `updaterIncludeFlatpak`, `updaterIgnoredPackages`, `updaterAllowAUR`
10. **App theming templates** - Users cannot pick which apps get re-themed, which is the main reason to edit this page.
   - Keys: 36 `theme_apps` rows, mostly `matugenTemplate*`, plus `runDmsMatugenTemplates`, `runUserMatugenTemplates` and terminal theming
11. **Wallpaper appearance** - Only the wallpaper path is mapped; fill mode, icon theme and cursor are not.
   - Keys: `wallpaperFillMode`, `wallpaperBackgroundColorMode`, `wallpaperBackgroundCustomColor`, `iconThemeDark`, `iconThemeLight`, `iconThemePerMode`, `cursorSettings.*`
12. **Launcher v2 and history** - Launcher style exists, but its v2 look, centering and per-plugin visibility do not.
   - Keys: `dankLauncherV2*` (9), `centeringMode`, `launcherPluginVisibility`, `appDrawerSectionViewModes`, `spotlightSectionViewModes`
13. **Bar widget options** - Only 34 of 212 widget fields are mapped; the per-widget cog pages are almost entirely unported.
   - Keys: 178 uncovered `widget_option` rows (clock, battery, music, system tray, workspace, island, apps dock)
14. **Dashboard options** - Dashboard tabs and cards are mapped but 64 per-card controls are not.
   - Keys: 64 uncovered `dashOptions` rows (weather widget grid, media player options, processor/network/disk card options)
15. **Dark mode schedule** - Theme scheduling is a headline feature and currently only partially covered.
   - Keys: 7 `themeMode*` session keys plus `nightModeEnabled`, `nightModeTemperature`, `nightModeAutoMode`, `nightModeStart*`/`nightModeEnd*`
16. **Wallpaper cycling** - Interval and transition exist; the folder and per-monitor cycling settings are missing.
   - Keys: `wallpaperCyclingFolderPath`, `wallpaperCyclingRecursive`, `monitorCyclingSettings`, `wallpaperCyclingRandom`, `wallpaperCyclingInterval`
17. **Filter lists** - Array-valued policy lists cannot use the IPC; they need explicit list editors in the menu.
   - Keys: `appIdSubstitutions`, `mediaExcludePlayers`, `nightModeExcludedApps`, `notificationRules`, `wellbeingAppLimits`, `screenPreferences`
18. **Power and sleep transitions** - 12 power rows are missing; timeouts are mapped, the fade and suspend-behaviour controls are not.
   - Keys: `fadeToLockEnabled`, `fadeToLockGracePeriod`, `fadeToDpmsEnabled`, `fadeToDpmsGracePeriod`
19. **Desktop widgets** - The desktop widget collection has no declarative representation at all.
   - Keys: `desktopWidgetInstances`, `desktopWidgetGroups`, `desktopContextMenu`
20. **Clipboard daemon limits** - Small gap, but `maxPinned` is a visible control on the Clipboard page.
   - Keys: `clipboardSettings.maxPinned`

## Phased plan

The phases group the top 20 gaps. Counts are uncovered rows from the page table above, so the phases do not restate the 530 covered rows. The three phases account for 630 of the 888 uncovered rows; the other 258 are not assigned here because no gap names their page.

### Phase 1: scalar settings on existing pages

What must exist first: an `@option` on a page that already exists, plus a scalar settings IPC write. No collection editor and no rebuild is needed.

This phase closes gaps 1, 3, 4, 5, 6, 7, 8, 9, 11, 12, 15, 16, 18 and 20, and the scalar rows of gap 2. It closes **307 uncovered rows** after the 2026-10-28 batch covered 34 of the original 341:

- Style, 59 rows: `theme_surfaces` 28, `surface_shadows` 8, `personalization/theme` 7, `theme_schedule` 2, `wallpaper_cycling` 3, and the `personalization` hub 30. The batch covered 19 of these (blur, radius, focus ring, interface style and density).
- Typography, 2 rows.
- Lock, 7 rows of `lock_screen`. The widget instance and `screenPreferences` rows are Phase 2.
- Power, 8 rows: `power_sleep` 7 and `battery` 1.
- Launcher, 26 rows.
- Bar, 108 rows: `dankbar_appearance` 30, `dankbar_settings` 26 and `dankbar_dot` 52.
- Compositor layout, 47 rows.
- Input, 29 rows: `mouse_touchpad` 20 and `keyboard` 9.
- Displays, 8 rows: `display_config` 6 and the two non-list `display_gamma` rows.
- Software updates, 13 rows.
- Clipboard, 0 rows: `maxPinned` is covered by the 2026-10-28 batch.

The remaining rows after Phase 1 are Phase 2 and Phase 3.

### Phase 2: collection editors

What must exist first: a collection editor widget that reads and writes a whole array or object, because the settings IPC rejects objects and arrays. Each editor needs a descriptor for its row fields. No rebuild is needed.

This phase closes gap 17, gap 19, and the collection rows of gap 2. It closes **11 uncovered rows**:

- `lockScreenWidgetInstances`, 1 row.
- `greeterWidgetInstances`, 1 row.
- Desktop widget collections, 3 rows: `desktopWidgetInstances`, `desktopWidgetGroups` and `desktopContextMenu`.
- `notificationRules`, 1 row.
- Filter lists, 5 rows: `appIdSubstitutions`, `mediaExcludePlayers`, `nightModeExcludedApps`, `wellbeingAppLimits` and `screenPreferences`.

### Phase 3: widget and dashboard fields

What must exist first: a descriptor for each of the 16 bar widget option pages and each dashboard card option set, so the option rows are generated from those descriptors rather than written by hand. App theming templates also need a descriptor per template, plus a rebuild-only path for the files those templates write outside the settings store.

This phase closes gaps 10, 13 and 14. It closes **278 uncovered rows**:

- Bar widget options, 178 `widget_option` rows.
- Dashboard options, 64 `dashOptions` rows.
- App theming, 36 `theme_apps` rows.

## Change log

### 2026-10-28: settings batch

Added 35 scalar template paths under `desktop.ojuny.dux`; 34 map to CSV rows that were not covered before, so the covered total moved from **496** to **530**.

| Area | Keys added | New CSV rows |
| --- | --- | ---: |
| Style (`theme_surfaces`, `personalization`) | `blurEnabled`, `blurStrength`, `blurBorderEnabled`, `blurBorderColor`, `blurBorderOpacity`, `blurForegroundLayers`, `foregroundLayerTransparency`, `blurLayerOutlineOpacity`, `blurredWallpaperLayer`, `blurWallpaperOnOverview`, `interfaceStyle`, `density`, `sectionDividerOpacity`, `radiusMode`, `fixedRadius`, `focusRingEnabled`, `focusRingWidth`, `focusRingColor`, `containerSaturation` | 19 |
| Lock (`lock_screen`) | `lockScreenShowWeather`, `lockScreenShowProfileImage`, `lockScreenShowPowerActions`, `lockScreenWallpaperFillMode` | 4 |
| Power (`power_sleep`) | `fadeToLockEnabled`, `fadeToLockGracePeriod`, `fadeToDpmsEnabled`, `fadeToDpmsGracePeriod` | 4 |
| Typography | `fontScale`, `fontWeight`, `textRenderType`, `textRenderQuality` (shared spec) | 4 |
| Launcher | `launcherEnterAction`, `centeringMode` | 2 |
| Clipboard (`config_file`) | `disabled` (already covered), `maxPinned` | 1 |

`fontScale`, `fontWeight`, `textRenderType` and `textRenderQuality` are counted once, on the Typography page, not again under Style.

A `stylix.opacity.popups` slider was added for popup opacity.

Removed from the template: `settings.fontFamily`, `settings.monoFontFamily`, `settings.displayFontFamily` and `settings.lockScreenWallpaperPath`, because `ojuny-desktop` derives them from stylix and the wallpaper set. `popupTransparency` is exposed only through the `stylix.opacity.popups` slider; the template no longer writes `settings.popupTransparency`, so the value `ojuny-desktop` derives from stylix remains the single source of truth.

## Caveats

- `lockScreenWidgetInstances` and `greeterWidgetInstances` have function defaults (`lockWidgetDefaults()`, `greeterWidgetDefaults()`); the CSV records the expression source, not a computed value. All other shared defaults are literals.
- `barConfigs.*` and `dockConfigs.*` default rows use the `default` / `dock` instance in `key`; the ojuny path keeps `<id>` because the option applies to every instance.
- Widget option paths use `barConfigs.<id>.widgets.<widgetType>.<field>`; the actual storage is the widget entry inside `leftWidgets`/`centerWidgets`/`rightWidgets` (or the dock widget list).
- `dashOptions` rows cover the built-in registry options. Plugin-provided dashboard options (`plugin.json` `dash` entries) are dynamic and are not enumerated.
- Third-party plugin settings (`plugins.<id>.settings.*`) are plugin-defined and not part of this matrix.
- `runtime_only` rows are things a user should not set declaratively; their `ojuny_option_path` is intentionally empty.
