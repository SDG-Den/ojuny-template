/*
  @menu
  displayname = "Bar";
  icon = "view-list-symbolic";
  order = 10;
  description = "Bar layout, widgets and island style";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-bar = { config, pkgs, ... }: {

    # Bar
    # @option widget = "bar"; label = "Bar";
    desktop.ojuny.dms.barConfigs.default = {

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

      openOnOverview = false;

      # @option widget = "spin"; label = "Order"; group = "Bar"; groupOrder = 10; min = 1; max = 1000; hidden = true; description = "Sort order when several bars exist.";
      _order = 10;

      # @option widget = "switch"; label = "Auto hide"; group = "Auto hide"; groupOrder = 20; description = "Hide the bar until the pointer reaches the screen edge.";
      autoHide = false;

      # @option widget = "spin"; label = "Auto hide delay"; group = "Auto hide"; groupOrder = 20; min = 0; max = 5000; unit = "ms"; description = "Delay before the bar hides again."; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.autoHide"; visibleWhen.equals = true;
      autoHideDelay = 250;

      attachToScreenEdge = false;

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

      squareCorners = true;

      noBackground = false;

      widgetOutlineEnabled = true;

      borderEnabled = false;

      borderColor = "primary";

      borderOpacity = 1;

      shadowIntensity = 0;

      shadowOpacity = 60;

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

      # @option widget = "spin"; label = "Widget padding"; group = "Island"; groupOrder = 40; min = 0; max = 40; unit = "px";
      islandWidgetPadding = 0;

      # @option widget = "switch"; label = "Widget outline"; group = "Island"; groupOrder = 40; description = "Outline the widgets inside the island.";
      islandWidgetOutlineEnabled = true;

      # @option widget = "text"; label = "Widget outline color"; group = "Island"; groupOrder = 40; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
      islandWidgetOutlineColor = "surfaceText";

      # @option widget = "slider"; label = "Widget outline opacity"; group = "Island"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
      islandWidgetOutlineOpacity = 0.5;

      gothCornersEnabled = false;

      gothCornerRadiusOverride = false;

      gothCornerRadiusValue = 12;

      # @option widget = "switch"; label = "Goth corners"; group = "Island"; groupOrder = 40; description = "Square off the island corners instead of rounding them.";
      islandGothCornersEnabled = false;

      # @option widget = "switch"; label = "Override goth corner radius"; group = "Island"; groupOrder = 40; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornersEnabled"; visibleWhen.equals = true;
      islandGothCornerRadiusOverride = false;

      # @option widget = "spin"; label = "Goth corner radius"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; visibleWhen.path = "desktop.ojuny.dms.barConfigs.default.islandGothCornerRadiusOverride"; visibleWhen.equals = true;
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
          _order = 60;
          showAudioPercent = true;
          showBatteryIcon = true;
          showBrightnessIcon = true;
          showBrightnessPercent = true;
          showDoNotDisturbIcon = true;
          showIdleInhibitorIcon = true;
          showMicIcon = true;
          showMicPercent = true;
        };

      };

    };

    # @option widget = "switch"; label = "Elevation shadow"; group = "Bar"; advanced = true; description = "Draw a drop shadow under the bar.";
    desktop.ojuny.dms.settings.barElevationEnabled = false;

  };

}
