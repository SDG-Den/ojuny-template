/*
  @menu
  displayname = "Bluetooth";
  icon = "bluetooth-active-symbolic";
  order = 30;
  description = "Bluetooth pairing and services";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-bluetooth = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Bluetooth"; group = "Bluetooth"; applyCommand = "if test %%val%% = true; then bluetoothctl power on; else bluetoothctl power off; fi";
    hardware.bluetooth.enable = true;

    # @option widget = "switch"; label = "Power on at boot"; group = "Bluetooth"; visibleWhen.path = "hardware.bluetooth.enable"; visibleWhen.equals = true;
    hardware.bluetooth.powerOnBoot = true;

    # @option widget = "switch"; label = "Experimental features"; group = "Advanced"; visibleWhen.path = "hardware.bluetooth.enable"; visibleWhen.equals = true; hidden = true; description = "Enable experimental BlueZ features.";
    hardware.bluetooth.settings.General.Experimental = true;

    # @option widget = "switch"; label = "Auto enable"; group = "Advanced"; visibleWhen.path = "hardware.bluetooth.enable"; visibleWhen.equals = true; hidden = true;
    hardware.bluetooth.settings.Policy.AutoEnable = false;

    # @option widget = "switch"; label = "Blueman applet"; group = "Bluetooth"; visibleWhen.path = "hardware.bluetooth.enable"; visibleWhen.equals = true;
    services.blueman.enable = true;

    # @option widget = "switch"; label = "Bluetooth media controls"; group = "Bluetooth"; visibleWhen.path = "hardware.bluetooth.enable"; visibleWhen.equals = true; description = "Route Bluetooth headset buttons to the active DMS media player instead of mpris-proxy."; applyCommand = "dms ipc call settings set bluetoothMprisEnabled %%val%%";
    desktop.ojuny.dux.settings.bluetoothMprisEnabled = false;

  };

}
