/*
  @menu
  displayname = "Power";
  icon = "preferences-system-power-symbolic";
  order = 50;
  description = "Charge limit, battery alerts, idle timeouts and power actions";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-power =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      notificationStyles = {
        "toast" = 0;
        "notification" = 1;
      };

      powerProfiles = {
        "unchanged" = "";
        "power-saver" = "0";
        "balanced" = "1";
        "performance" = "2";
      };

      timeoutPresets = {
        "never" = 0;
        "15 seconds" = 15;
        "30 seconds" = 30;
        "1 minute" = 60;
        "2 minutes" = 120;
        "3 minutes" = 180;
        "5 minutes" = 300;
        "10 minutes" = 600;
        "15 minutes" = 900;
        "20 minutes" = 1200;
        "30 minutes" = 1800;
        "1 hour" = 3600;
        "1.5 hours" = 5400;
        "2 hours" = 7200;
        "3 hours" = 10800;
      };

      suspendBehaviors = {
        "suspend" = 0;
        "hibernate" = 1;
        "suspend-then-hibernate" = 2;
      };

      enumSpecs = {
        batteryChargeLimitNotificationType = {
          default = "toast";
          choices = notificationStyles;
        };
        batteryLowNotificationType = {
          default = "toast";
          choices = notificationStyles;
        };
        batteryCriticalNotificationType = {
          default = "notification";
          choices = notificationStyles;
        };
        acProfileName = {
          default = "unchanged";
          choices = powerProfiles;
        };
        batteryProfileName = {
          default = "unchanged";
          choices = powerProfiles;
        };
        acLockTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        batteryLockTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        acMonitorTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        batteryMonitorTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        acPostLockMonitorTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        batteryPostLockMonitorTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        acSuspendTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        batterySuspendTimeout = {
          default = "never";
          choices = timeoutPresets;
        };
        acSuspendBehavior = {
          default = "suspend";
          choices = suspendBehaviors;
        };
        batterySuspendBehavior = {
          default = "suspend";
          choices = suspendBehaviors;
        };
      };
    in
    {

      options.ojuny.dms = lib.mapAttrs (
        name: spec:
        lib.mkOption {
          type = lib.types.enum (lib.attrNames spec.choices);
          inherit (spec) default;
          description = "DMS ${name}.";
        }
      ) enumSpecs;

      config = {

        # @option widget = "slider"; label = "Charge limit"; group = "Charge limit"; groupOrder = 10; order = 10; min = 50; max = 100; step = 1; unit = "%"; description = "Stop charging at this percentage (needs a writable sysfs threshold)."; applyCommand = "dms ipc call settings set batteryChargeLimit %%val%%";
        desktop.ojuny.dms.settings.batteryChargeLimit = 100;

        # @option widget = "switch"; label = "Notify when limit is reached"; group = "Charge limit"; groupOrder = 10; order = 20; applyCommand = "dms ipc call settings set batteryNotifyChargeLimit %%val%%";
        desktop.ojuny.dms.settings.batteryNotifyChargeLimit = false;

        # @option widget = "dropdown"; label = "Alert style"; group = "Charge limit"; groupOrder = 10; order = 30; choices = [ "toast" "notification" ]; visibleWhen.path = "desktop.ojuny.dms.settings.batteryNotifyChargeLimit"; visibleWhen.equals = true; applyCommand = "case %%val%% in toast) v=0;; notification) v=1;; esac; dms ipc call settings set batteryChargeLimitNotificationType $v";
        ojuny.dms.batteryChargeLimitNotificationType = "toast";

        desktop.ojuny.dms.settings.batteryChargeLimitNotificationType =
          notificationStyles.${config.ojuny.dms.batteryChargeLimitNotificationType};

        # @option widget = "slider"; label = "Low threshold"; group = "Alerts"; groupOrder = 20; order = 10; min = 5; max = 40; step = 1; unit = "%"; applyCommand = "dms ipc call settings set batteryLowThreshold %%val%%";
        desktop.ojuny.dms.settings.batteryLowThreshold = 20;

        # @option widget = "switch"; label = "Low notification"; group = "Alerts"; groupOrder = 20; order = 20; applyCommand = "dms ipc call settings set batteryNotifyLow %%val%%";
        desktop.ojuny.dms.settings.batteryNotifyLow = false;

        # @option widget = "dropdown"; label = "Alert style"; group = "Alerts"; groupOrder = 20; order = 30; choices = [ "toast" "notification" ]; visibleWhen.path = "desktop.ojuny.dms.settings.batteryNotifyLow"; visibleWhen.equals = true; applyCommand = "case %%val%% in toast) v=0;; notification) v=1;; esac; dms ipc call settings set batteryLowNotificationType $v";
        ojuny.dms.batteryLowNotificationType = "toast";

        desktop.ojuny.dms.settings.batteryLowNotificationType =
          notificationStyles.${config.ojuny.dms.batteryLowNotificationType};

        # @option widget = "slider"; label = "Critical threshold"; group = "Alerts"; groupOrder = 20; order = 40; min = 1; max = 30; step = 1; unit = "%"; applyCommand = "dms ipc call settings set batteryCriticalThreshold %%val%%";
        desktop.ojuny.dms.settings.batteryCriticalThreshold = 10;

        # @option widget = "switch"; label = "Critical notification"; group = "Alerts"; groupOrder = 20; order = 50; applyCommand = "dms ipc call settings set batteryNotifyCritical %%val%%";
        desktop.ojuny.dms.settings.batteryNotifyCritical = true;

        # @option widget = "dropdown"; label = "Alert style"; group = "Alerts"; groupOrder = 20; order = 60; choices = [ "toast" "notification" ]; visibleWhen.path = "desktop.ojuny.dms.settings.batteryNotifyCritical"; visibleWhen.equals = true; applyCommand = "case %%val%% in toast) v=0;; notification) v=1;; esac; dms ipc call settings set batteryCriticalNotificationType $v";
        ojuny.dms.batteryCriticalNotificationType = "notification";

        desktop.ojuny.dms.settings.batteryCriticalNotificationType =
          notificationStyles.${config.ojuny.dms.batteryCriticalNotificationType};

        # @option widget = "switch"; label = "Pulse animation"; group = "Alerts"; groupOrder = 20; order = 70; description = "Blink the battery indicator at the critical threshold."; applyCommand = "dms ipc call settings set batteryCriticalAnimation %%val%%";
        desktop.ojuny.dms.settings.batteryCriticalAnimation = true;

        # @option widget = "switch"; label = "Auto power saver"; group = "Power profiles"; groupOrder = 30; order = 10; description = "Switches to power saver at the low battery threshold."; applyCommand = "dms ipc call settings set batteryAutoPowerSaver %%val%%";
        desktop.ojuny.dms.settings.batteryAutoPowerSaver = false;

        # @option widget = "dropdown"; label = "Profile on AC"; group = "Power profiles"; groupOrder = 30; order = 20; choices = [ "unchanged" "power-saver" "balanced" "performance" ]; applyCommand = "case %%val%% in unchanged) v='';; power-saver) v=0;; balanced) v=1;; performance) v=2;; esac; dms ipc call settings set acProfileName \"$v\"";
        ojuny.dms.acProfileName = "unchanged";

        desktop.ojuny.dms.settings.acProfileName = powerProfiles.${config.ojuny.dms.acProfileName};

        # @option widget = "dropdown"; label = "Profile on battery"; group = "Power profiles"; groupOrder = 30; order = 30; choices = [ "unchanged" "power-saver" "balanced" "performance" ]; applyCommand = "case %%val%% in unchanged) v='';; power-saver) v=0;; balanced) v=1;; performance) v=2;; esac; dms ipc call settings set batteryProfileName \"$v\"";
        ojuny.dms.batteryProfileName = "unchanged";

        desktop.ojuny.dms.settings.batteryProfileName =
          powerProfiles.${config.ojuny.dms.batteryProfileName};

        # @option widget = "dropdown"; label = "Automatically lock after (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 10; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set acLockTimeout $v";
        ojuny.dms.acLockTimeout = "never";

        desktop.ojuny.dms.settings.acLockTimeout = timeoutPresets.${config.ojuny.dms.acLockTimeout};

        # @option widget = "dropdown"; label = "Automatically lock after (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 20; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set batteryLockTimeout $v";
        ojuny.dms.batteryLockTimeout = "never";

        desktop.ojuny.dms.settings.batteryLockTimeout =
          timeoutPresets.${config.ojuny.dms.batteryLockTimeout};

        # @option widget = "dropdown"; label = "Turn off displays after (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 30; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set acMonitorTimeout $v";
        ojuny.dms.acMonitorTimeout = "never";

        desktop.ojuny.dms.settings.acMonitorTimeout = timeoutPresets.${config.ojuny.dms.acMonitorTimeout};

        # @option widget = "dropdown"; label = "Turn off displays after (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 40; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set batteryMonitorTimeout $v";
        ojuny.dms.batteryMonitorTimeout = "never";

        desktop.ojuny.dms.settings.batteryMonitorTimeout =
          timeoutPresets.${config.ojuny.dms.batteryMonitorTimeout};

        # @option widget = "dropdown"; label = "Turn off displays after lock (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 50; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; advanced = true; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set acPostLockMonitorTimeout $v";
        ojuny.dms.acPostLockMonitorTimeout = "never";

        desktop.ojuny.dms.settings.acPostLockMonitorTimeout =
          timeoutPresets.${config.ojuny.dms.acPostLockMonitorTimeout};

        # @option widget = "dropdown"; label = "Turn off displays after lock (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 60; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; advanced = true; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set batteryPostLockMonitorTimeout $v";
        ojuny.dms.batteryPostLockMonitorTimeout = "never";

        desktop.ojuny.dms.settings.batteryPostLockMonitorTimeout =
          timeoutPresets.${config.ojuny.dms.batteryPostLockMonitorTimeout};

        # @option widget = "dropdown"; label = "Suspend system after (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 70; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set acSuspendTimeout $v";
        ojuny.dms.acSuspendTimeout = "never";

        desktop.ojuny.dms.settings.acSuspendTimeout = timeoutPresets.${config.ojuny.dms.acSuspendTimeout};

        # @option widget = "dropdown"; label = "Suspend system after (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 80; choices = [ "never" "15 seconds" "30 seconds" "1 minute" "2 minutes" "3 minutes" "5 minutes" "10 minutes" "15 minutes" "20 minutes" "30 minutes" "1 hour" "1.5 hours" "2 hours" "3 hours" ]; applyCommand = "case %%val%% in never) v=0;; \"15 seconds\") v=15;; \"30 seconds\") v=30;; \"1 minute\") v=60;; \"2 minutes\") v=120;; \"3 minutes\") v=180;; \"5 minutes\") v=300;; \"10 minutes\") v=600;; \"15 minutes\") v=900;; \"20 minutes\") v=1200;; \"30 minutes\") v=1800;; \"1 hour\") v=3600;; \"1.5 hours\") v=5400;; \"2 hours\") v=7200;; \"3 hours\") v=10800;; esac; dms ipc call settings set batterySuspendTimeout $v";
        ojuny.dms.batterySuspendTimeout = "never";

        desktop.ojuny.dms.settings.batterySuspendTimeout =
          timeoutPresets.${config.ojuny.dms.batterySuspendTimeout};

        # @option widget = "dropdown"; label = "Suspend behavior (on AC)"; group = "Idle timeouts"; groupOrder = 40; order = 90; choices = [ "suspend" "hibernate" "suspend-then-hibernate" ]; advanced = true; applyCommand = "case %%val%% in suspend) v=0;; hibernate) v=1;; suspend-then-hibernate) v=2;; esac; dms ipc call settings set acSuspendBehavior $v";
        ojuny.dms.acSuspendBehavior = "suspend";

        desktop.ojuny.dms.settings.acSuspendBehavior =
          suspendBehaviors.${config.ojuny.dms.acSuspendBehavior};

        # @option widget = "dropdown"; label = "Suspend behavior (on battery)"; group = "Idle timeouts"; groupOrder = 40; order = 100; choices = [ "suspend" "hibernate" "suspend-then-hibernate" ]; advanced = true; applyCommand = "case %%val%% in suspend) v=0;; hibernate) v=1;; suspend-then-hibernate) v=2;; esac; dms ipc call settings set batterySuspendBehavior $v";
        ojuny.dms.batterySuspendBehavior = "suspend";

        desktop.ojuny.dms.settings.batterySuspendBehavior =
          suspendBehaviors.${config.ojuny.dms.batterySuspendBehavior};

        desktop.ojuny.dms.settings.powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "hibernate"
          "restart"
        ];

        # @option widget = "text"; label = "Lock"; group = "Custom commands"; groupOrder = 50; order = 10; advanced = true; placeholder = "/usr/bin/myLock.sh"; description = "Runs instead of the built-in action; empty keeps the default."; applyCommand = "dms ipc call settings set customPowerActionLock %%val%%";
        desktop.ojuny.dms.settings.customPowerActionLock = "";

        # @option widget = "text"; label = "Log out"; group = "Custom commands"; groupOrder = 50; order = 20; advanced = true; placeholder = "/usr/bin/myLogout.sh"; description = "Runs instead of the built-in action; empty keeps the default."; applyCommand = "dms ipc call settings set customPowerActionLogout %%val%%";
        desktop.ojuny.dms.settings.customPowerActionLogout = "";

        # @option widget = "text"; label = "Suspend"; group = "Custom commands"; groupOrder = 50; order = 30; advanced = true; placeholder = "/usr/bin/mySuspend.sh"; description = "Runs instead of the built-in action; empty keeps the default."; applyCommand = "dms ipc call settings set customPowerActionSuspend %%val%%";
        desktop.ojuny.dms.settings.customPowerActionSuspend = "";

        # @option widget = "text"; label = "Hibernate"; group = "Custom commands"; groupOrder = 50; order = 40; advanced = true; placeholder = "/usr/bin/myHibernate.sh"; description = "Runs instead of the built-in action; empty keeps the default."; applyCommand = "dms ipc call settings set customPowerActionHibernate %%val%%";
        desktop.ojuny.dms.settings.customPowerActionHibernate = "";

        # @option widget = "text"; label = "Reboot"; group = "Custom commands"; groupOrder = 50; order = 50; advanced = true; placeholder = "/usr/bin/myReboot.sh"; description = "Runs instead of the built-in action; empty keeps the default."; applyCommand = "dms ipc call settings set customPowerActionReboot %%val%%";
        desktop.ojuny.dms.settings.customPowerActionReboot = "";

        # @option widget = "text"; label = "Power off"; group = "Custom commands"; groupOrder = 50; order = 60; advanced = true; placeholder = "/usr/bin/myPowerOff.sh"; description = "Runs instead of the built-in action; empty keeps the default."; applyCommand = "dms ipc call settings set customPowerActionPowerOff %%val%%";
        desktop.ojuny.dms.settings.customPowerActionPowerOff = "";

      };
    };

}
