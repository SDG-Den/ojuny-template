/*
  @menu
  displayname = "Control center";
  icon = "preferences-system-symbolic";
  order = 85;
  description = "Control center widgets and layout";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-controlcenter = { config, pkgs, ... }: {

    # Top row
    # @option widget = "switch"; label = "User"; group = "Top row";
    desktop.ojuny.dms.controlCenterWidgets.user.enabled = true;

    # @option widget = "spin"; label = "User order"; group = "Top row"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.user._order = 10;

    # @option widget = "spin"; label = "User column"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.user.col = 0;

    # @option widget = "spin"; label = "User row"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.user.row = 0;

    # @option widget = "spin"; label = "User width"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.user.w = 4;

    # @option widget = "spin"; label = "User height"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.user.h = 1;

    # @option widget = "switch"; label = "Battery"; group = "Top row";
    desktop.ojuny.dms.controlCenterWidgets.battery.enabled = true;

    # @option widget = "spin"; label = "Battery order"; group = "Top row"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.battery._order = 20;

    # @option widget = "spin"; label = "Battery column"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.battery.col = 4;

    # @option widget = "spin"; label = "Battery row"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.battery.row = 0;

    # @option widget = "spin"; label = "Battery width"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.battery.w = 1;

    # @option widget = "spin"; label = "Battery height"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.battery.h = 1;

    # @option widget = "switch"; label = "Settings"; group = "Top row";
    desktop.ojuny.dms.controlCenterWidgets.settings.enabled = true;

    # @option widget = "spin"; label = "Settings order"; group = "Top row"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.settings._order = 30;

    # @option widget = "spin"; label = "Settings column"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.settings.col = 5;

    # @option widget = "spin"; label = "Settings row"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.settings.row = 0;

    # @option widget = "spin"; label = "Settings width"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.settings.w = 1;

    # @option widget = "spin"; label = "Settings height"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.settings.h = 1;

    # @option widget = "switch"; label = "Settings small"; group = "Top row"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.settings.small = true;

    # @option widget = "switch"; label = "Lock"; group = "Top row";
    desktop.ojuny.dms.controlCenterWidgets.lock.enabled = true;

    # @option widget = "spin"; label = "Lock order"; group = "Top row"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.lock._order = 40;

    # @option widget = "spin"; label = "Lock column"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.lock.col = 6;

    # @option widget = "spin"; label = "Lock row"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.lock.row = 0;

    # @option widget = "spin"; label = "Lock width"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.lock.w = 1;

    # @option widget = "spin"; label = "Lock height"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.lock.h = 1;

    # @option widget = "switch"; label = "Lock small"; group = "Top row"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.lock.small = true;

    # @option widget = "switch"; label = "Power"; group = "Top row";
    desktop.ojuny.dms.controlCenterWidgets.power.enabled = true;

    # @option widget = "spin"; label = "Power order"; group = "Top row"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.power._order = 50;

    # @option widget = "spin"; label = "Power column"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.power.col = 7;

    # @option widget = "spin"; label = "Power row"; group = "Top row"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.power.row = 0;

    # @option widget = "spin"; label = "Power width"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.power.w = 1;

    # @option widget = "spin"; label = "Power height"; group = "Top row"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.power.h = 1;

    # @option widget = "switch"; label = "Power small"; group = "Top row"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.power.small = true;

    # Sliders
    # @option widget = "switch"; label = "Brightness slider"; group = "Sliders";
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider.enabled = true;

    # @option widget = "spin"; label = "Brightness order"; group = "Sliders"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider._order = 60;

    # @option widget = "spin"; label = "Brightness column"; group = "Sliders"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider.col = 0;

    # @option widget = "spin"; label = "Brightness row"; group = "Sliders"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider.row = 1;

    # @option widget = "spin"; label = "Brightness width"; group = "Sliders"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider.w = 1;

    # @option widget = "spin"; label = "Brightness height"; group = "Sliders"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.brightnessSlider.h = 5;

    # @option widget = "switch"; label = "Volume slider"; group = "Sliders";
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider.enabled = true;

    # @option widget = "spin"; label = "Volume order"; group = "Sliders"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider._order = 70;

    # @option widget = "spin"; label = "Volume column"; group = "Sliders"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider.col = 1;

    # @option widget = "spin"; label = "Volume row"; group = "Sliders"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider.row = 1;

    # @option widget = "spin"; label = "Volume width"; group = "Sliders"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider.w = 1;

    # @option widget = "spin"; label = "Volume height"; group = "Sliders"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.volumeSlider.h = 5;

    # @option widget = "switch"; label = "Input volume slider"; group = "Sliders";
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider.enabled = true;

    # @option widget = "spin"; label = "Input volume order"; group = "Sliders"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider._order = 80;

    # @option widget = "spin"; label = "Input volume column"; group = "Sliders"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider.col = 2;

    # @option widget = "spin"; label = "Input volume row"; group = "Sliders"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider.row = 1;

    # @option widget = "spin"; label = "Input volume width"; group = "Sliders"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider.w = 1;

    # @option widget = "spin"; label = "Input volume height"; group = "Sliders"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.inputVolumeSlider.h = 5;

    # Connectivity
    # @option widget = "switch"; label = "Wi-Fi"; group = "Connectivity";
    desktop.ojuny.dms.controlCenterWidgets.wifi.enabled = true;

    # @option widget = "spin"; label = "Wi-Fi order"; group = "Connectivity"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.wifi._order = 90;

    # @option widget = "spin"; label = "Wi-Fi column"; group = "Connectivity"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.wifi.col = 3;

    # @option widget = "spin"; label = "Wi-Fi row"; group = "Connectivity"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.wifi.row = 1;

    # @option widget = "spin"; label = "Wi-Fi width"; group = "Connectivity"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.wifi.w = 5;

    # @option widget = "spin"; label = "Wi-Fi height"; group = "Connectivity"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.wifi.h = 1;

    # @option widget = "switch"; label = "Bluetooth"; group = "Connectivity";
    desktop.ojuny.dms.controlCenterWidgets.bluetooth.enabled = true;

    # @option widget = "spin"; label = "Bluetooth order"; group = "Connectivity"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.bluetooth._order = 100;

    # @option widget = "spin"; label = "Bluetooth column"; group = "Connectivity"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.bluetooth.col = 3;

    # @option widget = "spin"; label = "Bluetooth row"; group = "Connectivity"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.bluetooth.row = 2;

    # @option widget = "spin"; label = "Bluetooth width"; group = "Connectivity"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.bluetooth.w = 5;

    # @option widget = "spin"; label = "Bluetooth height"; group = "Connectivity"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.bluetooth.h = 1;

    # @option widget = "switch"; label = "VPN"; group = "Connectivity";
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn.enabled = true;

    # @option widget = "spin"; label = "VPN order"; group = "Connectivity"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn._order = 110;

    # @option widget = "spin"; label = "VPN column"; group = "Connectivity"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn.col = 3;

    # @option widget = "spin"; label = "VPN row"; group = "Connectivity"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn.row = 3;

    # @option widget = "spin"; label = "VPN width"; group = "Connectivity"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn.w = 5;

    # @option widget = "spin"; label = "VPN height"; group = "Connectivity"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.builtin_vpn.h = 1;

    # System
    # @option widget = "switch"; label = "Disk usage"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.diskUsage.enabled = true;

    # @option widget = "text"; label = "Disk usage mount"; group = "System"; hidden = true; visibleWhen.path = "desktop.ojuny.dms.controlCenterWidgets.diskUsage.enabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage.mountpath = "/";

    # @option widget = "spin"; label = "Disk usage order"; group = "System"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage._order = 130;

    # @option widget = "spin"; label = "Disk usage column"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage.col = 3;

    # @option widget = "spin"; label = "Disk usage row"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage.row = 5;

    # @option widget = "spin"; label = "Disk usage width"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage.w = 5;

    # @option widget = "spin"; label = "Disk usage height"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.diskUsage.h = 1;

    # @option widget = "switch"; label = "Night mode toggle"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.nightMode.enabled = true;

    # @option widget = "spin"; label = "Night mode order"; group = "System"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.nightMode._order = 140;

    # @option widget = "spin"; label = "Night mode column"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.nightMode.col = 4;

    # @option widget = "spin"; label = "Night mode row"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.nightMode.row = 6;

    # @option widget = "spin"; label = "Night mode width"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.nightMode.w = 2;

    # @option widget = "spin"; label = "Night mode height"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.nightMode.h = 1;

    # @option widget = "switch"; label = "Night mode footer"; group = "System"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.nightMode.footer = true;

    # @option widget = "spin"; label = "Night mode footer width"; group = "System"; min = 1; max = 12; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.nightMode.footerW = 1;

    # @option widget = "switch"; label = "Do not disturb toggle"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.enabled = true;

    # @option widget = "spin"; label = "Do not disturb order"; group = "System"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb._order = 150;

    # @option widget = "spin"; label = "Do not disturb column"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.col = 4;

    # @option widget = "spin"; label = "Do not disturb row"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.row = 7;

    # @option widget = "spin"; label = "Do not disturb width"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.w = 2;

    # @option widget = "spin"; label = "Do not disturb height"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.h = 1;

    # @option widget = "switch"; label = "Do not disturb footer"; group = "System"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.footer = true;

    # @option widget = "spin"; label = "Do not disturb footer width"; group = "System"; min = 1; max = 12; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.doNotDisturb.footerW = 1;

    # @option widget = "switch"; label = "Idle inhibitor toggle"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.enabled = true;

    # @option widget = "spin"; label = "Idle inhibitor order"; group = "System"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor._order = 160;

    # @option widget = "spin"; label = "Idle inhibitor column"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.col = 4;

    # @option widget = "spin"; label = "Idle inhibitor row"; group = "System"; min = 0; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.row = 6;

    # @option widget = "spin"; label = "Idle inhibitor width"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.w = 2;

    # @option widget = "spin"; label = "Idle inhibitor height"; group = "System"; min = 1; max = 12;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.h = 1;

    # @option widget = "switch"; label = "Idle inhibitor footer"; group = "System"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.footer = true;

    # @option widget = "spin"; label = "Idle inhibitor footer width"; group = "System"; min = 1; max = 12; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.idleInhibitor.footerW = 1;

    # @option widget = "switch"; label = "Running apps"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.runningApps.enabled = true;

    # @option widget = "spin"; label = "Running apps order"; group = "System"; min = 1; max = 200; hidden = true;
    desktop.ojuny.dms.controlCenterWidgets.runningApps._order = 170;

    # @option widget = "spin"; label = "Running apps width"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.runningApps.w = 4;

    # @option widget = "spin"; label = "Running apps height"; group = "System";
    desktop.ojuny.dms.controlCenterWidgets.runningApps.h = 1;

    # @option widget = "switch"; label = "Running apps footer"; group = "System"; advanced = true;
    desktop.ojuny.dms.controlCenterWidgets.runningApps.footer = true;

  };

}
