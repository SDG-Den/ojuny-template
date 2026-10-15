/*
  @menu
  displayname = "Bar";
  icon = "view-list-symbolic";
  order = 50;
  description = "Bar layout, widgets and island style";
  category = "Desktop";
*/

/*
  @snippet
  name = "bar-widget-left";
  label = "Add left widget";
  snippet = ''
    # @option widget = "submodule"; label = "%%label%%"; group = "Left widgets";
    desktop.ojuny.dms.barConfigs.default.leftWidgets.%%id%% = {
      # @option widget = "switch"; label = "Enabled"; group = "Left widgets";
      enabled = true;
      # @option widget = "spin"; label = "Order"; group = "Left widgets"; min = 1; max = 100; hidden = true;
      _order = %%order%%;
    };
  '';
  placeholders.id.label = "Widget ID";
  placeholders.id.default = "myWidget";
  placeholders.label.label = "Label";
  placeholders.label.default = "My widget";
  placeholders.order.label = "Order";
  placeholders.order.default = "15";
*/

/*
  @snippet
  name = "bar-widget-right";
  label = "Add right widget";
  snippet = ''
    # @option widget = "submodule"; label = "%%label%%"; group = "Right widgets";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.%%id%% = {
      # @option widget = "switch"; label = "Enabled"; group = "Right widgets";
      enabled = true;
      # @option widget = "spin"; label = "Order"; group = "Right widgets"; min = 1; max = 100; hidden = true;
      _order = %%order%%;
    };
  '';
  placeholders.id.label = "Widget ID";
  placeholders.id.default = "myWidget";
  placeholders.label.label = "Label";
  placeholders.label.default = "My widget";
  placeholders.order.label = "Order";
  placeholders.order.default = "15";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-bar = { config, pkgs, ... }: {

    # Bar
    # @option widget = "switch"; label = "Enabled"; group = "Bar";
    desktop.ojuny.dms.barConfigs.default.enabled = true;

    # @option widget = "text"; label = "Name"; group = "Bar"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.name = "Main Bar";

    # @option widget = "switch"; label = "Elevation shadow"; group = "Bar"; advanced = true; description = "Draw a drop shadow under the bar.";
    desktop.ojuny.dms.settings.barElevationEnabled = false;

    # @option widget = "spin"; label = "Position"; group = "Bar"; min = 0; max = 1; step = 1; description = "0 = top, 1 = bottom.";
    desktop.ojuny.dms.barConfigs.default.position = 0;

    # @option widget = "switch"; label = "Visible"; group = "Bar";
    desktop.ojuny.dms.barConfigs.default.visible = true;

    # @option widget = "switch"; label = "Show on last display"; group = "Bar"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.showOnLastDisplay = true;

    # @option widget = "list"; label = "Screens"; group = "Bar"; description = "Screen names, or \"all\"."; hidden = true;
    desktop.ojuny.dms.barConfigs.default.screenPreferences = [ "all" ];

    # @option widget = "list"; label = "Center widgets"; group = "Bar"; description = "Widget ids shown in the center.";
    desktop.ojuny.dms.barConfigs.default.centerWidgets = [
      "music"
      "clock"
      "weather"
    ];

    # @option widget = "switch"; label = "Show on overview"; group = "Bar"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.openOnOverview = false;

    # @option widget = "spin"; label = "Order"; group = "Bar"; min = 1; max = 1000; hidden = true;
    desktop.ojuny.dms.barConfigs.default._order = 10;

    # Behaviour
    # @option widget = "switch"; label = "Auto hide"; group = "Behaviour";
    desktop.ojuny.dms.barConfigs.default.autoHide = false;

    # @option widget = "spin"; label = "Auto hide delay"; group = "Behaviour"; min = 0; max = 2000; step = 50; unit = "ms"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.autoHide"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.autoHideDelay = 250;

    # @option widget = "switch"; label = "Attach to screen edge"; group = "Behaviour"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.attachToScreenEdge = false;

    # @option widget = "switch"; label = "Use overlay layer"; group = "Behaviour"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.useOverlayLayer = false;

    # Sizing
    # @option widget = "slider"; label = "Transparency"; group = "Sizing"; min = 0.0; max = 1.0; step = 0.05;
    desktop.ojuny.dms.barConfigs.default.transparency = 1;

    # @option widget = "slider"; label = "Widget transparency"; group = "Sizing"; min = 0.0; max = 1.0; step = 0.05;
    desktop.ojuny.dms.barConfigs.default.widgetTransparency = 1;

    # @option widget = "slider"; label = "Icon scale"; group = "Sizing"; min = 0.5; max = 2.0; step = 0.05;
    desktop.ojuny.dms.barConfigs.default.iconScale = 0.9;

    # @option widget = "slider"; label = "Font scale"; group = "Sizing"; min = 0.5; max = 2.0; step = 0.05;
    desktop.ojuny.dms.barConfigs.default.fontScale = 0.9;

    # @option widget = "spin"; label = "Spacing"; group = "Sizing"; min = 0; max = 40; unit = "px";
    desktop.ojuny.dms.barConfigs.default.spacing = 0;

    # @option widget = "spin"; label = "Bottom gap"; group = "Sizing"; min = 0; max = 40; unit = "px"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.bottomGap = 0;

    # @option widget = "spin"; label = "Inner padding"; group = "Sizing"; min = 0; max = 40; unit = "px"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.innerPadding = 0;

    # @option widget = "spin"; label = "Widget padding"; group = "Sizing"; min = 0; max = 40; unit = "px";
    desktop.ojuny.dms.barConfigs.default.widgetPadding = 9;

    # Appearance
    # @option widget = "switch"; label = "Square corners"; group = "Appearance";
    desktop.ojuny.dms.barConfigs.default.squareCorners = true;

    # @option widget = "switch"; label = "No background"; group = "Appearance";
    desktop.ojuny.dms.barConfigs.default.noBackground = false;

    # @option widget = "switch"; label = "Widget outline"; group = "Appearance";
    desktop.ojuny.dms.barConfigs.default.widgetOutlineEnabled = true;

    # @option widget = "switch"; label = "Border"; group = "Appearance";
    desktop.ojuny.dms.barConfigs.default.borderEnabled = false;

    # @option widget = "text"; label = "Border color"; group = "Appearance"; description = "Theme role or hex."; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.borderEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.borderColor = "primary";

    # @option widget = "slider"; label = "Border opacity"; group = "Appearance"; min = 0.0; max = 1.0; step = 0.05; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.borderEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.borderOpacity = 1;

    # @option widget = "spin"; label = "Shadow intensity"; group = "Appearance"; min = 0; max = 100; hidden = true;
    desktop.ojuny.dms.barConfigs.default.shadowIntensity = 0;

    # @option widget = "spin"; label = "Shadow opacity"; group = "Appearance"; min = 0; max = 100; hidden = true;
    desktop.ojuny.dms.barConfigs.default.shadowOpacity = 60;

    # @option widget = "switch"; label = "Popup gaps (auto)"; group = "Appearance"; hidden = true;
    desktop.ojuny.dms.barConfigs.default.popupGapsAuto = true;

    # @option widget = "spin"; label = "Popup gaps (manual)"; group = "Appearance"; min = 0; max = 40; unit = "px"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.popupGapsAuto"; visibleWhen.equals = false;
    desktop.ojuny.dms.barConfigs.default.popupGapsManual = 4;

    # Island
    # @option widget = "switch"; label = "Island style"; group = "Island";
    desktop.ojuny.dms.barConfigs.default.island = true;

    # @option widget = "spin"; label = "Thickness"; group = "Island"; min = 0; max = 80; unit = "px"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandCompactThickness = 31;

    # @option widget = "spin"; label = "Outer gap"; group = "Island"; min = 0; max = 40; unit = "px"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandOuterGap = 3;

    # @option widget = "spin"; label = "Satellite gap"; group = "Island"; min = 0; max = 40; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandSatelliteGap = 8;

    # @option widget = "spin"; label = "Satellite hover gap"; group = "Island"; min = 0; max = 40; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandSatelliteHoverGap = 5;

    # @option widget = "spin"; label = "Satellite hover size"; group = "Island"; min = 0; max = 80; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandSatelliteHoverSize = 30;

    # @option widget = "spin"; label = "Satellite hover size expanded"; group = "Island"; min = 0; max = 80; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandSatelliteHoverSizeExpanded = 24;

    # @option widget = "spin"; label = "Satellite size"; group = "Island"; min = 0; max = 80; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandSatelliteSize = 26;

    # @option widget = "spin"; label = "Satellite size expanded"; group = "Island"; min = 0; max = 80; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandSatelliteSizeExpanded = 20;

    # @option widget = "spin"; label = "Hover open delay"; group = "Island"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandHoverOpenDelay = 350;

    # @option widget = "spin"; label = "Hover close delay"; group = "Island"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandHoverCloseDelay = 350;

    # @option widget = "spin"; label = "Widget padding"; group = "Island"; min = 0; max = 40; unit = "px"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandWidgetPadding = 0;

    # @option widget = "switch"; label = "Widget outline"; group = "Island"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled = true;

    # @option widget = "text"; label = "Widget outline color"; group = "Island"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineColor = "surfaceText";

    # @option widget = "slider"; label = "Widget outline opacity"; group = "Island"; min = 0.0; max = 1.0; step = 0.05; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.island"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineOpacity = 0.5;

    # Goth corners
    # @option widget = "switch"; label = "Goth corners"; group = "Goth corners";
    desktop.ojuny.dms.barConfigs.default.gothCornersEnabled = false;

    # @option widget = "switch"; label = "Override radius"; group = "Goth corners"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.gothCornersEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.gothCornerRadiusOverride = false;

    # @option widget = "spin"; label = "Radius"; group = "Goth corners"; min = 0; max = 60; unit = "px"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.gothCornerRadiusOverride"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.gothCornerRadiusValue = 12;

    # @option widget = "switch"; label = "Island goth corners"; group = "Goth corners"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.gothCornersEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandGothCornersEnabled = false;

    # @option widget = "switch"; label = "Island override radius"; group = "Goth corners"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornersEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandGothCornerRadiusOverride = false;

    # @option widget = "spin"; label = "Island radius"; group = "Goth corners"; min = 0; max = 60; unit = "px"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornerRadiusOverride"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.islandGothCornerRadiusValue = 20;

    # Left widgets
    # @option widget = "switch"; label = "Workspace switcher"; group = "Left widgets";
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.enabled = true;

    # @option widget = "spin"; label = "Workspace switcher order"; group = "Left widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher._order = 10;

    # @option widget = "switch"; label = "Workspace switcher: only occupied"; group = "Left widgets"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.showOccupiedWorkspacesOnly =
      true;

    # @option widget = "switch"; label = "Workspace switcher: show index"; group = "Left widgets"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.showWorkspaceIndex = true;

    # @option widget = "switch"; label = "Workspace switcher: pad to fixed count"; group = "Left widgets"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.showWorkspacePadding = true;

    # @option widget = "spin"; label = "Workspace switcher: padding count"; group = "Left widgets"; min = 1; max = 32; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.showWorkspacePadding"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.workspacePaddingCount = 5;

    # @option widget = "switch"; label = "Workspace switcher: DWL show all tags"; group = "Left widgets"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher.dwlShowAllTags = false;

    # @option widget = "switch"; label = "Phone connect"; group = "Left widgets";
    desktop.ojuny.dms.barConfigs.default.leftWidgets.dankKDEConnect.enabled = true;

    # @option widget = "spin"; label = "Phone connect order"; group = "Left widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.dankKDEConnect.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.dankKDEConnect._order = 20;

    # @option widget = "switch"; label = "Layout"; group = "Left widgets";
    desktop.ojuny.dms.barConfigs.default.leftWidgets.layout.enabled = true;

    # @option widget = "spin"; label = "Layout order"; group = "Left widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.layout.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.layout._order = 30;

    # @option widget = "switch"; label = "Scratchpad helper"; group = "Left widgets";
    desktop.ojuny.dms.barConfigs.default.leftWidgets.scratchpadHelper.enabled = true;

    # @option widget = "spin"; label = "Scratchpad helper order"; group = "Left widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.leftWidgets.scratchpadHelper.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.leftWidgets.scratchpadHelper._order = 40;

    /*
      @insert
      name = "bar-widget-left";
      group = "Left widgets";
      order = 1000;
    */

    # Right widgets
    # @option widget = "switch"; label = "System tray"; group = "Right widgets";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.systemTray.enabled = true;

    # @option widget = "spin"; label = "System tray order"; group = "Right widgets"; min = 1; max = 100; hidden = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.systemTray._order = 10;

    # @option widget = "switch"; label = "Clipboard"; group = "Right widgets";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.clipboard.enabled = true;

    # @option widget = "spin"; label = "Clipboard order"; group = "Right widgets"; min = 1; max = 100; hidden = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.clipboard._order = 20;

    # @option widget = "switch"; label = "Developer utilities"; group = "Right widgets";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.developerUtilities.enabled = true;

    # @option widget = "spin"; label = "Developer utilities order"; group = "Right widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.developerUtilities.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.developerUtilities._order = 30;

    # @option widget = "switch"; label = "Nix monitor"; group = "Right widgets";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.nixMonitor.enabled = true;

    # @option widget = "spin"; label = "Nix monitor order"; group = "Right widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.nixMonitor.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.nixMonitor._order = 40;

    # @option widget = "switch"; label = "Local services"; group = "Right widgets";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.localServices.enabled = true;

    # @option widget = "spin"; label = "Local services order"; group = "Right widgets"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.localServices.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.localServices._order = 50;

    # Control center button
    # @option widget = "switch"; label = "Control center button"; group = "Control center button";
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled = true;

    # @option widget = "spin"; label = "Order"; group = "Control center button"; min = 1; max = 100; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton._order = 60;

    # @option widget = "switch"; label = "Show audio percent"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showAudioPercent = true;

    # @option widget = "switch"; label = "Show battery icon"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showBatteryIcon = true;

    # @option widget = "switch"; label = "Show brightness icon"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showBrightnessIcon = true;

    # @option widget = "switch"; label = "Show brightness percent"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showBrightnessPercent = true;

    # @option widget = "switch"; label = "Show do-not-disturb icon"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showDoNotDisturbIcon = true;

    # @option widget = "switch"; label = "Show idle-inhibitor icon"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showIdleInhibitorIcon = true;

    # @option widget = "switch"; label = "Show mic icon"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showMicIcon = true;

    # @option widget = "switch"; label = "Show mic percent"; group = "Control center button"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton.showMicPercent = true;

    /*
      @insert
      name = "bar-widget-right";
      group = "Right widgets";
      order = 1000;
    */

  };

}
