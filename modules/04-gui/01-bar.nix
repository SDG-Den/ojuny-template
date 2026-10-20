/*
  @menu
  displayname = "Bar";
  icon = "view-list-symbolic";
  order = 10;
  description = "Bar layout, widgets and island style";
  category = "04-GUI";
*/

/*
  Bar widget catalog. One @widget-preset per widget DMS ships; presets with
  an options file in BarWidgetCatalog.qml also carry @widget-preset-field
  markers describing the settings the editor renders in the cog pop-out.
*/
/* @widget-preset
  id = "layout"; label = "Layout";
  description = "Display and switch MangoWC layouts";
  icon = "view-grid-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "launcherButton"; label = "App launcher";
  description = "Quick access to application launcher";
  icon = "view-app-grid-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.launcherLogoMode = "apps";
  defaults.launcherLogoSizeOffset = 0;
*/
/* @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoMode";
  widget = "dropdown"; choices = [ "apps" "os" "custom" ];
  label = "Logo"; description = "Which logo the launcher button shows.";
*/
/* @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoSizeOffset";
  widget = "spin"; min = -20; max = 20; unit = "px";
  label = "Logo size offset"; description = "Grow or shrink the launcher logo.";
*/
/* @widget-preset
  id = "workspaceSwitcher"; label = "Workspace switcher";
  description = "Shows current workspace and allows switching";
  icon = "view-dual-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.showOccupiedWorkspacesOnly = true;
  defaults.showWorkspaceIndex = true;
  defaults.showWorkspacePadding = true;
  defaults.workspacePaddingCount = 5;
  defaults.dwlShowAllTags = false;
*/
/* @widget-preset-field
  preset = "workspaceSwitcher"; name = "showOccupiedWorkspacesOnly";
  widget = "switch"; label = "Show occupied workspaces only";
  description = "Only list workspaces that have open windows.";
*/
/* @widget-preset-field
  preset = "workspaceSwitcher"; name = "showWorkspaceIndex";
  widget = "switch"; label = "Show workspace index";
*/
/* @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspacePaddingCount";
  widget = "spin"; min = 0; max = 20;
  label = "Workspace padding count";
*/
/* @widget-preset-field
  preset = "workspaceSwitcher"; name = "dwlShowAllTags";
  widget = "switch"; label = "Show all tags";
  description = "DWL only: list every tag instead of occupied ones.";
*/
/* @widget-preset
  id = "focusedWindow"; label = "Focused window";
  description = "Display currently focused application title";
  icon = "focus-windows-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.focusedWindowCompactMode = false;
  defaults.focusedWindowShowIcon = true;
  defaults.focusedWindowSize = 1;
*/
/* @widget-preset-field
  preset = "focusedWindow"; name = "focusedWindowCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/* @widget-preset-field
  preset = "focusedWindow"; name = "focusedWindowShowIcon";
  widget = "switch"; label = "Show icon";
*/
/* @widget-preset-field
  preset = "focusedWindow"; name = "focusedWindowSize";
  widget = "spin"; min = 0; max = 3; label = "Size";
*/
/* @widget-preset
  id = "runningApps"; label = "Running apps";
  description = "Shows all running applications with focus indication";
  icon = "view-app-grid-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
*/
/* @widget-preset-field
  preset = "runningApps"; name = "runningAppsCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/* @widget-preset-field
  preset = "runningApps"; name = "runningAppsGroupByApp";
  widget = "switch"; label = "Group by app";
*/
/* @widget-preset-field
  preset = "runningApps"; name = "runningAppsCurrentWorkspace";
  widget = "switch"; label = "Current workspace";
  description = "Only show apps from the active workspace.";
*/
/* @widget-preset-field
  preset = "runningApps"; name = "runningAppsCurrentMonitor";
  widget = "switch"; label = "Current display";
  description = "Only show apps from the same monitor.";
*/
/* @widget-preset
  id = "appsDock"; label = "Apps dock";
  description = "Pinned and running apps with drag-and-drop";
  icon = "view-list-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
*/
/* @widget-preset-field
  preset = "appsDock"; name = "barMaxVisibleApps";
  widget = "spin"; min = 0; max = 20; label = "Max visible apps";
  description = "0 shows every pinned app.";
*/
/* @widget-preset-field
  preset = "appsDock"; name = "barShowOverflowBadge";
  widget = "switch"; label = "Show overflow badge";
*/
/* @widget-preset-field
  preset = "appsDock"; name = "appsDockIconSizePercentage";
  widget = "spin"; min = 50; max = 200; unit = "%"; label = "Icon size";
*/
/* @widget-preset
  id = "island"; label = "Island";
  description = "Live activities that grow out of the bar";
  icon = "view-pin-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.islandFloating = false;
  defaults.islandPlacement = "edge";
  defaults.islandReserveThickness = 40;
*/
/* @widget-preset-field
  preset = "island"; name = "islandFloating";
  widget = "switch"; label = "Floating";
  description = "Detach the island from the bar edge.";
*/
/* @widget-preset-field
  preset = "island"; name = "islandPlacement";
  widget = "dropdown"; choices = [ "edge" "free" ]; label = "Placement";
*/
/* @widget-preset-field
  preset = "island"; name = "islandReserveThickness";
  widget = "spin"; min = 0; max = 200; unit = "px"; label = "Reserve thickness";
*/
/* @widget-preset
  id = "clock"; label = "Clock";
  description = "Current time and date display";
  icon = "clock-applet-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.clockDateOrder = "timeFirst";
*/
/* @widget-preset-field
  preset = "clock"; name = "clockCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/* @widget-preset-field
  preset = "clock"; name = "clockDateOrder";
  widget = "dropdown"; choices = [ "timeFirst" "dateFirst" ]; label = "Order";
  description = "Whether the time or the date comes first.";
*/
/* @widget-preset-field
  preset = "clock"; name = "clockNotificationBadge";
  widget = "switch"; label = "Notification badge";
  description = "Show the unread notification count next to the time.";
*/
/* @widget-preset
  id = "weather"; label = "Weather";
  description = "Current weather conditions and temperature";
  icon = "weather-clear-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "music"; label = "Media";
  description = "Now playing and media controls";
  icon = "audio-x-generic-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.mediaStyle = "controls";
  defaults.audioScrollMode = "volume";
*/
/* @widget-preset-field
  preset = "music"; name = "mediaStyle";
  widget = "dropdown"; choices = [ "controls" "activity" ]; label = "Style";
*/
/* @widget-preset-field
  preset = "music"; name = "mediaSize";
  widget = "spin"; min = 0; max = 3; label = "Size";
*/
/* @widget-preset-field
  preset = "music"; name = "audioScrollMode";
  widget = "dropdown"; choices = [ "volume" "song" "nothing" ]; label = "Scroll wheel";
*/
/* @widget-preset-field
  preset = "music"; name = "mediaShowCoverArt";
  widget = "switch"; label = "Cover art";
*/
/* @widget-preset
  id = "clipboard"; label = "Clipboard manager";
  description = "Access clipboard history";
  icon = "edit-paste-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "cpuUsage"; label = "CPU usage";
  description = "CPU usage indicator";
  icon = "cpu-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.minimumWidth = true;
*/
/* @widget-preset-field
  preset = "cpuUsage"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
  description = "Keep a dynamic minimum width.";
*/
/* @widget-preset
  id = "memUsage"; label = "Memory usage";
  description = "Memory usage indicator";
  icon = "memory-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.minimumWidth = true;
*/
/* @widget-preset-field
  preset = "memUsage"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/* @widget-preset-field
  preset = "memUsage"; name = "showSwap";
  widget = "switch"; label = "Show swap";
*/
/* @widget-preset-field
  preset = "memUsage"; name = "showInGb";
  widget = "switch"; label = "Show in GB";
*/
/* @widget-preset
  id = "diskUsage"; label = "Disk usage";
  description = "Percentage";
  icon = "drive-harddisk-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.mountPath = "/";
  defaults.showMountPath = true;
*/
/* @widget-preset-field
  preset = "diskUsage"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/* @widget-preset-field
  preset = "diskUsage"; name = "mountPath";
  widget = "text"; label = "Mount";
  description = "Filesystem path to report.";
*/
/* @widget-preset-field
  preset = "diskUsage"; name = "diskUsageMode";
  widget = "spin"; min = 0; max = 3; label = "Disk usage format";
*/
/* @widget-preset-field
  preset = "diskUsage"; name = "showMountPath";
  widget = "switch"; label = "Show mount path";
*/
/* @widget-preset
  id = "cpuTemp"; label = "CPU temperature";
  description = "CPU temperature display";
  icon = "temp-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.minimumWidth = true;
*/
/* @widget-preset-field
  preset = "cpuTemp"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/* @widget-preset
  id = "gpuTemp"; label = "GPU temperature";
  description = "GPU temperature display";
  icon = "sensors-temperature-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.minimumWidth = true;
  defaults.selectedGpuIndex = 0;
*/
/* @widget-preset-field
  preset = "gpuTemp"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/* @widget-preset-field
  preset = "gpuTemp"; name = "selectedGpuIndex";
  widget = "spin"; min = 0; max = 8; label = "GPU";
  description = "Index of the GPU to monitor.";
*/
/* @widget-preset-field
  preset = "gpuTemp"; name = "pciId";
  widget = "text"; label = "PCI id";
  description = "Stable GPU identifier; set automatically when the index changes.";
*/
/* @widget-preset
  id = "systemTray"; label = "System tray";
  description = "System notification area icons";
  icon = "notifications-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.trayPopupSingleLine = true;
  defaults.trayAutoOverflow = true;
*/
/* @widget-preset-field
  preset = "systemTray"; name = "trayUseInlineExpansion";
  widget = "switch"; label = "Use inline expansion";
  description = "Hidden icons expand in place instead of in a popup.";
*/
/* @widget-preset-field
  preset = "systemTray"; name = "trayPopupSingleLine";
  widget = "switch"; label = "Single-line popup";
*/
/* @widget-preset-field
  preset = "systemTray"; name = "trayAutoOverflow";
  widget = "switch"; label = "Auto overflow";
*/
/* @widget-preset-field
  preset = "systemTray"; name = "trayMaxVisibleItems";
  widget = "spin"; min = 0; max = 20; label = "Max visible";
  description = "0 lets the tray decide.";
*/
/* @widget-preset-field
  preset = "systemTray"; name = "trayIconSpacing";
  widget = "spin"; min = 0; max = 20; unit = "px"; label = "Icon spacing";
*/
/* @widget-preset
  id = "privacyIndicator"; label = "Privacy indicator";
  description = "Shows when microphone, camera, or screen sharing is active";
  icon = "media-record-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
*/
/* @widget-preset-field
  preset = "privacyIndicator"; name = "privacyShowMicIcon";
  widget = "switch"; label = "Microphone";
*/
/* @widget-preset-field
  preset = "privacyIndicator"; name = "privacyShowCameraIcon";
  widget = "switch"; label = "Camera";
*/
/* @widget-preset-field
  preset = "privacyIndicator"; name = "privacyShowScreenShareIcon";
  widget = "switch"; label = "Screen sharing";
*/
/* @widget-preset
  id = "controlCenterButton"; label = "Control Center";
  description = "Access to system controls and settings";
  icon = "preferences-system-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.showAudioPercent = true;
  defaults.showBatteryIcon = true;
  defaults.showBrightnessIcon = true;
  defaults.showBrightnessPercent = true;
  defaults.showDoNotDisturbIcon = true;
  defaults.showIdleInhibitorIcon = true;
  defaults.showMicIcon = true;
  defaults.showMicPercent = true;
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showNetworkIcon";
  widget = "switch"; label = "Show network icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showVpnIcon";
  widget = "switch"; label = "Show VPN icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showBluetoothIcon";
  widget = "switch"; label = "Show Bluetooth icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showAudioIcon";
  widget = "switch"; label = "Show audio icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showAudioPercent";
  widget = "switch"; label = "Show audio percent";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showMicIcon";
  widget = "switch"; label = "Show microphone icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showMicPercent";
  widget = "switch"; label = "Show microphone percent";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showBrightnessIcon";
  widget = "switch"; label = "Show brightness icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showBrightnessPercent";
  widget = "switch"; label = "Show brightness percent";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showBatteryIcon";
  widget = "switch"; label = "Show battery icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showPrinterIcon";
  widget = "switch"; label = "Show printer icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showScreenSharingIcon";
  widget = "switch"; label = "Show screen sharing icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showIdleInhibitorIcon";
  widget = "switch"; label = "Show idle inhibitor icon";
*/
/* @widget-preset-field
  preset = "controlCenterButton"; name = "showDoNotDisturbIcon";
  widget = "switch"; label = "Show do not disturb icon";
*/
/* @widget-preset
  id = "notificationButton"; label = "Notification Center";
  description = "Access to notifications and do not disturb";
  icon = "notifications-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "battery"; label = "Battery";
  description = "Battery and power management";
  icon = "battery-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.showBatteryPercent = true;
  defaults.batteryStyle = "icon";
*/
/* @widget-preset-field
  preset = "battery"; name = "showBatteryPercent";
  widget = "switch"; label = "Show percentage";
*/
/* @widget-preset-field
  preset = "battery"; name = "showBatteryPercentOnlyOnBattery";
  widget = "switch"; label = "Only on battery";
  description = "Hide the percentage while charging.";
*/
/* @widget-preset-field
  preset = "battery"; name = "showBatteryTime";
  widget = "switch"; label = "Show remaining time";
*/
/* @widget-preset-field
  preset = "battery"; name = "batteryStyle";
  widget = "dropdown"; choices = [ "icon" "solid" "outline" "ring" "duo" ];
  label = "Battery style";
*/
/* @widget-preset
  id = "vpn"; label = "VPN";
  description = "VPN status and quick connect";
  icon = "network-vpn-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "idleInhibitor"; label = "Idle inhibitor";
  description = "Prevent screen timeout";
  icon = "my-caffeine-on-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "capsLockIndicator"; label = "Caps Lock indicator";
  description = "Shows when caps lock is active";
  icon = "caps-lock-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "spacer"; label = "Spacer";
  description = "Customizable empty space";
  icon = "view-more-horizontal-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
  defaults.size = 20;
*/
/* @widget-preset
  id = "separator"; label = "Separator";
  description = "Visual divider between widgets";
  icon = "list-remove-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "network_speed_monitor"; label = "Network speed monitor";
  description = "Network download and upload speed display";
  icon = "network-transmit-receive-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
*/
/* @widget-preset-field
  preset = "network_speed_monitor"; name = "hideWhenIdle";
  widget = "switch"; label = "Hide when idle";
  description = "While download and upload are both under 1 KB/s.";
*/
/* @widget-preset-field
  preset = "network_speed_monitor"; name = "compactMode";
  widget = "switch"; label = "Compact mode";
  description = "Whole numbers, at most three digits.";
*/
/* @widget-preset
  id = "keyboard_layout_name"; label = "Keyboard layout";
  description = "Displays the active keyboard layout and allows switching";
  icon = "input-keyboard-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
*/
/* @widget-preset-field
  preset = "keyboard_layout_name"; name = "keyboardLayoutNameCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/* @widget-preset-field
  preset = "keyboard_layout_name"; name = "keyboardLayoutNameShowIcon";
  widget = "switch"; label = "Show icon";
*/
/* @widget-preset
  id = "notepadButton"; label = "Notepad";
  description = "Quick access to notepad";
  icon = "text-editor-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "colorPicker"; label = "Color Picker";
  description = "Quick access to color picker";
  icon = "color-select-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/
/* @widget-preset
  id = "systemUpdate"; label = "System update";
  description = "Check for system updates";
  icon = "software-update-available-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
*/
/* @widget-preset-field
  preset = "systemUpdate"; name = "hideWhenIdle";
  widget = "switch"; label = "Hide when no updates";
*/
/* @widget-preset
  id = "powerMenuButton"; label = "Power";
  description = "Display the power system menu";
  icon = "system-shutdown-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = false;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-bar = { config, pkgs, ... }: {

    # Bar
    # @option widget = "bar"; label = "Bar";
    desktop.ojuny.dms.barConfigs.default = {

      # @option widget = "switch"; label = "Enabled"; group = "Bar"; groupOrder = 10; description = "Turn this bar on at startup.";
      enabled = true;

      # @option widget = "text"; label = "Name"; group = "Bar"; groupOrder = 10; description = "Display name for this bar.";
      name = "Main Bar";

      # @option widget = "dropdown"; label = "Position"; group = "Bar"; groupOrder = 10; choices = [ "0" "1" "2" "3" ]; description = "Screen edge: 0 = top, 1 = bottom, 2 = left, 3 = right.";
      position = 0;

      # @option widget = "switch"; label = "Visible"; group = "Bar"; groupOrder = 10; description = "Show the bar when it is enabled.";
      visible = true;

      # @option widget = "switch"; label = "Show on last display"; group = "Bar"; groupOrder = 10; description = "Keep the bar on the display it was last shown on.";
      showOnLastDisplay = true;

      # @option widget = "list"; label = "Screens"; group = "Bar"; groupOrder = 10; hidden = true; description = "Screen names, or \"all\".";
      screenPreferences = [ "all" ];

      /* @option label = "Center widgets"; description = "Widgets shown in the bar centre. Position is the tile order. The island widget displaces centre widgets."; */
      centerWidgets = [
        "music"
        "clock"
        "weather"
      ];

      # @option widget = "switch"; label = "Show on overview"; group = "Bar"; groupOrder = 10; description = "Keep the bar visible while the overview is open.";
      openOnOverview = false;

      # @option widget = "spin"; label = "Order"; group = "Bar"; groupOrder = 10; min = 1; max = 1000; hidden = true; description = "Sort order when several bars exist.";
      _order = 10;

      # @option widget = "switch"; label = "Auto hide"; group = "Auto hide"; groupOrder = 20; description = "Hide the bar until the pointer reaches the screen edge.";
      autoHide = false;

      # @option widget = "spin"; label = "Auto hide delay"; group = "Auto hide"; groupOrder = 20; min = 0; max = 5000; unit = "ms"; description = "Delay before the bar hides again."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.autoHide"; visibleWhen.equals = true;
      autoHideDelay = 250;

      # @option widget = "switch"; label = "Attach to screen edge"; group = "Bar"; groupOrder = 10; description = "Snap the bar flush to the screen edge instead of floating.";
      attachToScreenEdge = false;

      # @option widget = "switch"; label = "Use overlay layer"; group = "Bar"; groupOrder = 10; advanced = true; description = "Draw the bar on the overlay layer so windows can overlap it.";
      useOverlayLayer = false;

      # @option widget = "slider"; label = "Transparency"; group = "Transparency"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar background.";
      transparency = 1;

      # @option widget = "slider"; label = "Widget transparency"; group = "Transparency"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar widgets.";
      widgetTransparency = 1;

      # @option widget = "slider"; label = "Icon scale"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0.5; max = 2.0; step = 0.05; description = "Multiplier for widget icon sizes.";
      iconScale = 0.9;

      # @option widget = "slider"; label = "Font scale"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0.5; max = 2.0; step = 0.05; description = "Multiplier for bar font sizes.";
      fontScale = 0.9;

      # @option widget = "spin"; label = "Spacing"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Gap between widgets.";
      spacing = 0;

      # @option widget = "spin"; label = "Bottom gap"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 100; unit = "px"; description = "Gap between the bar and its screen edge.";
      bottomGap = 0;

      # @option widget = "spin"; label = "Inner padding"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Padding inside the bar around its content.";
      innerPadding = 0;

      # @option widget = "spin"; label = "Widget padding"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Padding around each widget.";
      widgetPadding = 9;

      # @option widget = "switch"; label = "Square corners"; group = "Appearance"; groupOrder = 35; description = "Use square bar corners instead of rounded ones.";
      squareCorners = true;

      # @option widget = "switch"; label = "No background"; group = "Appearance"; groupOrder = 35; description = "Draw no background surface; widgets sit directly on the wallpaper.";
      noBackground = false;

      # @option widget = "switch"; label = "Widget outline"; group = "Appearance"; groupOrder = 35; description = "Draw an outline around each widget.";
      widgetOutlineEnabled = true;

      # @option widget = "switch"; label = "Border"; group = "Appearance"; groupOrder = 35; description = "Draw a border around the bar.";
      borderEnabled = false;

      # @option widget = "dropdown"; label = "Border color"; group = "Appearance"; groupOrder = 35; choices = [ "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role used for the bar border. sch = scheme high surface, s = surface."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.borderEnabled"; visibleWhen.equals = true;
      borderColor = "primary";

      # @option widget = "slider"; label = "Border opacity"; group = "Appearance"; groupOrder = 35; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar border."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.borderEnabled"; visibleWhen.equals = true;
      borderOpacity = 1;

      # @option widget = "spin"; label = "Shadow intensity"; group = "Appearance"; groupOrder = 35; min = 0; max = 100; description = "Strength of the bar drop shadow.";
      shadowIntensity = 0;

      # @option widget = "spin"; label = "Shadow opacity"; group = "Appearance"; groupOrder = 35; min = 0; max = 100; unit = "%"; description = "Opacity of the bar drop shadow in percent.";
      shadowOpacity = 60;

      # @option widget = "switch"; label = "Automatic popup gaps"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; description = "Compute popup gap size from the bar layout automatically.";
      popupGapsAuto = true;

      # @option widget = "spin"; label = "Popup gap"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Popup gap size when automatic gaps are off."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.popupGapsAuto"; visibleWhen.equals = false;
      popupGapsManual = 4;

      # @option widget = "switch"; label = "Island"; group = "Island"; groupOrder = 40; description = "Draw the bar as a floating island detached from the screen edge.";
      island = true;

      # @option widget = "spin"; label = "Compact thickness"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Island thickness in compact mode.";
      islandCompactThickness = 31;

      # @option widget = "spin"; label = "Outer gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Gap between the island and the screen edge.";
      islandOuterGap = 3;

      # @option widget = "spin"; label = "Satellite gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Gap between the island and its satellite popouts.";
      islandSatelliteGap = 8;

      # @option widget = "spin"; label = "Satellite hover gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Extra satellite gap while the island is hovered.";
      islandSatelliteHoverGap = 5;

      # @option widget = "spin"; label = "Satellite hover size"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Satellite size while the island is hovered.";
      islandSatelliteHoverSize = 30;

      # @option widget = "spin"; label = "Satellite hover size expanded"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Expanded satellite size while the island is hovered.";
      islandSatelliteHoverSizeExpanded = 24;

      # @option widget = "spin"; label = "Satellite size"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Size of the satellite popouts around the island.";
      islandSatelliteSize = 26;

      # @option widget = "spin"; label = "Satellite size expanded"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Expanded size of the satellite popouts.";
      islandSatelliteSizeExpanded = 20;

      # @option widget = "spin"; label = "Hover open delay"; group = "Island"; groupOrder = 40; min = 0; max = 2000; unit = "ms"; description = "Delay before a hovered satellite opens.";
      islandHoverOpenDelay = 350;

      # @option widget = "spin"; label = "Hover close delay"; group = "Island"; groupOrder = 40; min = 0; max = 2000; unit = "ms"; description = "Delay before a hovered satellite closes.";
      islandHoverCloseDelay = 350;

      # @option widget = "spin"; label = "Widget padding"; group = "Island"; groupOrder = 40; min = 0; max = 40; unit = "px"; description = "Padding around widgets inside the island.";
      islandWidgetPadding = 0;

      # @option widget = "switch"; label = "Widget outline"; group = "Island"; groupOrder = 40; description = "Outline the widgets inside the island.";
      islandWidgetOutlineEnabled = true;

      # @option widget = "dropdown"; label = "Widget outline color"; group = "Island"; groupOrder = 40; choices = [ "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role used for the island widget outline. surfaceText = on-background text."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
      islandWidgetOutlineColor = "surfaceText";

      # @option widget = "slider"; label = "Widget outline opacity"; group = "Island"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the island widget outline."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
      islandWidgetOutlineOpacity = 0.5;

      # @option widget = "switch"; label = "Bar goth corners"; group = "Appearance"; groupOrder = 35; description = "Square off the regular (non-island) bar corners instead of rounding them.";
      gothCornersEnabled = false;

      # @option widget = "switch"; label = "Override bar goth corner radius"; group = "Appearance"; groupOrder = 35; description = "Use a custom radius for the bar's goth corners."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.gothCornersEnabled"; visibleWhen.equals = true;
      gothCornerRadiusOverride = false;

      # @option widget = "spin"; label = "Bar goth corner radius"; group = "Appearance"; groupOrder = 35; min = 0; max = 100; unit = "px"; description = "Radius of the bar's goth corners."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.gothCornerRadiusOverride"; visibleWhen.equals = true;
      gothCornerRadiusValue = 12;

      # @option widget = "switch"; label = "Island goth corners"; group = "Island"; groupOrder = 40; description = "Square off the island's corners instead of rounding them.";
      islandGothCornersEnabled = false;

      # @option widget = "switch"; label = "Override island goth corner radius"; group = "Island"; groupOrder = 40; description = "Use a custom radius for the island's goth corners."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornersEnabled"; visibleWhen.equals = true;
      islandGothCornerRadiusOverride = false;

      # @option widget = "spin"; label = "Island goth corner radius"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Radius of the island's goth corners."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornerRadiusOverride"; visibleWhen.equals = true;
      islandGothCornerRadiusValue = 20;

      /* @option label = "Left widgets"; description = "Widgets shown on the left of the bar. Position is the tile order."; */
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

        dankKDEConnect = {
          enabled = true;
          _order = 20;
        };

        layout = {
          enabled = true;
          _order = 30;
        };

        scratchpadHelper = {
          enabled = true;
          _order = 40;
        };

      };

      /* @option label = "Right widgets"; description = "Widgets shown on the right of the bar. Position is the tile order."; */
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

        nixMonitor = {
          enabled = true;
          _order = 40;
        };

        localServices = {
          enabled = true;
          _order = 50;
        };

        controlCenterButton = {
          enabled = true;
          showAudioPercent = true;
          showBatteryIcon = true;
          showBrightnessIcon = true;
          showBrightnessPercent = true;
          showDoNotDisturbIcon = true;
          showIdleInhibitorIcon = true;
          showMicIcon = true;
          showMicPercent = true;
          _order = 60;
        };

      };

    };

    # @option widget = "switch"; label = "Elevation shadow"; group = "Bar"; advanced = true; description = "Draw a drop shadow under the bar.";
    desktop.ojuny.dms.settings.barElevationEnabled = false;

  };

}
