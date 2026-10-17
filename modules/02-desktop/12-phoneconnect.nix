/*
  @menu
  displayname = "Phone connect";
  icon = "phone-symbolic";
  order = 120;
  description = "KDE Connect integration";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-phoneconnect = { config, pkgs, lib, ... }: {

    # @option widget = "switch"; label = "KDE Connect"; group = "KDE Connect"; description = "Phone notifications, file transfer and remote input.";
    programs.kdeconnect.enable = true;

    # themed fork of KDE Connect used by stylix; parity with dendrite desktop-svc.nix.
    programs.kdeconnect.package = lib.mkDefault pkgs.valent;

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

      # @option widget = "spin"; label = "Column"; group = "DMS plugin"; min = 0; max = 12;
      col = 3;

      # @option widget = "spin"; label = "Row"; group = "DMS plugin"; min = 0; max = 12;
      row = 4;

      # @option widget = "spin"; label = "Width"; group = "DMS plugin"; min = 1; max = 12;
      w = 5;

      # @option widget = "spin"; label = "Height"; group = "DMS plugin"; min = 1; max = 12;
      h = 1;
    };

  };

}
