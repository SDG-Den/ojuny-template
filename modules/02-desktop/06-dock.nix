/* @menu
   displayname = "Dock";
   icon = "view-app-grid-symbolic";
   order = 60;
   description = "Dock appearance and behaviour";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-dock = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    /* @option widget = "submodule"; label = "Dock"; group = "Dock"; */
    desktop.ojuny.dms.dockConfigs.dock = {
      /* @option widget = "switch"; label = "Enabled"; group = "Dock"; */
      enabled = false;

      /* @option widget = "spin"; label = "Position"; group = "Dock"; min = 0; max = 1; step = 1; description = "0 = top, 1 = bottom."; */
      position = 1;

      /* @option widget = "text"; label = "Mode"; group = "Dock"; description = "DMS dock mode, e.g. compact."; */
      mode = "compact";

      /* @option widget = "spin"; label = "Icon size"; group = "Dock"; min = 16; max = 96; unit = "px"; */
      iconSize = 40;

      /* @option widget = "spin"; label = "Spacing"; group = "Dock"; min = 0; max = 40; unit = "px"; */
      spacing = 7;

      /* @option widget = "spin"; label = "Item spacing"; group = "Dock"; min = 0; max = 40; unit = "px"; */
      itemSpacing = 4;

      /* @option widget = "spin"; label = "Margin"; group = "Dock"; min = 0; max = 100; unit = "px"; */
      margin = 0;

      /* @option widget = "spin"; label = "Bottom gap"; group = "Dock"; min = 0; max = 100; unit = "px"; */
      bottomGap = 0;

      /* @option widget = "slider"; label = "Transparency"; group = "Dock"; min = 0.0; max = 1.0; step = 0.05; */
      transparency = 1;

      /* @option widget = "switch"; label = "Auto hide"; group = "Dock"; */
      autoHide = false;

      /* @option widget = "switch"; label = "Smart auto hide"; group = "Dock"; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.autoHide"; visibleWhen.equals = true; */
      smartAutoHide = false;

      /* @option widget = "switch"; label = "Magrify on hover"; group = "Dock"; */
      magnification = false;

      /* @option widget = "spin"; label = "Magnification scale"; group = "Dock"; min = 100; max = 300; unit = "%"; visibleWhen.path = "desktop.ojuny.dms.dockConfigs.dock.magnification"; visibleWhen.equals = true; */
      magnificationScale = 130;

      /* @option widget = "switch"; label = "Group by app"; group = "Dock"; */
      groupByApp = true;

      /* @option widget = "switch"; label = "Separate pinned and running"; group = "Dock"; */
      separatePinnedAndRunningApps = true;

      /* @option widget = "switch"; label = "Show trash"; group = "Dock"; */
      showTrash = false;

      /* @option widget = "text"; label = "Taskbar alignment"; group = "Dock"; description = "start, center or end."; */
      taskbarAlign = "center";
    };

  };

}
