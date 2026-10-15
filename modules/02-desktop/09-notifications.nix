/* @menu
   displayname = "Notifications";
   icon = "preferences-system-notifications-symbolic";
   order = 90;
   description = "Notification popups and OSD";
   category = "Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-notifications = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # NOTE: notification behaviour in desktop.ojuny.dms.settings
    # (notificationAnimationDuration, notificationBodyFontSize,
    # notificationCompactMode, notificationFocusedMonitor,
    # notificationOverlayEnabled, notificationShowTimeoutBar,
    # notificationSummaryFontSize). OSD settings (osdAlwaysShowValue) are
    # folded into this page.

  };

}
