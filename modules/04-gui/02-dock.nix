/*
  @menu
  displayname = "Dock";
  icon = "view-app-grid-symbolic";
  order = 20;
  description = "Dock appearance and behaviour";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dock = { config, pkgs, ... }: {

    # Dock
    # @option widget = "dock"; label = "Dock";
    desktop.ojuny.dms.dockConfigs.dock = {
      # @option widget = "switch"; label = "Enabled"; group = "Dock"; groupOrder = 10;
      enabled = false;

      # @option widget = "text"; label = "Name"; group = "Dock"; groupOrder = 10; hidden = true;
      name = "Dock";

      # @option widget = "spin"; label = "Order"; group = "Dock"; groupOrder = 10; min = 1; max = 1000; hidden = true;
      _order = 10;

      # @option widget = "spin"; label = "Position"; group = "Dock"; groupOrder = 10; min = 0; max = 1; step = 1; description = "0 = top, 1 = bottom.";
      position = 1;

      # @option widget = "list"; label = "Screens"; group = "Dock"; groupOrder = 10; description = "Screen names, or \"all\"."; hidden = true;
      screenPreferences = [ "all" ];

      # @option widget = "switch"; label = "Isolate displays"; group = "Dock"; groupOrder = 10; hidden = true;
      isolateDisplays = true;

      # @option widget = "switch"; label = "Show on last display"; group = "Dock"; groupOrder = 10; hidden = true;
      showOnLastDisplay = true;

      # @option widget = "switch"; label = "Show on fullscreen"; group = "Dock"; groupOrder = 10;
      showOnFullscreen = false;

      # @option widget = "switch"; label = "Show on overview"; group = "Dock"; groupOrder = 10; hidden = true;
      openOnOverview = false;

      # @option widget = "switch"; label = "Use overlay layer"; group = "Dock"; groupOrder = 10; hidden = true;
      useOverlayLayer = true;

      # Behaviour
      # @option widget = "switch"; label = "Auto hide"; group = "Behaviour"; groupOrder = 20;
      autoHide = false;

      # @option widget = "switch"; label = "Smart auto hide"; group = "Behaviour"; groupOrder = 20; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.autoHide"; visibleWhen.equals = true;
      smartAutoHide = false;

      # @option widget = "switch"; label = "Group by app"; group = "Behaviour"; groupOrder = 20;
      groupByApp = true;

      # @option widget = "switch"; label = "Separate pinned and running"; group = "Behaviour"; groupOrder = 20; hidden = true;
      separatePinnedAndRunningApps = true;

      # @option widget = "switch"; label = "Show overflow badge"; group = "Behaviour"; groupOrder = 20; hidden = true;
      showOverflowBadge = true;

      # @option widget = "switch"; label = "Edit on right click"; group = "Behaviour"; groupOrder = 20; hidden = true;
      editOnRightClick = false;

      # @option widget = "switch"; label = "Restore special workspace on click"; group = "Behaviour"; groupOrder = 20; hidden = true;
      restoreSpecialWorkspaceOnClick = false;

      # @option widget = "dropdown"; label = "Mode"; group = "Behaviour"; groupOrder = 20; choices = [ "compact" "comfortable" "comfortable-appmenu" ]; hidden = true;
      mode = "compact";

      # @option widget = "dropdown"; label = "Indicator style"; group = "Behaviour"; groupOrder = 20; choices = [ "line" "dot" "none" ]; hidden = true;
      indicatorStyle = "line";

      # @option widget = "dropdown"; label = "Widget expansion"; group = "Behaviour"; groupOrder = 20; choices = [ "popout" "inline" ]; hidden = true;
      widgetExpansion = "popout";

      # @option widget = "spin"; label = "Max visible apps"; group = "Behaviour"; groupOrder = 20; min = 0; max = 50; advanced = true;
      maxVisibleApps = 0;

      # @option widget = "spin"; label = "Max visible running apps"; group = "Behaviour"; groupOrder = 20; min = 0; max = 50; advanced = true;
      maxVisibleRunningApps = 0;

      # @option widget = "dropdown"; label = "Taskbar alignment"; group = "Behaviour"; groupOrder = 20; choices = [ "start" "center" "end" ]; hidden = true;
      taskbarAlign = "center";

      # Sizing
      # @option widget = "spin"; label = "Icon size"; group = "Sizing"; groupOrder = 30; min = 16; max = 96; unit = "px";
      iconSize = 40;

      # @option widget = "spin"; label = "Spacing"; group = "Sizing"; groupOrder = 30; min = 0; max = 40; unit = "px";
      spacing = 7;

      # @option widget = "spin"; label = "Item spacing"; group = "Sizing"; groupOrder = 30; min = 0; max = 40; unit = "px"; advanced = true;
      itemSpacing = 4;

      # @option widget = "spin"; label = "Margin"; group = "Sizing"; groupOrder = 30; min = 0; max = 100; unit = "px"; advanced = true;
      margin = 0;

      # @option widget = "spin"; label = "Bottom gap"; group = "Sizing"; groupOrder = 30; min = 0; max = 100; unit = "px"; advanced = true;
      bottomGap = 0;

      # @option widget = "slider"; label = "Transparency"; group = "Sizing"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05;
      transparency = 1;

      # Appearance
      # @option widget = "switch"; label = "Follow interface style"; group = "Appearance"; groupOrder = 40;
      followInterfaceStyle = true;

      # @option widget = "switch"; label = "Border"; group = "Appearance"; groupOrder = 40;
      borderEnabled = true;

      # @option widget = "text"; label = "Border color"; group = "Appearance"; groupOrder = 40; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.borderEnabled"; visibleWhen.equals = true;
      borderColor = "secondary";

      # @option widget = "slider"; label = "Border opacity"; group = "Appearance"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.borderEnabled"; visibleWhen.equals = true;
      borderOpacity = 1;

      # Magnification
      # @option widget = "switch"; label = "Magnify on hover"; group = "Magnification"; groupOrder = 50;
      magnification = false;

      # @option widget = "spin"; label = "Magnification scale"; group = "Magnification"; groupOrder = 50; min = 100; max = 300; unit = "%"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.magnification"; visibleWhen.equals = true;
      magnificationScale = 130;

      # @option widget = "dropdown"; label = "Magnification profile"; group = "Magnification"; groupOrder = 50; choices = [ "parabolic" "linear" ]; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.magnification"; visibleWhen.equals = true;
      magnificationProfile = "parabolic";

      # Launcher
      # @option widget = "switch"; label = "Launcher icon"; group = "Launcher"; groupOrder = 60;
      launcherEnabled = true;

      # @option widget = "dropdown"; label = "Logo mode"; group = "Launcher"; groupOrder = 60; choices = [ "os" "custom" ]; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoMode = "os";

      # @option widget = "path"; label = "Custom logo"; group = "Launcher"; groupOrder = 60; nullable = true; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherLogoMode"; visibleWhen.equals = "custom";
      launcherLogoCustomPath = "";

      # @option widget = "text"; label = "Logo color override"; group = "Launcher"; groupOrder = 60; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoColorOverride = "primary";

      # @option widget = "slider"; label = "Logo brightness"; group = "Launcher"; groupOrder = 60; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoBrightness = 0.5;

      # @option widget = "slider"; label = "Logo contrast"; group = "Launcher"; groupOrder = 60; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoContrast = 1;

      # @option widget = "spin"; label = "Logo size offset"; group = "Launcher"; groupOrder = 60; min = -40; max = 40; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
      launcherLogoSizeOffset = 0;

      # Trash
      # @option widget = "switch"; label = "Show trash"; group = "Trash"; groupOrder = 70;
      showTrash = false;

      # @option widget = "text"; label = "File manager"; group = "Trash"; groupOrder = 70; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.showTrash"; visibleWhen.equals = true;
      trashFileManager = "default";

      # @option widget = "text"; label = "Custom command"; group = "Trash"; groupOrder = 70; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.showTrash"; visibleWhen.equals = true;
      trashCustomCommand = "";

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
