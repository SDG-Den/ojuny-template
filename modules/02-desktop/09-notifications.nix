/*
  @menu
  displayname = "Notifications";
  icon = "preferences-system-notifications-symbolic";
  order = 70;
  description = "Notification popups and clipboard history";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-notifications = { config, pkgs, ... }: {

    # @option widget = "spin"; label = "Popup duration"; group = "Popups"; groupOrder = 10; order = 10; min = 0; step = 50; unit = "ms";
    desktop.ojuny.dms.settings.notificationAnimationDuration = 400;

    # @option widget = "switch"; label = "Compact mode"; group = "Popups"; groupOrder = 10; order = 20;
    desktop.ojuny.dms.settings.notificationCompactMode = true;

    # @option widget = "switch"; label = "Overlay"; group = "Popups"; groupOrder = 10; order = 30;
    desktop.ojuny.dms.settings.notificationOverlayEnabled = true;

    # @option widget = "switch"; label = "Show timeout bar"; group = "Popups"; groupOrder = 10; order = 40;
    desktop.ojuny.dms.settings.notificationShowTimeoutBar = true;

    # @option widget = "switch"; label = "Only on focused monitor"; group = "Popups"; groupOrder = 10; order = 50;
    desktop.ojuny.dms.settings.notificationFocusedMonitor = true;

    # @option widget = "spin"; label = "Summary font size"; group = "Popups"; groupOrder = 10; order = 60; min = 6; unit = "pt";
    desktop.ojuny.dms.settings.notificationSummaryFontSize = 16;

    # @option widget = "spin"; label = "Body font size"; group = "Popups"; groupOrder = 10; order = 70; min = 6; unit = "pt";
    desktop.ojuny.dms.settings.notificationBodyFontSize = 10;

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
