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

    # Top row
    # @option widget = "horizontal-submodule"; label = "User"; group = "Top row"; groupOrder = 10; order = 10; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.user = { enabled = true; _order = 10; col = 0; row = 0; w = 4; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Battery"; group = "Top row"; groupOrder = 10; order = 20; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.battery = { enabled = true; _order = 20; col = 4; row = 0; w = 1; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Settings"; group = "Top row"; groupOrder = 10; order = 30; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.settings = { enabled = true; _order = 30; col = 5; row = 0; w = 1; h = 1; small = true; };

    # @option widget = "horizontal-submodule"; label = "Lock"; group = "Top row"; groupOrder = 10; order = 40; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.lock = { enabled = true; _order = 40; col = 6; row = 0; w = 1; h = 1; small = true; };

    # @option widget = "horizontal-submodule"; label = "Power"; group = "Top row"; groupOrder = 10; order = 50; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.power = { enabled = true; _order = 50; col = 7; row = 0; w = 1; h = 1; small = true; };

    # Sliders
    # @option widget = "horizontal-submodule"; label = "Brightness slider"; group = "Sliders"; groupOrder = 20; order = 60; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider = { enabled = true; _order = 60; col = 0; row = 1; w = 1; h = 5; };

    # @option widget = "horizontal-submodule"; label = "Volume slider"; group = "Sliders"; groupOrder = 20; order = 70; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider = { enabled = true; _order = 70; col = 1; row = 1; w = 1; h = 5; };

    # @option widget = "horizontal-submodule"; label = "Input volume slider"; group = "Sliders"; groupOrder = 20; order = 80; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider = { enabled = true; _order = 80; col = 2; row = 1; w = 1; h = 5; };

    # Connectivity
    # @option widget = "horizontal-submodule"; label = "Wi-Fi"; group = "Connectivity"; groupOrder = 30; order = 90; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.wifi = { enabled = true; _order = 90; col = 3; row = 1; w = 5; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Bluetooth"; group = "Connectivity"; groupOrder = 30; order = 100; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.bluetooth = { enabled = true; _order = 100; col = 3; row = 2; w = 5; h = 1; };

    # @option widget = "horizontal-submodule"; label = "VPN"; group = "Connectivity"; groupOrder = 30; order = 110; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn = { enabled = true; _order = 110; col = 3; row = 3; w = 5; h = 1; };

    # @option widget = "horizontal-submodule"; label = "KDE Connect"; group = "Connectivity"; groupOrder = 30; order = 120; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.plugin_dankKDEConnect = { enabled = true; _order = 120; col = 3; row = 4; w = 5; h = 1; };

    # System
    # @option widget = "horizontal-submodule"; label = "Disk usage"; group = "System"; groupOrder = 40; order = 130; maxColumns = 4; visibleWhen.path = "desktop.ojuny.dms.controlCenterWidgets.diskUsage.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage = { enabled = true; mountpath = "/"; _order = 130; col = 3; row = 5; w = 5; h = 1; };

    # @option widget = "horizontal-submodule"; label = "Night mode"; group = "System"; groupOrder = 40; order = 140; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.nightMode = { enabled = true; _order = 140; col = 4; row = 6; w = 2; h = 1; footer = true; footerW = 1; };

    # @option widget = "horizontal-submodule"; label = "Do not disturb"; group = "System"; groupOrder = 40; order = 150; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb = { enabled = true; _order = 150; col = 4; row = 7; w = 2; h = 1; footer = true; footerW = 1; };

    # @option widget = "horizontal-submodule"; label = "Idle inhibitor"; group = "System"; groupOrder = 40; order = 160; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor = { enabled = true; _order = 160; col = 4; row = 6; w = 2; h = 1; footer = true; footerW = 1; };

    # @option widget = "horizontal-submodule"; label = "Running apps"; group = "System"; groupOrder = 40; order = 170; maxColumns = 4;
    desktop.ojuny.dms.controlCenterWidgets.runningApps = { enabled = true; _order = 170; w = 4; h = 1; footer = true; };

  };

}
