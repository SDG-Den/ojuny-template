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

      _order = 10;

      autoHide = false;

      autoHideDelay = 250;

      attachToScreenEdge = false;

      useOverlayLayer = false;

      transparency = 1;

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

      island = true;

      islandCompactThickness = 31;

      islandOuterGap = 3;

      islandSatelliteGap = 8;

      islandSatelliteHoverGap = 5;

      islandSatelliteHoverSize = 30;

      islandSatelliteHoverSizeExpanded = 24;

      islandSatelliteSize = 26;

      islandSatelliteSizeExpanded = 20;

      islandHoverOpenDelay = 350;

      islandHoverCloseDelay = 350;

      islandWidgetPadding = 0;

      islandWidgetOutlineEnabled = true;

      islandWidgetOutlineColor = "surfaceText";

      islandWidgetOutlineOpacity = 0.5;

      gothCornersEnabled = false;

      gothCornerRadiusOverride = false;

      gothCornerRadiusValue = 12;

      islandGothCornersEnabled = false;

      islandGothCornerRadiusOverride = false;

      islandGothCornerRadiusValue = 20;

      /* @option label = "Left widgets"; */
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

      /* @option label = "Right widgets"; */
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
