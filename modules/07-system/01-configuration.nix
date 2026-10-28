/*
  @menu
  displayname = "System";
  icon = "computer-symbolic";
  order = 10;
  description = "Hostname, locale, time and keyboard";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-configuration =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      userHome = user: user.home or null;
      primaryUser =
        if config.users.users ? user && userHome config.users.users.user != null then
          config.users.users.user
        else
          lib.findFirst (entry: userHome entry != null) null (lib.attrValues config.users.users);
      primaryHome = if primaryUser != null then userHome primaryUser else "/home/user";
      repoPathAbsolute =
        if lib.hasPrefix "/" config.ojuny.repoPath then
          config.ojuny.repoPath
        else
          "${primaryHome}/${config.ojuny.repoPath}";
    in
    {
      imports = [ self.modules.nixos.patches ];

      options.ojuny.patches = lib.mkEnableOption "automatic import of patch- modules placed in the repository";

      options.ojuny.time.auto = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set the time zone automatically from location.";
      };

      options.ojuny.repoPath = lib.mkOption {
        type = lib.types.str;
        default = "repos/nix-flake";
        description = "Path to the system flake, relative to the primary user's home or absolute.";
      };

      options.ojuny.i18n.extraLocaleSettings = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.locale = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Locale value for this category.";
            };
          }
        );
        default = { };
        description = "Locale category overrides written to i18n.extraLocaleSettings.";
      };

      config = {

        # @option widget = "switch"; label = "Enable patches"; group = "Patches"; description = "Automatically import patch- modules placed in the repository.";
        ojuny.patches = true;

        # @option widget = "text"; label = "Repository path"; group = "Paths"; groupOrder = 50; order = 10; description = "Absolute path, or a path relative to the primary user's home.";
        ojuny.repoPath = "repos/nix-flake";

        environment.variables = {
          OJUNY_REPO_PATH = repoPathAbsolute;
          OJUNY_FLAKE = repoPathAbsolute;
        };

        # @option widget = "text"; label = "Hostname"; group = "Identity"; applyCommand = "hostnamectl set-hostname %%val%%";
        networking.hostName = "ojuny";

        # @option widget = "switch"; label = "Automatic time zone"; group = "Time and locale"; groupOrder = 20; order = 5; description = "Use automatic-timezoned and geoclue2 to set the time zone from location.";
        ojuny.time.auto = false;

        # @option widget = "dropdown"; label = "Time zone"; group = "Time and locale"; description = "A name from the tz database."; choices = [ "Europe/Amsterdam" "Europe/London" "Europe/Berlin" "UTC" "America/New_York" "America/Los_Angeles" "Asia/Tokyo" "Asia/Shanghai" "Australia/Sydney" ]; applyCommand = "timedatectl set-timezone %%val%%"; visibleWhen.path = "ojuny.time.auto"; visibleWhen.equals = false;
        time.timeZone = "Europe/Amsterdam";

        services.automatic-timezoned.enable = config.ojuny.time.auto;
        services.geoclue2.enable = config.ojuny.time.auto;

        # @option widget = "dropdown"; label = "Default locale"; group = "Time and locale"; choices = [ "en_US.UTF-8" "en_GB.UTF-8" "de_DE.UTF-8" "nl_NL.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" ]; applyCommand = "localectl set-locale LANG=%%val%%";
        i18n.defaultLocale = "en_US.UTF-8";

        # @option widget = "table-attrset"; label = "Extra locale settings"; group = "Time and locale"; advanced = true; columns = [ "locale" ]; columnTypes = [ "str" ]; keyEditable = true; description = "Per-category locale overrides, for example LC_TIME = nl_NL.UTF-8.";
        ojuny.i18n.extraLocaleSettings = { };

        # Derived from the table above; no @option.
        i18n.extraLocaleSettings = lib.mapAttrs (
          _: entry: entry.locale
        ) config.ojuny.i18n.extraLocaleSettings;

        # @option widget = "dropdown"; label = "Console keymap"; group = "Keyboard"; description = "Used on the TTY; the Wayland layout is on the Display page."; choices = [ "us" "uk" "de" "fr" "latam" "es" "nl" "dvorak" ]; applyCommand = "localectl set-keymap %%val%%";
        console.keyMap = "us";

        system.nixos.distroName = "Ojuny";
        system.nixos.distroId = "ojuny";

        # DO NOT CHANGE, this value is for the *initial* state and should not be changed.
        system.stateVersion = "25.05";

      };

    };

}
