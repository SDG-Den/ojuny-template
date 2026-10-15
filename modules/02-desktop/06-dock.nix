/*
  @menu
  displayname = "Dock";
  icon = "view-app-grid-symbolic";
  order = 60;
  description = "Dock appearance and behaviour";
  category = "Desktop";
*/

/*
  @snippet
  name = "dock-widget";
  label = "Add dock widget";
  snippet = ''
    # @option widget = "submodule"; label = "%%label%%"; group = "Dock widgets";
    desktop.ojuny.dms.dockConfigs.dock.widgets.%%id%% = {
      # @option widget = "switch"; label = "Enabled"; group = "Dock widgets";
      enabled = true;
      # @option widget = "spin"; label = "Order"; group = "Dock widgets"; min = 1; max = 100; hidden = true;
      _order = %%order%%;
    };
  '';
  placeholders.id.label = "Widget ID";
  placeholders.id.default = "myWidget";
  placeholders.label.label = "Label";
  placeholders.label.default = "My widget";
  placeholders.order.label = "Order";
  placeholders.order.default = "40";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dock = { config, pkgs, ... }: {

    # Dock
    # @option widget = "switch"; label = "Enabled"; group = "Dock";
    desktop.ojuny.dms.dockConfigs.dock.enabled = false;

    # @option widget = "text"; label = "Name"; group = "Dock"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.name = "Dock";

    # @option widget = "spin"; label = "Order"; group = "Dock"; min = 1; max = 1000; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock._order = 10;

    # @option widget = "spin"; label = "Position"; group = "Dock"; min = 0; max = 1; step = 1; description = "0 = top, 1 = bottom.";
    desktop.ojuny.dms.dockConfigs.dock.position = 1;

    # @option widget = "list"; label = "Screens"; group = "Dock"; description = "Screen names, or \"all\"."; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.screenPreferences = [ "all" ];

    # @option widget = "switch"; label = "Isolate displays"; group = "Dock"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.isolateDisplays = true;

    # @option widget = "switch"; label = "Show on last display"; group = "Dock"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.showOnLastDisplay = true;

    # @option widget = "switch"; label = "Show on fullscreen"; group = "Dock";
    desktop.ojuny.dms.dockConfigs.dock.showOnFullscreen = false;

    # @option widget = "switch"; label = "Show on overview"; group = "Dock"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.openOnOverview = false;

    # @option widget = "switch"; label = "Use overlay layer"; group = "Dock"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.useOverlayLayer = true;

    # Behaviour
    # @option widget = "switch"; label = "Auto hide"; group = "Behaviour";
    desktop.ojuny.dms.dockConfigs.dock.autoHide = false;

    # @option widget = "switch"; label = "Smart auto hide"; group = "Behaviour"; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.autoHide"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.smartAutoHide = false;

    # @option widget = "switch"; label = "Group by app"; group = "Behaviour";
    desktop.ojuny.dms.dockConfigs.dock.groupByApp = true;

    # @option widget = "switch"; label = "Separate pinned and running"; group = "Behaviour"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.separatePinnedAndRunningApps = true;

    # @option widget = "switch"; label = "Show overflow badge"; group = "Behaviour"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.showOverflowBadge = true;

    # @option widget = "switch"; label = "Edit on right click"; group = "Behaviour"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.editOnRightClick = false;

    # @option widget = "switch"; label = "Restore special workspace on click"; group = "Behaviour"; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.restoreSpecialWorkspaceOnClick = false;

    # @option widget = "dropdown"; label = "Mode"; group = "Behaviour"; choices = [ "compact" "comfortable" "comfortable-appmenu" ]; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.mode = "compact";

    # @option widget = "dropdown"; label = "Indicator style"; group = "Behaviour"; choices = [ "line" "dot" "none" ]; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.indicatorStyle = "line";

    # @option widget = "dropdown"; label = "Widget expansion"; group = "Behaviour"; choices = [ "popout" "inline" ]; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.widgetExpansion = "popout";

    # @option widget = "spin"; label = "Max visible apps"; group = "Behaviour"; min = 0; max = 50; advanced = true;
    desktop.ojuny.dms.dockConfigs.dock.maxVisibleApps = 0;

    # @option widget = "spin"; label = "Max visible running apps"; group = "Behaviour"; min = 0; max = 50; advanced = true;
    desktop.ojuny.dms.dockConfigs.dock.maxVisibleRunningApps = 0;

    # @option widget = "dropdown"; label = "Taskbar alignment"; group = "Behaviour"; choices = [ "start" "center" "end" ]; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.taskbarAlign = "center";

    # Sizing
    # @option widget = "spin"; label = "Icon size"; group = "Sizing"; min = 16; max = 96; unit = "px";
    desktop.ojuny.dms.dockConfigs.dock.iconSize = 40;

    # @option widget = "spin"; label = "Spacing"; group = "Sizing"; min = 0; max = 40; unit = "px";
    desktop.ojuny.dms.dockConfigs.dock.spacing = 7;

    # @option widget = "spin"; label = "Item spacing"; group = "Sizing"; min = 0; max = 40; unit = "px"; advanced = true;
    desktop.ojuny.dms.dockConfigs.dock.itemSpacing = 4;

    # @option widget = "spin"; label = "Margin"; group = "Sizing"; min = 0; max = 100; unit = "px"; advanced = true;
    desktop.ojuny.dms.dockConfigs.dock.margin = 0;

    # @option widget = "spin"; label = "Bottom gap"; group = "Sizing"; min = 0; max = 100; unit = "px"; advanced = true;
    desktop.ojuny.dms.dockConfigs.dock.bottomGap = 0;

    # @option widget = "slider"; label = "Transparency"; group = "Sizing"; min = 0.0; max = 1.0; step = 0.05;
    desktop.ojuny.dms.dockConfigs.dock.transparency = 1;

    # Appearance
    # @option widget = "switch"; label = "Follow interface style"; group = "Appearance";
    desktop.ojuny.dms.dockConfigs.dock.followInterfaceStyle = true;

    # @option widget = "switch"; label = "Border"; group = "Appearance";
    desktop.ojuny.dms.dockConfigs.dock.borderEnabled = true;

    # @option widget = "text"; label = "Border color"; group = "Appearance"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.borderEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.borderColor = "secondary";

    # @option widget = "slider"; label = "Border opacity"; group = "Appearance"; min = 0.0; max = 1.0; step = 0.05; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.borderEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.borderOpacity = 1;

    # Magnification
    # @option widget = "switch"; label = "Magnify on hover"; group = "Magnification";
    desktop.ojuny.dms.dockConfigs.dock.magnification = false;

    # @option widget = "spin"; label = "Magnification scale"; group = "Magnification"; min = 100; max = 300; unit = "%"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.magnification"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.magnificationScale = 130;

    # @option widget = "dropdown"; label = "Magnification profile"; group = "Magnification"; choices = [ "parabolic" "linear" ]; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.magnification"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.magnificationProfile = "parabolic";

    # Launcher
    # @option widget = "switch"; label = "Launcher icon"; group = "Launcher";
    desktop.ojuny.dms.dockConfigs.dock.launcherEnabled = true;

    # @option widget = "dropdown"; label = "Logo mode"; group = "Launcher"; choices = [ "os" "custom" ]; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.launcherLogoMode = "os";

    # @option widget = "path"; label = "Custom logo"; group = "Launcher"; nullable = true; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherLogoMode"; visibleWhen.equals = "custom";
    desktop.ojuny.dms.dockConfigs.dock.launcherLogoCustomPath = "";

    # @option widget = "text"; label = "Logo color override"; group = "Launcher"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.launcherLogoColorOverride = "primary";

    # @option widget = "slider"; label = "Logo brightness"; group = "Launcher"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.launcherLogoBrightness = 0.5;

    # @option widget = "slider"; label = "Logo contrast"; group = "Launcher"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.launcherLogoContrast = 1;

    # @option widget = "spin"; label = "Logo size offset"; group = "Launcher"; min = -40; max = 40; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.launcherEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.launcherLogoSizeOffset = 0;

    # Trash
    # @option widget = "switch"; label = "Show trash"; group = "Trash";
    desktop.ojuny.dms.dockConfigs.dock.showTrash = false;

    # @option widget = "text"; label = "File manager"; group = "Trash"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.showTrash"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.trashFileManager = "default";

    # @option widget = "text"; label = "Custom command"; group = "Trash"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.showTrash"; visibleWhen.equals = true;
    desktop.ojuny.dms.dockConfigs.dock.trashCustomCommand = "";

    # @option widget = "list"; label = "Item order"; group = "Dock"; description = "Explicit dock item order, empty for default."; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.order = [ ];

    # Dock widgets
    # @option widget = "switch"; label = "Launcher widget"; group = "Dock widgets";
    desktop.ojuny.dms.dockConfigs.dock.widgets.dock_launcher.enabled = true;

    # @option widget = "spin"; label = "Launcher widget order"; group = "Dock widgets"; min = 1; max = 100; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.widgets.dock_launcher._order = 10;

    # @option widget = "switch"; label = "Apps widget"; group = "Dock widgets";
    desktop.ojuny.dms.dockConfigs.dock.widgets.dock_apps.enabled = true;

    # @option widget = "spin"; label = "Apps widget order"; group = "Dock widgets"; min = 1; max = 100; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.widgets.dock_apps._order = 20;

    # @option widget = "switch"; label = "Trash widget"; group = "Dock widgets";
    desktop.ojuny.dms.dockConfigs.dock.widgets.dock_trash.enabled = true;

    # @option widget = "spin"; label = "Trash widget order"; group = "Dock widgets"; min = 1; max = 100; hidden = true;
    desktop.ojuny.dms.dockConfigs.dock.widgets.dock_trash._order = 30;

    /*
      @insert
      name = "dock-widget";
      group = "Dock widgets";
      order = 1000;
    */

  };

}
