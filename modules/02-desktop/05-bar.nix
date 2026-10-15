/* @menu
   displayname = "Bar";
   icon = "view-list-symbolic";
   order = 50;
   description = "Bar layout, widgets and position";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-bar = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    /* @option widget = "submodule"; label = "Main bar"; group = "Bar"; */
    desktop.ojuny.dms.barConfigs.default = {
      /* @option widget = "switch"; label = "Visible"; group = "Bar"; */
      enabled = true;

      /* @option widget = "text"; label = "Name"; group = "Bar"; */
      name = "Main Bar";

      /* @option widget = "spin"; label = "Position"; group = "Bar"; min = 0; max = 1; step = 1; description = "0 = top, 1 = bottom."; */
      position = 0;

      /* @option widget = "switch"; label = "Auto hide"; group = "Bar"; */
      autoHide = false;

      /* @option widget = "spin"; label = "Auto hide delay"; group = "Bar"; min = 0; max = 2000; step = 50; unit = "ms"; */
      autoHideDelay = 250;

      /* @option widget = "switch"; label = "Island style"; group = "Bar"; */
      island = true;

      /* @option widget = "slider"; label = "Transparency"; group = "Bar"; min = 0.0; max = 1.0; step = 0.05; */
      transparency = 1;

      /* @option widget = "slider"; label = "Icon scale"; group = "Bar"; min = 0.5; max = 2.0; step = 0.05; */
      iconScale = 0.9;

      /* @option widget = "slider"; label = "Font scale"; group = "Bar"; min = 0.5; max = 2.0; step = 0.05; */
      fontScale = 0.9;

      /* @option widget = "spin"; label = "Spacing"; group = "Bar"; min = 0; max = 40; unit = "px"; */
      spacing = 0;

      /* @option widget = "spin"; label = "Bottom gap"; group = "Bar"; min = 0; max = 40; unit = "px"; */
      bottomGap = 0;

      /* @option widget = "spin"; label = "Inner padding"; group = "Bar"; min = 0; max = 40; unit = "px"; */
      innerPadding = 0;

      /* @option widget = "spin"; label = "Widget padding"; group = "Bar"; min = 0; max = 40; unit = "px"; */
      widgetPadding = 9;

      /* @option widget = "switch"; label = "Square corners"; group = "Bar"; */
      squareCorners = true;

      /* @option widget = "switch"; label = "No background"; group = "Bar"; */
      noBackground = false;

      /* @option widget = "switch"; label = "Show on last display"; group = "Bar"; */
      showOnLastDisplay = true;

      /* @option widget = "list"; label = "Screens"; group = "Bar"; description = "Screen names, or \"all\"."; */
      screenPreferences = [ "all" ];

      /* @option widget = "submodule"; label = "Workspace switcher"; group = "Left widgets"; */
      desktop.ojuny.dms.barConfigs.default.leftWidgets.workspaceSwitcher = {
        /* @option widget = "switch"; label = "Enabled"; group = "Left widgets"; */
        enabled = true;

        /* @option widget = "spin"; label = "Order"; group = "Left widgets"; min = 1; max = 100; */
        _order = 10;

        /* @option widget = "switch"; label = "Show only occupied"; group = "Left widgets"; */
        showOccupiedWorkspacesOnly = true;

        /* @option widget = "switch"; label = "Show index"; group = "Left widgets"; */
        showWorkspaceIndex = true;

        /* @option widget = "switch"; label = "Pad to fixed count"; group = "Left widgets"; */
        showWorkspacePadding = true;

        /* @option widget = "spin"; label = "Padding count"; group = "Left widgets"; min = 1; max = 32; */
        workspacePaddingCount = 5;
      };

      /* @option widget = "submodule"; label = "Layout"; group = "Left widgets"; */
      desktop.ojuny.dms.barConfigs.default.leftWidgets.layout = {
        /* @option widget = "switch"; label = "Enabled"; group = "Left widgets"; */
        enabled = true;

        /* @option widget = "spin"; label = "Order"; group = "Left widgets"; min = 1; max = 100; */
        _order = 30;
      };

      /* @option widget = "submodule"; label = "System tray"; group = "Right widgets"; */
      desktop.ojuny.dms.barConfigs.default.rightWidgets.systemTray = {
        /* @option widget = "spin"; label = "Order"; group = "Right widgets"; min = 1; max = 100; */
        _order = 10;
      };

      /* @option widget = "submodule"; label = "Control center button"; group = "Right widgets"; */
      desktop.ojuny.dms.barConfigs.default.rightWidgets.controlCenterButton = {
        /* @option widget = "switch"; label = "Enabled"; group = "Right widgets"; */
        enabled = true;

        /* @option widget = "spin"; label = "Order"; group = "Right widgets"; min = 1; max = 100; */
        _order = 60;

        /* @option widget = "switch"; label = "Show audio percent"; group = "Right widgets"; */
        showAudioPercent = true;

        /* @option widget = "switch"; label = "Show battery icon"; group = "Right widgets"; */
        showBatteryIcon = true;

        /* @option widget = "switch"; label = "Show mic icon"; group = "Right widgets"; */
        showMicIcon = true;

        /* @option widget = "switch"; label = "Show do-not-disturb icon"; group = "Right widgets"; */
        showDoNotDisturbIcon = true;
      };
    };

    # The remaining widgets (dankKDEConnect, scratchpadHelper, clipboard,
    # developerUtilities, nixMonitor, localServices) keep their defaults; add
    # them here in the same shape to edit them.

  };

}
