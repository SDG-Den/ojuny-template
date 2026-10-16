/*
  @menu
  displayname = "Browser";
  icon = "web-browser-symbolic";
  order = 20;
  description = "Web browser and default browser";
  category = "Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-browser =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      # The profile settings below live in home-manager, which uses the system
      # package set, so the addon overlay has to be registered here.
      nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ];

      # @option widget = "switch"; label = "Firefox"; group = "Browser";
      programs.firefox.enable = true;

      # @option widget = "switch"; label = "Disable telemetry"; group = "Privacy";
      programs.firefox.policies.DisableTelemetry = true;

      # @option widget = "switch"; label = "Block tracking cookies"; group = "Privacy";
      programs.firefox.policies.EnableTrackingProtection = {
        Value = true;
      };

      # @option widget = "switch"; label = "Disable Firefox studies"; group = "Privacy";
      programs.firefox.policies.DisableFirefoxStudies = true;

      # @option widget = "switch"; label = "Disable Pocket"; group = "Privacy";
      programs.firefox.policies.DisablePocket = true;

      # @option widget = "switch"; label = "Offer to save logins"; group = "Privacy";
      programs.firefox.policies.OfferToSaveLogins = false;

      # @option widget = "switch"; label = "MIME defaults"; group = "Default applications";
      xdg.mime.enable = true;

      # @option widget = "text"; label = "HTML"; group = "Default applications";
      xdg.mime.defaultApplications."text/html" = "firefox.desktop";

      # @option widget = "text"; label = "HTTP"; group = "Default applications";
      xdg.mime.defaultApplications."x-scheme-handler/http" = "firefox.desktop";

      # @option widget = "text"; label = "HTTPS"; group = "Default applications";
      xdg.mime.defaultApplications."x-scheme-handler/https" = "firefox.desktop";

      # @option widget = "text"; label = "PDF"; group = "Default applications";
      xdg.mime.defaultApplications."application/pdf" = "firefox.desktop";

      # @option widget = "text"; label = "PNG images"; group = "Default applications";
      xdg.mime.defaultApplications."image/png" = "firefox.desktop";

      # @option widget = "text"; label = "Email links"; group = "Default applications";
      xdg.mime.defaultApplications."x-scheme-handler/mailto" = "firefox.desktop";

    };

  # Profiles and extensions are home-manager territory; they ride on the same
  # page and are imported for every account through sharedModules. Gated by the
  # system Firefox switch so they only apply when the browser is enabled.
  flake.modules.homeManager.applications-browser =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    {
      config = lib.mkIf (osConfig.programs.firefox.enable or false) {

        # @option widget = "text"; label = "Profile name"; group = "Profile"; description = "Name of the main profile on disk.";
        programs.firefox.profiles.default.name = "default";

        # @option widget = "switch"; label = "Default profile"; group = "Profile";
        programs.firefox.profiles.default.isDefault = true;

        # @option widget = "text"; label = "Search engine"; group = "Profile"; description = "Engine the profile starts with.";
        programs.firefox.profiles.default.search.default = "google";

        # @option widget = "packages"; label = "Extensions"; group = "Profile"; description = "Firefox extensions installed into the profile. Available addons come from the firefox-addons input.";
        programs.firefox.profiles.default.extensions.packages = with pkgs.firefox-addons; [
          ublock-origin
          sponsorblock
        ];

      };
    };

}
