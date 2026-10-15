/*
  @menu
  displayname = "Notifications";
  icon = "preferences-system-notifications-symbolic";
  order = 90;
  description = "Notification popups and clipboard history";
  category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-notifications = { config, pkgs, ... }: {

    # @option widget = "spin"; label = "Popup duration"; group = "Popups"; min = 0; max = 5000; step = 50; unit = "ms";
    desktop.ojuny.dms.settings.notificationAnimationDuration = 400;

    # @option widget = "switch"; label = "Compact mode"; group = "Popups";
    desktop.ojuny.dms.settings.notificationCompactMode = true;

    # @option widget = "switch"; label = "Overlay"; group = "Popups";
    desktop.ojuny.dms.settings.notificationOverlayEnabled = true;

    # @option widget = "switch"; label = "Show timeout bar"; group = "Popups";
    desktop.ojuny.dms.settings.notificationShowTimeoutBar = true;

    # @option widget = "switch"; label = "Only on focused monitor"; group = "Popups";
    desktop.ojuny.dms.settings.notificationFocusedMonitor = true;

    # @option widget = "spin"; label = "Summary font size"; group = "Popups"; min = 6; max = 32; unit = "pt";
    desktop.ojuny.dms.settings.notificationSummaryFontSize = 16;

    # @option widget = "spin"; label = "Body font size"; group = "Popups"; min = 6; max = 32; unit = "pt";
    desktop.ojuny.dms.settings.notificationBodyFontSize = 10;

    # @option widget = "switch"; label = "Keep history"; group = "Clipboard";
    desktop.ojuny.dms.clipboardSettings.disableHistory = false;

    # @option widget = "switch"; label = "Persist across reboots"; group = "Clipboard"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.disablePersist = false;

    # @option widget = "switch"; label = "Clear at startup"; group = "Clipboard"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.clearAtStartup = true;

    # @option widget = "spin"; label = "Auto clear after"; group = "Clipboard"; min = 0; max = 30; unit = "days"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.autoClearDays = 1;

    # @option widget = "spin"; label = "History size"; group = "Clipboard"; min = 1; max = 500; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxHistory = 25;

    # @option widget = "spin"; label = "Max entry size"; group = "Clipboard"; min = 0; max = 104857600; step = 1024; unit = "bytes"; visibleWhen.path = "desktop.ojuny.dms.clipboardSettings.disableHistory"; visibleWhen.equals = false;
    desktop.ojuny.dms.clipboardSettings.maxEntrySize = 5242880;

  };

}
