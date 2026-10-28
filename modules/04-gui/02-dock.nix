/*
  @menu
  displayname = "Dock";
  icon = "view-app-grid-symbolic";
  order = 20;
  description = "Dock appearance and behaviour";
  category = "04-GUI";
*/

/*
  Dock widget catalog. Instance ids match the DMS widget ids so
  DockConfig.js withAppSlots stops injecting duplicate launcher/trash rows.
*/
/* @widget-preset
  id = "dockLauncher"; label = "Launcher"; description = "App launcher button";
  icon = "system-run-symbolic"; sections = [ "dock" ]; hasSettings = false;
*/
/* @widget-preset
  id = "appsDock"; label = "Apps"; description = "Pinned and running apps";
  icon = "view-list-symbolic"; sections = [ "dock" ]; hasSettings = false;
*/
/* @widget-preset
  id = "dockTrash"; label = "Trash"; description = "Trash and recent files";
  icon = "user-trash-symbolic"; sections = [ "dock" ]; hasSettings = false;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dock = { config, pkgs, ... }: {

    # Dock
    # @option widget = "dock"; label = "Dock";
    desktop.ojuny.dux.dockConfigs.dock = {
      # @option widget = "switch"; label = "Enabled"; group = "Dock"; groupOrder = 10; applyCommand = "if test %%val%% = true; then dms ipc call dock revealFor dock; else dms ipc call dock hideFor dock; fi";
      enabled = false;

      # @option widget = "text"; label = "Name"; group = "Dock"; groupOrder = 10; hidden = true;
      name = "Dock";

      # @option widget = "spin"; label = "Order"; group = "Dock"; groupOrder = 10; min = 1; max = 1000; hidden = true;
      _order = 10;

      # @option widget = "dropdown"; label = "Position"; group = "Dock"; groupOrder = 10; choices = [ "0" "1" "2" "3" ]; description = "Screen edge: 0 = top, 1 = bottom, 2 = left, 3 = right.";
      position = 1;

      # @option widget = "list"; label = "Screens"; group = "Dock"; groupOrder = 10; description = "Screen names, or \"all\"."; hidden = true;
      screenPreferences = [ "all" ];

      # @option widget = "switch"; label = "Isolate displays"; group = "Dock"; groupOrder = 10; hidden = true;
      isolateDisplays = true;

      # @option widget = "switch"; label = "Show on last display"; group = "Dock"; groupOrder = 10; hidden = true; description = "Keep the dock on the display it was last shown on.";
      showOnLastDisplay = true;

      # @option widget = "switch"; label = "Show on fullscreen"; group = "Dock"; groupOrder = 10; description = "Keep the dock visible on fullscreen windows.";
      showOnFullscreen = false;

      # @option widget = "switch"; label = "Show on overview"; group = "Dock"; groupOrder = 10; hidden = true;
      openOnOverview = false;

      # @option widget = "switch"; label = "Use overlay layer"; group = "Dock"; groupOrder = 10; hidden = true;
      useOverlayLayer = true;

      # @option widget = "list"; label = "Item order"; group = "Dock"; groupOrder = 10; description = "Explicit dock item order, empty for default."; hidden = true;
      order = [ ];

      # Behaviour
      # @option widget = "switch"; label = "Auto hide"; group = "Behaviour"; groupOrder = 20; description = "Hide the dock until the pointer reaches the screen edge."; applyCommand = "dms ipc call dock autoHideFor dock %%val%%";
      autoHide = false;

      # @option widget = "switch"; label = "Smart auto hide"; group = "Behaviour"; groupOrder = 20; description = "Hide the dock only while a window overlaps it. Mutually exclusive with auto hide."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.autoHide"; visibleWhen.equals = true;
      smartAutoHide = false;

      # @option widget = "switch"; label = "Group by app"; group = "Behaviour"; groupOrder = 20; description = "Group pinned and running instances of the same app.";
      groupByApp = true;

      # @option widget = "switch"; label = "Separate pinned and running"; group = "Behaviour"; groupOrder = 20; hidden = true; description = "Split pinned apps from running-but-unpinned apps.";
      separatePinnedAndRunningApps = true;

      # @option widget = "switch"; label = "Show overflow badge"; group = "Behaviour"; groupOrder = 20; hidden = true; description = "Show a badge when apps are hidden in the overflow section.";
      showOverflowBadge = true;

      # @option widget = "switch"; label = "Edit on right click"; group = "Behaviour"; groupOrder = 20; hidden = true; description = "Right-click an item to edit the dock.";
      editOnRightClick = false;

      # @option widget = "switch"; label = "Restore special workspace on click"; group = "Behaviour"; groupOrder = 20; hidden = true; description = "Leave the special workspace when the dock is clicked.";
      restoreSpecialWorkspaceOnClick = false;

      # @option widget = "dropdown"; label = "Mode"; group = "Behaviour"; groupOrder = 20; choices = [ "compact" "comfortable" "comfortable-appmenu" ]; hidden = true; description = "Dock layout mode.";
      mode = "compact";

      # @option widget = "dropdown"; label = "Indicator style"; group = "Behaviour"; groupOrder = 20; choices = [ "line" "dot" "none" ]; hidden = true; description = "How running apps are indicated.";
      indicatorStyle = "line";

      # @option widget = "dropdown"; label = "Widget expansion"; group = "Behaviour"; groupOrder = 20; choices = [ "popout" "inline" ]; hidden = true; description = "Expand dock widgets in place or as a popout.";
      widgetExpansion = "popout";

      # @option widget = "spin"; label = "Max visible apps"; group = "Behaviour"; groupOrder = 20; min = 0; max = 100; description = "Maximum pinned apps shown before the rest go into overflow. 0 = unlimited.";
      maxVisibleApps = 0;

      # @option widget = "spin"; label = "Max visible running apps"; group = "Behaviour"; groupOrder = 20; min = 0; max = 100; description = "Maximum running (unpinned) apps shown before the rest go into overflow. 0 = unlimited.";
      maxVisibleRunningApps = 0;

      # @option widget = "dropdown"; label = "Taskbar alignment"; group = "Behaviour"; groupOrder = 20; choices = [ "start" "center" "end" ]; hidden = true; description = "Alignment of dock items along the dock.";
      taskbarAlign = "center";

      # Sizing
      # @option widget = "spin"; label = "Icon size"; group = "Sizing"; groupOrder = 30; min = 16; max = 96; unit = "px"; description = "Dock icon size.";
      iconSize = 40;

      # @option widget = "spin"; label = "Spacing"; group = "Sizing"; groupOrder = 30; min = 0; max = 40; unit = "px"; description = "Gap between dock items.";
      spacing = 7;

      # @option widget = "spin"; label = "Item spacing"; group = "Sizing"; groupOrder = 30; min = 0; max = 40; unit = "px"; advanced = true; description = "Gap between grouped app icons.";
      itemSpacing = 4;

      # @option widget = "spin"; label = "Margin"; group = "Sizing"; groupOrder = 30; min = 0; max = 100; unit = "px"; advanced = true; description = "Margin around the dock surface.";
      margin = 0;

      # @option widget = "spin"; label = "Bottom gap"; group = "Sizing"; groupOrder = 30; min = 0; max = 100; unit = "px"; advanced = true; description = "Gap between the dock and its screen edge.";
      bottomGap = 0;

      # @option widget = "slider"; label = "Transparency"; group = "Sizing"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the dock background.";
      transparency = 1;

      # Appearance
      # @option widget = "switch"; label = "Follow interface style"; group = "Appearance"; groupOrder = 40; description = "Follow the interface style theme.";
      followInterfaceStyle = true;

      # @option widget = "switch"; label = "Border"; group = "Appearance"; groupOrder = 40; description = "Draw a border around the dock.";
      borderEnabled = true;

      # @option widget = "dropdown"; label = "Border color"; group = "Appearance"; groupOrder = 40; choices = [ "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role used for the dock border. secondary = theme secondary."; hidden = true; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.borderEnabled"; visibleWhen.equals = true;
      borderColor = "secondary";

      # @option widget = "slider"; label = "Border opacity"; group = "Appearance"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the dock border."; hidden = true; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.borderEnabled"; visibleWhen.equals = true;
      borderOpacity = 1;

      # Magnification
      # @option widget = "switch"; label = "Magnify on hover"; group = "Magnification"; groupOrder = 50; description = "Enlarge icons under the pointer.";
      magnification = false;

      # @option widget = "spin"; label = "Magnification scale"; group = "Magnification"; groupOrder = 50; min = 100; max = 300; unit = "%"; advanced = true; description = "Peak magnification size in percent."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.magnification"; visibleWhen.equals = true;
      magnificationScale = 130;

      # @option widget = "dropdown"; label = "Magnification profile"; group = "Magnification"; groupOrder = 50; choices = [ "parabolic" "linear" ]; advanced = true; description = "Shape of the magnification curve."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.magnification"; visibleWhen.equals = true;
      magnificationProfile = "parabolic";

      # Launcher
      # @option widget = "switch"; label = "Launcher icon"; group = "Launcher"; groupOrder = 60; description = "Show the launcher button at the start of the dock.";
      launcherEnabled = true;

      # @option widget = "dropdown"; label = "Logo mode"; group = "Launcher"; groupOrder = 60; choices = [ "os" "custom" ]; hidden = true; description = "Launcher logo source."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoMode = "os";

      # @option widget = "path"; label = "Custom logo"; group = "Launcher"; groupOrder = 60; nullable = true; hidden = true; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.launcherLogoMode"; visibleWhen.equals = "custom";
      launcherLogoCustomPath = "";

      # @option widget = "dropdown"; label = "Logo color override"; group = "Launcher"; groupOrder = 60; choices = [ "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role used to tint the launcher logo."; hidden = true; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoColorOverride = "primary";

      # @option widget = "slider"; label = "Logo brightness"; group = "Launcher"; groupOrder = 60; min = 0.0; max = 2.0; step = 0.05; advanced = true; description = "Launcher logo brightness."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoBrightness = 0.5;

      # @option widget = "slider"; label = "Logo contrast"; group = "Launcher"; groupOrder = 60; min = 0.0; max = 2.0; step = 0.05; advanced = true; description = "Launcher logo contrast."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoContrast = 1;

      # @option widget = "spin"; label = "Logo size offset"; group = "Launcher"; groupOrder = 60; min = -40; max = 40; unit = "px"; advanced = true; description = "Launcher logo size adjustment in pixels."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoSizeOffset = 0;

      # Trash
      # @option widget = "switch"; label = "Show trash"; group = "Trash"; groupOrder = 70; description = "Show a trash item at the end of the dock.";
      showTrash = false;

      # @option widget = "text"; label = "File manager"; group = "Trash"; groupOrder = 70; hidden = true; description = "File manager opened by the trash item. \"default\" uses the system default, which is the file manager selected on the Applications page."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.showTrash"; visibleWhen.equals = true;
      trashFileManager = "default";

      # @option widget = "text"; label = "Custom command"; group = "Trash"; groupOrder = 70; hidden = true; description = "Custom command run by the trash item instead of the file manager."; visibleWhen.path = "desktop.ojuny.dux.dockConfigs.dock.showTrash"; visibleWhen.equals = true;
      trashCustomCommand = "";

      # Dock widgets
      /* @option label = "Widgets"; description = "Dock items in display order. Position is the tile order."; */
      widgets = {
        dockLauncher = { enabled = true; _order = 10; };
        appsDock = { enabled = true; _order = 20; };
        dockTrash = { enabled = true; _order = 30; };
      };
    };

  };

}
