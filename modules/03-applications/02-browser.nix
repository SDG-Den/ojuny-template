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

      # To install Firefox extensions declaratively, add the firefox-addons
      # input to flake.nix and put packages in programs.firefox.profiles.

    };

}
