/*
  @menu
  displayname = "Power";
  icon = "preferences-system-power-symbolic";
  order = 50;
  description = "Charge limit, battery alerts, idle timeouts and power actions";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-power = { config, pkgs, ... }: {

    # @option widget = "slider"; label = "Charge limit"; group = "Charge limit"; groupOrder = 10; order = 10; min = 50; max = 100; step = 1; unit = "%"; description = "Stop charging at this percentage (needs a writable sysfs threshold).";
    desktop.ojuny.dms.settings.batteryChargeLimit = 100;

    # @option widget = "switch"; label = "Notify when limit is reached"; group = "Charge limit"; groupOrder = 10; order = 20;
    desktop.ojuny.dms.settings.batteryNotifyChargeLimit = false;

    # @option widget = "dropdown"; label = "Alert style"; group = "Charge limit"; groupOrder = 10; order = 30; choices = [ "0" "1" ]; description = "0 = toast, 1 = notification."; visibleWhen.path = "desktop.ojuny.dms.settings.batteryNotifyChargeLimit"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.batteryChargeLimitNotificationType = 0;

    # @option widget = "slider"; label = "Low threshold"; group = "Alerts"; groupOrder = 20; order = 10; min = 5; max = 40; step = 1; unit = "%";
    desktop.ojuny.dms.settings.batteryLowThreshold = 20;

    # @option widget = "switch"; label = "Low notification"; group = "Alerts"; groupOrder = 20; order = 20;
    desktop.ojuny.dms.settings.batteryNotifyLow = false;

    # @option widget = "dropdown"; label = "Alert style"; group = "Alerts"; groupOrder = 20; order = 30; choices = [ "0" "1" ]; description = "0 = toast, 1 = notification."; visibleWhen.path = "desktop.ojuny.dms.settings.batteryNotifyLow"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.batteryLowNotificationType = 0;

    # @option widget = "slider"; label = "Critical threshold"; group = "Alerts"; groupOrder = 20; order = 40; min = 1; max = 30; step = 1; unit = "%";
    desktop.ojuny.dms.settings.batteryCriticalThreshold = 10;

    # @option widget = "switch"; label = "Critical notification"; group = "Alerts"; groupOrder = 20; order = 50;
    desktop.ojuny.dms.settings.batteryNotifyCritical = true;

    # @option widget = "dropdown"; label = "Alert style"; group = "Alerts"; groupOrder = 20; order = 60; choices = [ "0" "1" ]; description = "0 = toast, 1 = notification."; visibleWhen.path = "desktop.ojuny.dms.settings.batteryNotifyCritical"; visibleWhen.equals = true;
    desktop.ojuny.dms.settings.batteryCriticalNotificationType = 1;

    # @option widget = "switch"; label = "Pulse animation"; group = "Alerts"; groupOrder = 20; order = 70; description = "Blink the battery indicator at the critical threshold.";
    desktop.ojuny.dms.settings.batteryCriticalAnimation = true;

    # @option widget = "switch"; label = "Auto power saver"; group = "Power profiles"; groupOrder = 30; order = 10; description = "Switches to power saver at the low battery threshold.";
    desktop.ojuny.dms.settings.batteryAutoPowerSaver = false;

    # @option widget = "dropdown"; label = "Profile on AC"; group = "Power profiles"; groupOrder = 30; order = 20; choices = [ "" "0" "1" "2" ]; description = "0 = power saver, 1 = balanced, 2 = performance; empty = don't change.";
    desktop.ojuny.dms.settings.acProfileName = "";

    # @option widget = "dropdown"; label = "Profile on battery"; group = "Power profiles"; groupOrder = 30; order = 30; choices = [ "" "0" "1" "2" ]; description = "0 = power saver, 1 = balanced, 2 = performance; empty = don't change.";
    desktop.ojuny.dms.settings.batteryProfileName = "";

    # @option widget = "dropdown"; label = "Automatically lock after (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 10; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.acLockTimeout = 0;

    # @option widget = "dropdown"; label = "Automatically lock after (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 20; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.batteryLockTimeout = 0;

    # @option widget = "dropdown"; label = "Turn off displays after (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 30; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.acMonitorTimeout = 0;

    # @option widget = "dropdown"; label = "Turn off displays after (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 40; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.batteryMonitorTimeout = 0;

    # @option widget = "dropdown"; label = "Turn off displays after lock (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 50; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; advanced = true; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.acPostLockMonitorTimeout = 0;

    # @option widget = "dropdown"; label = "Turn off displays after lock (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 60; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; advanced = true; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.batteryPostLockMonitorTimeout = 0;

    # @option widget = "dropdown"; label = "Suspend system after (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 70; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.acSuspendTimeout = 0;

    # @option widget = "dropdown"; label = "Suspend system after (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 80; choices = [ "0" "15" "30" "60" "120" "180" "300" "600" "900" "1200" "1800" "3600" "5400" "7200" "10800" ]; unit = "s"; description = "Seconds; 0 = never.";
    desktop.ojuny.dms.settings.batterySuspendTimeout = 0;

    # @option widget = "dropdown"; label = "Suspend behavior (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 90; choices = [ "0" "1" "2" ]; advanced = true; description = "0 = suspend, 1 = hibernate, 2 = suspend then hibernate.";
    desktop.ojuny.dms.settings.acSuspendBehavior = 0;

    # @option widget = "dropdown"; label = "Suspend behavior (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 100; choices = [ "0" "1" "2" ]; advanced = true; description = "0 = suspend, 1 = hibernate, 2 = suspend then hibernate.";
    desktop.ojuny.dms.settings.batterySuspendBehavior = 0;

    # @option widget = "text"; label = "Lock"; group = "Custom commands"; groupOrder = 50; order = 10; advanced = true; placeholder = "/usr/bin/myLock.sh"; description = "Runs instead of the built-in action; empty keeps the default.";
    desktop.ojuny.dms.settings.customPowerActionLock = "";

    # @option widget = "text"; label = "Log out"; group = "Custom commands"; groupOrder = 50; order = 20; advanced = true; placeholder = "/usr/bin/myLogout.sh"; description = "Runs instead of the built-in action; empty keeps the default.";
    desktop.ojuny.dms.settings.customPowerActionLogout = "";

    # @option widget = "text"; label = "Suspend"; group = "Custom commands"; groupOrder = 50; order = 30; advanced = true; placeholder = "/usr/bin/mySuspend.sh"; description = "Runs instead of the built-in action; empty keeps the default.";
    desktop.ojuny.dms.settings.customPowerActionSuspend = "";

    # @option widget = "text"; label = "Hibernate"; group = "Custom commands"; groupOrder = 50; order = 40; advanced = true; placeholder = "/usr/bin/myHibernate.sh"; description = "Runs instead of the built-in action; empty keeps the default.";
    desktop.ojuny.dms.settings.customPowerActionHibernate = "";

    # @option widget = "text"; label = "Reboot"; group = "Custom commands"; groupOrder = 50; order = 50; advanced = true; placeholder = "/usr/bin/myReboot.sh"; description = "Runs instead of the built-in action; empty keeps the default.";
    desktop.ojuny.dms.settings.customPowerActionReboot = "";

    # @option widget = "text"; label = "Power off"; group = "Custom commands"; groupOrder = 50; order = 60; advanced = true; placeholder = "/usr/bin/myPowerOff.sh"; description = "Runs instead of the built-in action; empty keeps the default.";
    desktop.ojuny.dms.settings.customPowerActionPowerOff = "";

  };

}
