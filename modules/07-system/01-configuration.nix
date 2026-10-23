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
    {
      imports = [ self.modules.nixos.patches ];

      options.ojuny.patches = lib.mkEnableOption "automatic import of patch- modules placed in the repository";

      config = {

        # @option widget = "switch"; label = "Enable patches"; group = "Patches"; description = "Automatically import patch- modules placed in the repository.";
        ojuny.patches = true;

        # @option widget = "text"; label = "Hostname"; group = "Identity"; applyCommand = "hostnamectl set-hostname %%val%%";
        networking.hostName = "ojuny";

        # @option widget = "dropdown"; label = "Time zone"; group = "Time and locale"; description = "A name from the tz database."; choices = [ "Europe/Amsterdam" "Europe/London" "Europe/Berlin" "UTC" "America/New_York" "America/Los_Angeles" "Asia/Tokyo" "Asia/Shanghai" "Australia/Sydney" ]; applyCommand = "timedatectl set-timezone %%val%%";
        time.timeZone = "Europe/Amsterdam";

        # @option widget = "dropdown"; label = "Default locale"; group = "Time and locale"; choices = [ "en_US.UTF-8" "en_GB.UTF-8" "de_DE.UTF-8" "nl_NL.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" ]; applyCommand = "localectl set-locale LANG=%%val%%";
        i18n.defaultLocale = "en_US.UTF-8";

        # @option widget = "dropdown"; label = "Console keymap"; group = "Keyboard"; description = "Used on the TTY; the Wayland layout is on the Display page."; choices = [ "us" "uk" "de" "fr" "latam" "es" "nl" "dvorak" ]; applyCommand = "localectl set-keymap %%val%%";
        console.keyMap = "us";

        # system.stateVersion is written once by scripts/setup.sh and is never
        # shown or prompted in the GUI. Set it to the release you installed from
        # and do not change it afterwards.
        system.stateVersion = "25.05";

      };

    };

}
