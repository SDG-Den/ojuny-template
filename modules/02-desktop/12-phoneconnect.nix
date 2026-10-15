/*
  @menu
  displayname = "Phone connect";
  icon = "phone-symbolic";
  order = 120;
  description = "KDE Connect integration";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-phoneconnect = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "KDE Connect"; group = "KDE Connect"; description = "Phone notifications, file transfer and remote input.";
    programs.kdeconnect.enable = true;

    # @option widget = "submodule"; label = "Bar widget"; group = "DMS plugin";
    desktop.ojuny.dms.barConfigs.default.leftWidgets.dankKDEConnect = {
      # @option widget = "switch"; label = "Enabled"; group = "DMS plugin";
      enabled = true;

      # @option widget = "spin"; label = "Order"; group = "DMS plugin"; min = 1; max = 100;
      _order = 20;
    };

    # @option widget = "submodule"; label = "Control center widget"; group = "DMS plugin";
    desktop.ojuny.dms.controlCenterWidgets.plugin_dankKDEConnect = {
      # @option widget = "switch"; label = "Enabled"; group = "DMS plugin";
      enabled = true;

      # @option widget = "spin"; label = "Order"; group = "DMS plugin"; min = 1; max = 200;
      _order = 120;
    };

  };

}
