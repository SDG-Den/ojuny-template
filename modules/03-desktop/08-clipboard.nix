/*
  @menu
  displayname = "Clipboard";
  icon = "edit-paste-symbolic";
  order = 80;
  description = "Clipboard history settings";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-clipboard = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Keep history"; group = "Clipboard"; groupOrder = 20; order = 10;
    desktop.ojuny.dms.clipboardSettings.disableHistory = false;

    # @option widget = "switch"; label = "Persist across reboots"; group = "Clipboard"; groupOrder = 20; order = 20; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.disablePersist = false;

    # @option widget = "switch"; label = "Clear at startup"; group = "Clipboard"; groupOrder = 20; order = 30; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.clearAtStartup = true;

    # @option widget = "spin"; label = "Auto clear after"; group = "Clipboard"; groupOrder = 20; order = 40; min = 0; unit = "days"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.autoClearDays = 1;

    # @option widget = "spin"; label = "History size"; group = "Clipboard"; groupOrder = 20; order = 50; min = 1; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxHistory = 25;

    # @option widget = "spin"; label = "Max entry size"; group = "Clipboard"; groupOrder = 20; order = 60; min = 0; step = 1024; unit = "bytes"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxEntrySize = 5242880;

  };

}
