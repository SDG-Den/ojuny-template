/*
  @menu
  displayname = "Notifications";
  icon = "preferences-system-notifications-symbolic";
  order = 70;
  description = "Notification popups";
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

  };

}
