/*
  @menu
  displayname = "Control center";
  icon = "preferences-system-symbolic";
  order = 50;
  description = "Control center widgets and layout";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-controlcenter = { config, pkgs, ... }: {

    # @option widget = "grid-configuration"; label = "Widget layout"; group = "Widgets"; groupOrder = 10; order = 10; gridColumns = 8;
    desktop.ojuny.dms.controlCenterWidgets = {
      user = {
        enabled = true;
        _order = 10;
        col = 0;
        row = 0;
        w = 5;
        h = 1;
      };
      battery = {
        enabled = true;
        _order = 20;
        col = 5;
        row = 0;
        w = 1;
        h = 1;
      };
      power = {
        small = true;
        enabled = true;
        _order = 50;
        col = 7;
        row = 0;
        w = 1;
        h = 1;
      };
      brightnessSlider = {
        enabled = true;
        _order = 60;
        col = 0;
        row = 1;
        w = 1;
        h = 5;
      };
      volumeSlider = {
        enabled = true;
        _order = 70;
        col = 1;
        row = 1;
        w = 1;
        h = 5;
      };
      inputVolumeSlider = {
        enabled = true;
        _order = 80;
        col = 2;
        row = 1;
        w = 1;
        h = 5;
      };
      wifi = {
        enabled = true;
        _order = 90;
        col = 3;
        row = 1;
        w = 5;
        h = 1;
      };
      bluetooth = {
        enabled = true;
        _order = 100;
        col = 3;
        row = 2;
        w = 5;
        h = 1;
      };
      builtin_vpn = {
        enabled = true;
        _order = 110;
        col = 3;
        row = 3;
        w = 5;
        h = 1;
      };
      plugin_dankKDEConnect = {
        enabled = true;
        _order = 120;
        col = 3;
        row = 4;
        w = 5;
        h = 1;
      };
      diskUsage = {
        enabled = true;
        _order = 130;
        col = 3;
        row = 5;
        w = 5;
        h = 1;
      };
      nightMode = {
        footer = true;
        enabled = true;
        _order = 140;
        col = 4;
        row = 6;
        w = 2;
        h = 1;
      };
      doNotDisturb = {
        footer = true;
        enabled = true;
        _order = 150;
        col = 4;
        row = 7;
        w = 2;
        h = 1;
      };
      idleInhibitor = {
        footer = true;
        enabled = true;
        _order = 160;
        col = 4;
        row = 6;
        w = 2;
        h = 1;
      };
      runningApps = {
        footer = true;
        enabled = true;
        _order = 170;
        col = 0;
        row = 0;
        w = 4;
        h = 1;
      };
      quickTiles = {
        enabled = true;
        _order = 180;
        col = 0;
        row = 6;
        w = 8;
        h = 1;
      };
      lock = {
        enabled = true;
        _order = 190;
        col = 6;
        row = 0;
        w = 1;
        h = 1;
      };
    };

  };

}
