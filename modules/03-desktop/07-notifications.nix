/*
  @menu
  displayname = "Notifications";
  icon = "preferences-system-notifications-symbolic";
  order = 70;
  description = "Notification popups";
  category = "03-Desktop";
*/

{ self, inputs, ... }:

let
  popupPositions = {
    "top-right" = 0;
    "top-left" = 2;
    "top-center" = -1;
    "bottom-center" = 5;
    "bottom-right" = 3;
    "bottom-left" = 1;
  };
in
{

  flake.modules.nixos.desktop-notifications =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.dms.notificationPopupPosition = lib.mkOption {
        type = lib.types.enum (lib.attrNames popupPositions);
        default = "top-right";
      };

      config = {

        # @option widget = "dropdown"; label = "Notification popup position"; group = "Popups"; groupOrder = 10; order = 5; choices = [ "top-right" "top-left" "top-center" "bottom-center" "bottom-right" "bottom-left" ];
        ojuny.dms.notificationPopupPosition = "top-right";

        desktop.ojuny.dms.settings.notificationPopupPosition =
          popupPositions.${config.ojuny.dms.notificationPopupPosition};

        # @option widget = "spin"; label = "Popup duration"; group = "Popups"; groupOrder = 10; order = 10; min = 0; step = 50; unit = "ms";
        desktop.ojuny.dms.settings.notificationAnimationDuration = 400;

        # @option widget = "switch"; label = "Compact mode"; group = "Popups"; groupOrder = 10; order = 20;
        desktop.ojuny.dms.settings.notificationCompactMode = true;

        # @option widget = "switch"; label = "Overlay"; group = "Popups"; groupOrder = 10; order = 30; applyCommand = "dms ipc call settings set notificationOverlayEnabled %%val%%";
        desktop.ojuny.dms.settings.notificationOverlayEnabled = true;

        # @option widget = "switch"; label = "Show timeout bar"; group = "Popups"; groupOrder = 10; order = 40; applyCommand = "dms ipc call settings set notificationShowTimeoutBar %%val%%";
        desktop.ojuny.dms.settings.notificationShowTimeoutBar = true;

        # @option widget = "switch"; label = "Only on focused monitor"; group = "Popups"; groupOrder = 10; order = 50; applyCommand = "dms ipc call settings set notificationFocusedMonitor %%val%%";
        desktop.ojuny.dms.settings.notificationFocusedMonitor = true;

        # @option widget = "spin"; label = "Summary font size"; group = "Popups"; groupOrder = 10; order = 60; min = 6; unit = "pt"; applyCommand = "dms ipc call settings set notificationSummaryFontSize %%val%%";
        desktop.ojuny.dms.settings.notificationSummaryFontSize = 16;

        # @option widget = "spin"; label = "Body font size"; group = "Popups"; groupOrder = 10; order = 70; min = 6; unit = "pt"; applyCommand = "dms ipc call settings set notificationBodyFontSize %%val%%";
        desktop.ojuny.dms.settings.notificationBodyFontSize = 10;

        # @option widget = "switch"; label = "Suppress duplicates"; group = "Popups"; groupOrder = 10; order = 80; applyCommand = "dms ipc call settings set notificationDedupeEnabled %%val%%";
        desktop.ojuny.dms.settings.notificationDedupeEnabled = true;

        # @option widget = "switch"; label = "Body click runs default action"; group = "Popups"; groupOrder = 10; order = 90; applyCommand = "dms ipc call settings set notificationPopupBodyInvokesAction %%val%%";
        desktop.ojuny.dms.settings.notificationPopupBodyInvokesAction = false;

        # @option widget = "switch"; label = "Foreground layers"; group = "Popups"; groupOrder = 10; order = 100; applyCommand = "dms ipc call settings set notificationForegroundLayers %%val%%";
        desktop.ojuny.dms.settings.notificationForegroundLayers = true;

        # @option widget = "switch"; label = "Popup shadow"; group = "Popups"; groupOrder = 10; order = 110; advanced = true; applyCommand = "dms ipc call settings set notificationPopupShadowEnabled %%val%%";
        desktop.ojuny.dms.settings.notificationPopupShadowEnabled = true;

        # @option widget = "spin"; label = "Low timeout"; group = "Timeouts"; groupOrder = 20; order = 10; min = 0; max = 600000; step = 1000; unit = "ms"; advanced = true; description = "0 = never.";
        desktop.ojuny.dms.settings.notificationTimeoutLow = 5000;

        # @option widget = "spin"; label = "Normal timeout"; group = "Timeouts"; groupOrder = 20; order = 20; min = 0; max = 600000; step = 1000; unit = "ms"; advanced = true; description = "0 = never.";
        desktop.ojuny.dms.settings.notificationTimeoutNormal = 5000;

        # @option widget = "spin"; label = "Critical timeout"; group = "Timeouts"; groupOrder = 20; order = 30; min = 0; max = 600000; step = 1000; unit = "ms"; advanced = true; description = "0 = never.";
        desktop.ojuny.dms.settings.notificationTimeoutCritical = 0;

        # @option widget = "switch"; label = "Ignore app-requested timeout"; group = "Timeouts"; groupOrder = 20; order = 40; advanced = true; description = "Use the timeouts above instead of app durations."; applyCommand = "dms ipc call settings set notificationIgnoreAppTimeout %%val%%";
        desktop.ojuny.dms.settings.notificationIgnoreAppTimeout = false;

        # @option widget = "switch"; label = "Automatically enable while screen sharing"; group = "Do not disturb"; groupOrder = 30; order = 10; applyCommand = "dms ipc call settings set notificationDndWhileScreenSharing %%val%%";
        desktop.ojuny.dms.settings.notificationDndWhileScreenSharing = true;

        # @option widget = "switch"; label = "Allow critical"; group = "Do not disturb"; groupOrder = 30; order = 20; description = "Critical notifications still pop up."; applyCommand = "dms ipc call settings set notificationDndAllowCritical %%val%%";
        desktop.ojuny.dms.settings.notificationDndAllowCritical = true;

        # @option widget = "switch"; label = "Privacy mode"; group = "Privacy"; groupOrder = 40; order = 10; advanced = true; description = "Popups hide the message until expanded."; applyCommand = "dms ipc call settings set notificationPopupPrivacyMode %%val%%";
        desktop.ojuny.dms.settings.notificationPopupPrivacyMode = false;

        # @option widget = "switch"; label = "History"; group = "History"; groupOrder = 50; order = 10; applyCommand = "dms ipc call settings set notificationHistoryEnabled %%val%%";
        desktop.ojuny.dms.settings.notificationHistoryEnabled = true;

        # @option widget = "dropdown"; label = "Retention"; group = "History"; groupOrder = 50; order = 20; choices = [ "0" "1" "3" "7" "14" "30" ]; advanced = true; description = "0 = forever."; applyCommand = "dms ipc call settings set notificationHistoryMaxAgeDays %%val%%";
        desktop.ojuny.dms.settings.notificationHistoryMaxAgeDays = 7;

        # @option widget = "spin"; label = "Maximum entries"; group = "History"; groupOrder = 50; order = 30; min = 10; max = 200; step = 10; advanced = true; applyCommand = "dms ipc call settings set notificationHistoryMaxCount %%val%%";
        desktop.ojuny.dms.settings.notificationHistoryMaxCount = 50;

        # @option widget = "switch"; label = "Low"; group = "History"; groupOrder = 50; order = 40; advanced = true; applyCommand = "dms ipc call settings set notificationHistorySaveLow %%val%%";
        desktop.ojuny.dms.settings.notificationHistorySaveLow = true;

        # @option widget = "switch"; label = "Normal"; group = "History"; groupOrder = 50; order = 50; advanced = true; applyCommand = "dms ipc call settings set notificationHistorySaveNormal %%val%%";
        desktop.ojuny.dms.settings.notificationHistorySaveNormal = true;

        # @option widget = "switch"; label = "Critical"; group = "History"; groupOrder = 50; order = 60; advanced = true; applyCommand = "dms ipc call settings set notificationHistorySaveCritical %%val%%";
        desktop.ojuny.dms.settings.notificationHistorySaveCritical = true;

      };
    };

}
