/*
  @menu
  displayname = "Browser";
  icon = "web-browser-symbolic";
  order = 60;
  description = "Web browser and default browser";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-browser =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      browserDesktop =
        {
          firefox = "firefox.desktop";
          chrome = "google-chrome.desktop";
          brave = "brave-browser.desktop";
        }
        .${config.ojuny.browser.selected};
    in
    {

      options.ojuny.browser.selected = lib.mkOption {
        type = lib.types.enum [
          "firefox"
          "chrome"
          "brave"
        ];
        default = "firefox";
        description = "Browser used for web and document links.";
      };

      options.ojuny.browser.chrome.savePasswords = lib.mkEnableOption "saving passwords in Chrome";
      
      options.ojuny.browser.brave.savePasswords = lib.mkEnableOption "saving passwords in Brave";

      options.ojuny.browser.defaults = {
        html = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for HTML files";
        };
        http = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for HTTP links";
        };
        https = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for HTTPS links";
        };
        pdf = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for PDF documents";
        };
        png = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "the selected browser as default for PNG images";
        };
        mailto = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "the selected browser as default for email links";
        };
      };

      imports = [
        self.modules.nixos.chrome
        self.modules.nixos.brave
      ];
      config = {
      # The profile settings below live in home-manager, which uses the system
      # package set, so the addon overlay has to be registered here.
      nixpkgs.overlays = [ inputs.firefox-addons.overlays.default ];


     
      # @option widget = "dropdown"; label = "Default browser"; group = "Browser"; groupOrder = 10; order = 1; choices = [ "firefox" "chrome" "brave" ]; applyCommand = "case %%val%% in firefox) b=firefox.desktop;; chrome) b=google-chrome.desktop;; brave) b=brave-browser.desktop;; esac; xdg-settings set default-web-browser \"$b\"";
      ojuny.browser.selected = "firefox";

      # @option widget = "switch"; label = "Enable Firefox"; group = "Firefox"; groupOrder = 20; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.enable = true;

      # @option widget = "switch"; label = "Disable telemetry"; group = "Firefox"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.DisableTelemetry = true;

      # @option widget = "switch"; label = "Block tracking cookies"; group = "Firefox"; order = 3; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.EnableTrackingProtection = {
        Value = true;
      };

      # @option widget = "switch"; label = "Disable Firefox studies"; group = "Firefox"; order = 4; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.DisableFirefoxStudies = true;

      # @option widget = "switch"; label = "Disable Pocket"; group = "Firefox"; order = 5; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.DisablePocket = true;

      # @option widget = "switch"; label = "Offer to save logins"; group = "Firefox"; order = 6; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
      programs.firefox.policies.OfferToSaveLogins = false;

      

      # @option widget = "switch"; label = "Offer to save passwords"; group = "Chrome"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "chrome";
      ojuny.browser.chrome.savePasswords = false;
      

      # @option widget = "switch"; label = "Offer to save passwords"; group = "Brave"; order = 2; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "brave";
      ojuny.browser.brave.savePasswords = false;

      

      programs.chromium.enable = lib.mkDefault config.ojuny.browser.selected != "firefox";

      programs.chromium.defaultSearchProviderEnabled = true;

      programs.chromium.extraOpts =
        {
          firefox = { };
          chrome = {
            PasswordManagerEnabled = config.ojuny.browser.chrome.savePasswords;
          };
          brave = {
            PasswordManagerEnabled = config.ojuny.browser.brave.savePasswords;
          };
        }
        .${config.ojuny.browser.selected};

      xdg.mime.enable = true;

      # @option widget = "switch"; label = "Set as default for HTML files"; group = "Default applications"; groupOrder = 50; order = 1; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" text/html";
      xdg.mime.defaultApplications."text/html" = lib.mkIf config.ojuny.browser.defaults.html browserDesktop;

      # @option widget = "switch"; label = "Set as default for HTTP links"; group = "Default applications"; order = 2; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" x-scheme-handler/http";
      xdg.mime.defaultApplications."x-scheme-handler/http" = lib.mkIf config.ojuny.browser.defaults.http browserDesktop;

      # @option widget = "switch"; label = "Set as default for HTTPS links"; group = "Default applications"; order = 3; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" x-scheme-handler/https";
      xdg.mime.defaultApplications."x-scheme-handler/https" = lib.mkIf config.ojuny.browser.defaults.https browserDesktop;

      # @option widget = "switch"; label = "Set as default for PDF documents"; group = "Default applications"; order = 4; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" application/pdf";
      xdg.mime.defaultApplications."application/pdf" = lib.mkIf config.ojuny.browser.defaults.pdf browserDesktop;

      # @option widget = "switch"; label = "Set as default for PNG images"; group = "Default applications"; order = 5; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" image/png";
      xdg.mime.defaultApplications."image/png" = lib.mkIf config.ojuny.browser.defaults.png browserDesktop;

      # @option widget = "switch"; label = "Set as default for Email links"; group = "Default applications"; order = 6; applyCommand = "v=$(xdg-settings get default-web-browser); [ -n \"$v\" ] && xdg-mime default \"$v\" x-scheme-handler/mailto";
      xdg.mime.defaultApplications."x-scheme-handler/mailto" = lib.mkIf config.ojuny.browser.defaults.mailto browserDesktop;
      };

    };

  flake.modules.nixos.brave = { lib, pkgs, config, ... }: { 

    options.ojuny.browser.brave.enable = lib.mkEnableOption "the Brave browser";
    config = {
    # @option widget = "switch"; label = "Enable Brave"; group = "Brave"; groupOrder = 40; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "brave";
      ojuny.browser.brave.enable = false;

    environment.systemPackages = lib.mkIf config.ojuny.browser.brave.enable [ pkgs.brave ];
    };
  };

  flake.modules.nixos.chrome = { lib, pkgs, config, ... }: { 

    options.ojuny.browser.chrome.enable = lib.mkEnableOption "the Google Chrome browser";
    config = {
      # @option widget = "switch"; label = "Enable Chrome"; group = "Chrome"; groupOrder = 30; order = 1; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "chrome";
      ojuny.browser.chrome.enable = false;

      environment.systemPackages = lib.mkIf config.ojuny.browser.chrome.enable [ pkgs.chrome ];
    };
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

        # @option widget = "text"; label = "Profile name"; group = "Firefox"; order = 10; description = "Name of the main profile on disk."; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.name = "default";

        # @option widget = "switch"; label = "Default profile"; group = "Firefox"; order = 11; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.isDefault = true;

        # @option widget = "text"; label = "Search engine"; group = "Firefox"; order = 12; description = "Engine the profile starts with."; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.search.default = "google";

        # @option widget = "packages"; label = "Extensions"; group = "Firefox"; order = 13; description = "Firefox extensions installed into the profile. Available addons come from the firefox-addons input."; visibleWhen.path = "ojuny.browser.selected"; visibleWhen.equals = "firefox";
        programs.firefox.profiles.default.extensions.packages = with pkgs.firefox-addons; [
          ublock-origin
          sponsorblock
        ];

        stylix.targets.firefox.profileNames = [ "default" ];

      };
    };

}
