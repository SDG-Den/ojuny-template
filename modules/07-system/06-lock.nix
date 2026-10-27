/*
  @menu
  displayname = "Lock screen";
  icon = "system-lock-screen-symbolic";
  order = 60;
  description = "Lock behaviour, authentication and screensaver";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-lock =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      u2fModes = {
        "security-key-only" = "or";
        "second-factor" = "and";
      };
    in
    {

      options.ojuny.dms.u2fMode = lib.mkOption {
        type = lib.types.enum (lib.attrNames u2fModes);
        default = "security-key-only";
        description = "DMS u2fMode.";
      };

      options.ojuny.authentication.fingerprint.enable = lib.mkEnableOption "fingerprint authentication";

      config = {

        # @option widget = "switch"; label = "Lock at startup"; group = "Behavior"; groupOrder = 10; order = 10; applyCommand = "dms ipc call settings set lockAtStartup %%val%%";
        desktop.ojuny.dms.settings.lockAtStartup = false;

        # @option widget = "switch"; label = "Lock before suspend"; group = "Behavior"; groupOrder = 10; order = 20; applyCommand = "dms ipc call settings set lockBeforeSuspend %%val%%";
        desktop.ojuny.dms.settings.lockBeforeSuspend = false;

        # @option widget = "switch"; label = "Power off displays on lock"; group = "Behavior"; groupOrder = 10; order = 30; applyCommand = "dms ipc call settings set lockScreenPowerOffMonitorsOnLock %%val%%";
        desktop.ojuny.dms.settings.lockScreenPowerOffMonitorsOnLock = false;

        # @option widget = "switch"; label = "loginctl integration"; group = "Behavior"; groupOrder = 10; order = 40; advanced = true; description = "Lets loginctl lock requests reach the shell."; applyCommand = "dms ipc call settings set loginctlLockIntegration %%val%%";
        desktop.ojuny.dms.settings.loginctlLockIntegration = true;

        # @option widget = "switch"; label = "Fingerprint"; group = "Authentication"; groupOrder = 20; order = 10; description = "Enable fprintd and fingerprint prompts for login, greetd, sudo, polkit and the lock screen. Password fallback stays enabled.";
        ojuny.authentication.fingerprint.enable = false;

        desktop.ojuny.dms.settings.enableFprint = config.ojuny.authentication.fingerprint.enable;

        # @option widget = "spin"; label = "Fingerprint attempts"; group = "Authentication"; groupOrder = 20; order = 20; min = 1; max = 30; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.enableFprint"; visibleWhen.equals = true; description = "Failed attempts before the reader is locked out."; applyCommand = "dms ipc call settings set maxFprintTries %%val%%";
        desktop.ojuny.dms.settings.maxFprintTries = 15;

        # @option widget = "switch"; label = "Security key"; group = "Authentication"; groupOrder = 20; order = 30; description = "Unlock with a FIDO security key."; applyCommand = "dms ipc call settings set enableU2f %%val%%";
        desktop.ojuny.dms.settings.enableU2f = false;

        # @option widget = "dropdown"; label = "Security key mode"; group = "Authentication"; groupOrder = 20; order = 40; choices = [ "security-key-only" "second-factor" ]; visibleWhen.path = "desktop.ojuny.dms.settings.enableU2f"; visibleWhen.equals = true; applyCommand = "case %%val%% in security-key-only) v=or;; second-factor) v=and;; esac; dms ipc call settings set u2fMode $v";
        ojuny.dms.u2fMode = "security-key-only";

        desktop.ojuny.dms.settings.u2fMode = u2fModes.${config.ojuny.dms.u2fMode};

        # @option widget = "switch"; label = "Security key shortcut"; group = "Authentication"; groupOrder = 20; order = 50; visibleWhen.path = "desktop.ojuny.dms.settings.enableU2f"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set lockScreenSecurityKeyShortcutEnabled %%val%%";
        desktop.ojuny.dms.settings.lockScreenSecurityKeyShortcutEnabled = false;

        # @option widget = "text"; label = "Key combination"; group = "Authentication"; groupOrder = 20; order = 60; visibleWhen.path = "desktop.ojuny.dms.settings.lockScreenSecurityKeyShortcutEnabled"; visibleWhen.equals = true; description = "Format: Ctrl+Q."; applyCommand = "dms ipc call settings set lockScreenSecurityKeyShortcut %%val%%";
        desktop.ojuny.dms.settings.lockScreenSecurityKeyShortcut = "Ctrl+Q";

        # @option widget = "color"; label = "Inactive display color"; group = "Displays"; groupOrder = 30; order = 10; description = "Solid colour for locked-off displays (OLED burn-in protection)."; applyCommand = "dms ipc call settings set lockScreenInactiveColor %%val%%";
        desktop.ojuny.dms.settings.lockScreenInactiveColor = "#000000";

        # @option widget = "switch"; label = "Play video on lock"; group = "Video screensaver"; groupOrder = 40; order = 10; applyCommand = "dms ipc call settings set lockScreenVideoEnabled %%val%%";
        desktop.ojuny.dms.settings.lockScreenVideoEnabled = false;

        # @option widget = "text"; label = "Video path"; group = "Video screensaver"; groupOrder = 40; order = 20; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.lockScreenVideoEnabled"; visibleWhen.equals = true; description = "Absolute path to a video file; kept as a runtime string, not a store path."; applyCommand = "dms ipc call settings set lockScreenVideoPath %%val%%";
        desktop.ojuny.dms.settings.lockScreenVideoPath = "";

        # @option widget = "switch"; label = "Automatic cycling"; group = "Video screensaver"; groupOrder = 40; order = 30; advanced = true; visibleWhen.path = "desktop.ojuny.dms.settings.lockScreenVideoEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set lockScreenVideoCycling %%val%%";
        desktop.ojuny.dms.settings.lockScreenVideoCycling = false;

        services.fprintd = lib.mkIf config.ojuny.authentication.fingerprint.enable {
          enable = true;
          enablePam = false;
        };

        environment.systemPackages = lib.mkIf config.ojuny.authentication.fingerprint.enable [
          pkgs.fprintd
          pkgs.libfprint
          (pkgs.writeShellApplication {
            name = "ojuny-fingerprint-detect";
            runtimeInputs = [ pkgs.coreutils pkgs.fprintd ];
            text = ''
              exec fprintd-list "$(id -un)"
            '';
          })
        ];

        security.pam.services = lib.mkIf config.ojuny.authentication.fingerprint.enable {
          login.fprintAuth = true;
          greetd.fprintAuth = true;
          sudo.fprintAuth = true;
          "polkit-1".fprintAuth = true;
          dankshell.fprintAuth = true;
        };

      };
    };

}
