/*
  @menu
  displayname = "Lock screen";
  icon = "system-lock-screen-symbolic";
  order = 60;
  description = "Lock behaviour, authentication and screensaver";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-lock = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Lock at startup"; group = "Behavior"; groupOrder = 10; order = 10;
    desktop.ojuny.dms.settings.lockAtStartup = false;

    # @option widget = "switch"; label = "Lock before suspend"; group = "Behavior"; groupOrder = 10; order = 20;
    desktop.ojuny.dms.settings.lockBeforeSuspend = false;

    # @option widget = "switch"; label = "Power off displays on lock"; group = "Behavior"; groupOrder = 10; order = 30;
    desktop.ojuny.dms.settings.lockScreenPowerOffMonitorsOnLock = false;

    # @option widget = "switch"; label = "loginctl integration"; group = "Behavior"; groupOrder = 10; order = 40; advanced = true; description = "Lets loginctl lock requests reach the shell.";
    desktop.ojuny.dms.settings.loginctlLockIntegration = true;

    # @option widget = "switch"; label = "Fingerprint"; group = "Authentication"; groupOrder = 20; order = 10; description = "Unlock with a fingerprint reader via fprint.";
    desktop.ojuny.dms.settings.enableFprint = false;

    # @option widget = "spin"; label = "Fingerprint attempts"; group = "Authentication"; groupOrder = 20; order = 20; min = 1; max = 30; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.enableFprint"; visibleWhen.equals = true; description = "Failed attempts before the reader is locked out.";
    desktop.ojuny.dms.settings.maxFprintTries = 15;

    # @option widget = "switch"; label = "Security key"; group = "Authentication"; groupOrder = 20; order = 30; description = "Unlock with a FIDO security key.";
    desktop.ojuny.dms.settings.enableU2f = false;

    # @option widget = "dropdown"; label = "Security key mode"; group = "Authentication"; groupOrder = 20; order = 40; choices = [ "or" "and" ]; visibleWhen.path = "desktop.ojuny.dms.settings.enableU2f"; visibleWhen.equals = true; description = "or = the key unlocks on its own, and = the key is a second factor after password or fingerprint.";
    desktop.ojuny.dms.settings.u2fMode = "or";

    # @option widget = "switch"; label = "Security key shortcut"; group = "Authentication"; groupOrder = 20; order = 50; visibleWhen.path = "desktop.ojuny.dms.settings.enableU2f"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.lockScreenSecurityKeyShortcutEnabled = false;

    # @option widget = "text"; label = "Key combination"; group = "Authentication"; groupOrder = 20; order = 60; visibleWhen.path = "desktop.ojuny.dms.settings.lockScreenSecurityKeyShortcutEnabled"; visibleWhen.equals = true; description = "Format: Ctrl+Q.";
    desktop.ojuny.dms.settings.lockScreenSecurityKeyShortcut = "Ctrl+Q";

    # @option widget = "color"; label = "Inactive display color"; group = "Displays"; groupOrder = 30; order = 10; description = "Solid colour for locked-off displays (OLED burn-in protection).";
    desktop.ojuny.dms.settings.lockScreenInactiveColor = "#000000";

    # @option widget = "switch"; label = "Play video on lock"; group = "Video screensaver"; groupOrder = 40; order = 10;
    desktop.ojuny.dms.settings.lockScreenVideoEnabled = false;

    # @option widget = "text"; label = "Video path"; group = "Video screensaver"; groupOrder = 40; order = 20; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.lockScreenVideoEnabled"; visibleWhen.equals = true; description = "Absolute path to a video file; kept as a runtime string, not a store path.";
    desktop.ojuny.dms.settings.lockScreenVideoPath = "";

    # @option widget = "switch"; label = "Automatic cycling"; group = "Video screensaver"; groupOrder = 40; order = 30; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.lockScreenVideoEnabled"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.lockScreenVideoCycling = false;

  };

}
